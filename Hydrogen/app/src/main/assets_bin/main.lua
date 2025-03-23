require "import"
initApp=true
useCustomAppToolbar=true
import "jesse205"
import "agreements"
import "android.content.Intent"
import "android.content.ComponentName"
import "android.net.Uri"
--print(1)

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
  this.doFile("home.lua")
end

