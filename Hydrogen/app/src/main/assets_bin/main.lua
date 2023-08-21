require "import"
initApp=true
import "jesse205"

-- 检测是否需要进入欢迎页面
import "agreements"

import "android.content.Intent"
import "android.content.ComponentName"
import "android.net.Uri"


function newLuaActivity(filedir,args)
  intent = Intent();
  intent.setAction(Intent.ACTION_MAIN);
  intent.addCategory(Intent.CATEGORY_LAUNCHER);
  intent.setFlags(Intent.FLAG_ACTIVITY_NEW_TASK);
  --设置启动的activity
  componentName = ComponentName(activity.getPackageName(), "com.jesse205.superlua.LuaActivity");
  intent.setComponent(componentName);
  --设置data
  uri = Uri.parse("file://"..filedir);
  intent.setData(uri);
  --设置bundle
  bundle = Bundle();
  bundle.putString("luaPath", filedir);
  --设置intent
  if args then
    bundle.putSerializable("arg", args)
  end
  intent.putExtras(bundle);
  this.startActivityForResult(intent, 1);
end

zHttp = {}

function zHttp.setcallback(code,content,callback)
  if code==403 then
    decoded_content = require "cjson".decode(content)
    if decoded_content.error and decoded_content.error.message and decoded_content.error.redirect then
      AlertDialog.Builder(this)
      .setTitle("提示")
      .setMessage(decoded_content.error.message)
      .setCancelable(false)
      .setPositiveButton("立即跳转",{onClick=function() activity.newActivity("huida",{decoded_content.error.redirect}) 提示("已跳转 成功后请自行退出") end})
      .show()
     else
      callback(code,content)
    end
   else
    callback(code,content)
  end
end


function zHttp.get(url,head,callback)
  Http.get(url,head,function(code,content)
    zHttp.setcallback(code,content,callback)
  end)
end

function zHttp.delete(url,head,callback)
  Http.delete(url,head,function(code,content)
    zHttp.setcallback(code,content,callback)
  end)
end


function zHttp.post(url,data,head,callback)
  Http.post(url,data,head,function(code,content)
    zHttp.setcallback(code,content,callback)
  end)
end

function zHttp.put(url,data,head,callback)
  Http.put(url,data,head,function(code,content)
    zHttp.setcallback(code,content,callback)
  end)
end

import "android.webkit.CookieManager"

function 获取Cookie(url)
  local cookieManager = CookieManager.getInstance();
  return cookieManager.getCookie(url);
end

apphead = {
  ["x-api-version"] = "3.0.89";
  ["x-app-za"] = "OS=Android";
  ["x-app-version"] = "8.44.0";
  ["cookie"] = 获取Cookie("https://www.zhihu.com/")
}

function 检查链接(url,b)
  local open=activity.getSharedData("内部浏览器查看回答")
  --  local url="https"..url:match("https(.+)")
  if url:find("zhihu.com/question") then

    local answer,questions=0,0
    if url:find("answer") then
      questions,answer=url:match("question/(.-)/"),url:match("answer/(.-)?") or url:match("answer/(.+)")
     else
      questions,answer=url:match("question/(.-)?") or url:match("question/(.+)"),nil
      if b then
        return true
      end
      if open=="false" then
        newLuaActivity(this.getLuaDir("question.lua"),Object{questions,true})
       else
        newLuaActivity(this.getLuaDir("huida.lua"),Object{url})
      end
      return
    end
    if b then
      return true
    end
    if open=="false" then
      newLuaActivity(this.getLuaDir("answer.lua"),Object{questions,answer,nil,true})
     else
      newLuaActivity(this.getLuaDir("huida.lua"),Object{url})--"https://www.zhihu.com/question/"..tostring(v.Tag.链接2.Text):match("(.+)分割").."/answer/"..tostring(v.Tag.链接2.Text):match("分割(.+)")})
    end
   elseif url:find("zhuanlan.zhihu.com/p/") then--/p/143744216
    newLuaActivity(this.getLuaDir("column.lua"),Object{url:match("zhihu.com/p/(.+)")})
   elseif url:find("zhuanlan.zhihu.com") then--/p/143744216
    newLuaActivity(this.getLuaDir("huida.lua"),Object{url})
   elseif url:find("zhihu.com/appview/p/") then--/p/143744216
    newLuaActivity(this.getLuaDir("column.lua"),Object{url:match("appview/p/(.+)")})
   elseif url:find("zhihu.com/topics/") then--/p/143744216
    newLuaActivity(this.getLuaDir("topic.lua"),Object{url:match("/topics/(.+)")})
   elseif url:find("zhihu.com/topic/") then--/p/143744216
    newLuaActivity(this.getLuaDir("topic.lua"),Object{url:match("/topic/(.+)")})
   elseif url:find("zhihu.com/pin/") then
    newLuaActivity(this.getLuaDir("column.lua"),Object{url:match("/pin/(.+)"),"想法"})
   elseif url:find("zhihu.com/video/") then
    local videoid= url:match("video/(.+)")
    zHttp.get("https://lens.zhihu.com/api/v4/videos/"..videoid,head,function(code,content)
      if code==200 then
        local v=require "cjson".decode(content)
        xpcall(function()
          视频链接=v.playlist.SD.play_url
          end,function()
          视频链接=v.playlist.LD.play_url
          end,function()
          视频链接=v.playlist.HD.play_url
        end)
        --        activity.finish()
        newLuaActivity(this.getLuaDir("huida.lua"),Object{视频链接})
       elseif code==401 then
        提示("请登录后查看视频")
      end
    end)
   elseif url:find("zhihu.com/zvideo/") then
    local videoid=url:match("/zvideo/(.-)?") or url:match("/zvideo/(.+)")
    newLuaActivity(this.getLuaDir("column.lua"),Object{videoid,"视频"})
   elseif url:find("zhihu.com/people") or url:find("zhihu.com/org") then
    local people_name=url:match("/people/(.-)?") or url:match("/people/(.+)")
    zHttp.get(url,head,function(code,content)
      if code==200 then
        local peopleid=content:match('":{"id":"(.-)","urlToken')
        --        activity.finish()
        newLuaActivity(this.getLuaDir("people.lua"),Object{peopleid,true})
       elseif code==401 then
        提示("请登录后查看用户")
      end
    end)
   elseif url:find("zhihu.com/signin") then
    newLuaActivity(this.getLuaDir("login.lua"))
   elseif url:find("https://ssl.ptlogin2.qq.com/jump") then
    activity.finish()
    newLuaActivity(this.getLuaDir("login.lua"),Object{url})
   elseif url:find("zhihu://") then
    检查意图(url)
   else
    newLuaActivity(this.getLuaDir("huida.lua"),Object{url})
  end
end


function 检查意图(url)
  local get=require "model.answer"
  local open=activity.getSharedData("内部浏览器查看回答")
  if url and url:find("zhihu://") then
    if url:find "answers" then
      local id=url:match("answers/(.-)?")

      get:getAnswer(id,function(s)
        newLuaActivity(this.getLuaDir("answer.lua"),Object{tointeger(s.question.id),tointeger(id),nil,true})
      end)
     elseif url:find "answer" then
      local id=url:match("answer/(.-)/") or url:match("answer/(.+)")
      get:getAnswer(id,function(s)
        newLuaActivity(this.getLuaDir("answer.lua"),Object{tointeger(s.question.id),tointeger(id),nil,true})
      end)
     elseif url:find "questions" then
      newLuaActivity(this.getLuaDir("question.lua"),Object{url:match("questions/(.-)?"),true})
     elseif url:find "question" then
      newLuaActivity(this.getLuaDir("question.lua"),Object{url:match("question/(.-)?"),true})
     elseif url:find "topic" then
      newLuaActivity(this.getLuaDir("topic.lua"),Object{url:match("topic/(.-)/")})
     elseif url:find "people" then
      newLuaActivity(this.getLuaDir("people.lua"),Object{url:match("people/(.-)?"),true})
     elseif url:find "articles" then
      newLuaActivity(this.getLuaDir("column.lua"),Object{url:match("articles/(.-)?")})
     elseif url:find "article" then
      newLuaActivity(this.getLuaDir("column.lua"),Object{url:match("article/(.-)?")})
     elseif url:find "pin" then
      newLuaActivity(this.getLuaDir("column.lua"),Object{url:match("pin/(.-)?"),"想法"})
     elseif url:find "zvideo" then
      newLuaActivity(this.getLuaDir("column.lua"),Object{url:match("zvideo/(.-)?"),"视频"})
     else
      提示("暂不支持的知乎意图"..intent)
    end
   elseif url and (url:find("http://") or url:find("https://")) and url:find("zhihu.com") then
    --    local myurl="https"..url:match("https(.+)")
    检查链接(url)
  end
end

if (activity.getIntent().getFlags() & Intent.FLAG_ACTIVITY_BROUGHT_TO_FRONT)~=0 then
  local intent=tostring(activity.getIntent().getData())
  检查意图(intent)
  activity.finish()
  return
end

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