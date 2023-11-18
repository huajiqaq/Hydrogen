import "android.webkit.CookieManager"

function urlEncode(s)
  s = string.gsub(s, "([^%w%.%- ])", function(c) return string.format("%%%02X", string.byte(c)) end)
  return string.gsub(s, " ", " ")
end


function urlDecode(s)
  s = string.gsub(s, '%%(%x%x)', function(h) return string.char(tonumber(h, 16)) end)
  return s
end

function string:getUrlArg(arg)
  --lua对字符串进行了优化 变量为字符串时也可以调用string的其他方法
  return self:match(arg.."(.-)/%?") or  self:match(arg.."(.-)?") or self:match(arg.."(.+)")
end

function newLuaActivity(filedir,args)
  local filedir=this.getLuaDir(filedir..".lua")
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
    args=Object(args)
    bundle.putSerializable("arg", args)
  end
  intent.putExtras(bundle);
  this.startActivityForResult(intent, 1);
end

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
        newLuaActivity("question",{questions,true})
       else
        newLuaActivity("huida",{url})
      end
      return
    end
    if b then
      return true
    end
    if open=="false" then
      newLuaActivity("answer",{questions,answer,nil,true})
     else
      newLuaActivity("huida",{url})
    end
   elseif url:find("zhuanlan.zhihu.com/p/") then--/p/143744216
    if b then return true end
    newLuaActivity("column",{url:getUrlArg("zhihu.com/p/")})
   elseif url:find("zhuanlan.zhihu.com/write") then
    if b then return true end
    newLuaActivity("huida",{"https://zhuanlan.zhihu.com/write","专栏",true})
   elseif url:find("zhihu.com/appview/p/") then--/p/143744216
    if b then return true end
    newLuaActivity("column",{url:getUrlArg("appview/p/")})
   elseif url:find("zhihu.com/topics/") then--/p/143744216
    if b then return true end
    newLuaActivity("topic",{url:getUrlArg("/topics/")})
   elseif url:find("zhihu.com/topic/") then--/p/143744216
    if b then return true end
    newLuaActivity("topic",{url:getUrlArg("/topic/")})
   elseif url:find("zhihu.com/pin/") then
    if b then return true end
    newLuaActivity("column",{url:getUrlArg("/pin/"),"想法"})
   elseif url:find("zhihu.com/video/") then
    if b then return true end
    local videoid= url:getUrlArg("video/")
    local head = {
      ["cookie"] = CookieManager.getInstance().getCookie("https://www.zhihu.com/");
    }
    zHttp.get("https://lens.zhihu.com/api/v4/videos/"..videoid,head,function(code,content)
      if code==200 then
        local v=luajson.decode(content)
        xpcall(function()
          视频链接=v.playlist.SD.play_url
          end,function()
          视频链接=v.playlist.LD.play_url
          end,function()
          视频链接=v.playlist.HD.play_url
        end)
        newLuaActivity("huida",{视频链接})
       elseif code==401 then
        Toast.makeText(activity, "请登录后查看视频",Toast.LENGTH_SHORT).show()
      end
    end)
   elseif url:find("zhihu.com/zvideo/") then
    if b then return true end
    local videoid=url:getUrlArg("/zvideo/")
    newLuaActivity("column",{videoid,"视频"})
   elseif url:find("zhihu.com/people") or url:find("zhihu.com/org") then
    if b then return true end
    local people_name=url:getUrlArg("/people/")
    local head = {
      ["cookie"] = CookieManager.getInstance().getCookie("https://www.zhihu.com/");
    }
    zHttp.get(url,head,function(code,content)
      if code==200 then
        local peopleid=content:match('":{"id":"(.-)","urlToken')
        newLuaActivity("people",{peopleid,true})
       elseif code==401 then
        Toast.makeText(activity, "请登录后查看用户",Toast.LENGTH_SHORT).show()
      end
    end)
   elseif url:find("zhihu.com/roundtable/") then
    if b then return true end
    newLuaActivity("column",{url:getUrlArg("/roundtable/"),"圆桌"})
   elseif url:find("zhihu.com/special/") then
    if b then return true end
    newLuaActivity("column",{url:getUrlArg("/special/"),"专题"})

   elseif url:find("zhihu.com/column/") then
    if b then return true end
    newLuaActivity("people_column",{url:getUrlArg("/column/")})
   elseif url:find("www.zhihu.com/theater") then
    if b then return true end
    newLuaActivity("column",{url:match("drama_id=(.-)&"),"直播"})

   elseif url:find("zhihu.com/signin") then
    if b then return true end
    newLuaActivity("login")
   elseif url:find("https://ssl.ptlogin2.qq.com/jump") then
    if b then return true end
    activity.finish()
    newLuaActivity("login",{url})
   elseif url:find("zhihu://") then
    if b then return true end
    检查意图(url)
   else
    if b then return false end
    newLuaActivity("huida",{url})
  end
end

function 检查意图(url,b)
  local open=activity.getSharedData("内部浏览器查看回答")
  if url and url:find("zhihu://") then
    if url:find "answers" then
      if b then return true end
      local id=url:getUrlArg("answers/")
      newLuaActivity("answer",{"null",tointeger(id),nil,true})
     elseif url:find "answer" then
      if b then return true end
      local id=url:getUrlArg("answer/")
      newLuaActivity("answer",{"null",tointeger(id),nil,true})
     elseif url:find "questions" then
      if b then return true end
      newLuaActivity("question",{url:getUrlArg("questions/"),true})
     elseif url:find "question" then
      if b then return true end
      newLuaActivity("question",{url:getUrlArg("question/"),true})
     elseif url:find "topic" then
      if b then return true end
      newLuaActivity("topic",{url:getUrlArg("topic/")})
     elseif url:find "people" then
      if b then return true end
      newLuaActivity("people",{url:getUrlArg("people/"),true})
     elseif url:find "columns" then
      if b then return true end
      newLuaActivity("people_column",{url:getUrlArg("columns/")})
     elseif url:find "articles" then
      if b then return true end
      newLuaActivity("column",{url:getUrlArg("articles/")})
     elseif url:find "article" then
      if b then return true end
      newLuaActivity("column",{url:getUrlArg("article/")})
     elseif url:find "pin" then
      if b then return true end
      newLuaActivity("column",{url:getUrlArg("pin/"),"想法"})
     elseif url:find "zvideo" then
      if b then return true end
      newLuaActivity("column",{url:getUrlArg("zvideo/"),"视频"})
     elseif url:find("roundtable") then
      if b then return true end
      newLuaActivity("column",{url:getUrlArg("/roundtable/"),"圆桌"})
     elseif url:find("special") then
      if b then return true end
      newLuaActivity("column",{url:getUrlArg("/special/"),"专题"})
     elseif url:find("theater") then
      if b then return true end
      newLuaActivity("column",{url:match("drama_id=(.-)&"),"直播"})

     else
      if b then return false end
      Toast.makeText(activity, "暂不支持的知乎意图"..url,Toast.LENGTH_SHORT).show()
    end
   elseif url and (url:find("http://") or url:find("https://")) and url:find("zhihu.com") then
    检查链接(url)
  end
end