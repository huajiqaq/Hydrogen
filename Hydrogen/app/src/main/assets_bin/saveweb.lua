require "import"
import "mods.muk"
import "com.ua.*"

chrome = import "com.lua.LuaWebChrome";
client = import "com.lua.LuaWebViewclient";
callback = import "com.androlua.LuaWebView$LuaWebViewClient";


保存url,保存路径,写入内容=...

activity.setContentView(loadlayout("layout/browser"))

波纹({fh,_more},"圆主题")

content.BackgroundColor=转0x("#00000000",true);

local ua=getua(content)
content.getSettings().setUserAgentString(ua)

提示("请在页面加载完毕后手动点击右上角保存页面")

task(1,function()
  content.loadUrl(保存url)
end)

content.getSettings()
.setLayoutAlgorithm(WebSettings.LayoutAlgorithm.SINGLE_COLUMN)
.setJavaScriptEnabled(true)--设置支持Js
.setLoadWithOverviewMode(true)
.setDefaultTextEncodingName("utf-8")
.setLoadsImagesAutomatically(true)
.setAllowFileAccess(true)
.setDatabasePath(APP_CACHEDIR)
--设置 应用 缓存目录
.setAppCachePath(APP_CACHEDIR)
--开启 DOM 存储功能
.setDomStorageEnabled(true)
--开启 数据库 存储功能
.setDatabaseEnabled(true)
--开启 应用缓存 功能

.setUseWideViewPort(true)
.setBuiltInZoomControls(true)
.setSupportZoom(true)


if activity.getSharedData("禁用缓存")=="true"
  content
  .getSettings()
  .setAppCacheEnabled(false)
  --关闭 DOM 存储功能
  .setDomStorageEnabled(true)
  --关闭 数据库 存储功能
  .setDatabaseEnabled(true)
  .setCacheMode(WebSettings.LOAD_NO_CACHE);
 else
  content
  .getSettings()
  .setAppCacheEnabled(true)
  --开启 DOM 存储功能
  .setDomStorageEnabled(true)
  --开启 数据库 存储功能
  .setDatabaseEnabled(true)
  .setCacheMode(WebSettings.LOAD_DEFAULT)
end

if 无图模式 then
  content.getSettings().setBlockNetworkImage(true)
end

content.loadUrl(url)
content.removeView(content.getChildAt(0))


function setProgress(p)
  ValueAnimator.ofFloat({pbar.getWidth(),activity.getWidth()/100*p})
  .setDuration(500)
  .addUpdateListener{
    onAnimationUpdate=function(a)
      local x=a.getAnimatedValue()
      local linearParams = pbar.getLayoutParams()
      linearParams.width =x
      pbar.setLayoutParams(linearParams)
    end
  }.start()

end

_title.text="加载中"
content.setVisibility(8)

content.setWebChromeClient(LuaWebChrome(LuaWebChrome.IWebChrine{
  onReceivedTitle=function(view, title)
    _title.text=title
  end,
  onProgressChanged=function(view,p)
    setProgress(p)
    if p==100 then
      setProgress(100)
      Handler().postDelayed(Runnable({
        run=function()
          pbar.Visibility=4
          linearParams=pbar.getLayoutParams()
          linearParams.width =0
          pbar.setLayoutParams(linearParams)
        end,
      }),500)
     else
      pbar.Visibility=0
    end

  end,

  onShowFileChooser=function(v,fic,fileChooserParams)
  end,

  onConsoleMessage=function(consoleMessage)
  end,

  onShowCustomView=function(view,url)
  end,
  onHideCustomView=function(view,url)
  end,
}))


静态渐变(转0x(primaryc)-0x9f000000,转0x(primaryc),pbar,"横")


function onKeyDown(code,event)
  if string.find(tostring(event),"KEYCODE_BACK") ~= nil then
    if content.canGoBack() then
      content.goBack()
     else
      activity.finish()
    end
  end
end


local webview_loadurl=content.getUrl()
local mhtml2html=Uri.fromFile(File(this.getLuaDir().."/mhtml2html.html")).toString()

content.setWebViewClient{
  shouldOverrideUrlLoading=function(view,url)--回调参数，v控件，url网址
    view.stopLoading()
  end,
  onPageStarted=function(view,url,favicon)
    webview_loadurl=url
    加载js(view,获取js("native"))
    view.evaluateJavascript(获取js("imgload"),{onReceiveValue=function(b)end})
    content.setVisibility(0)
  end,
  onLoadResource=function(view,url)
  end,
  onPageFinished=function(view,url)
    屏蔽元素(view,{"SignFlowHomepage-footer"})
    屏蔽元素(view,{".AnswerReward",".AppViewRecommendedReading"})
end}


--设置网页图片点击事件，
local z=JsInterface{
  execute=function(b)
    if b=="getmhtml" then
      return 读取文件(保存路径.."/mht.mht")
     elseif webview_loadurl~=mhtml2html then
      return 提示("本页不支持该操作 只支持保存文件")
     else
      删除文件(保存路径.."/mht.mht")
      写入文件(保存路径.."/html.html",b)
      提示("保存成功")
      this.finish()
    end
  end
}

content.addJSInterface(z,"androlua")

pop={
  tittle="网页",
  list={
    {src=图标("refresh"),text="刷新",onClick=function()
        content.reload()
    end},
    {src=图标("get_app"),text="保存到本地",onClick=function()
        local 父文件夹路径=tostring(File(保存路径).getParentFile())
        if not(文件夹是否存在(父文件夹路径)) then
          创建文件夹(父文件夹路径)
        end
        AlertDialog.Builder(this)
        .setTitle("提示")
        .setMessage("保存中 请耐心等待")
        .setCancelable(false)
        .show()
        创建文件夹(保存路径)
        local 详情文件夹=保存路径.."/detail.txt"
        创建文件(详情文件夹)
        写入文件(详情文件夹,写入内容)
        content.saveWebArchive(保存路径.."/mht.mht")
        提示("保存成功 一秒后转换")
        task(1000,function()
          content.loadUrl(mhtml2html)
          提示("转换中")
        end)
    end},

    {src=图标("share"),text="分享",onClick=function()
        复制文本(content.getUrl())
        提示("已复制网页链接到剪切板")
    end},

  }
}

task(1,function()
  a=MUKPopu(pop)
end)


function onDestroy()
  content.clearCache(true)
  content.clearFormData()
  content.clearHistory()
  content.destroy()
end

if this.getSharedData("禁用缓存")=="true" then
  function onStop()
    content.clearCache(true)
    content.clearFormData()
    content.clearHistory()
  end
end