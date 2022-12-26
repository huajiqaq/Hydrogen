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


webview.loadUrl("file://"..内置存储文件("Download/"..urlEncode(title).."/"..urlEncode(author).."/mht.mht"))

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
  提示("暂不支持查看评论")
  --activity.newActivity("comment",{nil,"local",title,title,username.text})
  --print(nil,"local",title,username.text)

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
--  .setSupportZoom(true)
--  .setLoadWithOverviewMode(true)
.setUseWideViewPort(true)
.setDefaultTextEncodingName("utf-8")
.setLoadsImagesAutomatically(true)
.setAllowFileAccess(true)
.setDatabasePath(APP_CACHEDIR)
--//设置 应用 缓存目录
.setAppCachePath(APP_CACHEDIR)
--//开启 DOM 存储功能
.setDomStorageEnabled(false)
--        //开启 数据库 存储功能
.setDatabaseEnabled(false)
--     //开启 应用缓存 功能
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

webview.setWebViewClient{
  shouldOverrideUrlLoading=function(view,url)
    --    if url~=("https://www.zhihu.com/appview/answer/"..tointeger(b.id).."") then
    检查链接(url)
    view.stopLoading()
    view.goBack()
    --    end
  end,
  onPageStarted=function(view,url,favicon)
    if 全局主题值=="Night" then
      加载js(webview,[[javascript:(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=50,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#]]..backgroundc:sub(4,#backgroundc)..[[ !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]])
    end
  end,
  onPageFinished=function(view,url,favicon)
    if 全局主题值=="Night" then
      加载js(webview,[[javascript:(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=50,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#]]..backgroundc:sub(4,#backgroundc)..[[ !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]])
    end
  end,
  onLoadResource=function(view,url)
    if 全局主题值=="Night" then
      加载js(webview,[[javascript:(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=50,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#]]..backgroundc:sub(4,#backgroundc)..[[ !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]])
    end
    view.evaluateJavascript([[(function(){
    var tags=document.getElementsByTagName("img");         
    for(var i=0;i<tags.length;i++) {
        tags[i].onclick=function(){
         var tag=document.getElementsByTagName("img"); 
         var t={};     
         for(var z=0;z<tag.length;z++) {
            t[z]=tag[z].src; 
            if (tag[z].src==this.src) {
               t[tag.length]=z;
            }                      
         };  
           
         window.androlua.execute(JSON.stringify(t));
        }                                  
     };  
    return tags.length;  
    })();]],{onReceiveValue=function(b)end})
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
    if 全局主题值=="Night" then
      加载js(webview,[[javascript:(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=50,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#]]..backgroundc:sub(4,#backgroundc)..[[ !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]])
    end
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

  }
})