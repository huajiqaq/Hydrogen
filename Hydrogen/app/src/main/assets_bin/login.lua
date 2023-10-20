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
  login_web.loadUrl("https://www.zhihu.com/signin?next=www.zhihu.com")
end


--开启 DOM storage API 功能
login_web.getSettings().setDomStorageEnabled(true);


login_web
.getSettings()
.setAppCacheEnabled(true)
--开启 DOM 存储功能
.setDomStorageEnabled(true)
--开启 数据库 存储功能
.setDatabaseEnabled(true)
.setCacheMode(WebSettings.LOAD_DEFAULT)

login_web.setWebChromeClient(LuaWebChrome(LuaWebChrome.IWebChrine{
  onConsoleMessage=function(consoleMessage)
    if consoleMessage.message():find("sign_data=")
      activity.setSharedData("signdata",consoleMessage.message():match("sign_data=(.+)"))
    end
  end,
  onProgressChanged=function(view,Progress)
end}))

login_web.setDownloadListener({
  onDownloadStart=function(链接, UA, 相关信息, 类型, 大小)
    提示("本页不支持下载文件")
end})

login_web.setWebViewClient{
  onLoadResource=function(view,url)

  end,
  shouldOverrideUrlLoading=function(view,url)

    if not view.getUrl():find("https://www.zhihu.com/%?utm_id") and view.getUrl()~="https://www.zhihu.com/" then
      login_web.setVisibility(8)
      progress.setVisibility(0)
    end

    local res=false
    if url:find("wtloginmqq") then
      view.stopLoading()
      双按钮对话框("提示","是否使用QQ登录知乎？","是","否",
      function(an)
        activity.finish()
        xpcall(function()
          intent=Intent("android.intent.action.VIEW")
          intent.setData(Uri.parse(url))
          intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_SINGLE_TOP)
          this.startActivity(intent)
          an.dismiss()
        end,
        function()
          提示("尝试打开出错")
          an.dismiss()
        end)
      end,
      function(an)
        view.loadUrl("https://www.zhihu.com/signin")
        an.dismiss()
      end)
    end
  end,
  onPageStarted=function(view,url)
    加载js(view,获取js("login"))
    if 全局主题值=="Night" then
      黑暗模式主题(view)
    end
  end,
  onPageFinished=function(view,url)
    if url:find("https://www.zhihu.com/%?utm_id") or url=="https://www.zhihu.com" then
      local myurl= 'https://www.zhihu.com/api/v4/me'
      --避免head刷新不及时
      local head = {
        ["cookie"] = 获取Cookie("https://www.zhihu.com/")
      }
      zHttp.get(myurl,head,function(code,content)
        if code==200 then
          local data=luajson.decode(content)
          local uid=data.id--用tointeger不行数值太大了会
          activity.setSharedData("idx",uid)
          activity.setResult(100)
          activity.finish()
          提示("登录成功")
         else
          activity.finish()
          提示("登录失败")
        end
      end)

     else
      progress.setVisibility(8)
      login_web.setVisibility(0)
    end

end}


function onDestroy()
  login_web.destroy()
end