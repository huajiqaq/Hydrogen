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

if activity.getSharedData("迁移文件pref0.01")~="true" then
  if 文件是否存在(this.getApplicationInfo().dataDir.."/shared_prefs/Historyrecordtitle.xml")~=true then
    activity.setSharedData("迁移文件pref0.01","true")
    return
  end

  AlertDialog.Builder(this)
  .setTitle("提示")
  .setMessage("请迁移历史记录记录")
  .setCancelable(false)
  .setPositiveButton("立即迁移",{onClick=function()

      local function loadSharedPreferences(name)
        local prefs = this.getSharedPreferences(name, 0).getAll()
        local data = {}
        for entry in each(prefs.entrySet()) do
          data[tonumber(entry.getKey())] = entry.getValue()
        end
        return data
      end

      local function 清除记录(name)
        this.getSharedPreferences(name, 0).edit().clear().commit()
        local sharedPrefsDir = File(this.getApplicationInfo().dataDir, "shared_prefs");
        local fileToDelete = File(sharedPrefsDir, name .. ".xml");
        fileToDelete.delete();
      end

      local titles = loadSharedPreferences("Historyrecordtitle")
      local ids = loadSharedPreferences("Historyrecordid")
      local keywords = loadSharedPreferences("search_history")

      -- 清理旧存储
      local prefsToClear = {
        "Historyrecordtitle", "Historyrecordcontent",
        "Historyrecordid", "search_history"
      }
      for _, name in ipairs(prefsToClear) do
        清除记录(name)
      end

      -- 迁移浏览历史记录
      -- 获取并排序键值
      local sortedKeys = {}
      for key in pairs(ids) do table.insert(sortedKeys, key) end
      table.sort(sortedKeys, function(a, b) return a > b end)

      初始化历史记录数据()
      for _, key in ipairs(sortedKeys) do
        local _type, id = ids[key]:match("(.-)分割(.*)")
        保存历史记录(id, titles[key], "无预览内容", _type)
      end

      -- 迁移搜索历史记录
      sortedKeys = {}
      for key in pairs(keywords) do table.insert(sortedKeys, key) end
      table.sort(sortedKeys, function(a, b) return a > b end)

      初始化搜索历史记录数据()
      for _, key in ipairs(sortedKeys) do
        保存搜索历史记录(keywords[key])
      end

      activity.setSharedData("迁移文件pref0.01","true")
      提示("迁移成功")
  end})
  .show()
end