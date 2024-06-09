require "import"
import "mods.muk"
import "com.ua.*"
import "com.lua.LuaWebChrome"

url=...


activity.setContentView(loadlayout("layout/login"))

设置toolbar(toolbar)

波纹({fh,_info},"圆主题")

login_web.removeView(login_web.getChildAt(0))

login_web
.getSettings()
.setAppCacheEnabled(true)
--开启 DOM 存储功能
.setDomStorageEnabled(true)
--开启 数据库 存储功能
.setDatabaseEnabled(true)
.setCacheMode(WebSettings.LOAD_DEFAULT)


login_web.BackgroundColor=转0x("#00000000",true)

if url then
  login_web.loadUrl(url)
 else
  login_web.loadUrl("https://www.zhihu.com/signin")
end


login_web.setWebChromeClient(LuaWebChrome(LuaWebChrome.IWebChrine{
  onConsoleMessage=function(consoleMessage)
    if consoleMessage.message():find("sign_data=")
      activity.setSharedData("signdata",consoleMessage.message():match("sign_data=(.+)"))
      设置Cookie("https://www.zhihu.com/",luajson.decode(activity.getSharedData("signdata")).cookie)--设置Cookie
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
    if url:find("https://www.zhihu.com/signin") then
      加载js(view,获取js("login"))
      加载js(view,"document.cookie = 'z_c0=2|1:0|10:1717630166|4:z_c0|92:Mi4xRU52bkNRQUFBQUFBTU4tLVhybTZHQXdBQUFCZ0FsVk4xb0dJWmdEU3UxeUZ4OTM3NjREVXYxcm1DU0ZUSFBIeUFR|94b2c672aafc551bd8503d81662ba5dbf55de0e9e054f248dbee0231432e8ef3; ff_supports_webp=1; _xsrf=3mhSPpFld4Qe8V46QiIj27csHoR7nmSU; _zap=0fd30885-9969-451a-97f7-21c04146ad80; Hm_lvt_98beee57fd2ef70ccdd5ca52b9740c49=1717630298; _ga=GA1.2.380854752.1717630298; _gid=GA1.2.374219357.1717630298; Hm_lpvt_98beee57fd2ef70ccdd5ca52b9740c49=1717630344; d_c0=ADDfvl65uhhLBSL1mvx8NKlaNBqgKMw_YPs=|1717632667; KLBRSID=ed2ad9934af8a1f80db52dcb08d13344|1717632669|1717630293'")
    end
    if 全局主题值=="Night" then
      黑暗模式主题(view)
    end
  end,
  onPageFinished=function(view,url)
    if url:find("https://www.zhihu.com/%?utm_id") or url=="https://www.zhihu.com" then
      if isfirst==nil then
        isfirst=true
        --尝试解决登录无效的问题
        view.loadUrl("https://www.zhihu.com/")
        return
      end
      local myurl= 'https://www.zhihu.com/api/v4/me'
      --避免head刷新不及时
      local head = {
        ["cookie"] = 获取Cookie("https://www.zhihu.com/")
      }
      zHttp.get(myurl,head,function(code,content)
        if code==200 then
          local data=luajson.decode(content)
          local uid=data.id
          activity.setSharedData("idx",uid)
          activity.setResult(100)
          activity.finish()
          提示("登录成功")
         else
          view.loadUrl("https://www.zhihu.com/signin")
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

if this.getSharedData("禁用缓存")=="true" then
  function onStop()
    login_web.clearCache(true)
    login_web.clearFormData()
    login_web.clearHistory()
  end
end