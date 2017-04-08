BEGIN {
  FS = "[(),]+";
  
  # Define all known device types
  
  # NOTE: Any device type name here of the form IOCTL_.*_BASE is not output as a proper device name (it is used only for ioctl encoding)
  device_types["FILE_DEVICE_BEEP"] = 1;
  device_types["FILE_DEVICE_CD_ROM"] = 2;
  device_types["IOCTL_CDROM_BASE"] = 2;
  device_types["FILE_DEVICE_CD_ROM_FILE_SYSTEM"] = 3;
  device_types["FILE_DEVICE_CONTROLLER"] = 4;
  device_types["IOCTL_SCSI_BASE"] = 4;
  device_types["IOCTL_SDBUS_BASE"] = 4;
  device_types["IOCTL_PCMCIA_BASE"] = 4;
  device_types["FILE_DEVICE_DATALINK"] = 5;
  device_types["FILE_DEVICE_DFS"] = 6;
  device_types["FILE_DEVICE_DISK"] = 7;
  device_types["IOCTL_DISK_BASE"] = 7;
  device_types["FILE_DEVICE_DISK_FILE_SYSTEM"] = 8;
  device_types["FILE_DEVICE_FILE_SYSTEM"] = 9;
  device_types["FILE_DEVICE_INPORT_PORT"] = 10;
  device_types["FILE_DEVICE_KEYBOARD"] = 11;
  device_types["FILE_DEVICE_MAILSLOT"] = 12;
  device_types["FILE_DEVICE_MIDI_IN"] = 13;
  device_types["FILE_DEVICE_MIDI_OUT"] = 14;
  device_types["FILE_DEVICE_MOUSE"] = 15;
  device_types["FILE_DEVICE_MULTI_UNC_PROVIDER"] = 16;
  device_types["FILE_DEVICE_NAMED_PIPE"] = 17;
  device_types["FILE_DEVICE_NETWORK"] = 18;
  device_types["FILE_DEVICE_NETWORK_BROWSER"] = 19;
  device_types["FILE_DEVICE_NETWORK_FILE_SYSTEM"] = 20;
  device_types["FILE_DEVICE_NULL"] = 21;
  device_types["FILE_DEVICE_PARALLEL_PORT"] = 22;
  device_types["IOCTL_PAR_BASE"] = 22;
  device_types["FILE_DEVICE_PHYSICAL_NETCARD"] = 23;
  device_types["FILE_DEVICE_PRINTER"] = 24;
  device_types["FILE_DEVICE_SCANNER"] = 25;
  device_types["FILE_DEVICE_SERIAL_MOUSE_PORT"] = 26;
  device_types["FILE_DEVICE_SERIAL_PORT"] = 27;
  device_types["FILE_DEVICE_SCSI"] = 27;
  device_types["FILE_DEVICE_SCREEN"] = 28;
  device_types["FILE_DEVICE_SOUND"] = 29;
  device_types["FILE_DEVICE_STREAMS"] = 30;
  device_types["FILE_DEVICE_TAPE"] = 31;
  device_types["IOCTL_TAPE_BASE"] = 31;
  device_types["FILE_DEVICE_TAPE_FILE_SYSTEM"] = 32;
  device_types["FILE_DEVICE_TRANSPORT"] = 33;
  device_types["FILE_DEVICE_UNKNOWN"] = 34;
  device_types["FILE_DEVICE_USB"] = 34;
  device_types["FILE_DEVICE_VIDEO"] = 35;
  device_types["FILE_DEVICE_VIRTUAL_DISK"] = 36;
  device_types["FILE_DEVICE_WAVE_IN"] = 37;
  device_types["FILE_DEVICE_WAVE_OUT"] = 38;
  device_types["FILE_DEVICE_8042_PORT"] = 39;
  device_types["FILE_DEVICE_NETWORK_REDIRECTOR"] = 40;
  device_types["FILE_DEVICE_BATTERY"] = 41;
  device_types["FILE_DEVICE_BUS_EXTENDER"] = 42;
  device_types["FILE_DEVICE_MODEM"] = 43;
  device_types["FILE_DEVICE_VDM"] = 44;
  device_types["FILE_DEVICE_MASS_STORAGE"] = 45;
  device_types["IOCTL_STORAGE_BASE"] = 45;
  device_types["FILE_DEVICE_SMB"] = 46;
  device_types["FILE_DEVICE_KS"] = 47;
  device_types["FILE_DEVICE_CHANGER"] = 48;
  device_types["IOCTL_CHANGER_BASE"] = 48;
  device_types["FILE_DEVICE_SMARTCARD"] = 49;
  device_types["FILE_DEVICE_ACPI"] = 50;
  device_types["FILE_DEVICE_DVD"] = 51;
  device_types["IOCTL_DVD_BASE"] = 51;
  device_types["FILE_DEVICE_FULLSCREEN_VIDEO"] = 52;
  device_types["FILE_DEVICE_DFS_FILE_SYSTEM"] = 53;
  device_types["FILE_DEVICE_DFS_VOLUME"] = 54;
  device_types["FILE_DEVICE_SERENUM"] = 55;
  device_types["FILE_DEVICE_TERMSRV"] = 56;
  device_types["FILE_DEVICE_KSEC"] = 57;
  device_types["FILE_DEVICE_FIPS"] = 58;
  device_types["FILE_DEVICE_DOT4"] = 58; # 0x3a in ($DDK)/inc/ddk/d4drvif.h
  device_types["FILE_DEVICE_INFINIBAND"] = 59;
  # No 60 or 61, apparently
  device_types["FILE_DEVICE_VMBUS"] = 62;
  device_types["FILE_DEVICE_CRYPT_PROVIDER"] = 63;
  device_types["FILE_DEVICE_WPD"] = 64;
  device_types["FILE_DEVICE_BLUETOOTH"] = 65;
  device_types["FILE_DEVICE_BIOMETRIC"] = 68; # 0x44 in ($DDK)/inc/api/devioctl.h
  device_types["MOUNTDEVCONTROLTYPE"] = 77; # 'M' in ($DDK)/inc/ddk/mountmgr.h
  device_types["VOLSNAPCONTROLTYPE"] = 83; # 'S' in ($DDK)/inc/ddk/ntifs.h
  device_types["FILE_DEVICE_VOLUME"] = 86; # 'V' in ($DDK)/inc/api/ntddvol.h
  device_types["IOCTL_VOLUME_BASE"] = 86; # 'V' in ($SDK)/Include/WinIoctl.h
  device_types["FTTYPE"] = 102; # 'f' in ($DDK)/inc/api/ntddft.h
  device_types["FTCONTROLTYPE"] = 103; # 'g' in ($DDK)/inc/api/ntddft2.h
  device_types["MOUNTMGRCONTROLTYPE"] = 109; # 'm' in ($DDK)/inc/ddk/mountmgr.h
  device_types["FILE_DEVICE_IRCLASS"] = 3936; # 0x0F60 in ($DDK)/inc/ddk/irclass_ioctl.h
  device_types["FILE_DEVICE_USB_SCAN"] = 32768; # 0x8000 in ($DDK)/inc/ddk/usbscan.h
  device_types["MPIO_DSM"] = 29549; # 'dsm' in ($DDK)/inc/dsm.h, which is 0x64736d, truncated to 0x736d
  device_types["0xc0c0"] = 49344; # 0xc0c0 in ($DDK)/inc/ddk/ntddnlb.h

  function_types["USB_SUBMIT_URB"] = 0;
  function_types["USB_RESET_PORT"] = 1;
  function_types["USB_GET_ROOTHUB_PDO"] = 3;
  function_types["USB_GET_PORT_STATUS"] = 4;
  function_types["USB_ENABLE_PORT"] = 5;
  function_types["USB_GET_HUB_COUNT"] = 6;
  function_types["USB_CYCLE_PORT"] = 7;
  function_types["USB_GET_HUB_NAME"] = 8;
  function_types["USB_IDLE_NOTIFICATION"] = 9;
  function_types["USB_RECORD_FAILURE"] = 10;
  function_types["USB_GET_BUS_INFO"] = 264;
  function_types["USB_GET_CONTROLLER_NAME"] = 265;
  function_types["USB_GET_BUSGUID_INFO"] = 266;
  function_types["USB_GET_PARENT_HUB_INFO"] = 267;
  function_types["USB_GET_DEVICE_HANDLE"] = 268;
  function_types["USB_GET_DEVICE_HANDLE_EX"] = 269;
  function_types["USB_GET_TT_DEVICE_HANDLE"] = 270;
  function_types["USB_GET_TOPOLOGY_ADDRESS"] = 271;
  function_types["USB_IDLE_NOTIFICATION_EX"] = 272;
  function_types["USB_REQ_GLOBAL_SUSPEND"] = 273;
  function_types["USB_REQ_GLOBAL_RESUME"] = 274;
  function_types["USB_GET_HUB_CONFIG_INFO"] = 275;
  function_types["HCD_GET_STATS_1"] = 255;
  function_types["HCD_DIAGNOSTIC_MODE_ON"] = 256;
  function_types["HCD_DIAGNOSTIC_MODE_OFF"] = 257;
  function_types["HCD_GET_ROOT_HUB_NAME"] = 258;
  function_types["HCD_GET_DRIVERKEY_NAME"] = 265;
  function_types["HCD_GET_STATS_2"] = 266;
  function_types["HCD_DISABLE_PORT"] = 268;
  function_types["HCD_ENABLE_PORT"] = 269;
  function_types["HCD_USER_REQUEST"] = 270;
  function_types["HCD_TRACE_READ_REQUEST"] = 275;
  function_types["USB_GET_NODE_INFORMATION"] = 258;
  function_types["USB_GET_NODE_CONNECTION_INFORMATION"] = 259;
  function_types["USB_GET_DESCRIPTOR_FROM_NODE_CONNECTION"] = 260;
  function_types["USB_GET_NODE_CONNECTION_NAME"] = 261;
  function_types["USB_DIAG_IGNORE_HUBS_ON"] = 262;
  function_types["USB_DIAG_IGNORE_HUBS_OFF"] = 263;
  function_types["USB_GET_NODE_CONNECTION_DRIVERKEY_NAME"] = 264;
  function_types["USB_GET_HUB_CAPABILITIES"] = 271;
  function_types["USB_GET_NODE_CONNECTION_ATTRIBUTES"] = 272;
  function_types["USB_HUB_CYCLE_PORT"] = 273;
  function_types["USB_GET_NODE_CONNECTION_INFORMATION_EX"] = 274;
  function_types["USB_RESET_HUB"] = 275;
  function_types["USB_GET_HUB_CAPABILITIES_EX"] = 276;
  function_types["USB_PROPAGATE_RESUME"] = 276;
  function_types["USB_NOTIFY_HUB_PWR_LOSS"] = 277;
  function_types["IOCTL_DOT4_USER_BASE"] = 2049;
  function_types["USBPRINT_IOCTL_INDEX"] = 0;
  function_types["IOCTL_INDEX"] = 2048;
  function_types["SCSISCAN_CMD_CODE"] = 4;
  function_types["SCSISCAN_LOCKDEVICE"] = 5;
  function_types["SCSISCAN_UNLOCKDEVICE"] = 6;
  function_types["SCSISCAN_SET_TIMEOUT"] = 7;
  function_types["SCSISCAN_GET_INFO"] = 8;
  function_types["WPD_CONTROL_FUNCTION_GENERIC_MESSAGE"] = 66;
  function_types["BTH_IOCTL_BASE"] = 0;

  method_types["METHOD_BUFFERED"] = 0;
  method_types["METHOD_IN_DIRECT"] = 1;
  method_types["METHOD_OUT_DIRECT"] = 2;
  method_types["METHOD_NEITHER"] = 3;

  access_types["FILE_ANY_ACCESS"] = 0;
  access_types["FILE_SPECIAL_ACCESS"] = 0;
  access_types["FILE_READ_ACCESS"] = 1;
  access_types["FILE_READ_DATA"] = 1;
  access_types["FILE_WRITE_ACCESS"] = 2;
  access_types["FILE_WRITE_DATA"] = 2;
  
  # Begin building database: start with all known devices
  for (i in device_types)
  {
    if (i ~ /^IOCTL_.*_BASE$/)
      continue;
    if ((sprintf("%x", device_types[i]), "name") in data)
      data[sprintf("%x", device_types[i]), "name"] = data[sprintf("%x", device_types[i]), "name"] " " i;
    else
      data[sprintf("%x", device_types[i]), "name"] = i;
  }

  num_improper_ioctls = 0;
}

# Helper function for maintaining sets of id's as string values
function add_to_set(set, id)
{
  num = split(set, tmp, " ");
  if (num == 0)
    return id;
  for (i = 1; i <= num; i++)
  {
    if (tmp[i] == id)
      return set;
  }
  return set " " id;
}

# Helper function for sanity checks
function expect(x)
{
  if (NF != x + 1 || $(x + 1) != "")
  { 
    print "Skipping line due to wrong number of fields: " $0 > "/dev/stderr";
    next;
  }
}

# Helper function for parsing id's
function parse_id(x, ctl_code,    tmp)
{
  if (!match(x, "^#define([A-Z0-9_]+)" ctl_code "$", tmp))
  { 
    print "Skipping line due to improper #define: " $0 > "/dev/stderr";
    next;
  }
  return tmp[1];
}

# Helper function for parsing device types
function parse_device(x)
{
  if (x !~ /^[A-Z0-9_]+|0x[0-9a-h]+$/)
  {
    print "Skipping line due to improper device type: " $0 > "/dev/stderr";
    next;
  }
  if (!(x in device_types))
  {
    unrecognized_devices[x] = 1;
    next;
  }
  return sprintf("%x", device_types[x]);
}

# Helper function for parsing methods
function parse_method(x)
{
  if (match(x, /^[0-3]$/))
    return x;
  if (x in method_types)
    return sprintf("%x", method_types[x]);
  unrecognized_methods[x] = 1;
  next;
}

 # Helper function for parsing access
function parse_access(x,    tmp)
{
  if (match(x, /^[0-3]$/))
    return x;
  if (x in access_types)
    return sprintf("%x", access_types[x]);
  else
  {
    if (match(x, /^([A-Z0-9_]+)\|([A-Z0-9_]+)$/, tmp))
    {
      if (!(tmp[1] in access_types) || !(tmp[2] in access_types))
      {
        unrecognized_access[x] = 1;
        next;
      }
      return sprintf("%x", access_types[tmp[1]] + access_types[tmp[2]]);
    }
    else
    {
      unrecognized_access[x] = 1;
      next;
    }
  }
}

# Helper function for parsing function codes: we allow hex, dec, SYMBOL, SYMBOL+dec, or SYMBOL+hex
function parse_function(x,    tmp)
{
  # Parse function: we allow hex, dec, SYMBOL, or SYMBOL+dec
  if (!match(x, /^(0x[A-Za-z0-9]+)$|^([0-9]+)$|^([A-Z0-9_]+)$|^([A-Z0-9_]+)\+([0-9]+)$|^([A-Z0-9_]+)\+(0x[A-Za-z0-9]+)$/, tmp))
  {
    print "Skipping line due to unrecognized function: " x > "/dev/stderr";
    next;
  }
  if (1 in tmp)
    return sprintf("%x", strtonum(tmp[1]));
  else if (2 in tmp)
    return sprintf("%x", strtonum(tmp[2]));
  else if (3 in tmp)
  {
    if (!(tmp[3] in function_types))
    {
      unrecognized_functions[tmp[3]] = 1;
      next;
    }
    return sprintf("%x", function_types[tmp[3]]);
  }
  else if (4 in tmp) # both 4 and 5 must be in tmp
  {
    if (!(tmp[4] in function_types))
    {
      unrecognized_functions[tmp[4]] = 1;
      next;
    }
    return sprintf("%x", function_types[tmp[4]] + strtonum(tmp[5]));
  }
  else  # both 6 and 7 must be in tmp
  {
    if (!(tmp[6] in function_types))
    {
      unrecognized_functions[tmp[6]] = 1;
      next;
    }
    return sprintf("%x", function_types[tmp[6]] + strtonum(tmp[7]));
  }
}

# Helper function for checking ioctl definitions and creating an index value from them
function make_index(device, fun, method, access, id)
{
  # Decode definitions of parts, and determine their numerical values
  device_hex = parse_device(device);
  device_value = strtonum("0x" device_hex);
  function_hex = parse_function(fun);
  function_value = strtonum("0x" function_hex);
  method_hex = parse_method(method);
  method_value = strtonum("0x" method_hex);
  access_hex = parse_access(access);
  access_value = strtonum("0x" access_hex);

  # There are a handful of ioctl definitions that are wrong - i.e., pass a value > 0xFFF for function.
  # The macros for CTL_CODE, etc., allow this type of spillover, so we have to, too.

  original_index = device_hex SUBSEP function_hex SUBSEP method_hex SUBSEP access_hex;
  if ((device_value > 0xFFFF) || (function_value > 0xFFF) || (method_value > 0x3) || (access_value > 0x3))
  {
    correct_ioctl = or(or(or(lshift(device_value, 16), lshift(function_value, 2)),
        lshift(access_value, 14)), method_value);
    correct_device_value = and(rshift(correct_ioctl, 16), 0xFFFF);
    correct_device_hex = sprintf("%x", correct_device_value);
    correct_function_value = and(rshift(correct_ioctl, 2), 0xFFF);
    correct_function_hex = sprintf("%x", correct_function_value);
    correct_method_value = and(correct_ioctl, 0x3);
    correct_method_hex = sprintf("%x", correct_method_value);
    correct_access_value = and(rshift(correct_ioctl, 14), 0x3);
    correct_access_hex = sprintf("%x", correct_access_value);
    correct_index = correct_device_hex SUBSEP correct_function_hex SUBSEP correct_method_hex SUBSEP correct_access_hex;
    num_improper_ioctls++;
    improper_ioctls[num_improper_ioctls] = original_index " -> " correct_index " for " id;
    return correct_index;
  }
  else
    return original_index;
}

# Helper function that determines the index and saves the data
function save_data(device, fun, method, access, id)
{
  # Determine the index
  idx = make_index(device, fun, method, access, id);

  # Save the data
  data[idx] = add_to_set(data[idx], id);
}

# Skip the lines that actually define the macro USB_KERNEL_CTL_BUFFERED
/#defineUSB_KERNEL_CTL_BUFFERED\(/ { next; }

# Handle USB_KERNEL_CTL_BUFFERED ioctl definitions
/#define[A-Z0-9_]+USB_KERNEL_CTL_BUFFERED\(/ {
  # Sanity check
  expect(2)
  
  # Save results
  save_data("FILE_DEVICE_USB", $2, "METHOD_BUFFERED", "FILE_ANY_ACCESS", parse_id($1, "USB_KERNEL_CTL_BUFFERED"));
  next;
}

# Skip the lines that actually define the macro USB_KERNEL_CTL
/#defineUSB_KERNEL_CTL\(/ { next; }

# Handle USB_KERNEL_CTL ioctl definitions
/#define[A-Z0-9_]+USB_KERNEL_CTL\(/ {
  # Sanity check
  expect(2)
  
  # Save results
  save_data("FILE_DEVICE_USB", $2, "METHOD_NEITHER", "FILE_ANY_ACCESS", parse_id($1, "USB_KERNEL_CTL"));
  next;
}

# Skip the lines that actually define the macro USB_CTL
/#defineUSB_CTL\(/ { next; }

# Handle USB_CTL ioctl definitions
/#define[A-Z0-9_]+USB_CTL\(/ {
  # Sanity check
  expect(2)
  
  # Save results
  save_data("FILE_DEVICE_USB", $2, "METHOD_BUFFERED", "FILE_ANY_ACCESS", parse_id($1, "USB_CTL"));
  next;
}

# Skip the lines that actually define the macro BTH_KERNEL_CTL
/#defineBTH_KERNEL_CTL\(/ { next; }

# Handle BTH_KERNEL_CTL ioctl definitions
/#define[A-Z0-9_]+BTH_KERNEL_CTL\(/ {
  # Sanity check
  expect(2)
  
  # Save results
  save_data("FILE_DEVICE_BLUETOOTH", $2, "METHOD_NEITHER", "FILE_ANY_ACCESS", parse_id($1, "BTH_KERNEL_CTL"));
  next;
}

# Skip the lines that actually define the macro BTH_CTL
/#defineBTH_CTL\(/ { next; }

# Handle BTH_CTL ioctl definitions
/#define[A-Z0-9_]+BTH_CTL\(/ {
  # Sanity check
  expect(2)
  
  # Save results
  save_data("FILE_DEVICE_BLUETOOTH", $2, "METHOD_BUFFERED", "FILE_ANY_ACCESS", parse_id($1, "BTH_CTL"));
  next;
}

# Skip the lines that actually define the macro BIO_CTL_CODE
/#defineBIO_CTL_CODE\(/ { next; }

# Handle BIO_CTL_CODE ioctl definitions
/#define[A-Z0-9_]+BIO_CTL_CODE\(/ {
  # Sanity check
  expect(2)
  
  # Save results
  save_data("FILE_DEVICE_BIOMETRIC", $2, "METHOD_BUFFERED", "FILE_ANY_ACCESS", parse_id($1, "BIO_CTL_CODE"));
  next;
}

# Skip the lines that actually define the macro _TDI_CONTROL_CODE
/#define_TDI_CONTROL_CODE\(/ { next; }

# Handle _TDI_CONTROL_CODE ioctl definitions
/#define[A-Z0-9_]+_TDI_CONTROL_CODE\(/ {
  # Sanity check
  expect(3)
  
  # Save results
  save_data("FILE_DEVICE_TRANSPORT", $2, $3, "FILE_ANY_ACCESS", parse_id($1, "_TDI_CONTROL_CODE"));
  next;
}

# Skip the lines that actually define the HID CTL_CODE macros
/#defineHID_CTL_CODE\(/ { next; }
/#defineHID_BUFFER_CTL_CODE\(/ { next; }
/#defineHID_IN_CTL_CODE\(/ { next; }
/#defineHID_OUT_CTL_CODE\(/ { next; }

# Handle HID CTL_CODE ioctl definitions
/#define[A-Z0-9_]+HID_CTL_CODE\(/ {
  # Sanity check
  expect(2)
  
  # Save results
  save_data("FILE_DEVICE_KEYBOARD", $2, "METHOD_NEITHER", "FILE_ANY_ACCESS", parse_id($1, "HID_CTL_CODE"));
  next;
}
/#define[A-Z0-9_]+HID_BUFFER_CTL_CODE\(/ {
  # Sanity check
  expect(2)
  
  # Save results
  save_data("FILE_DEVICE_KEYBOARD", $2, "METHOD_BUFFERED", "FILE_ANY_ACCESS", parse_id($1, "HID_BUFFER_CTL_CODE"));
  next;
}
/#define[A-Z0-9_]+HID_IN_CTL_CODE\(/ {
  # Sanity check
  expect(2)
  
  # Save results
  save_data("FILE_DEVICE_KEYBOARD", $2, "METHOD_IN_DIRECT", "FILE_ANY_ACCESS", parse_id($1, "HID_IN_CTL_CODE"));
  next;
}
/#define[A-Z0-9_]+HID_OUT_CTL_CODE\(/ {
  # Sanity check
  expect(2)
  
  # Save results
  save_data("FILE_DEVICE_KEYBOARD", $2, "METHOD_OUT_DIRECT", "FILE_ANY_ACCESS", parse_id($1, "HID_OUT_CTL_CODE"));
  next;
}

# Skip the lines that actually define the macro _IP_CTL_CODE
/#define_IP_CTL_CODE\(/ { next; }

# Handle _IP_CTL_CODE ioctl definitions
/#define[A-Z0-9_]+_IP_CTL_CODE\(/ {
  # Sanity check
  expect(4)
  
  # Save results
  save_data("FILE_DEVICE_NETWORK", $2, $3, $4, parse_id($1, "_IP_CTL_CODE"));
  next;
}

# Skip the lines that actually define the macro _IPFLTRDRVR_CTL_CODE
/#define_IPFLTRDRVR_CTL_CODE\(/ { next; }

# Handle _IPFLTRDRVR_CTL_CODE ioctl definitions
/#define[A-Z0-9_]+_IPFLTRDRVR_CTL_CODE\(/ {
  # Sanity check
  expect(4)
  
  # Save results
  save_data("FILE_DEVICE_NETWORK", $2, $3, $4, parse_id($1, "_IPFLTRDRVR_CTL_CODE"));
  next;
}

# Skip the lines that actually define the macro _NDIS_CONTROL_CODE
/#define_NDIS_CONTROL_CODE\(/ { next; }

# Handle _NDIS_CONTROL_CODE ioctl definitions
/#define[A-Z0-9_]+_NDIS_CONTROL_CODE\(/ {
  # Sanity check
  expect(3)
  
  # Save results
  save_data("FILE_DEVICE_PHYSICAL_NETCARD", $2, $3, "FILE_ANY_ACCESS", parse_id($1, "_NDIS_CONTROL_CODE"));
  next;
}

# Skip the lines that actually define the macro _TCP_CTL_CODE
/#define_TCP_CTL_CODE\(/ { next; }

# Handle _TCP_CTL_CODE ioctl definitions
/#define[A-Z0-9_]+_TCP_CTL_CODE\(/ {
  # Sanity check
  expect(4)
  
  # Save results
  save_data("FILE_DEVICE_NETWORK", $2, $3, $4, parse_id($1, "_TCP_CTL_CODE"));
  next;
}

# Skip the lines that actually define the macro SCARD_CTL_CODE
/#defineSCARD_CTL_CODE\(/ { next; }

# Handle SCARD_CTL_CODE ioctl definitions
/#define[A-Z0-9_]+SCARD_CTL_CODE\(/ {
  # Sanity check
  expect(2);
  
  # Save results
  save_data("FILE_DEVICE_SMARTCARD", $2, "METHOD_BUFFERED", "FILE_ANY_ACCESS", parse_id($1, "SCARD_CTL_CODE"));
  next;
}

# Skip the lines that actually define the macro CTL_CODE or its associated helper macros
/#defineCTL_CODE\(/ { next; }
/#defineDEVICE_TYPE_FROM_CTL_CODE\(/ { next; }
/#defineMETHOD_FROM_CTL_CODE\(/ { next; }

# Handle standard CTL_CODE ioctl definitions
/#define[A-Z0-9_]+CTL_CODE\(/ {
  # Sanity check (this test and the next also catch new #defines for CTL_CODE replacement macros)
  expect(5);
  
  # Save results
  save_data($2, $3, $4, $5, parse_id($1, "CTL_CODE"));
  next;
}

# Special handling of IOCTL_ABORT_PIPE
/#defineIOCTL_ABORT_PIPEIOCTL_CANCEL_IO/ {
  save_data("FILE_DEVICE_USB_SCAN", "IOCTL_INDEX+1", "METHOD_BUFFERED", "FILE_ANY_ACCESS", "IOCTL_ABORT_PIPE");
  next;
}

# Skip lines that are not real IOCTLs
/#defineIOCTL_IP_RTCHANGE_NOTIFY_REQUEST101/ { next; }
/#defineIOCTL_IP_ADDCHANGE_NOTIFY_REQUEST102/ { next; }
/#defineIOCTL_ARP_SEND_REQUEST103/ { next; }
/#defineIOCTL_IP_INTERFACE_INFO104/ { next; }
/#defineIOCTL_IP_GET_BEST_INTERFACE105/ { next; }
/#defineIOCTL_IP_UNIDIRECTIONAL_ADAPTER_ADDRESS106/ { next; }
/#defineIOCTL_CDROM_SUB_Q_CHANNEL0x00/ { next; }
/#defineIOCTL_CDROM_CURRENT_POSITION0x01/ { next; }
/#defineIOCTL_CDROM_MEDIA_CATALOG0x02/ { next; }
/#defineIOCTL_CDROM_TRACK_ISRC0x03/ { next; }
/#defineIOCTL_STORAGE_BC_VERSION1/ { next; }
/#defineIOCTL_VOLUME_BC_VERSION1/ { next; }
/#defineIOCTL_DOT4_LASTIOCTL_DOT4_USER_BASE\+9/ { next; }
/#defineIOCTL_MTP_CUSTOM_COMMAND0x3150544d/ { next; }
/#defineIOCTL_WMP_METADATA_ROUND_TRIP0x31504d57/ { next; }
/#defineIOCTL_WMP_DEVICE_CAN_SYNC0x32504d57/ { next; }

{
  # Skip lines that define device or function types
  for (i in device_types)
    if (match($0, "^#define" i))
      next;
  for (i in function_types)
    if (match($0, "^#define" i))
      next;

  # Process SCSI IOCTLs
  if (match($0, "^#define(IOCTL_SCSI_[A-Z0-9_]+)\\(\\(FILE_DEVICE_SCSI<<16\\)\\+(0x[a-fA-F0-9]+)\\)$", tmp))
  {
    # Parse out and create index
    val = strtonum(tmp[2]);

    device_hex = parse_device("FILE_DEVICE_SCSI");
    function_value = and(rshift(val, 2), 0xFFF);
    function_hex = sprintf("%x", function_value);
    method_value = and(val, 0x3);
    method_hex = sprintf("%x", method_value);
    access_value = and(rshift(val, 14), 0x3);
    access_hex = sprintf("%x", access_value);

    # Save results
    idx = device_hex SUBSEP function_hex SUBSEP method_hex SUBSEP access_hex;
    data[idx] = add_to_set(data[idx], tmp[1]);
    next;
  }

  # Sanity check (this test also catches new #defines for CTL_CODE replacement macros)
  print "Unprocessed line: " $0 > "/dev/stderr";
}

END {
  for (i in unrecognized_devices)
    print "Unrecognized device: " i > "/dev/stderr";
  for (i in unrecognized_functions)
    print "Unrecognized function: " i > "/dev/stderr";
  for (i in unrecognized_methods)
    print "Unrecognized method: " i > "/dev/stderr";
  for (i in unrecognized_access)
    print "Unrecognized access: " i > "/dev/stderr";
  for (i in improper_ioctls)
    print "Improper IOCTL definition: " improper_ioctls[i] > "/dev/stderr";
    
  # Output results
  printf("var ioctl_db = {\n");
  for (i in device_types)
  {
    printf("  '" sprintf("%x", device_types[i]) "': { n: '" data[sprintf("%x", device_types[i]), "name"] "', i: {\n");
    for (j in data)
    {
      split(j, tmp, SUBSEP);
      if (tmp[1] != sprintf("%x", device_types[i]) || tmp[2] == "name")
        continue;
      printf("    '" tmp[2] "." tmp[3] "." tmp[4] "': '" data[j] "',\n");
    }
    printf("    end:0 } },\n");
  }
  printf("  end:0 };\n");
}