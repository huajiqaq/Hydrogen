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