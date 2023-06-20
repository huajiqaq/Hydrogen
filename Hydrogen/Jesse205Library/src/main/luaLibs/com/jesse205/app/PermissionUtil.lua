local PermissionUtil={}
local grantedList={}
PermissionUtil.grantedList=grantedList
local context=jesse205.context--当前context

--申请多个权限
local function request(permissions,requestCode)
  ActivityCompat.requestPermissions(context,String(permissions),requestCode or 0)
end
PermissionUtil.request=request

---检查单个权限是否*给予
local function checkPermission(permission)
  return ActivityCompat.checkSelfPermission(context,permission)==PackageManager.PERMISSION_GRANTED
end
PermissionUtil.checkPermission=checkPermission

---检查多个权限是否给予
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
{
  {
    icon=R.drawable.ic_file_outline;
    name=getLocalLangObj("存储权限"),
    tool="文件浏览器"
    todo="获取文件列表"
    permissions={"android.permission.WRITE_EXTERNAL_STORAGE","android.permission.READ_EXTERNAL_STORAGE"};
  }
}]]
local function askForRequestPermissions(permissionsItemsList,requestCode)
  for index=1,#permissionsItemsList do
    local permissionsItem=permissionsItemsList[index]
    local permissions=permissionsItem.permissions
    if not(check(permissions)) then
      local builder=AlertDialog.Builder(this)
      .setIcon(permissionsItem.icon)
      .setTitle(R.string.jesse205_permission_request)
      .setMessage(formatResStr(R.string.jesse205_permission_ask,{autoId2str(permissionsItem.tool),autoId2str(permissionsItem.name),autoId2str(permissionsItem.todo)}))
      .setPositiveButton(android.R.string.ok,function()
        if permissionsItem.intent then
          activity.startActivity(permissionsItem.intent)
         else
          request(permissions,requestCode)
        end
      end)
      if permissionsItem.helpUrl then
        builder.setNeutralButton(R.string.jesse205_getHelp,nil)
      end
      local dialog=builder.show()
      local neutralButton=dialog.getButton(AlertDialog.BUTTON_NEUTRAL)
      if permissionsItem.helpUrl then
        neutralButton.onClick=function()
          openUrl(permissionsItem.helpUrl)
        end
      end
    end
  end
end

PermissionUtil.askForRequestPermissions=askForRequestPermissions

return PermissionUtil
