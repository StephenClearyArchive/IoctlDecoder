function dump_source(obj)
{
  if (Array.prototype.isPrototypeOf(obj))
  {
    var ret = '[';
    for (var i = 0; i != obj.length; ++i)
    {
      ret += dump_source(obj[i]);
      if (i != obj.length - 1)
        ret += ',';
    }
    return ret + ']';
  }
  if (typeof(obj) == 'object')
  {
    var ret = '{';
    var properties = Array();
    for (property in obj)
      properties[properties.length] = property;
    for (var i = 0; i != properties.length; ++i)
    {
      ret += dump_source(properties[i]) + ':' + dump_source(obj[properties[i]]);
      if (i != properties.length - 1)
        ret += ',';
    }
    return ret + '}';
  }
  if (typeof(obj) == 'number')
    return obj.toString();
  if (typeof(obj) == 'string')
    return '\'' + obj.replace(/\\/g, '\\\\').replace(/'/g, '\\\'') + '\'';
  if (typeof(obj) == 'function')
    return obj.toString();
}
