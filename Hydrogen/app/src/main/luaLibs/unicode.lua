return function()
  local String = luajava.bindClass "java.lang.String"
  local Integer = luajava.bindClass "java.lang.Integer"
  local StringBuffer = luajava.bindClass "java.lang.StringBuffer"
  local string=String(string)
  local unicode = StringBuffer();
  for i = 0, string.length()-1 do
    local c = string.charAt(i);
    unicode.append("\\u" .. Integer.toHexString(c));
  end
  return unicode.toString();
end