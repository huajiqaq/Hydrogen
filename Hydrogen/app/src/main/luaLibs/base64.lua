base64 = {}

local String=luajava.bindClass "java.lang.String"
local Base64=luajava.bindClass "android.util.Base64";

function base64.enc(str)
  local encodedText = Base64.encodeToString(String(str).getBytes(), Base64.NO_WRAP);
  return tostring(encodedText)
end


function base64.dec(str)
  local decodedBytes = Base64.decode(String(str).getBytes(), Base64.DEFAULT);
  local decodedString = String(decodedBytes, "UTF-8");
  return tostring(decodedString)
end

return base64