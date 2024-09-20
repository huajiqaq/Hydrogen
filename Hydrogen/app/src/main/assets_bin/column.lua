require "import"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
import "android.graphics.Color"
import "android.animation.ObjectAnimator"
import "android.animation.ArgbEvaluator"
import "android.animation.ValueAnimator"
import "android.graphics.Typeface"
import "com.androlua.LuaWebView$JsInterface"

import "com.google.android.material.floatingactionbutton.ExtendedFloatingActionButton"

local id,类型=...

if 类型==nil or 类型:match("%d") then
  类型="文章"
end

初始化历史记录数据(true)

activity.setContentView(loadlayout("layout/column_parent"))

if 类型=="本地" then
  task(1,function()
    _title.text="本地内容"
    local html=File(id)
    local 详情=读取文件(tostring(html.getParent()).."/detail.txt")
    if 详情:match("article")
      mytype="文章"
     elseif 详情:match("pin")
      mytype="想法"
    end
    myid = 详情:match("(%d+)[^/]*$")
    local myuri = Uri.fromFile(html).toString();
    content.loadUrl(myuri)
  end)
end

base_column=require "model/column"
:new(id,类型)

urltype=base_column.urltype
fxurl=base_column.fxurl

波纹({fh,_more},"圆主题")
静态渐变(转0x(primaryc)-0x9f000000,转0x(primaryc),pbar,"横")

content.getSettings()
.setLayoutAlgorithm(WebSettings.LayoutAlgorithm.SINGLE_COLUMN)
.setJavaScriptEnabled(true)--设置支持Js
.setJavaScriptCanOpenWindowsAutomatically(true)
.setUseWideViewPort(true)
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

content.removeView(content.getChildAt(0))

if activity.getSharedData("禁用缓存")=="true"
  content
  .getSettings()
  .setAppCacheEnabled(false)
  .setCacheMode(WebSettings.LOAD_NO_CACHE)
  --关闭 DOM 存储功能
  .setDomStorageEnabled(true)
  --关闭 数据库 存储功能
  .setDatabaseEnabled(false)
 else
  content
  .getSettings()
  .setAppCacheEnabled(true)
  .setCacheMode(WebSettings.LOAD_DEFAULT)
  --开启 DOM 存储功能
  .setDomStorageEnabled(true)
  --开启 数据库 存储功能
  .setDatabaseEnabled(true)
end

if 无图模式 then
  content.getSettings().setBlockNetworkImage(true)
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

_title.Text="加载中"

local ua=getua(content)
content.getSettings().setUserAgentString(ua)
content.BackgroundColor=转0x("#00000000",true);

function 刷新()

  --第二个为issave 为true代表记录历史记录
  base_column:getData(function(data)
    if data==false then
      提示("加载页面失败")
      _title.Text="加载失败"
      return
    end
    --针对没有通过请求直接回调的内容的处理
    if type(data)=="table" then
      --针对直播需要特殊判断
      if 类型~="直播" then
        author_id=data.author.id
        aurhor_name=data.author.name
        page_title=data.title
        _title.text=page_title
        --软件自己拼接成的保存路径
        保存路径=data.savepath
       else
        author_id=data.theater.actor.id
      end
    end
    content.setVisibility(8)
    content.loadUrl(base_column.weburl)


  end,true)

  if 类型=="直播" then
    followdoc='document.querySelector(".TheaterRoomHeader-actor").childNodes[2]'
  end

end
content.setWebContentsDebuggingEnabled(true)
content.setWebViewClient{
  onReceivedError=function(view,a,b)

  end,
  shouldOverrideUrlLoading=function(view,url)
    view.stopLoading()
    if url:sub(1,4)~="http" then
      if 检查意图(url,true) then
        检查意图(url)
      end
     else
      if urltype and url:find("https://www.zhihu.com/oia/"..urltype.."/"..id) then
        return false
      end
      检查链接(url)
    end
  end,
  onPageStarted=function(view,url,favicon)
    view.evaluateJavascript(获取js("imgload"),{onReceiveValue=function(b)end})
    网页字体设置(view)
    加载js(view,获取js("native"))
    等待doc(view)
    if 全局主题值=="Night" then
      夜间模式主题(view)
    end
    if url:find("https://www.zhihu.com/appview/pin/"..id) then
      加载js(view,获取js("pin"))
     elseif url:find("https://www.zhihu.com/zvideo/"..id)
      加载js(view,获取js("zvideo"))
     elseif url:find("https://www.zhihu.com/theater/")
      加载js(view,获取js("drama"))
    end

  end,
  onPageFinished=function(view,l)
    content.setVisibility(0)
  end,
  onLoadResource=function(view,url)
  end,
  shouldInterceptRequest=拦截加载}

刷新()

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

import "com.lua.LuaWebChrome"
import "android.content.pm.ActivityInfo"
content.setWebChromeClient(LuaWebChrome(LuaWebChrome.IWebChrine{
  onReceivedTitle=function(view, title)
    if not page_title then
      _title.text=title
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
  onShowCustomView=function(view,url)
    web_video_view=view
    savedScrollY=content.getScrollY()
    content.setVisibility(8)
    activity.getDecorView().addView(web_video_view)
    --this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE)
    全屏()
  end,
  onHideCustomView=function(view,url)
    content.setVisibility(0)
    activity.getDecorView().removeView(web_video_view)
    --this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
    取消全屏()
    Handler().postDelayed(Runnable({
      run=function()
        content.scrollTo(0, savedScrollY);
      end,
    }),200)
  end,

  onConsoleMessage=function(consoleMessage)
    --打印控制台信息
    if consoleMessage.message()=="显示评论" then
      activity.newActivity("comment",{id,urltype.."s",nil,nil,保存路径})
     elseif consoleMessage.message()=="查看用户" then
      activity.newActivity("people",{author_id})
     elseif consoleMessage.message():find("收藏") then
      if not(getLogin()) then
        return 提示("请登录后使用本功能")
      end
      local func=function() end
      if consoleMessage.message():find("分割") then
        func=function(count)
          if count==0 then
            local callbackid=tostring(consoleMessage.message()):match("收藏分割(.+)")
            local sendobj='{"id":"'..callbackid..'","type":"success","params":{"contentType":"'..urltype..'","contentId":"'..id..'","collected":false}}'
            加载js(content,'window.zhihuWebApp && window.zhihuWebApp.callback('..sendobj..')')
          end
        end
      end
      加入收藏夹(id,urltype,func)
     elseif consoleMessage.message()=="申请转载" then
      if not(getLogin()) then
        return 提示("请登录后使用本功能")
      end
      加入专栏(id,urltype)
     elseif consoleMessage.message():find("关注分割") then
      if not(getLogin()) then
        return 提示("请登录后使用本功能")
      end

      local mtext=consoleMessage.message():match("关注分割(.+)")
      if mtext:find("已关注") then
        zHttp.delete("https://api.zhihu.com/people/"..author_id.."/followers/"..activity.getSharedData("idx"),posthead,function(a,b)
          if a==200 then
            加载js(content,followdoc..'.innerText="关注"')
          end
        end)
       elseif mtext:find("关注") then
        zHttp.post("https://api.zhihu.com/people/"..author_id.."/followers","",posthead,function(a,b)
          if a==200 then
            加载js(content,followdoc..'.innerText="已关注"')
           elseif a==500 then
            提示("请登录后使用本功能")
          end
        end)
      end

    end
end}))

content.setDownloadListener({
  onDownloadStart=function(链接, UA, 相关信息, 类型, 大小)
    webview下载文件(链接, UA, 相关信息, 类型, 大小)
end})


--退出时去除webview的内存

function onDestroy()
  content.destroy()
end

if this.getSharedData("禁用缓存")=="true" then
  function onStop()
    content.clearCache(true)
    content.clearFormData()
    content.clearHistory()
  end
end

webview查找文字监听(content)

--pop

if 类型=="本地" then
  pop={
    tittle="本地",
    list={
      {
        src=图标("refresh"),text="刷新",onClick=function()
          if _title.Text=="加载失败" then
            刷新()
           else
            content.reload()
          end
          提示("正在刷新中")
        end
      },

      {
        src=图标("chat_bubble"),text="查看评论",onClick=function()
          local 保存路径=tostring(File(id).getParent())
          if getDirSize(保存路径.."/".."fold/")==0 then
            提示("你还没有收藏评论")
           else
            activity.newActivity("comment",{nil,"local",nil,nil,保存路径})
          end
        end
      },

      {
        src=图标("cloud"),text="使用网络打开",onClick=function()
          activity.newActivity("column",{myid,mytype})
        end
      },

      {
        src=图标("cloud"),text="另存为pdf",onClick=function()
          import "android.print.PrintAttributes"

          printManager = this.getSystemService(Context.PRINT_SERVICE);
          printAdapter = content.createPrintDocumentAdapter();
          printManager.print("文档", printAdapter,PrintAttributes.Builder().build());
        end
      },

      {
        src=图标("search"),text="在网页查找内容",onClick=function()
          webview查找文字(content)
        end
      },

    }
  }
 elseif 类型 then

  pop={
    tittle=类型,
    list={
      {
        src=图标("refresh"),text="刷新",onClick=function()
          if _title.Text=="加载失败" then
            刷新()
           else
            content.reload()
          end
          提示("正在刷新中")
        end
      },
      {
        src=图标("share"),text="分享",onClick=function()
          local format="【%s】【%s】%s：%s"
          分享文本(string.format(format,类型,_title.Text,aurhor_name,fxurl))
        end
      },
      {
        src=图标("chat_bubble"),text="查看评论",onClick=function()
          if not urltype then
            return 提示("该页不支持该操作")
          end
          activity.newActivity("comment",{id,urltype.."s",nil,nil,保存路径})

        end
      },
      {
        src=图标("explore"),text="收藏文件夹",onClick=function()
          if not urltype then
            return 提示("该页不支持该操作")
          end
          加入收藏夹(id,urltype)
        end
      },
      {
        src=图标("explore"),text="举报",onClick=function()
          if not urltype then
            return 提示("该页不支持该操作")
          end
          local url="https://www.zhihu.com/report?id="..id.."&type="..urltype
          activity.newActivity("browser",{url.."&source=android&ab_signature=","举报"})
        end
      },
      {
        src=图标("save"),text="保存在本地",onClick=function()
          if 类型~="想法" and 类型~="文章" then
            return 提示(类型.."不支持保存")
          end

          local result=get_write_permissions()
          if result~=true then
            return false
          end

          local 保存路径=内置存储文件("Download/".._title.Text.."/"..aurhor_name)
          local 写入内容='pin_url="'..content.getUrl()
          this.newActivity("saveweb",{content.getUrl(),保存路径,写入内容})

        end
      },
      {
        src=图标("search"),text="在网页查找内容",onClick=function()
          webview查找文字(content)
        end
      },
    }
  }
 else
  pop={
    tittle=_title.Text,
    list={
    }
  }
end

task(1,function()
  a=MUKPopu(pop)

  if 类型=="文章" or 类型=="视频" then
    fab.Visibility=0
    local mylist=pop.list
    for i = 1, #mylist do
      local myname = mylist[i].text
      if myname:find("评论") then
        local monclick=mylist[i].onClick
        fab.onClick=monclick
        break
      end
    end

  end
end)