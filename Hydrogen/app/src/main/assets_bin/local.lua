require "import"
import "mods.muk"
import "com.lua.*"
import "android.text.method.LinkMovementMethod"
import "android.text.Html"
import "java.net.URL"
import "android.webkit.WebChromeClient"
import "android.content.pm.ActivityInfo"
import "android.graphics.PathMeasure"


title,author=...

波纹({fh,_more,mark},"圆主题")
波纹({all_root},"方自适应")

local 保存路径=内置存储文件("Download/"..title.."/"..author)
filedir=保存路径.."/html.html"
xxx=读取文件(保存路径.."/detail.txt")


if xxx:match("article") or xxx:match("pin") then
  this.finish()
  this.newActivity("column",{filedir,"本地"})
  return
end

--暂时这么解决闪屏问题 第二种解决方法添加 layoutTransition=LayoutTransition()
local 加载内容=读取文件(filedir)
if 全局主题值=="Night" then
  加载内容=加载内容:gsub('light','dark')
end
task(1,function()
  t.content.loadDataWithBaseURL(nil,加载内容,"text/html","utf-8",nil)
end)

--new 0.53 引入mhtml2html解析mhtml 去除大量mhtml替换逻辑

import "androidx.viewpager2.widget.ViewPager2"
activity.setContentView(loadlayout("layout/local"))

设置toolbar(toolbar)


local isDoubleTap=false
local timeOut=200

local detector=GestureDetector(this,{a=lambda _:_})

detector.setOnDoubleTapListener {
  onDoubleTap=function()
    t.content.scrollTo(0, 0)
    isDoubleTap=true
    task(timeOut,function()isDoubleTap=false end)
  end
}

all_root.onTouch=function(v,e)
  return detector.onTouchEvent(e)
end

all_root.onClick=function(v)
  if not isDoubleTap then
    task(timeOut,function()
      if not isDoubleTap then
        local questionid=xxx:match[[question_id="(.-)"]]
        activity.newActivity("question",{questionid})
      end
    end)
  end
end

--解决快速滑动出现的bug 点击停止滑动
local AppBarLayoutBehavior=luajava.bindClass "com.hydrogen.AppBarLayoutBehavior"
appbar.LayoutParams.behavior=AppBarLayoutBehavior(this,nil)

pg.setUserInputEnabled(false) --禁止滑动


波纹({all_root},"方自适应")

_title.text=title

--维持和answer.lua的统一性
t={}
local 加入view=loadlayout({
  LinearLayout,
  layout_width="fill";
  layout_height="fill";
  id="root";
  {
    NestedLuaWebView,
    id="content",
    layout_width="-1";
    layout_height="-1";
    Visibility=8,
  };
},t)

import "com.dingyi.adapter.BaseViewPage2Adapter"
pg.adapter=BaseViewPage2Adapter(this)
pg.adapter.add(加入view)

userinfo.onClick=function()
  提示("请点击右上角「使用网络打开」打开原回答页后查看")
end

task(1,function()
  顶栏高度=toolbar.height
end)


local function 设置滑动跟随(t)
  t.onGenericMotion=function(view,x,y,lx,ly)
    if t.getScrollY()<=0 then
      appbar.setExpanded(true);
     else
      appbar.setExpanded(false);
    end
  end
end

设置滑动跟随(t.content)

username.text=xxx:match[[author="(.-)"]]
userheadline.text=xxx:match[[headline="(.-)"]]
if userheadline.text=="" then
  userheadline.text="Ta还没有签名哦~"
end

thanks_count.text=xxx:match[[thanks_count="(.-)"]]
comment_count.text=xxx:match[[comment_count="(.-)"]]
vote_count.text=xxx:match[[vote_count="(.-)"]]

comment.onClick=function()
  local 保存路径=内置存储文件("Download/"..title:gsub("/","or").."/"..username.text)
  if getDirSize(保存路径.."/".."fold/")==0 then
    提示("你还没有收藏评论")
   else
    activity.newActivity("comment",{保存路径,"local",nil,nil,保存路径})
  end
end;

function 网络打开提示()
  提示("请点击右上角「使用网络打开」打开原回答页后进行该操作")
end

mark.onClick=网络打开提示
thank.onClick=网络打开提示
voteup.onClick=网络打开提示

波纹({fh,_more,mark,comment,thank,voteup},"圆主题")

t.content
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

t.content.removeView(t.content.getChildAt(0))


if activity.getSharedData("禁用缓存")=="true"
  t.content
  .getSettings()
  .setAppCacheEnabled(false)
  .setCacheMode(WebSettings.LOAD_NO_CACHE);
 else
  t.content
  .getSettings()
  .setAppCacheEnabled(true)
  .setCacheMode(WebSettings.LOAD_DEFAULT)
end

t.content.BackgroundColor=转0x("#00000000",true);

t.content.setDownloadListener({
  onDownloadStart=function(链接, UA, 相关信息, 类型, 大小)
    提示("本地暂不支持下载")
end})


--设置网页图片点击事件，
local z=JsInterface{
  execute=function(b)
    if b~=nil and #b>1 then
      --newActivity传入字符串过大会造成闪退 暂时通过setSharedData解决
      this.setSharedData("imagedata",b)
      activity.newActivity("image")
    end
  end,
}


t.content.addJSInterface(z,"androlua")

t.content.setWebViewClient{
  shouldOverrideUrlLoading=function(view,url)
    检查链接(url)
    view.stopLoading()
    view.goBack()
  end,
  onPageStarted=function(view,url,favicon)
  end,
  onPageFinished=function(view,l)
    t.content.evaluateJavascript(获取js("imgload"),{onReceiveValue=function(b)end})
    t.content.setVisibility(0)
  end,
  onLoadResource=function(view,url)
  end,
}

t.content.setWebChromeClient(LuaWebChrome(LuaWebChrome.IWebChrine{
  onProgressChanged=function(view,url,favicon)
    if 全局主题值=="Night" then
      黑暗页(view)
    end
end}))


local content=t.content
webview查找文字监听(content)

task(1,function()
  a=MUKPopu({
    tittle="回答",
    list={
      {
        src=图标("error"),text="相关",onClick=function()
          提示("如果有问题 可以点击主页右上角 在弹出菜单点击反馈进行反馈")
        end
      },

      {
        src=图标("cloud"),text="使用网络打开",onClick=function()
          local questionid=xxx:match[[question_id="(.-)"]]
          local answerid=xxx:match[[answer_id="(.-)"]]
          activity.newActivity("answer",{questionid,answerid})
        end
      },

      {
        src=图标("cloud"),text="另存为pdf",onClick=function()
          import "android.print.PrintAttributes"
          printManager = this.getSystemService(Context.PRINT_SERVICE);
          printAdapter = t.content.createPrintDocumentAdapter();
          printManager.print("文档", printAdapter,PrintAttributes.Builder().build());
        end
      },

      {
        src=图标("search"),text="在网页查找内容",onClick=function()
          local content=t.content
          webview查找文字(content)
        end
      },

    }
  })
end)

if this.getSharedData("显示虚拟滑动按键")=="true" then
  bottom_parent.Visibility=0
  up_button.onClick=function()
    t.content.scrollBy(0, -t.content.height);
    if t.content.getScrollY()<=0 then
      appbar.setExpanded(true,false);
    end
  end
  down_button.onClick=function()
    t.content.scrollBy(0, t.content.height);
    appbar.setExpanded(false,false);
  end
end