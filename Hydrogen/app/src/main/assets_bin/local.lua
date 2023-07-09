require "import"
import "mods.muk"
import "com.lua.*"
import "android.text.method.LinkMovementMethod"
import "android.text.Html"
import "java.net.URL"
import "com.bumptech.glide.Glide"
import "android.webkit.WebChromeClient"
import "android.content.pm.ActivityInfo"
import "android.graphics.PathMeasure"

activity.setContentView(loadlayout("layout/local"))

title,author=...

波纹({fh,_more,mark},"圆主题")
波纹({all_root},"方自适应")

myuri = Uri.fromFile(File(内置存储文件("Download/"..title.."/"..author.."/mht.mht"))).toString();

webview.loadUrl(myuri)

_title.text=title
xxx=读取文件(内置存储文件("Download/"..title.."/"..author.."/detail.txt"))

if not(xxx:match("question_id")) then
  activity.finish()
  activity.newActivity("huida",{"file://"..内置存储文件("Download/"..urlEncode(title).."/"..urlEncode(author).."/mht.mht"),nil,nil,xxx:match('url="(.-)"')})
  return
end

username.text=xxx:match[[author="(.-)"]]
userheadline.text=xxx:match[[headline="(.-)"]]
thanks_count.text=xxx:match[[thanks_count="(.-)"]]
comment_count.text=xxx:match[[comment_count="(.-)"]]
vote_count.text=xxx:match[[vote_count="(.-)"]]
if userheadline.text=="" then
  userheadline.text="Ta还没有签名哦~"
end

mark.onClick=function()
  local 保存路径=内置存储文件("Download/"..title:gsub("/","or").."/"..username.text)
  if getDirSize(保存路径.."/".."fold/")==0 then
    提示("你还没有收藏评论")
   else
    activity.newActivity("comment",{nil,"local",title,username.text})
  end
end


local function 设置滑动跟随(t)
  t.onScrollChange=function(vew,x,y,lx,ly)

    if y<=2 then--解决滑到顶了还是没有到顶的bug
      llb.y=0
      mark_parent.y=0
      return
    end
    if ly>y then --上次滑动y大于这次y就是向上滑
      if llb.y<=0 or math.abs(y-ly)>=dp2px(56) then --这个or为了防止快速大滑动
        llb.y=0
        mark_parent.y=0
       else
        llb.y=llb.y-math.abs(y-ly)
        mark_parent.y=mark_parent.y-math.abs(y-ly)
      end
     else
      if llb.y<=dp2px(56)+dp2px(26) then --没到底就向底移动(上滑)，+26dp是悬浮球高
        llb.y=llb.y+math.abs(y-ly)
        mark_parent.y=mark_parent.y+math.abs(y-ly)
      end
    end
  end
end


msrcroll.smoothScrollTo(0,0)

设置滑动跟随(msrcroll)

webview
.getSettings()
.setLayoutAlgorithm(WebSettings.LayoutAlgorithm.SINGLE_COLUMN)
.setJavaScriptEnabled(true)--设置支持Js
.setJavaScriptCanOpenWindowsAutomatically(true)
.setUseWideViewPort(true)
.setDefaultTextEncodingName("utf-8")
.setLoadsImagesAutomatically(true)
.setAllowFileAccess(true)
.setDatabasePath(APP_CACHEDIR)
--//设置 应用 缓存目录
.setAppCachePath(APP_CACHEDIR)
--//开启 DOM 存储功能
.setDomStorageEnabled(false)
--//开启 数据库 存储功能
.setDatabaseEnabled(false)
--//开启 应用缓存 功能
.setSupportZoom(true)
.setBuiltInZoomControls(true)


webview.removeView(webview.getChildAt(0))

if activity.getSharedData("禁用缓存")=="true"
  webview
  .getSettings()
  .setAppCacheEnabled(false)
  .setCacheMode(WebSettings.LOAD_NO_CACHE);
 else
  webview
  .getSettings()
  .setAppCacheEnabled(true)
  .setCacheMode(2)
end

webview.setDownloadListener({
  onDownloadStart=function(链接, UA, 相关信息, 类型, 大小)
    提示("本地暂不支持下载")
end})

webview.setWebViewClient{
  shouldOverrideUrlLoading=function(view,url)
    检查链接(url)
    view.stopLoading()
    view.goBack()
  end,
  onPageStarted=function(view,url,favicon)
    if 全局主题值=="Night" then
      黑暗模式主题(view)
    end
  end,
  onPageFinished=function(view,url,favicon)
    if 全局主题值=="Night" then
      黑暗模式主题(view)
    end
  end,
  onLoadResource=function(view,url)
    view.evaluateJavascript(获取js("imgload"),{onReceiveValue=function(b)end})
  end,
}

local v,s;

local z=JsInterface{
  execute=function(b)
    if b~=nil and #b>3 then
      activity.newActivity("image",{b})
    end
  end
}

webview.addJSInterface(z,"androlua")

webview.setWebChromeClient(luajava.override(WebChromeClient,{
  onProgressChanged=function(super,view,url,favicon)
  end,
  onShowCustomView=function(z,a,b)
    v=a
    s=mscroll.getScrollY()
    activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE);
    activity.getWindow().getDecorView().setSystemUiVisibility(
    View.SYSTEM_UI_FLAG_LAYOUT_STABLE
    | View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
    | View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION
    | View.SYSTEM_UI_FLAG_HIDE_NAVIGATION
    | View.SYSTEM_UI_FLAG_FULLSCREEN
    | View.SYSTEM_UI_FLAG_IMMERSIVE_STICKY);

    activity.getDecorView().addView(a)
  end,
  onHideCustomView=function()
    activity.getDecorView().removeView(v)
    activity.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);

    activity.getWindow().getDecorView().setSystemUiVisibility(View.SYSTEM_UI_FLAG_VISIBLE)

    设置主题()

    mscroll.smoothScrollTo(0,s)

  end
}))

a=MUKPopu({
  tittle="回答",
  list={
    {
      src=图标("error"),text="相关",onClick=function()
        提示("如果有问题 可以点击主页右上角 在弹出菜单点击反馈进行反馈")
      end
    },

    {
      src=图标("build"),text="关闭硬件加速",onClick=function()
        AlertDialog.Builder(this)
        .setTitle("提示")
        .setMessage("你确认要关闭当前页的硬件加速吗 关闭后滑动可能会造成卡顿 如果当前页显示正常请不要关闭")
        .setPositiveButton("关闭",{onClick=function(v)
            msrcroll.setLayerType(View.LAYER_TYPE_SOFTWARE, nil);
            webview.reload()
            提示("关闭成功")
        end})
        .setNeutralButton("取消",{onClick=function(v)
        end})
        .show()
      end
    },

  }
})

if activity.getSharedData("异常提示0.01")==nil
  AlertDialog.Builder(this)
  .setTitle("小提示")
  .setCancelable(false)
  .setMessage("在最近的测试中 发现部分回答显示不完整 现确认为是开启硬件加速后出现的问题 如若出现了异常情况 请点击右上角「关闭硬件加速」 关闭动画会卡顿 如果流量没问题请不要点击")
  .setPositiveButton("我知道了",{onClick=function() activity.setSharedData("异常提示0.01","true") end})
  .show()
end