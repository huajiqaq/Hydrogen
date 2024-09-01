require "import"
import "mods.muk"
import "com.ua.*"

chrome = import "com.lua.LuaWebChrome";
client = import "com.lua.LuaWebViewclient";
callback = import "com.androlua.LuaWebView$LuaWebViewClient";


url,urltitle=...

activity.setContentView(loadlayout("layout/browser"))

波纹({fh,_more},"圆主题")

content.BackgroundColor=转0x("#00000000",true);

if url:find("https://www.zhihu.com/messages") then
  content.getSettings().setUserAgentString("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36")
 else
  local ua=getua(content)
  content.getSettings().setUserAgentString(ua)
end


content.getSettings()
.setLayoutAlgorithm(WebSettings.LayoutAlgorithm.SINGLE_COLUMN)
.setJavaScriptEnabled(true)--设置支持Js
.setLoadWithOverviewMode(true)
.setDefaultTextEncodingName("utf-8")
.setLoadsImagesAutomatically(true)
.setAllowFileAccess(false)
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
    if urltitle then
      title=urltitle.." - 知乎"
    end
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
    uploadMessageAboveL=fic
    local intent= Intent(Intent.ACTION_PICK)
    intent.setType("image/*;video/*")
    this.startActivityForResult(intent, 1)
    return true;
  end,

  onConsoleMessage=function(consoleMessage)
    --打印控制台信息
    if consoleMessage.message():find("加载完成") then
      content.setVisibility(0)
      progress.setVisibility(8)
     elseif consoleMessage.message():find("重新加载") then
      content.setVisibility(8)
      progress.setVisibility(0)
     elseif consoleMessage.message()=="显示评论" then
      activity.newActivity("comment",{mresult,mmtype.."s"})
    end
  end,

  onShowCustomView=function(view,url)
    web_video_view=view
    savedScrollY=content.getScrollY()
    content.setVisibility(8)
    activity.getDecorView().addView(web_video_view)
    --    this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE)
    全屏()
  end,
  onHideCustomView=function(view,url)
    content.setVisibility(0)
    activity.getDecorView().removeView(web_video_view)
    --    this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
    取消全屏()
    Handler().postDelayed(Runnable({
      run=function()
        content.scrollTo(0, savedScrollY);
      end,
    }),200)
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

webview查找文字监听(content)

pop={
  tittle="网页",
  list={
    {src=图标("refresh"),text="刷新",onClick=function()
        content.reload()
    end},
    {src=图标("redo"),text="前进",onClick=function()
        content.goForward()
    end},
    {src=图标("undo"),text="后退",onClick=function()
        content.goBack()
    end},
    {src=图标("close"),text="停止",onClick=function()
        content.stopLoading()
    end},

    {src=图标("share"),text="分享",onClick=function()
        复制文本(content.getUrl())
        提示("已复制网页链接到剪切板")
    end},
    {
      src=图标("search"),text="在网页查找内容",onClick=function()
        webview查找文字(content)
      end
    },

  }
}

content.setWebViewClient{
  shouldOverrideUrlLoading=function(view,url)--回调参数，v控件，url网址
    res=false
    if url:find("zhihu.com") and url:find("https://www.zhihu.com/account/unhuman") then
      view.stopLoading()
      activity.setResult(100)
      if url:find("zhihu.com/signin") then
        activity.newActivity("login")
        return
      end
      if url:find("need_login=true") and not(url:find("https://www.zhihu.com/account/unhuman")) then
        AlertDialog.Builder(this)
        .setTitle("提示")
        .setMessage("登录可减少验证的出现 多次出现验证知乎可能会暂时封禁一些功能 如果长期使用推荐登录 如已验证通过请自行退出 如退出后多次出现请尝试登录")
        .setPositiveButton("我知道了",nil)
        .setNeutralButton("登录",{onClick=function() activity.newActivity("login") end})
        .setCancelable(false)
        .show()
        return
      end
      return
    end
    if url:sub(1,4)~="http" then
      view.stopLoading()
      if 检查意图(url,true) then
        检查意图(url)
        activity.finish()
       else
        双按钮对话框("提示","是否用第三方软件打开本链接？","是","否",
        function(an)
          xpcall(function()
            intent=Intent("android.intent.action.VIEW")
            intent.setData(Uri.parse(url))
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_SINGLE_TOP)
            this.startActivity(intent)
            an.dismiss()
          end,
          function()
            提示("尝试打开第三方app出错")
            an.dismiss()
          end)
        end,
        function(an)
          an.dismiss()
        end)
      end
     else
      if 检查链接(url,true) then
        if url:find("https://www.zhihu.com/answer/") then
          url=url
          return
        end
        view.stopLoading()
        检查链接(url)
      end
    end
    if url=="https://www.zhihu.com" or url=="https://www.zhihu.com/" or url=="https://www.zhihu.com?utm" then
      view.stopLoading()
    end

  end,
  onPageStarted=function(view,url,favicon)
    view.evaluateJavascript(获取js("imgload"),{onReceiveValue=function(b)end})
    网页字体设置(view)
    等待doc(view)
    if url:find("zhihu.com/search") then
      加载js(view,'window.open=function() { return false }')
    end
    if 全局主题值=="Night" then
      夜间模式主题(view)
    end

    local pop=table.clone(pop)

    if urltitle=="举报" then
      加载js内容=获取js("report")
     elseif urltitle=="提问" then
      加载js内容=获取js("ask")
     elseif urltitle=="新建专栏" then
      加载js内容=获取js("addcolumn")
     elseif url:find("https://www.zhihu.com/messages") then
      加载js内容=获取js("messages")
     elseif url:find("https://www.zhihu.com/notifications") then
      加载js内容=获取js("notification")
     elseif url:find("https://www.zhihu.com/settings/") then
      加载js内容=获取js("setting")
     else
      加载js内容=获取js("model")
    end

    加载js(view,获取js("native"))

    a=MUKPopu(pop)

    if 加载js内容 then
      加载js(view,加载js内容)
    end

    content.setVisibility(0)

  end,
  onLoadResource=function(view,url)

  end,
  onPageFinished=function(view,url)
    屏蔽元素(view,{"SignFlowHomepage-footer"})
  end,
  shouldInterceptRequest=拦截加载}

--设置网页图片点击事件，
local z=JsInterface{
  execute=function(b)
    if b~=nil and #b>1 then
      --newActivity传入字符串过大会造成闪退 暂时通过setSharedData解决
      this.setSharedData("imagedata",b)
      activity.newActivity("image")
    end
  end
}

content.addJSInterface(z,"androlua")

content.setDownloadListener({
  onDownloadStart=function(链接, UA, 相关信息, 类型, 大小)
    webview下载文件(链接, UA, 相关信息, 类型, 大小)
end})


task(1,function()
  a=MUKPopu(pop)
end)


uploadMessageAboveL=0
onActivityResult=function(req,res,intent)
  if (res == Activity.RESULT_CANCELED) then
    if(uploadMessageAboveL~=nil and uploadMessageAboveL~=0 )then
      uploadMessageAboveL.onReceiveValue(nil);
    end
  end
  local results
  if (res == Activity.RESULT_OK)then
    if(uploadMessageAboveL==nil or type(uploadMessageAboveL)=="number")then
      return;
    end
    if (intent ~= nil) then
      local dataString = intent.getDataString();
      local clipData = intent.getClipData();
      if (clipData ~= nil) then
        results = Uri[clipData.getItemCount()];
        for i = 0,clipData.getItemCount()-1 do
          local item = clipData.getItemAt(i);
          results[i] = item.getUri();
        end
      end
      if (dataString ~= nil) then
        results = Uri[1];
        results[0]=Uri.parse(dataString)
      end
    end
  end
  if(results~=nil)then
    uploadMessageAboveL.onReceiveValue(results);
    uploadMessageAboveL = nil;
  end
  if res==100 then
    if url:find("zhihu.com") and url:find("https://www.zhihu.com/account/unhuman") then
      activity.finish()
    end
  end
end

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