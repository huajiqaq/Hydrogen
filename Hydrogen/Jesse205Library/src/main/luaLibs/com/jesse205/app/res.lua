--RES资源获取工具
--[[
--颜色
res.color.attr.colorAccent
androires.color.attr.colorAccent
res.colorStateList.attr.colorAccent
res.color.attr.colorPrimary
--id
android.res.id.attr.actionBarTheme
res.id.attr.actionBarTheme

res(android.res.id.attr.actionBarTheme).color.attr.colorControlNormal

]]
local res={}
res._VERSION="1.0 (alpha)"
res._VERSIONCODE=1
res._NAME="Android Res Getter"

--android.res
local androidRes=table.clone(res)
androidRes._isAndroidRes=true
android.res=androidRes

---默认值
local defaultAttrValue={
  color=0xFFFF0000,
  id=0,
  resourceId=0,
  colorStateList=false,
  boolean=false,
  complexColor=false,
  dimension=0,
  drawable=false,
  float=0,
  font=false,
  int=0,
  integer=0,
  string=false,
  text=false,
  textArray=false,
  type=false,
  themeAttributeId=0,
}

--自动将简写转换为完整形式
local typeFix={
  id="getResourceId",
}

local resources=activity.getResources()
local contextTheme=activity.getTheme()

local resMetatable,
androidMetatable,typeMetatable,
androidAttrMetatable,attrMetatable

--应用了样式的res索引
local styledResMap={}
local styledAndroidResMap={}

local function key2getter(key)
  --print("key2getter",key)
  return "get"..string.gsub(key, "^(%w)", string.upper)
end

local function getAttrValue(_type,key,style)
  --print("getAttrValue",_type,key,style)
  local array
  if style then
    array=contextTheme.obtainStyledAttributes(style,{key})
   else
    array=contextTheme.obtainStyledAttributes({key})
  end
  local defaultValue=defaultAttrValue[_type]
  local value
  if defaultValue~=false then
    value=array[typeFix[_type] or key2getter(_type)](0,defaultAttrValue[_type])
   else
    value=array[typeFix[_type] or key2getter(_type)](0)
  end
  array.recycle()
  luajava.clear(array)
  return value
end

typeMetatable={
  __index=function(self,key)
    local _type=rawget(self,"_type")
    local style=rawget(self,"_style")
    local isAndroidRes=rawget(self,"_isAndroidRes")
    local value
    if key=="attr" then--res.xxx.attr
      value={_type=_type,_isAndroidRes=isAndroidRes,_style=style}
      setmetatable(value,attrMetatable)
     else--res.xxx.xxx
      local Rid=isAndroidRes and android.R or R
      value = resources[key2getter(_type)](Rid[_type][key])
    end
    rawset(self,key,value)
    return value
  end
}

attrMetatable={
  __index=function(self,key)
    local _type=rawget(self,"_type")
    local style=rawget(self,"_style")
    local isAndroidRes=rawget(self,"_isAndroidRes")
    local value
    local Rid=isAndroidRes and android.R or R
    value=getAttrValue(_type,Rid.attr[key],style)
    rawset(self,key,value)
    return value
  end
}

resMetatable={
  __index=function(self,key)
    local isAndroidRes=rawget(self,"_isAndroidRes")
    local style=rawget(self,"_style")
    local typeT={_type=key,_isAndroidRes=isAndroidRes,_style=style}
    setmetatable(typeT,typeMetatable)
    return typeT
  end,
  __call=function(self,key)
    local isAndroidRes=rawget(self,"_isAndroidRes")
    local map=isAndroidRes and styledAndroidResMap or styledResMap
    local styled=map[key]
    if not styled then
      styled={_isAndroidRes=isAndroidRes,_style=key}
      setmetatable(styled,resMetatable)
      map[key]=styled
    end
    return styled
  end,
}

setmetatable(res,resMetatable)
setmetatable(androidRes,resMetatable)

return res