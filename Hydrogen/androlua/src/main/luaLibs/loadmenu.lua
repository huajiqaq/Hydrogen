local require=require
local table=require "table"
luajava.ids=luajava.ids or {id=0x7f000000}
local ids = luajava.ids
local _G=_G
local insert = table.insert
local new = luajava.new
local bindClass = luajava.bindClass
local LuaDrawable=luajava.bindClass "com.androlua.LuaDrawable"
local loadbitmap=require "loadbitmap"

local function loadmenu(menu,t,root,maxcount)
  local root=root or _G
  local maxcount=maxcount or 0
  for k,v in ipairs(t) do
    local id=ids.id
    ids.id=ids.id+1
    if v[1]== MenuItem then
      local item=menu.add(v.group or 0,id,v.order or 0,v.title)
      if v.id then
        rawset(root,v.id,item)
        ids[v.id]=id
      end
      --maxcount 即如果循环小于指定次数就添加到actionbar栏上
      if k<=maxcount then
        item.setShowAsAction(MenuItem.SHOW_AS_ACTION_ALWAYS)
      end
      if v.icon then
        --是BitmapDrawable就直接设置
        if luajava.instanceof(v.icon,BitmapDrawable) then
          item.setIcon(v.icon)
         else
          item.setIcon(BitmapDrawable(loadbitmap(v.icon)))
        end
      end
      if v.enabled==false then
        item.setEnabled(false)
      end
      if v.visible==false then
        item.setVisible(false)
      end
      if v.checkable==true then
        item.setCheckable(true)
      end
      if v.checked==true then
        item.setChecked(true)
      end
     elseif v[1]== SubMenu then
      local item=menu.addSubMenu(v.group or 0,id,v.order or 0,v.title)
      loadmenu(item,v,root)
    end
  end
end
return loadmenu