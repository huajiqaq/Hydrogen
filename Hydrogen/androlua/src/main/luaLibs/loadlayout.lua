local require=require
local luajava = luajava
local table=require "table"
luajava.ids=luajava.ids or {id=0x7f000000}
local ids = luajava.ids
local _G=_G
local insert = table.insert
local new = luajava.new
local bindClass = luajava.bindClass
--local ids={}
local ltrs={}
local type=type
local context=activity or service

local ViewGroup=bindClass("android.view.ViewGroup")
local String=bindClass("java.lang.String")
local Gravity=bindClass("android.view.Gravity")
local OnClickListener=bindClass("android.view.View$OnClickListener")
local TypedValue=luajava.bindClass("android.util.TypedValue")
local BitmapDrawable=luajava.bindClass("android.graphics.drawable.BitmapDrawable")
local LuaDrawable=luajava.bindClass "com.androlua.LuaDrawable"
local LuaBitmapDrawable=luajava.bindClass "com.androlua.LuaBitmapDrawable"
local LuaAdapter=luajava.bindClass "com.androlua.LuaAdapter"
local ArrayListAdapter=bindClass("android.widget.ArrayListAdapter")
local ArrayPageAdapter=bindClass("android.widget.ArrayPageAdapter")
local AdapterView=bindClass("android.widget.AdapterView")
local ScaleType=bindClass("android.widget.ImageView$ScaleType")
local TruncateAt=bindClass("android.text.TextUtils$TruncateAt")
local scaleTypes=ScaleType.values()
local android_R=bindClass("android.R")
android={R=android_R}

local Context=bindClass "android.content.Context"
local DisplayMetrics=bindClass "android.util.DisplayMetrics"

local wm =context.getSystemService(Context.WINDOW_SERVICE);
local outMetrics = DisplayMetrics();
wm.getDefaultDisplay().getMetrics(outMetrics);
local W = outMetrics.widthPixels;
local H = outMetrics.heightPixels;

local function alyloader(path)
  local alypath=package.path:gsub("%.lua;",".aly;")
  local path,msg=package.searchpath(path,alypath)
  if msg then
    return msg
  end
  local f=io.open(path)
  local s=f:read("*a")
  f:close()
  if string.sub(s,1,4)=="\27Lua" then
    return assert(loadfile(path)),path
  else
    --return assert(loadstring("return "..s, path:match("[^/]+/[^/]+$"),"bt")),path
    local f,st=loadstring("return "..s, path:match("[^/]+/[^/]+$"),"bt")
    if st then
      error(st:gsub("%b[]",path,1),0)
    end
    return f,st
  end
end
table.insert(package.searchers,alyloader)


local dm=context.getResources().getDisplayMetrics()
local id=0x7f000000
local toint={
  --android:drawingCacheQuality
  auto=0,
  low=1,
  high=2,

  --android:importantForAccessibility
  auto=0,
  yes=1,
  no=2,

  --android:layerType
  none=0,
  software=1,
  hardware=2,

  --android:layoutDirection
  ltr=0,
  rtl=1,
  inherit=2,
  locale=3,

  --android:scrollbarStyle
  insideOverlay=0x0,
  insideInset=0x01000000,
  outsideOverlay=0x02000000,
  outsideInset=0x03000000,

  --android:visibility
  visible=0,
  invisible=4,
  gone=8,

  wrap_content=-2,
  fill_parent=-1,
  match_parent=-1,
  wrap=-2,
  fill=-1,
  match=-1,

  --android:autoLink
  none=0x00,
  web=0x01,
  email=0x02,
  phon=0x04,
  map=0x08,
  all=0x0f,

  --android:orientation
  vertical=1,
  horizontal= 0,

  --android:gravity
  axis_clip = 8,
  axis_pull_after = 4,
  axis_pull_before = 2,
  axis_specified = 1,
  axis_x_shift = 0,
  axis_y_shift = 4,
  bottom = 80,
  center = 17,
  center_horizontal = 1,
  center_vertical = 16,
  clip_horizontal = 8,
  clip_vertical = 128,
  display_clip_horizontal = 16777216,
  display_clip_vertical = 268435456,
  --fill = 119,
  fill_horizontal = 7,
  fill_vertical = 112,
  horizontal_gravity_mask = 7,
  left = 3,
  no_gravity = 0,
  relative_horizontal_gravity_mask = 8388615,
  relative_layout_direction = 8388608,
  right = 5,
  start = 8388611,
  top = 48,
  vertical_gravity_mask = 112,
  ["end"] = 8388613,

  --android:textAlignment
  inherit=0,
  gravity=1,
  textStart=2,
  textEnd=3,
  textCenter=4,
  viewStart=5,
  viewEnd=6,

  --android:inputType
  none=0x00000000,
  text=0x00000001,
  textCapCharacters=0x00001001,
  textCapWords=0x00002001,
  textCapSentences=0x00004001,
  textAutoCorrect=0x00008001,
  textAutoComplete=0x00010001,
  textMultiLine=0x00020001,
  textImeMultiLine=0x00040001,
  textNoSuggestions=0x00080001,
  textUri=0x00000011,
  textEmailAddress=0x00000021,
  textEmailSubject=0x00000031,
  textShortMessage=0x00000041,
  textLongMessage=0x00000051,
  textPersonName=0x00000061,
  textPostalAddress=0x00000071,
  textPassword=0x00000081,
  textVisiblePassword=0x00000091,
  textWebEditText=0x000000a1,
  textFilter=0x000000b1,
  textPhonetic=0x000000c1,
  textWebEmailAddress=0x000000d1,
  textWebPassword=0x000000e1,
  number=0x00000002,
  numberSigned=0x00001002,
  numberDecimal=0x00002002,
  numberPassword=0x00000012,
  phone=0x00000003,
  datetime=0x00000004,
  date=0x00000014,
  time=0x00000024,

  --android:imeOptions
  normal=0x00000000,
  actionUnspecified=0x00000000,
  actionNone=0x00000001,
  actionGo=0x00000002,
  actionSearch=0x00000003,
  actionSend=0x00000004,
  actionNext=0x00000005,
  actionDone=0x00000006,
  actionPrevious=0x00000007,
  flagNoFullscreen=0x2000000,
  flagNavigatePrevious=0x4000000,
  flagNavigateNext=0x8000000,
  flagNoExtractUi=0x10000000,
  flagNoAccessoryAction=0x20000000,
  flagNoEnterAction=0x40000000,
  flagForceAscii=0x80000000,

}

local scaleType={
  --android:scaleType
  matrix=0,
  fitXY=1,
  fitStart=2,
  fitCenter=3,
  fitEnd=4,
  center=5,
  centerCrop=6,
  centerInside=7,
}


local rules={
  layout_above=2,
  layout_alignBaseline=4,
  layout_alignBottom=8,
  layout_alignEnd=19,
  layout_alignLeft=5,
  layout_alignParentBottom=12,
  layout_alignParentEnd=21,
  layout_alignParentLeft=9,
  layout_alignParentRight=11,
  layout_alignParentStart=20,
  layout_alignParentTop=10,
  layout_alignRight=7,
  layout_alignStart=18,
  layout_alignTop=6,
  layout_alignWithParentIfMissing=0,
  layout_below=3,
  layout_centerHorizontal=14,
  layout_centerInParent=13,
  layout_centerVertical=15,
  layout_toEndOf=17,
  layout_toLeftOf=0,
  layout_toRightOf=1,
  layout_toStartOf=16
}


local types={
  px=0,
  dp=1,
  sp=2,
  pt=3,
  ["in"]=4,
  mm=5
}

local function checkType(v)
  local n,ty=string.match(v,"^(%-?[%.%d]+)(%a%a)$")
  return tonumber(n),types[ty]
end

local function checkPercent(v)
  local n,ty=string.match(v,"^(%-?[%.%d]+)%%([wh])$")
  if ty==nil then
    return nil
  elseif ty=="w" then
    return tonumber(n)*W/100
  elseif ty=="h" then
    return tonumber(n)*H/100
  end
end


local function split(s,t)
  local idx=1
  local l=#s
  return function()
    local i=s:find(t,idx)
    if idx>=l then
      return nil
    end
    if i==nil then
      i=l+1
    end
    local sub=s:sub(idx,i-1)
    idx=i+1
    return sub
  end
end
local function checkint(s)
  local ret=0
  for n in split(s,"|") do
    if toint[n] then
      ret=ret | toint[n]
    else
      return nil
    end
  end
  return ret
end



local function checkNumber(var)
  if type(var) == "string" then
    if var=="true" then
      return true
    elseif var=="false" then
      return false
    end

    if toint[var] then
      return toint[var]
    end

    local p=checkPercent(var)
    if p then
      return p
    end

    local i=checkint(var)
    if i then
      return i
    end

    local h=string.match(var,"^#(%x+)$")
    if h then
      local c=tonumber(h,16)
      if c then
        if #h<=6 then
          return c-0x1000000
        elseif #h<=8 then
          if c>0x7fffffff then
            return c-0x100000000
          else
            return c
          end
        end
      end
    end

    local n,ty=checkType(var)
    if ty then
      return TypedValue.applyDimension(ty,n,dm)
    end
  end
  -- return var
end

local function checkValue(var)
  return tonumber(var) or checkNumber(var) or var
end

local function checkValues(...)
  local vars={...}
  for n=1,#vars do
    vars[n]=checkValue(vars[n])
  end
  return unpack(vars)
end

local function getattr(s)
  return android_R.attr[s]
end

local function checkattr(s)
  local e,s=pcall(getattr,s)
  if e then
    return s
  end
  return nil
end

local function getIdentifier(name)
  return context.getResources().getIdentifier(name,null,null)
end

local function dump2 (t)
  local _t={}
  table.insert(_t,tostring(t))
  table.insert(_t,"\t{")
  for k,v in pairs(t) do
    if type(v)=="table" then
      table.insert(_t,"\t\t"..tostring(k).."={"..tostring(v[1]).." ...}")
    else
      table.insert(_t,"\t\t"..tostring(k).."="..tostring(v))
    end
  end
  table.insert(_t,"\t}")
  t=table.concat(_t,"\n")
  return t
end

local ver = luajava.bindClass("android.os.Build").VERSION.SDK_INT;
local function setBackground(view,bg)
  if ver<16 then
    view.setBackgroundDrawable(bg)
  else
    view.setBackground(bg)
  end
end

local function setattribute(root,view,params,k,v,ids)
  if k=="layout_x" then
    params.x=checkValue(v)
  elseif k=="layout_y" then
    params.y=checkValue(v)
  elseif k=="layout_weight" then
    params.weight=checkValue(v)
  elseif k=="layout_gravity" then
    params.gravity=checkValue(v)
  elseif k=="layout_marginStart" then
    params.setMarginStart(checkValue(v))
  elseif k=="layout_marginEnd" then
    params.setMarginEnd(checkValue(v))
  elseif rules[k] and (v==true or v=="true") then
    params.addRule(rules[k])
  elseif rules[k] then
    params.addRule(rules[k],ids[v])
  elseif k=="items" then --创建列表项目
    if type(v)=="table" then
      if view.adapter then
        view.adapter.addAll(v)
      else
        local adapter=ArrayListAdapter(context,android_R.layout.simple_list_item_1, String(v))
        view.setAdapter(adapter)
      end
    elseif type(v)=="function" then
      if view.adapter then
        view.adapter.addAll(v())
      else
        local adapter=ArrayListAdapter(context,android_R.layout.simple_list_item_1, String(v()))
        view.setAdapter(adapter)
      end
    elseif type(v)=="string" then
      local v=rawget(root,v) or rawget(_G,v)
      if view.adapter then
        view.adapter.addAll(v())
      else
        local adapter=ArrayListAdapter(context,android_R.layout.simple_list_item_1, String(v()))
        view.setAdapter(adapter)
      end
    end
  elseif k=="pages" and type(v)=="table" then --创建页项目
    local ps={}
    for n,o in ipairs(v) do
      local tp=type(o)
      if tp=="string" or tp=="table" then
        table.insert(ps,loadlayout(o,root))
      else
        table.insert(ps,o)
      end
    end
    local adapter=ArrayPageAdapter(View(ps))
    view.setAdapter(adapter)
  elseif k=="textSize" then
    if tonumber(v) then
      view.setTextSize(tonumber(v))
    elseif type(v)=="string" then
      local n,ty=checkType(v)
      if ty then
        view.setTextSize(ty,n)
      else
        view.setTextSize(v)
      end
    else
      view.setTextSize(v)
    end
  elseif k=="textAppearance" then
    view.setTextAppearance(context,checkattr(v))
  elseif k=="ellipsize" then
    view.setEllipsize(TruncateAt[string.upper(v)])
  elseif k=="url" then
    view.loadUrl(url)
  elseif k=="src" then
    if v:find("^%?") then
      view.setImageResource(getIdentifier(v:sub(2,-1)))
    elseif v:find("^https?://") then
      task([[require "import" url=... return loadbitmap(url)]],v,function(bmp)view.setImageBitmap(bmp)end)
    else
      view.setImageBitmap(loadbitmap(v))
    end
  elseif k=="scaleType" then
    view.setScaleType(scaleTypes[scaleType[v]])
  elseif k=="background" then
    if type(v)=="string" then
      if v:find("^%?") then
        view.setBackgroundResource(getIdentifier(v:sub(2,-1)))
      elseif v:find("^#") then
        view.setBackgroundColor(checkNumber(v))
      elseif rawget(root,v) or rawget(_G,v) then
        v=rawget(root,v) or rawget(_G,v)
        if type(v)=="function" then
          setBackground(view,LuaDrawable(v))
        elseif type(v)=="userdata" then
          setBackground(view,v)
        end
      else
        if (not v:find("^/")) and luadir then
          v=luadir..v
        end
        if v:find("%.9%.png") then
          setBackground(view,NineBitmapDrawable(loadbitmap(v)))
        else
          setBackground(view,LuaBitmapDrawable(context,v))
        end
      end
    elseif type(v)=="userdata" then
      setBackground(view,v)
    elseif type(v)=="number" then
      setBackground(view,v)
    end
  elseif k=="onClick" then --设置onClick事件接口
    local listener
    if type(v)=="function" then
      listener=OnClickListener{onClick=v}
    elseif type(v)=="userdata" then
      listener=v
    elseif type(v)=="string" then
      if ltrs[v] then
        listener=ltrs[v]
      else
        local l=rawget(root,v) or rawget(_G,v)
        if type(l)=="function" then
          listener=OnClickListener{onClick=l}
        elseif type(l)=="userdata" then
          listener=l
        else
          listener=OnClickListener{onClick=function(a)(root[v] or _G[v])(a)end}
        end
        ltrs[v]=listener
      end
    end
    view.setOnClickListener(listener)
  elseif k=="password" and (v=="true" or v==true) then
    view.setInputType(0x81)
  elseif type(k)=="string" and not(k:find("layout_")) and not(k:find("padding")) and k~="style" then --设置属性
    k=string.gsub(k,"^(%w)",function(s)return string.upper(s)end)
    if k=="Text" or k=="Title" or k=="Subtitle" then
      view["set"..k](v)
    elseif not k:find("^On") and not k:find("^Tag") and type(v)=="table" then
      view["set"..k](checkValues(unpack(v)))
    else
      view["set"..k](checkValue(v))
    end
  end
end

local function copytable(f,t,b)
  for k,v in pairs(f) do
    if k==1 then
    elseif b or t[k]==nil then
      t[k]=v
    end
  end
end


local function setstyle(c,t,root,view,params,ids)
  local mt=getmetatable(t)
  if not mt or not mt.__index then
    return
    end
  local m=mt.__index
  if c[m] then
    return
    end
  c[m]=true
  for k,v in pairs(m) do
    if not rawget(c,k) then
      pcall(setattribute,root,view,params,k,v,ids)
    end
    c[k]=true
  end
  setstyle(c,m,root,view,params,ids)
end


local function loadlayout(t,root,group)
  if type(t)=="string" then
    t=require(t)
  elseif type(t)~="table" then
    error(string.format("loadlayout error: Fist value Must be a table, checked import layout.",0))
    end
  root=root or _G
  local view,style

  if t.style then
    if t.style:find("^%?") then
      style=getIdentifier(t.style:sub(2,-1))
    else
      local st,sty=pcall(require,t.style)
      if st then
        --copytable(sty,t)
        setmetatable(t,{__index=sty})
      else
        style=checkattr(t.style)
      end
    end
  end
  if not t[1] then
    error(string.format("loadlayout error: Fist value Must be a Class, checked import package.\n\tat %s",dump2(t)),0)
  end

  if style then
    view = t[1](context,nil,style)
  else
    view = t[1](context) --创建view
  end

  local params=ViewGroup.LayoutParams(checkValue(t.layout_width) or -2,checkValue(t.layout_height) or -2) --设置layout属性
  if group then
    params=group.LayoutParams(params)
  end

  --设置layout_margin属性
  if t.layout_margin or t.layout_marginStart or t.layout_marginEnd or t.layout_marginLeft or t.layout_marginTop or t.layout_marginRight or t.layout_marginBottom then
    params.setMargins(checkValues( t.layout_marginLeft or t.layout_margin or 0,t.layout_marginTop or t.layout_margin or 0,t.layout_marginRight or t.layout_margin or 0,t.layout_marginBottom or t.layout_margin or 0))
  end

  --设置padding属性
  if t.padding and type(t.padding)=="table" then
    view.setPadding(checkValues(unpack(t.padding)))
  elseif t.padding or t.paddingLeft or t.paddingTop or t.paddingRight or t.paddingBottom then
    view.setPadding(checkValues(t.paddingLeft or t.padding or 0, t.paddingTop or t.padding or 0, t.paddingRight or t.padding or 0, t.paddingBottom or t.padding or 0))
  end
  if t.paddingStart or t.paddingEnd then
    view.setPaddingRelative(checkValues(t.paddingStart or t.padding or 0, t.paddingTop or t.padding or 0, t.paddingEnd or t.padding or 0, t.paddingBottom or t.padding or 0))
  end

  local c={}
  setmetatable(c,{__index=t})
  setstyle(c,t,root,view,params,ids)

  for k,v in pairs(t) do
    if tonumber(k) and (type(v)=="table" or type(v)=="string") then --创建子view
      if luajava.instanceof(view,AdapterView) then
        if type(v)=="string" then
          v=require(v)
        end
        view.adapter=LuaAdapter(context,v)
      else
        view.addView(loadlayout(v,root,t[1]))
      end
    elseif k=="id" then --创建view的全局变量
      rawset(root,v,view)
      local id=ids.id
      ids.id=ids.id+1
      view.setId(id)
      ids[v]=id

    else
      local e,s=pcall(setattribute,root,view,params,k,v,ids)
      if not e then
        local _,i=s:find(":%d+:")
        s=s:sub(i or 1,-1)
        local t,du=pcall(dump2,t)
        print(string.format("loadlayout error %s \n\tat %s\n\tat  key=%s value=%s\n\tat %s",s,view.toString(),k,v,du or ""),0)
      end
    end
  end

  --if group then
  --group.addView(view,params)
  --else
  view.setLayoutParams(params)
  return view
  --end
end


return loadlayout

