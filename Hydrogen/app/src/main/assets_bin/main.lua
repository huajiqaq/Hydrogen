require "import"
initApp=true
import "jesse205"

-- 检测是否需要进入欢迎页面
import "agreements"
local welcomeAgain = not(getSharedData("welcome"))
if not(welcomeAgain) then
  for index=1, #agreements do
    local content=agreements[index]
    if getSharedData(content.name) ~= content.date then
      welcomeAgain = true
      setSharedData("welcome",false)
      break
    end
  end
  activity.newActivity("home",{activity.getIntent()})
  activity.finish()
end
if welcomeAgain then
  newSubActivity("Welcome")
  activity.finish()
  return
end
--[[
StatService.start(activity)

import "AppFunctions"

oldTheme=ThemeUtil.getAppTheme()
oldDarkActionBar=getSharedData("theme_darkactionbar")

--计时间戳器
local lastBackTime=0

activity.setTitle(R.string.app_name)
--activity.setContentView(loadlayout("layout"))

actionBar=activity.getSupportActionBar()
actionBar.setTitle(R.string.app_name)
--actionBar.setDisplayHomeAsUpEnabled(true)

function onCreateOptionsMenu(menu)
  local inflater=activity.getMenuInflater()
  inflater.inflate(R.menu.menu_main,menu)
end

function onOptionsItemSelected(item)
  local id=item.getItemId()
  local Rid=R.id
  local aRid=android.R.id
  if id==aRid.home then
    activity.finish()
   elseif id==Rid.menu_more_settings then--设置
    newSubActivity("Settings")
   elseif id==Rid.menu_more_about then--关于
    newSubActivity("About")
  end
end

function onResume()
  if (oldTheme~=ThemeUtil.getAppTheme())
    or (oldDarkActionBar~=getSharedData("theme_darkactionbar"))
    then
    activity.recreate()
    return
  end
end

function onDestroy()
  AppPath.cleanTemp()
end

function onBackPressed()
  if (System.currentTimeMillis()-lastBackTime)> 2000 then
    MyToast(R.string.exit_toast)
    .addCallback(Snackbar.BaseCallback({
      onDismissed=function()
        lastBackTime=0
      end
    }))
    lastBackTime=System.currentTimeMillis()
    return true
  end
end

function onConfigurationChanged(config)
  screenConfigDecoder:decodeConfiguration(config)
end

screenConfigDecoder=ScreenFixUtil.ScreenConfigDecoder({

})

onConfigurationChanged(activity.getResources().getConfiguration())
]]