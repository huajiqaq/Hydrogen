local context=activity or service

local LuaBitmap=luajava.bindClass "com.androlua.LuaBitmap"
local function loadbitmap(path)
  if not path:find("^https*://") and not path:find("%.%a%a%a%a?$") then
    path=path..".png"
  end
 if path:find("^https*://") then
    return LuaBitmap.getHttpBitmap(context,path)
 elseif not path:find("^/") then
    return LuaBitmap.getLocalBitmap(context,string.format("%s/%s",luajava.luadir,path))
 else
    return LuaBitmap.getLocalBitmap(context,path)
  end
end
return loadbitmap
