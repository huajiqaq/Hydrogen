local PermissionUtil={}
local grantedList={}
PermissionUtil.grantedList=grantedList
local context=Jesse205.context--当前context

local function request(permissions)
  ActivityCompat.requestPermissions(context,String(permissions),0)
end
PermissionUtil.request=request

local function checkPermission(permission)
  return ActivityCompat.checkSelfPermission(context,permission)==PackageManager.PERMISSION_GRANTED
end
PermissionUtil.checkPermission=checkPermission

local function check(permissions)
  for index,permission in ipairs(permissions)
    local granted=checkPermission(permission)
    if not(granted) then--有一个没给予，直接返回false
      return false
    end
  end
  return true--所有的权限都没有没被给予，返回true
end
PermissionUtil.check=check

--[[
local function smartRequestPermission(permissions)
  local needApply={}
  for index,permission in ipairs(permissions)
    local granted=grantedList[permission]
    if not(granted) then
      local nowGranted=checkPermission(permission)
      if nowGranted then
        grantedList[permission]=true
       else
        table.insert(needApply,permission)
      end
    end
  end
  if #needApply~=0 then
    request(needApply)
  end
  needApply=nil
end
PermissionUtil.smartRequestPermission=smartRequestPermission
]]
--[[
{
  {
    icon=R.drawable.ic_file_outline;
    name=getLocalLangObj("存储权限"),
    tool="文件浏览器"
    todo="获取文件列表"
    permissions={"android.permission.WRITE_EXTERNAL_STORAGE","android.permission.READ_EXTERNAL_STORAGE"};
  }
}]]
local function askForRequestPermissions(permissionsItemsList)
  for index=1,#permissionsItemsList do
    local permissionsItem=permissionsItemsList[index]
    local permissions=permissionsItem.permissions
    if not(check(permissions)) then
      AlertDialog.Builder(this)
      .setIcon(permissionsItem.icon)
      .setTitle(R.string.Jesse205_permission_request)
      .setMessage(formatResStr(R.string.Jesse205_permission_ask,{permissionsItem.tool,permissionsItem.name,permissionsItem.todo}))
      .setPositiveButton(android.R.string.ok,function()
        request(permissions)
      end)
      .show()
    end

  end
end
PermissionUtil.askForRequestPermissions=askForRequestPermissions

return PermissionUtil
