require "import"
import "mods.muk"
import "com.ua.*"

chrome = import "com.lua.LuaWebChrome";
client = import "com.lua.LuaWebViewclient";
callback = import "com.androlua.LuaWebView$LuaWebViewClient";


liulanurl,docode,ischeck,fxurl=...

activity.setContentView(loadlayout("layout/huida"))

波纹({fh,_more},"圆主题")

liulan.loadUrl(liulanurl)

if docode~=nil then
  liulan.getSettings().setUserAgentString("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36")
  -- else
 elseif liulanurl:find("zhihu") and not liulanurl:find("zvideo") then
  liulan.getSettings().setUserAgentString("Mozilla/5.0 (Android 9; MI ) AppleWebKit/537.36 (KHTML) Version/4.0 Chrome/74.0.3729.136 mobile SearchCraft/2.8.2 baiduboxapp/3.2.5.10")--设置UA
end

liulan.removeView(liulan.getChildAt(0))

if ischeck then
  if liulanurl=="https://www.zhihu.com" or docode=="提问" then
    是否加载js=true
   elseif liulanurl:find("zhihu") and liulanurl:find("answer") then
    是否加载js=true
   elseif liulanurl:find("https://www.zhihu.com/messages") then
    是否加载js=true
   elseif liulanurl:find("zhihu") and liulanurl:find("question") and liulanurl:find("write") then
    是否加载js=true
  end
end

if 是否加载js then
  liulan.setVisibility(8)
  progress.setVisibility(0)
end

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

liulan.setWebChromeClient(LuaWebChrome(LuaWebChrome.IWebChrine{
  onReceivedTitle=function(view, title)
    --_title.text=(liulan.getTitle())
    if type(docode)=="string" then
      title=docode.." - 知乎"
    end
    if _title.text~="搜索" then
      if liulanurl~="https://www.zhihu.com" and activity.getSharedData("标题简略化")~="true" then
        _title.text=(title)
       elseif liulanurl=="https://www.zhihu.com"
        _title.text="提问 - 知乎"
       else
        _title.text="加载完成"
      end
    end
  end,
  onProgressChanged=function(view,p)
    setProgress(p)
    if p==100 then
      pbar.setVisibility(8)
      setProgress(0)
    end

  end,

  onShowFileChooser=function(v,fic,fileChooserParams)
    uploadMessageAboveL=fic
    local intent= Intent(Intent.ACTION_PICK)
    intent.setType("image/*")
    this.startActivityForResult(intent, 1)
    return true;
  end,

  onConsoleMessage=function(consoleMessage)
    --打印控制台信息
    if consoleMessage.message():find("加载完成") then
      liulan.setVisibility(0)
      progress.setVisibility(8)
     elseif consoleMessage.message():find("重新加载") then
      liulan.setVisibility(8)
      progress.setVisibility(0)
    end
  end,

  onShowCustomView=function(view,url)
    liulan.setVisibility(8);
    this.addContentView(view, WindowManager.LayoutParams(-1, -1))
    kkoo=view
    activity.getWindow().getDecorView().setSystemUiVisibility(5639)
  end,
  onHideCustomView=function(view,url)
    kkoo.getParent().removeView(kkoo.setForeground(nil).setVisibility(8))
    liulan.setVisibility(0)
    kkoo=nil
    activity.getWindow().getDecorView().setSystemUiVisibility(8208)
  end
}))


静态渐变(转0x(primaryc)-0x9f000000,转0x(primaryc),pbar,"横")


function onKeyDown(code,event)
  if string.find(tostring(event),"KEYCODE_BACK") ~= nil then
    if liulan.canGoBack() then
      liulan.goBack()
     else
      activity.finish()
    end
  end
end

liulan.setWebViewClient{
  shouldOverrideUrlLoading=function(view,url)--回调参数，v控件，url网址
    local res=false
    if liulanurl:find("zhihu.com") and liulanurl:find("https://www.zhihu.com/account/unhuman") then
      提示("验证通过")
      local function success_do()
        activity.setResult(100)
        activity.finish()
      end
      if liulanurl:find("need_login=true") then
        AlertDialog.Builder(this)
        .setTitle("提示")
        .setMessage("登录可减少验证的出现 多次出现验证知乎可能会暂时封禁一些功能 如果长期使用推荐登录")
        .setPositiveButton("我知道了",{onClick=function() success_do() end})
        .setCancelable(false)
        .show()
        return
      end
      success_do()
      return
    end
    if url:sub(1,4)~="http" then
      view.stopLoading()
      if 检查意图(url,true) then
        检查意图(url)
        activity.finish()
       else
        双按钮对话框("提示","是否用第三方软件打开本链接？","是","否",
        function()
          xpcall(function()
            intent=Intent("android.intent.action.VIEW")
            intent.setData(Uri.parse(url))
            intent.addFlags(Intent.FLAG_ACTIVITY_NEW_TASK | Intent.FLAG_ACTIVITY_SINGLE_TOP)
            this.startActivity(intent)
            an.dismiss()
          end,
          function(v)
            提示("尝试打开第三方app出错")
            an.dismiss()
          end)
        end,
        function()
          an.dismiss()
        end)
      end
     else
      if 检查链接(url,true) then
        view.stopLoading()
        检查链接(url)
      end
    end
  end,
  onPageStarted=function(view,url,favicon)

    等待doc(view)
    if url:find("zhihu.com/search") then
      加载js(view,'window.open=function() { return false }')
    end
    if 全局主题值=="Night" then
      黑暗模式主题(view)
    end

    if url=="https://www.zhihu.com" or docode=="提问" then
      加载js内容=获取js("ask")
     elseif url:find("zhihu") and url:find("answer") then
      加载js内容=获取js("answer")
     elseif url:find("https://www.zhihu.com/messages") then
      加载js内容=获取js("messages")
     elseif url:find("zhihu") and url:find("question") and url:find("write") or url:find("zhihu") and url:find("question") and url:find("edit") then
      加载js内容=获取js("answering")
     else
      加载js内容=nil
    end


    if 加载js内容 then
      加载js(view,加载js内容)
    end

  end,
  onLoadResource=function(view,url)
  end,
  onPageFinished=function(view,url)
    if docode~="默认" then 屏蔽元素(view,{"SignFlowHomepage-footer"})
    end
end}



liulan.getSettings()
.setLayoutAlgorithm(WebSettings.LayoutAlgorithm.SINGLE_COLUMN)
.setJavaScriptEnabled(true)--设置支持Js
.setLoadWithOverviewMode(true)
.setDefaultTextEncodingName("utf-8")
.setLoadsImagesAutomatically(true)
.setAllowFileAccess(false)
.setDatabasePath(APP_CACHEDIR)
--//设置 应用 缓存目录
.setAppCachePath(APP_CACHEDIR)
--//开启 DOM 存储功能
.setDomStorageEnabled(true)
--//开启 数据库 存储功能
.setDatabaseEnabled(true)
--//开启 应用缓存 功能

.setUseWideViewPort(true)
.setBuiltInZoomControls(true)
.setSupportZoom(true)


if activity.getSharedData("禁用缓存")=="true"
  liulan
  .getSettings()
  .setAppCacheEnabled(false)
  --//开启 DOM 存储功能
  .setDomStorageEnabled(true)
  --//开启 数据库 存储功能
  .setDatabaseEnabled(true)
  .setCacheMode(WebSettings.LOAD_NO_CACHE);
 else
  liulan
  .getSettings()
  .setAppCacheEnabled(true)
  --//开启 DOM 存储功能
  .setDomStorageEnabled(true)
  --//开启 数据库 存储功能
  .setDatabaseEnabled(true)
  .setCacheMode(2)
end

liulan.setDownloadListener({
  onDownloadStart=function(链接, UA, 相关信息, 类型, 大小)
    webview下载文件(链接, UA, 相关信息, 类型, 大小)
end})

task(1,function()
  a=MUKPopu({
    tittle="网页",
    list={
      {src=图标("refresh"),text="刷新",onClick=function()
          liulan.reload()
      end},--添加项目(菜单项)
      {src=图标("redo"),text="前进",onClick=function()
          liulan.goForward()
      end},--添加项目(菜单项)
      {src=图标("undo"),text="后退",onClick=function()
          liulan.goBack()
      end},--添加项目(菜单项)
      {src=图标("close"),text="停止",onClick=function()
          liulan.stopLoading()
      end},--添加项目(菜单项)

      {src=图标("share"),text="分享",onClick=function()
          if fxurl then
            复制文本(fxurl)
           else
            复制文本(liulan.getUrl())
          end
          提示("已复制网页链接到剪切板")
      end},

    }
  })
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
end

function onDestroy()
  liulan.destroy()
end