require "import"
import "mods.muk"
import "com.ua.*"
import "com.lua.LuaWebChrome"

url=...


activity.setContentView(loadlayout("layout/login"))

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

    if url:sub(1,4)~="http" then
      return true
    end

    if not view.getUrl():find("https://www.zhihu.com/%?utm_id") and view.getUrl()~="https://www.zhihu.com/" then
      login_web.setVisibility(8)
      progress.setVisibility(0)
    end


    if url:find("qq.com") then
      view.stopLoading()
      view.getSettings().setUserAgentString("Mozilla/5.0 (Linux; Android 5.1; OPPO R9tm Build/LMY47I; wv) AppleWebKit/537.36 (KHTML, like Gecko) Version/4.0 Chrome/53.0.2785.49 Mobile MQQBrowser/6.2 TBS/043128 Safari/537.36 V1_AND_SQ_7.0.0_676_YYB_D PA QQ/7.0.0.3135 NetType/4G WebP/0.3.0 Pixel/1080 Edg/125.0.0.0")
      view.loadUrl(url)
      return
    end

  end,
  onPageStarted=function(view,url)
    if url:find("https://www.zhihu.com/signin") then
      加载js(view,获取js("login"))
    end
    if 全局主题值=="Night" then
      夜间模式主题(view)
    end
    网页字体设置(view)
  end,
  onPageFinished=function(view,url)
    if url:find("https://www.zhihu.com/%?utm_id") or url=="https://www.zhihu.com" or url=="https://www.zhihu.com/" then
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
          加载js(view,"document.cookie = document.cookie")
          提示("登录成功")
         else
          view.loadUrl("https://www.zhihu.com/signin")
          加载js(view,"document.cookie = ''")
          提示("登录失败")
        end
      end)

     else
      progress.setVisibility(8)
      login_web.setVisibility(0)
    end
  end,
  shouldInterceptRequest=拦截加载}


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