require "import"
import "mods.muk"
import "com.ua.*"
import "com.lua.LuaWebChrome"

url=...


activity.setContentView(loadlayout("layout/login"))


波纹({fh,_info},"圆主题")


login_web.removeView(login_web.getChildAt(0))

if url then
  login_web.loadUrl(url)
 else
  login_web.loadUrl("https://www.zhihu.com/signin")
end


--开启 DOM storage API 功能
login_web.getSettings().setDomStorageEnabled(true);


login_web
.getSettings()
.setAppCacheEnabled(true)
--//开启 DOM 存储功能
.setDomStorageEnabled(true)
--        //开启 数据库 存储功能
.setDatabaseEnabled(true)
.setCacheMode(2)

--import "android.webkit.WebChromeClient"
--login_web.setWebChromeClient(luajava.override(WebChromeClient,{
login_web.setWebChromeClient(LuaWebChrome(LuaWebChrome.IWebChrine{
  onConsoleMessage=function(consoleMessage)
    if consoleMessage.message():find("sign_data=")
      activity.setSharedData("signdata",consoleMessage.message():match("sign_data=(.+)"))
    end
  end,
  onProgressChanged=function(view,Progress)
    if 全局主题值=="Night" then
      黑暗模式主题(view)
      --      加载js(view,[[javascript:(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=50,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#]]..backgroundc:sub(4,#backgroundc)..[[ !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]])
    end
end}))

login_web.setDownloadListener({
  onDownloadStart=function(链接, UA, 相关信息, 类型, 大小)
    提示("本页不支持下载文件")
end})

login_web.setWebViewClient{
  onLoadResource=function(view,url)
    if 全局主题值=="Night" then
      黑暗模式主题(view)
      --      加载js(view,[[javascript:(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=50,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#]]..backgroundc:sub(4,#backgroundc)..[[ !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]])
    end

  end,
  shouldOverrideUrlLoading=function(view,url)
    if login_web.getUrl()~="https://www.zhihu.com/" then
      login_web.setVisibility(8)
      progress.setVisibility(0)
    end

    local res=false
    if url:find("wtloginmqq") then
      view.stopLoading()
      双按钮对话框("提示","是否使用QQ登录知乎？","是","否",
      function()
        activity.finish()
        xpcall(function()
          intent=Intent("android.intent.action.VIEW")
          intent.setData(Uri.parse(url))
          intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_SINGLE_TOP)
          this.startActivity(intent)
          an.dismiss()
        end,
        function(v)
          提示("尝试打开出错")
          an.dismiss()
        end)
      end,
      function()
        view.loadUrl("https://www.zhihu.com/signin")
        an.dismiss()
      end)
    end
  end,
  onPageStarted=function(view,url)
    view.evaluateJavascript([[(function(){
let logFetch = window.fetch
function onfetch(callback) {
    window.fetch = function (input, init) {
        return new Promise((resolve, reject) => {
            logFetch(input, init)
                .then(function (response) {
                    callback(response.clone())
                    resolve(response)
                }, reject)
        })
    }
}

onfetch(response => {
   // response.json()
   response.text()
    .then(res=>{
//    if (res.access_token) {
    if (/access_token/.test(res)) {
	console.log("sign_data="+res)
    }
	})
})
})()]],nil)
  end,
  onPageFinished=function(view,url)
    if login_web.getUrl():find("https://www.zhihu.com/%?utm_id") or login_web.getUrl()=="https://www.zhihu.com" then
      activity.setResult(100)
      activity.newActivity("home")
      activity.finish()
      提示("登录成功")
     else
      progress.setVisibility(8)
      login_web.setVisibility(0)
    end

    if 全局主题值=="Night" then
      黑暗模式主题(view)
      --      加载js(view,[[javascript:(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=50,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#]]..backgroundc:sub(4,#backgroundc)..[[ !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]])
    end

end}

function onKeyDown(keyCode,event)

  if (keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0)
    activity.setResult(100)
    activity.newActivity("home")
    activity.finish()
    return true;
  end
end

--[=[
控件隐藏(验证码_root)


local 临时cookie="" --登录过程的cookie
local 是否验证码=false

function 数据加密(str,str2) --加密签名信息
  import "com.zhihu.hydrogen.util.b"
  return b.a(str,str2)
end

local tmp1=string.format("OS=Android&Release=%s&Model=%s",Build.VERSION.RELEASE,Build.MODEL)--登录的版本信息





local head = { --head头，以下信息必要
  ["Authorization"]="oauth 8d5227e0aaaa4797a763ac64e0c3b8",
  ["x-app-version"]="5.6.1",
  ["x-app-za"]=tmp1,
}


function 构建父请求数据(type)--如函数
  local parent={
    timestamp=os.time(),
    client_id = "8d5227e0aaaa4797a763ac64e0c3b8",
    source = "com.zhihu.android",
    grant_type=type
  }

  parent.signature=数据加密(type..parent.client_id..parent.source..parent.timestamp,"ecbefbf6b17e47ecb9035107866380")
  return parent
end


function 格式化数据(m) --转换数据
  local t=""
  for k,v in pairs(m)
    if #t<1 then
      t=t..k.."="..v
     else
      t=t.."&"..k.."="..v
    end
  end

  return t
end


--[=[
function 登录(a,b)
  local base=构建父请求数据("password")
  base.username=tostring(a)
  base.password=tostring(b)
  head.cookie=临时cookie

  Http.post("https://api.zhihu.com/sign_in",格式化数据(base),临时cookie,nil,head,function(a,b,c)
    临时cookie=""
    是否验证码=false
    --清空验证码信息
    if a==201 then --返回码

      if require "cjson".decode(b).cookie then
        设置Cookie("https://www.zhihu.com/",c)--设置Cookie
        提示("登录成功")
        activity.setResult(100,Intent())--回调吗
        activity.finish()
       else
        验证码图片.setImageBitmap(nil)--设置空图片，防止一些bug
        控件隐藏(验证码_root)
        提示("登录出错 :"..require "cjson".decode(b).error.message)
      end
     elseif a~=-1 then
      控件隐藏(验证码_root)
      验证码图片.setImageBitmap(nil)
      提示("登录出错 :"..require "cjson".decode(b).error.message)
     else
      控件隐藏(验证码_root)
      提示("登录出错")
      验证码图片.setImageBitmap(nil)
    end
  end)
end
function 输入验证码(text)
  Http.post("https://api.zhihu.com/captcha","input_text="..text,{["cookie"]=临时cookie},function(code,b,c,d,e)

    if code==201 then --判断返回码
      if b:find("true") then --如果验证成功
        登录(login_username.getText(),login_password.getText())
       else
        提示("输入验证码出错 :"..require "cjson".decode(b).error.message)
      end
     elseif code~=-1 then
      提示("输入验证码出错 :"..require "cjson".decode(b).error.message)
     else
      提示("验证码出错")
    end

  end)
end

function 请求验证码()
  Http.put("https://api.zhihu.com/captcha",临时cookie,{["cookie"]=临时cookie},function(a,b,c,d,e)
    if a==202 then
      bitmapArray=byte{} --基础的byte数组
      bitmapArray = Base64.decode(require "cjson".decode(b).img_base64, Base64.DEFAULT);
      验证码图片.setImageBitmap(BitmapFactory.decodeByteArray(bitmapArray, 0, #bitmapArray))--设置图像
     elseif code~=-1 then
      提示("获取验证码出错 :"..require "cjson".decode(b).error.message)
     else
      提示("获取验证码出错")

    end
  end)
end




button.onClick=function()
  if #临时cookie>1 or 是否验证码==true then --判断是否输入验证码
    if #login_captcha.getText()<1 then --判断是否输入
      提示("验证码为空")
     else
      输入验证码(login_captcha.getText())
    end
   else
    if #login_username.getText()<1 or #login_password.getText()<1 then --检测账号密码是否输入
      提示("请输入账号密码")
      return
    end
    Http.get("https://api.zhihu.com/captcha",function(a,b,c,d,e)
      if a==200 then--这里是获取是否需要输入验证码
        临时cookie=c
        if b:find("true") then
          是否验证码=true
          提示("需要验证码验证")--提示验证验证码
          请求验证码()
          控件显示(验证码_root)
         else--不然就登录
          是否验证码=false
          登录(login_username.getText(),login_password.getText())
        end
       elseif code~=-1 then
        临时cookie=""
        提示("登录出错 :"..require "cjson".decode(b).error.message)
       else
        临时cookie=""
        提示("登录出错")
      end
    end)
  end
end

a=MUKPopu({
  tittle="登录",
  list={
    {src=图标("head"),text="切换网页版登录",onClick=function()
        local tmp=[[local m=tostring(...)  if m=="https://www.zhihu.com/" then    activity.newActivity("main") activity.finish() end]]--构造代码
        activity.newActivity("huida",{"https://www.zhihu.com/signin?next=%2F",tmp,true})
        activity.setResult(200)
        activity.finish()
    end},
  }
})
]=]

function onDestroy()
  login_web.destroy()
  System.gc()
  LuaUtil.rmDir(File(tostring(ContextCompat.getDataDir(activity)).."/cache"))
  collectgarbage("collect")
end