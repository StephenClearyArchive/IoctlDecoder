var method_names = [ 'METHOD_BUFFERED', 'METHOD_IN_DIRECT', 'METHOD_OUT_DIRECT', 'METHOD_NEITHER' ];
var access_names = [ 'FILE_ANY_ACCESS', 'FILE_READ_ACCESS', 'FILE_WRITE_ACCESS', 'FILE_READ_ACCESS | FILE_WRITE_ACCESS' ];

// Helper function to fill out some standard numeric results once a numeric match is found
function ioctl_decode_value(ret, value)
{
  ret.ioctl_value = value;
  ret.device_value = (value >> 16) & 0xFFFF;
  ret.function_value = (value >> 2) & 0xFFF;
  ret.access_value = (value >> 14) & 0x3;
  ret.method_value = value & 0x3;
  if (ret.device_value & 0x8000)
    ret.device_common = 1;
  if (ret.function_value & 0x800)
    ret.function_custom = 1;

  ret.method = method_names[ret.method_value];
  ret.access = access_names[ret.access_value];
}

// Decodes an ioctl given as a numeric value
function ioctl_decode_number(value)
{
  var ret = new Object();

  ioctl_decode_value(ret, value);

  // See if we know what device this is
  var device_lookup = ret.device_value.toString(16);
  if (device_lookup in ioctl_db)
  {
    ret.device = ioctl_db[device_lookup].n;
    // If we know the device, see if we know the ioctl name
    var ioctl_lookup = ret.function_value.toString(16) + '.' +
        ret.method_value.toString(16) + '.' + ret.access_value.toString(16);
    if (ioctl_lookup in ioctl_db[device_lookup].i)
      ret.ioctl = ioctl_db[device_lookup].i[ioctl_lookup];
    else
    {
      // Last-ditch effort: check for a device/function match with a method/access mismatch
      for (var access = 0; access != 4; ++access)
      {
        for (var method = 0; method != 4; ++method)
        {
          var lookup = ret.function_value.toString(16) + '.' +
              method.toString(16) + '.' + access.toString(16);
          if (lookup in ioctl_db[device_lookup].i)
          {
            ret.inexact_ioctl_value = (ret.device_value << 16) | (ret.function_value << 2) |
                (access << 14) | (method);
            ret.inexact_ioctl = ioctl_db[device_lookup].i[lookup];
          }
        }
      }
    }
  }

  return ret;
}

// Decodes an ioctl given as a regex string
function ioctl_decode_string(value)
{
  var ret = [];

  var re = new RegExp(value, 'i');

  for (device in ioctl_db)
  {
    for (ioctl in ioctl_db[device].i)
    {
      if (!ioctl_db[device].i[ioctl].match(re))
        continue;

      var device_value = parseInt(device, 16);
      var function_method_access = ioctl.split('.');
      var function_value = parseInt(function_method_access[0], 16);
      var method_value = parseInt(function_method_access[1], 16);
      var access_value = parseInt(function_method_access[2], 16);
      var ioctl_value = (device_value << 16) | (function_value << 2) |
          (access_value << 14) | (method_value);

      ret[ret.length] = ioctl_decode_number(ioctl_value);
    }
  }

  return ret;
}

// Adds all ioctls for a given device to the results
function add_device_ioctls_to_result_set(result, device)
{
  if (!('i' in ioctl_db[device]))
  {
    var device_value = parseInt(device, 16);
    var function_value = 0;
    var method_value = 0;
    var access_value = 0;
    var ioctl_value = (device_value << 16) | (function_value << 2) |
        (access_value << 14) | (method_value);

    var fake_ioctl = new Object();
    ioctl_decode_value(fake_ioctl, ioctl_value);
    fake_ioctl.device = ioctl_db[device].n;
    fake_ioctl.ioctl = 'fake';
    result[result.length] = fake_ioctl;
  }

  for (ioctl in ioctl_db[device].i)
  {
    var device_value = parseInt(device, 16);
    var function_method_access = ioctl.split('.');
    var function_value = parseInt(function_method_access[0], 16);
    var method_value = parseInt(function_method_access[1], 16);
    var access_value = parseInt(function_method_access[2], 16);
    var ioctl_value = (device_value << 16) | (function_value << 2) |
        (access_value << 14) | (method_value);

    result[result.length] = ioctl_decode_number(ioctl_value);
  }
}

// Decodes an ioctl, as best as it can
function ioctl_decode(value, force_decimal)
{
  var ret = [];

  // Attempt to convert the string to a numeric value

  // If it could be a hex value, use that
  if (!force_decimal && /^(0x)?[0-9A-F]+$/i.test(value))
    ret[ret.length] = ioctl_decode_number(parseInt(value, 16));

  // If it could be a decimal value, use that
  if (/^[0-9]+$/.test(value) && parseInt(value, 10) != parseInt(value, 16))
    ret[ret.length] = ioctl_decode_number(parseInt(value, 10));
  else if (force_decimal && !/^[0-9]+$/.test(value))
    throw Error(0, 'Not a decimal number');

  // If it cannot be a numeric value, then gather string results
  if (!force_decimal && ret.length == 0)
    return ioctl_decode_string(value);
  else
  {
    // Clean up numeric results: if one is merely a decoded value, remove it
    if (ret.length == 2)
    {
      if ((ret[0].ioctl || ret[0].inexact_ioctl) && !ret[1].ioctl && !ret[1].inexact_ioctl)
        ret = ret.slice(0, -1);
      else if (!ret[0].ioctl && !ret[0].inexact_ioctl && (ret[1].ioctl || ret[1].inexact_ioctl))
        ret = ret.slice(1);
    }
  }

  return ret;
}

// Decodes a device, as best as it can
function device_decode(value, force_decimal)
{
  var ret = [];

  // Attempt to convert the string to a numeric value

  // If it could be a hex value, use that
  if (!force_decimal && /^(0x)?[0-9A-F]+$/i.test(value))
  {
    var device = parseInt(value, 16).toString(16);
    if (device in ioctl_db)
      add_device_ioctls_to_result_set(ret, device)
  }

  // If it could be a decimal value, use that
  if (/^[0-9]+$/.test(value) && parseInt(value, 10) != parseInt(value, 16))
  {
    var device = parseInt(value, 10).toString(16);
    if (device in ioctl_db)
      add_device_ioctls_to_result_set(ret, device)
  }
  else if (force_decimal && !/^[0-9]+$/.test(value))
    throw Error(0, 'Not a decimal number');

  // If it cannot be a numeric value, then gather string results
  if (!force_decimal && ret.length == 0)
  {
    var re = new RegExp(value, 'i');
    for (device in ioctl_db)
    {
      if (!ioctl_db[device].n.match(re))
        continue;
      add_device_ioctls_to_result_set(ret, device)
    }
  }

  return ret;
}
