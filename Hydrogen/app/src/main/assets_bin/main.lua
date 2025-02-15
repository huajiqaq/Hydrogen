require "import"
initApp=true
import "jesse205"
import "agreements"
import "android.content.Intent"
import "android.content.ComponentName"
import "android.net.Uri"

import "model.zHttp"
import "model.zhihu_url"

--[[if (activity.getIntent().getFlags() & Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT)~=0 then
    local intent=tostring(activity.getIntent().getData())
    检查意图(intent)
    activity.finish()
    return
  end]]
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
end

-- 检测是否需要进入欢迎页面

if welcomeAgain then
  newSubActivity("Welcome")
  activity.finish()
  return
 else

  activity.newActivity("home",{activity.getIntent()})
  
  activity.finish()
end

