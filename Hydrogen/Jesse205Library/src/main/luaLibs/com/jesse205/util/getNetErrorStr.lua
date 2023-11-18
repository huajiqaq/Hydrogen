local netCodeMap=application.get("netCodeMap")
if not netCodeMap then
  netCodeMap=HashMap({
    [301] ="Moved Permanently",
    [305] ="Use Proxy",
    [405] ="Method Not Allowed",
    [205] ="Reset Content",
    [412] ="Precondition Failed",
    [401] ="Unauthorized",
    [409] ="Conflict",
    [307] ="Temporary Redirect",
    [407] ="Proxy Authentication Required",
    [303] ="See Other",
    [203] ="Non-Authoritative Information",
    [503] ="Service Unavailable",
    [403] ="Forbidden",
    [410] ="Gone",
    [202] ="Accepted",
    [302] ="Found",
    [406] ="Not Acceptable",
    [206] ="Partial Content",
    [502] ="Bad Gateway",
    [408] ="Request Timeout",
    [204] ="No Content",
    [304] ="Not Modified",
    [404] ="Not Found",
    [413] ="Request Entity Too Large",
    [300] ="Multiple Choices",
    [200] ="OK",
    [100] ="Continue",
    [414] ="Request URI Too Long",
    [500] ="Internal Server Error",
    [400] ="Bad Request",
    [505] ="HTTP Version Not Supported",
    [504] ="Gateway Timeout",
    [416] ="Requested Range Not Satisfiable",
    [501] ="Not Implemented",
    [101] ="Switching Protocols",
    [411] ="Length Required",
  })
  application.set("netCodeMap",netCodeMap)
end

local function getNetErrorStr(code)
  local errStr=netCodeMap[code]
  return formatResStr(R.string.jesse205_toast_neterror,{errStr or "Unknow",code})
end
--application.set("NetErrorStr",NetErrorStr)
return getNetErrorStr