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
-- //开启 数据库 存储功能
.setDatabaseEnabled(true)
.setCacheMode(2)

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
    加载js(view,获取js("login"))
    if 全局主题值=="Night" then
      黑暗模式主题(view)
    end
  end,
  onPageFinished=function(view,url)
    if login_web.getUrl():find("https://www.zhihu.com/%?utm_id") or login_web.getUrl()=="https://www.zhihu.com" then
      activity.setResult(100)
      activity.finish()
      提示("登录成功")
     else
      progress.setVisibility(8)
      login_web.setVisibility(0)
    end

end}

function onKeyDown(keyCode,event)

  if (keyCode == KeyEvent.KEYCODE_BACK && event.getRepeatCount() == 0)
    activity.setResult(100)
    activity.finish()
    return true;
  end
end


function onDestroy()
  login_web.destroy()
end