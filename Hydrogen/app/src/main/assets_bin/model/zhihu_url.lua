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
  return self:match(arg.."(.-)/%?") or self:match(arg.."(.-)/") or self:match(arg.."(.-)%?") or self:match(arg.."(.-)&") or self:match(arg.."(.+)")
end

--获取第一个数字 找不到就返回原字符串
local function getFirstNumber(str)
    local number = str:match("%d+")
    return tonumber(number) or str
end


function 检查链接(url,b)
  --  local url="https"..url:match("https(.+)")
  if url:find("zhihu.com/question") or url:find("zhihu.com/answer") then

    local answer,questions=0,0
    if url:find("answers") then
      questions,answer=url:match("question/(.-)/"),url:match("answers/(.-)?") or url:match("answers/(.+)")
      if b then
        return true
      end
     elseif url:find("answer") then
      questions,answer=url:match("question/(.-)/"),url:match("answer/(.-)?") or url:match("answer/(.+)")
      if b then
        return true
      end
     else
      if b then
        return true
      end
      questions,answer=url:match("question/(.-)?") or url:match("question/(.+)"),nil
      this.newActivity("question",{questions})
      return
    end
    this.newActivity("answer",{getFirstNumber(questions),getFirstNumber(answer)})
   elseif url:find("zhihu.com/column/republish_apply") then
    if b then return true end
    -- 网页端加入专栏
    加入专栏(url:getUrlArg("id="),url:getUrlArg("type="))
   elseif url:find("https://www.zhihu.com/account/unhuman") then
    if b then return true end
    activity.newActivity("browser",{url})
   elseif url:find("zhuanlan.zhihu.com/p/") then--/p/143744216
    if b then return true end
    this.newActivity("column",{url:getUrlArg("zhihu.com/p/")})
   elseif url:find("zhihu.com/appview/p/") then--/p/143744216
    if b then return true end
    this.newActivity("column",{url:getUrlArg("appview/p/")})
   elseif url:find("zhihu.com/topics/") then--/p/143744216
    if b then return true end
    this.newActivity("topic",{url:getUrlArg("/topics/")})
   elseif url:find("zhihu.com/topic/") then--/p/143744216
    if b then return true end
    this.newActivity("topic",{url:getUrlArg("/topic/")})
   elseif url:find("zhihu.com/pin/") then
    if b then return true end
    this.newActivity("column",{url:getUrlArg("/pin/"),"想法"})
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
        this.newActivity("browser",{视频链接})
       elseif code==401 then
        Toast.makeText(activity, "请登录后查看视频",Toast.LENGTH_SHORT).show()
      end
    end)
   elseif url:find("zhihu.com/zvideo/") then
    if b then return true end
    local videoid=url:getUrlArg("/zvideo/")
    this.newActivity("column",{videoid,"视频"})
   elseif url:find("zhihu.com/people") or url:find("zhihu.com/org") then
    if b then return true end
    local people_name=url:getUrlArg("/people/") or url:getUrlArg("/org/")
    this.newActivity("people",{people_name})
   elseif url:find("zhihu.com/roundtable/") then
    if b then return true end
    this.newActivity("column",{url:getUrlArg("/roundtable/"),"圆桌"})
   elseif url:find("zhihu.com/special/") then
    if b then return true end
    this.newActivity("column",{url:getUrlArg("/special/"),"专题"})

   elseif url:find("zhihu.com/column/") then
    if b then return true end
    this.newActivity("people_column",{url:getUrlArg("/column/")})
   elseif url:find("www.zhihu.com/theater") then
    if b then return true end
    this.newActivity("column",{url:match("drama_id=(.-)&"),"直播"})

   elseif url:find("zhihu.com/signin") then
    if b then return true end
    this.newActivity("login")
   elseif url:find("zhihu.com/oia") then
    if b then return true end
    local url=url:gsub("oia/","")
    return 检查意图(url)
    --zhihu_url_Webview.loadUrl(url)
   elseif url:find("https://ssl.ptlogin2.qq.com/jump") then
    if b then return true end
    activity.finish()
    this.newActivity("login",{url})
   elseif url:find("zhihu.com/comment/list") then
    if b then return true end
    local mtype=url:match("comment/list/(.-)/")
    activity.newActivity("comment",{url:getUrlArg(mtype.."/"),mtype.."s"})
   elseif url:find("zhihu://") then
    if b then return true end
    检查意图(url)
   else
    if b then return false end
    this.newActivity("browser",{url})
  end
end

function 检查意图(url,b)
  if url and url:find("zhihu://") then
    if url:find "answers" then
      if b then return true end
      local id=url:getUrlArg("answers/")
      this.newActivity("answer",{"null",id})
     elseif url:find "answer" then
      if b then return true end
      local id=url:getUrlArg("answer/")
      this.newActivity("answer",{"null",id})
     elseif url:find "questions" then
      if b then return true end
      this.newActivity("question",{url:getUrlArg("questions/")})
     elseif url:find "question" then
      if b then return true end
      this.newActivity("question",{url:getUrlArg("question/")})
     elseif url:find "topic" then
      if b then return true end
      this.newActivity("topic",{url:getUrlArg("topic/")})
     elseif url:find "people" then
      if b then return true end
      this.newActivity("people",{url:getUrlArg("people/")})
     elseif url:find "columns" then
      if b then return true end
      this.newActivity("people_column",{url:getUrlArg("columns/")})
     elseif url:find "articles" then
      if b then return true end
      this.newActivity("column",{url:getUrlArg("articles/")})
     elseif url:find "article" then
      if b then return true end
      this.newActivity("column",{url:getUrlArg("article/")})
     elseif url:find "pin" then
      if b then return true end
      this.newActivity("column",{url:getUrlArg("pin/"),"想法"})
     elseif url:find "zvideo" then
      if b then return true end
      this.newActivity("column",{url:getUrlArg("zvideo/"),"视频"})
     elseif url:find("roundtable") then
      if b then return true end
      this.newActivity("column",{url:getUrlArg("/roundtable/"),"圆桌"})
     elseif url:find("special") then
      if b then return true end
      this.newActivity("column",{url:getUrlArg("/special/"),"专题"})
     elseif url:find("theater") then
      if b then return true end
      this.newActivity("column",{url:match("drama_id=(.-)&"),"直播"})

     else
      if b then return false end
      Toast.makeText(activity, "暂不支持的知乎意图"..url,Toast.LENGTH_SHORT).show()
    end
   elseif url and (url:find("http://") or url:find("https://")) and url:find("zhihu.com") then
    检查链接(url)
  end
end