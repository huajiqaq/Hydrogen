require "import"
import "mods.muk"
import "com.ua.*"

chrome = import "com.lua.LuaWebChrome";
client = import "com.lua.LuaWebViewclient";
callback = import "com.androlua.LuaWebView$LuaWebViewClient";


liulanurl,docode,ischeck,fxurl,mtype=...

activity.setContentView(loadlayout("layout/huida"))

波纹({fh,_more},"圆主题")

if type(docode)=="number" then
  activity.setResult(docode)
end

-- 定义一个函数，接受一个字符串参数，返回一个布尔值
function check_url(url)
  -- 使用Lua的模式匹配，检查URL是否以https://www.zhihu.com/question/开头
  local prefix = "https://www.zhihu.com/question/"
  if url:sub(1, #prefix) == prefix then
    -- 如果是，继续检查URL是否包含两个数字部分，分别是问题ID和回答ID
    local question_id, answer_id = url:match(prefix .. "(%d+)/answer/(%d+)")
    if question_id and answer_id then
      -- 如果是，继续检查URL是否以?utm_id=结尾，或者没有其他内容
      local suffix = url:sub(#prefix + #question_id + #answer_id + 9)
      if suffix == "" or suffix:match("?utm_id=") then
        -- 如果是，返回true，表示URL符合条件
        return true
      end
    end
  end
  -- 否则，返回false，表示URL不符合条件
  return false
end

if docode~=nil and ischeck~="null" then
  liulan.getSettings().setUserAgentString("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36")
 elseif check_url(liulanurl) or liulanurl:find("https://www.zhihu.com/answer/") then
  liulan.getSettings().setUserAgentString("Mozilla/5.0 (Android 9; MI ) AppleWebKit/537.36 (KHTML) Version/4.0 Chrome/74.0.3729.136 mobile SearchCraft/2.8.2 baiduboxapp/3.2.5.10")
end
liulan.BackgroundColor=转0x("#00000000",true);

liulan.getSettings()
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
  liulan
  .getSettings()
  .setAppCacheEnabled(false)
  --关闭 DOM 存储功能
  .setDomStorageEnabled(true)
  --关闭 数据库 存储功能
  .setDatabaseEnabled(true)
  .setCacheMode(WebSettings.LOAD_NO_CACHE);
 else
  liulan
  .getSettings()
  .setAppCacheEnabled(true)
  --开启 DOM 存储功能
  .setDomStorageEnabled(true)
  --开启 数据库 存储功能
  .setDatabaseEnabled(true)
  .setCacheMode(WebSettings.LOAD_DEFAULT)
end

liulan.loadUrl(liulanurl)
liulan.removeView(liulan.getChildAt(0))


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
liulan.setVisibility(8)

liulan.setWebChromeClient(LuaWebChrome(LuaWebChrome.IWebChrine{
  onReceivedTitle=function(view, title)
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
      liulan.setVisibility(0)
      progress.setVisibility(8)
     elseif consoleMessage.message():find("重新加载") then
      liulan.setVisibility(8)
      progress.setVisibility(0)
     elseif consoleMessage.message():find("提交成功退出") then
      提示("成功")
      activity.finish()
     elseif consoleMessage.message()=="显示评论" then
      activity.newActivity("comment",{mresult,mmtype.."s"})
    end
  end,

  onShowCustomView=function(view,url)
    web_video_view=view
    savedScrollY=liulan.getScrollY()
    liulan.setVisibility(8)
    activity.getDecorView().addView(web_video_view)
--    this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE)
    全屏()
  end,
  onHideCustomView=function(view,url)
    liulan.setVisibility(0)
    activity.getDecorView().removeView(web_video_view)
--    this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
    取消全屏()
    Handler().postDelayed(Runnable({
      run=function()
        liulan.scrollTo(0, savedScrollY);
      end,
    }),200)
  end,
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

mpop={
  tittle="网页",
  list={
    {src=图标("refresh"),text="刷新",onClick=function()
        liulan.reload()
    end},
    {src=图标("redo"),text="前进",onClick=function()
        liulan.goForward()
    end},
    {src=图标("undo"),text="后退",onClick=function()
        liulan.goBack()
    end},
    {src=图标("close"),text="停止",onClick=function()
        liulan.stopLoading()
    end},

    {src=图标("share"),text="分享",onClick=function()
        if fxurl then
          复制文本(fxurl)
         else
          复制文本(liulan.getUrl())
        end
        提示("已复制网页链接到剪切板")
    end},

  }
}

liulan.setWebViewClient{
  shouldOverrideUrlLoading=function(view,url)--回调参数，v控件，url网址
    res=false
    if liulanurl:find("zhihu.com") and liulanurl:find("https://www.zhihu.com/account/unhuman") then
      view.stopLoading()
      if url:find("zhihu.com/signin") then
        activity.newActivity("login")
        return
      end
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
    if url:find("zhihu") and url:find("question") and url:find("write") or url:find("zhihu") and url:find("question") and url:find("edit") or url:find("answer_deleted_redirect") then
      return
    end
    if url:find("zhihu") and url:find("zhuanlan") and url:find("write") or url:find("zhihu") and url:find("zhuanlan") and url:find("edit") then
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
        if liulanurl:find("https://www.zhihu.com/answer/") then
          liulanurl=url
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
    等待doc(view)
    屏蔽元素(view,{"SignFlowHomepage-footer"})
    if url:find("zhihu.com/search") then
      加载js(view,'window.open=function() { return false }')
    end
    if 全局主题值=="Night" then
      黑暗模式主题(view)
    end

    local mpop=table.clone(mpop)

    if mtype=="举报" then
      加载js内容=获取js("report")
     elseif docode=="提问" then
      加载js内容=获取js("ask")
     elseif check_url(liulanurl) then
      加载js内容=获取js("answer")
     elseif url:find("https://www.zhihu.com/messages") then
      加载js内容=获取js("messages")
     elseif url:find("zhihu") and url:find("question") and url:find("write") or url:find("zhihu") and url:find("question") and url:find("edit") then
      加载js内容=获取js("answering")
     elseif url:find("zhihu") and url:find("zhuanlan") and url:find("write") or url:find("zhihu") and url:find("zhuanlan") and url:find("edit") then
      加载js内容=获取js("write_zhuanlan")
     elseif url:find("https://www.zhihu.com/notifications") then
      加载js内容=获取js("notification")
     elseif url:find("https://www.zhihu.com/settings/") then
      加载js内容=获取js("setting")
     elseif url:find("https://www.zhihu.com/knowledge%-plan/editor%-setting") then
      加载js内容=获取js("editor-setting")
     elseif url:find("https://www.zhihu.com/zvideo/upload%-video") then
      加载js内容=获取js("upload_video")
     elseif url:find("zhihu.com/market/paid") then
      加载js内容=获取js("paid_content")
      mresult=url:match("/section/(.+)")
      mmtype="paid_column_section_manuscript"
      table.insert(mpop.list,#mpop.list,{src=图标("chat_bubble"),text="查看评论",onClick=function()
          activity.newActivity("comment",{mresult,mmtype.."s"})
      end})
      a=MUKPopu(mpop)
     elseif docode=="想法" then
      加载js内容=获取js("addpin")
     elseif docode=="新建专栏" then
      加载js内容=获取js("addcolumn")
     elseif docode=="我的专栏" then
      加载js内容=获取js("mycolumn")
     elseif docode=="我的视频设置" then
      加载js内容=获取js("myvideo-setting")
     elseif docode=="我的文章设置" then
      加载js内容=获取js("mywenzhang-setting")
     else
      加载js内容=获取js("model")
    end

    a=MUKPopu(mpop)

    if 加载js内容 then
      加载js(view,加载js内容)
    end

    加载js(view,获取js("zhihugif"))

    liulan.setVisibility(0)

  end,
  onLoadResource=function(view,url)
  end,
  onPageFinished=function(view,url)
end}


liulan.setDownloadListener({
  onDownloadStart=function(链接, UA, 相关信息, 类型, 大小)
    webview下载文件(链接, UA, 相关信息, 类型, 大小)
end})


task(1,function()
  a=MUKPopu(mpop)
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
    if liulanurl:find("zhihu.com") and liulanurl:find("https://www.zhihu.com/account/unhuman") then
      activity.finish()
    end
  end
end

function onDestroy()
  liulan.clearCache(true)
  liulan.clearFormData()
  liulan.clearHistory()
  liulan.destroy()
end

if this.getSharedData("禁用缓存")=="true" then
  function onStop()
    liulan.clearCache(true)
    liulan.clearFormData()
    liulan.clearHistory()
  end
end