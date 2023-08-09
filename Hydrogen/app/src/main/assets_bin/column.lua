require "import"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
import "model.column"
import "android.graphics.Color"
import "android.animation.ObjectAnimator"
import "android.animation.ArgbEvaluator"
import "android.animation.ValueAnimator"
import "android.graphics.Typeface"
import "com.androlua.LuaWebView$JsInterface"

local result,类型,islocal,uri,simpletitle,autoname=...

if 类型==nil or 类型:match("%d") then
  类型="文章"
end

初始化历史记录数据(true)

activity.setContentView(loadlayout("layout/column_parent"))

if islocal then
  if 类型~="视频" then
    原类型=类型
    类型="本地"
  end
  comment_type="local"
 else

  if 类型=="文章" then
    comment_type="articles"
   elseif 文章=="想法"
    comment_type="pins"
   elseif 类型=="视频"
    comment_type="zvideos"
  end

end


local hsn=this.getResources().getDimensionPixelSize( luajava.bindClass("com.android.internal.R$dimen")().status_bar_height )--获取状态栏高

波纹({fh,_more},"圆主题")

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

mcolumn=column:new(result)

function 刷新()
  if 类型=="文章" then
    mcolumn:getDataAsyc(function(url)
      if url==false then
        提示("加载页面失败")
        _title.Text="加载失败"
        --task(2,恢复白色)
       elseif activity.getSharedData("标题简略化")=="true" then
        _title.Text=类型
       else
        content.setVisibility(0)
        autoname=url.author.name
        simpletitle=url.title
        _title.Text=url.title
        --  恢复白色()
        content.loadUrl("https://www.zhihu.com/appview/p/"..result)
        保存历史记录(_title.Text,"文章分割"..result,50)
      end
    end)
   elseif 类型=="想法" then
    content.setVisibility(0)

    _title.Text="查看想法"
    zHttp.get("https://www.zhihu.com/api/v4/pins/"..result,head,function(code,content)
      simpletitle=require "cjson".decode(content).excerpt_title
      autoname=require "cjson".decode(content).author.name
      comment_count=tointeger(require "cjson".decode(content).comment_count)
      保存历史记录(simpletitle,"想法分割"..result,50)
    end)
    content.loadUrl("https://www.zhihu.com/appview/pin/"..result)
    --对应api是https://www.zhihu.com/api/v4/pins/ID，或者https://api.zhihu.com/pins/ID，均可以取得内容，后续再做
   elseif 类型=="视频" then
    content.loadUrl("https://www.zhihu.com/zvideo/"..result.."?utm_id=0")
    _title.Text="视频"
    zHttp.get("https://www.zhihu.com/api/v4/zvideos/"..result,head,function(code,content)
      simpletitle=require "cjson".decode(content).title
      autoname=require "cjson".decode(content).author.name
      保存历史记录(simpletitle,"视频分割"..result,50)
    end)
    if activity.getSharedData("视频提示0.01")==nil
      AlertDialog.Builder(this)
      .setTitle("小提示")
      .setCancelable(false)
      .setMessage("你可点击右上角查看评论")
      .setPositiveButton("我知道了",{onClick=function() activity.setSharedData("视频提示0.01","true") end})
      .show()
    end
   elseif 类型=="本地" then
    content.loadUrl(uri)
    _title.Text=simpletitle
  end

end

--设置webview

content=mty

content.getSettings()
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
.setDomStorageEnabled(true)
--        //开启 数据库 存储功能
.setDatabaseEnabled(true)

content.removeView(content.getChildAt(0))

if activity.getSharedData("禁用缓存")=="true"
  content
  .getSettings()
  .setAppCacheEnabled(false)
  .setCacheMode(WebSettings.LOAD_NO_CACHE)
  --//开启 DOM 存储功能
  .setDomStorageEnabled(true)
  -- //开启 数据库 存储功能
  .setDatabaseEnabled(false)
 else
  content
  .getSettings()
  .setAppCacheEnabled(true)
  .setCacheMode(2)
  --//开启 DOM 存储功能
  .setDomStorageEnabled(true)
  -- //开启 数据库 存储功能
  .setDatabaseEnabled(true)
end

content.setWebViewClient{
  onReceivedError=function(view,a,b)

  end,
  shouldOverrideUrlLoading=function(view,url)

    if url~=("https://www.zhihu.com/appview/p/"..result) then
      if url:sub(1,4)~="http" then
        if 检查意图(url,true) then
          view.stopLoading()
          检查意图(url)
        end
       else
        检查链接(url)
        view.stopLoading()
        view.goBack()
      end
    end
  end,
  onPageStarted=function(view,url,favicon)
    --网页加载
    等待doc(view)
    if 全局主题值=="Night" then
      黑暗模式主题(view)
     else
      白天主题(view)
    end

  end,
  onPageFinished=function(view,l)
  end,
  onLoadResource=function(view,url)
    view.evaluateJavascript(获取js("imgload"),{onReceiveValue=function(b)end})
  end,
}

刷新()

--设置网页图片点击事件，
local z=JsInterface{
  execute=function(b)
    if b~=nil and #b>1 then
      activity.newActivity("image",{b})
    end
  end
}

content.addJSInterface(z,"androlua")

import "com.lua.LuaWebChrome"
content.setWebChromeClient(LuaWebChrome(LuaWebChrome.IWebChrine{
  onProgressChanged=function(view,p)
    setProgress(p)
    if p==100 then
      pbar.setVisibility(8)
      setProgress(0)
    end

  end,
  onShowCustomView=function(view,url)
    --    content.setVisibility(8);
    this.addContentView(view, WindowManager.LayoutParams(-1, -1))
    kkoo=view
    activity.getWindow().getDecorView().setSystemUiVisibility(5639)
  end,
  onHideCustomView=function(view,url)
    kkoo.getParent().removeView(kkoo.setForeground(nil).setVisibility(8))
    content.setVisibility(0)
    kkoo=nil
    activity.getWindow().getDecorView().setSystemUiVisibility(8208)
  end,

  onConsoleMessage=function(consoleMessage)
    --打印控制台信息
    if consoleMessage.message()=="显示评论" then
      activity.newActivity("comment",{result,"articles"})
    end
end}))

content.setDownloadListener({
  onDownloadStart=function(链接, UA, 相关信息, 类型, 大小)
    webview下载文件(链接, UA, 相关信息, 类型, 大小)
end})


--退出时去除bitmap的内存

function onDestroy()
  content.destroy()
  pcall(
  function()
    local a=mn.getDrawable()
    a.setImageDrawable(nil)
    b.getBitmap().recycle()
  end)
end

--pop

if 类型=="文章" then
  task(1,function()
    a=MUKPopu({
      tittle="文章",
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
            local url="https://zhuanlan.zhihu.com/p/"..result
            local format="【%s】%s:… %s"
            分享文本(string.format(format,_title.Text,mcolumn:getUsername(),url))

          end
        },
        {
          src=图标("chat_bubble"),text="查看评论",onClick=function()
            activity.newActivity("comment",{result,comment_type,simpletitle,autoname})

          end
        },
        {
          src=图标("explore"),text="收藏文件夹",onClick=function()
            加入收藏夹(result,"article")

          end
        },
        {
          src=图标("save"),text="保存在本地",onClick=function()

            local result=get_write_permissions()
            if result~=true then
              return false
            end

            if not(文件是否存在(内置存储文件("Download/".._title.Text))) then
              创建文件夹(内置存储文件("Download/".._title.Text))
            end
            创建文件夹(内置存储文件("Download/".._title.Text.."/"..autoname))
            content.saveWebArchive(内置存储文件("Download/".._title.Text.."/"..autoname.."/mht.mht"))
            创建文件(内置存储文件("Download/".._title.Text.."/"..autoname.."/detail.txt"))

            写入文件(内置存储文件("Download/".._title.Text.."/"..autoname.."/detail.txt"),'article_url="'..content.getUrl()..'"')

            提示("保存成功")
          end
        }
      }
    })
  end)
 elseif 类型=="想法" then
  task(1,function()
    a=MUKPopu({
      tittle="一个想法",
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
            activity.newActivity("comment",{result,comment_type,simpletitle,autoname,tostring(comment_count)})

          end
        },
        {
          src=图标("explore"),text="收藏文件夹",onClick=function()
            加入收藏夹(result,"pin")

          end
        },
        {
          src=图标("save"),text="保存在本地",onClick=function()
            创建文件夹(内置存储文件("Download/"..simpletitle))
            创建文件夹(内置存储文件("Download/"..simpletitle.."/"..autoname))

            创建文件(内置存储文件("Download/"..simpletitle.."/"..autoname.."/detail.txt"))

            写入文件(内置存储文件("Download/"..simpletitle.."/"..autoname.."/detail.txt"),'pin_url="'..content.getUrl()..'"')

            content.saveWebArchive(内置存储文件("Download/"..simpletitle.."/"..autoname.."/mht.mht"))
            提示("保存成功")
          end
        },
      }
    })
  end)
 elseif 类型=="视频" then
  task(1,function()
    a=MUKPopu({
      tittle="视频",
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
            activity.newActivity("comment",{result,comment_type,simpletitle,autoname,tostring(comment_count)})

          end
        },

        {
          src=图标("chat_bubble"),text="查看保存评论",onClick=function()
            local 保存路径=内置存储文件("Download/"..simpletitle.."/"..autoname)
            if getDirSize(保存路径.."/".."fold/")==0 then
              --            提示("你还没有收藏评论")
             else
              activity.newActivity("comment",{result,"local",simpletitle,autoname})
            end

          end
        },

        {
          src=图标("explore"),text="收藏文件夹",onClick=function()
            加入收藏夹(result,"zvideo",simpletitle,autoname)

          end
        },
        {
          src=图标("save"),text="保存在本地",onClick=function()
            创建文件夹(内置存储文件("Download/"..simpletitle))
            创建文件夹(内置存储文件("Download/"..simpletitle.."/"..autoname))

            创建文件(内置存储文件("Download/"..simpletitle.."/"..autoname.."/detail.txt"))

            写入文件(内置存储文件("Download/"..simpletitle.."/"..autoname.."/detail.txt"),'video_url="'..content.getUrl()..'"')

            写入文件(内置存储文件("Download/"..simpletitle.."/"..autoname.."/mht.mht"),'video_id="'..result..'"')

            提示("保存成功")
          end
        }
      }
    })
  end)
 elseif 类型=="本地" then
  task(1,function()
    a=MUKPopu({
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
            local 保存路径=内置存储文件("Download/"..simpletitle.."/"..autoname)
            if getDirSize(保存路径.."/".."fold/")==0 then
              提示("你还没有收藏评论")
             else
              activity.newActivity("comment",{result,comment_type,simpletitle,autoname})
            end
          end
        },

        {
          src=图标("cloud"),text="使用网络打开",onClick=function()
            activity.newActivity("column",{result,原类型})
          end
        },

      }
    })
  end)
end
