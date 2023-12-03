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
  mtype="local"
 else

  if 类型=="文章" then
    mtype="article"
    fxurl="https://zhuanlan.zhihu.com/p/"..result
   elseif 类型=="想法"
    mtype="pin"
    fxurl="https://www.zhihu.com/appview/pin/"..result
   elseif 类型=="视频"
    mtype="zvideo"
    fxurl="https://www.zhihu.com/zvideo/"..result
    followdoc='document.querySelector(".FollowButton")'
   elseif 类型=="圆桌" then
    fxurl="https://www.zhihu.com/roundtable/"..result
    follow_content_doc='document.querySelector(".MetaArea-module-header-1S1T").childNodes[1].childNodes[1]'
   elseif 类型=="专题" then
    fxurl="https://www.zhihu.com/special/"..result
    follow_content_doc='document.querySelector(".FollowButton-module-root-3aFK")'
  end

end


波纹({fh,_more},"圆主题")
静态渐变(转0x(primaryc)-0x9f000000,转0x(primaryc),pbar,"横")


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


if getLogin() then
  zHttp.post("https://api.zhihu.com/usertask-core/action/read_content",'{"content_id":"'..result..'","content_type":"ANSWER","action_time":'..os.time()..'}',postapphead,function(code,content)
    if code==200 then
    end
  end)
end

function 刷新()
  content.setVisibility(8)
  if 类型=="文章" then
    zHttp.get("https://www.zhihu.com/api/v4/articles/"..result,head,function(code,body)
      if code==200 then
        local url=luajson.decode(body)
        autoname=url.author.name
        simpletitle=url.title
        simpletitle=StringHelper.Sub(simpletitle,0,20,"...")
        if simpletitle=="" then
          simpletitle="一个文章"
        end
        authorid=url.author.id
        _title.Text=url.title
        content.loadUrl("https://www.zhihu.com/appview/p/"..result)
        保存历史记录(_title.Text,"文章分割"..result,50)
       else
        提示("加载页面失败")
        _title.Text="加载失败"
      end
      if luajson.decode(body).author.id==activity.getSharedData("idx") then
        table.insert(mpop.list,#mpop.list,{
          src=mpop.list[#mpop.list].src,text="编辑文章",onClick=function()
            提示("请手动进入设置")
            activity.newActivity("huida",{"https://zhuanlan.zhihu.com/p/"..result,"我的文章设置"})
          end
        })
        a=MUKPopu(mpop)
      end
    end)
   elseif 类型=="想法" then
    _title.Text="查看想法"
    zHttp.get("https://www.zhihu.com/api/v4/pins/"..result,head,function(code,content)
      simpletitle=luajson.decode(content).excerpt_title
      simpletitle=StringHelper.Sub(simpletitle,0,20,"...")
      if simpletitle=="" then
        simpletitle="一个想法"
      end
      autoname=luajson.decode(content).author.name
      authorid=luajson.decode(content).author.id
      if luajson.decode(content).self_create then
        table.insert(mpop.list,#mpop.list,{
          src=mpop.list[#mpop.list].src,text="删除想法",onClick=function()
            zHttp.delete("https://www.zhihu.com/api/v4/pins/"..result,posthead,function(code,content)
              if code==200 then
                提示("删除成功")
               elseif code==401 then
                提示("请登录后使用本功能")
              end
            end)

          end
        })
        a=MUKPopu(mpop)
      end
      保存历史记录(simpletitle,"想法分割"..result,50)
    end)
    content.loadUrl("https://www.zhihu.com/appview/pin/"..result)
   elseif 类型=="视频" then
    content.loadUrl("https://www.zhihu.com/zvideo/"..result.."?utm_id=0")
    _title.Text="视频"
    zHttp.get("https://www.zhihu.com/api/v4/zvideos/"..result,head,function(code,content)
      simpletitle=luajson.decode(content).title
      simpletitle=StringHelper.Sub(simpletitle,0,20,"...")
      if simpletitle=="" then
        simpletitle="一个视频"
      end
      autoname=luajson.decode(content).author.name
      authorid=luajson.decode(content).author.id
      保存历史记录(simpletitle,"视频分割"..result,50)
      table.insert(mpop.list,#mpop.list,{
        src=mpop.list[#mpop.list].src,text="编辑视频",onClick=function()
          提示("请手动进入设置")
          activity.newActivity("huida",{"https://www.zhihu.com/zvideo/"..result,"我的视频设置"})
        end
      })
      a=MUKPopu(mpop)
    end)
    if activity.getSharedData("视频提示0.01")==nil
      AlertDialog.Builder(this)
      .setTitle("小提示")
      .setCancelable(false)
      .setMessage("你可点击右上角查看评论")
      .setPositiveButton("我知道了",{onClick=function() activity.setSharedData("视频提示0.01","true") end})
      .show()
    end
   elseif 类型=="直播" then
    followdoc='document.querySelector(".TheaterRoomHeader-actor").childNodes[2]'
    zHttp.get("https://www.zhihu.com/api/v4/drama/dramas/"..result.."/lite",head,function(code,content)
      _title.Text="直播"
      authorid=luajson.decode(content).theater.actor.id
      mid=luajson.decode(content).theater.id
      mty.loadUrl("https://www.zhihu.com/theater/"..mid.."?drama_id="..result)
    end)
   elseif 类型=="圆桌" then
    content.loadUrl("https://www.zhihu.com/roundtable/"..result)
    _title.Text="圆桌"
   elseif 类型=="专题" then
    content.loadUrl("https://www.zhihu.com/special/"..result)
    _title.Text="专题"
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

mty.setWebContentsDebuggingEnabled(true)
content.setWebViewClient{
  onReceivedError=function(view,a,b)

  end,
  shouldOverrideUrlLoading=function(view,url)
    import "android.content.*"
    activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(url)
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
  end,
  onPageStarted=function(view,url,favicon)
    --网页加载
    等待doc(view)
    加载js(view,获取js("zhihugif"))
    if 全局主题值=="Night" then
      content.BackgroundColor=转0x("#00000000",true);
      黑暗模式主题(view)
      content.setVisibility(0)
     else
      白天主题(view)
    end

    if url:find("https://www.zhihu.com/special/"..result) then
      加载js(view,获取js("special"))
     elseif url:find("https://www.zhihu.com/roundtable/"..result) then
      加载js(view,获取js("roundtable"))
     elseif url:find("https://www.zhihu.com/appview/pin/"..result) then
      加载js(view,获取js("pin"))
     elseif url:find("https://www.zhihu.com/appview/p/"..result)
      加载js(view,获取js("article"))
     elseif url:find("https://www.zhihu.com/zvideo/"..result)
      加载js(view,获取js("zvideo"))
     elseif url:find("https://www.zhihu.com/special/"..result)
      加载js(view,获取js("special"))
     elseif url:find("https://www.zhihu.com/theater/")
      加载js(view,获取js("drama"))
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
import "android.content.pm.ActivityInfo"
content.setWebChromeClient(LuaWebChrome(LuaWebChrome.IWebChrine{
  onProgressChanged=function(view,p)
    setProgress(p)
    if p==100 then
      setProgress(100)
      task(500,function()
        linearParams=pbar.getLayoutParams()
        linearParams.width =0
        pbar.setLayoutParams(linearParams)
      end)
    end

  end,
  onShowCustomView=function(view,url)
    this.addContentView(view, WindowManager.LayoutParams(-1, -1))
    this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE)
    kkoo=view
    activity.getWindow().getDecorView().setSystemUiVisibility(5639)
  end,
  onHideCustomView=function(view,url)
    kkoo.getParent().removeView(kkoo.setForeground(nil).setVisibility(8))
    this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
    content.setVisibility(0)
    kkoo=nil
    activity.getWindow().getDecorView().setSystemUiVisibility(8208)
  end,

  onConsoleMessage=function(consoleMessage)
    --打印控制台信息
    if consoleMessage.message():find("关注分割") then
      local mtext=consoleMessage.message():match("关注分割(.+)")
      if mtext:find("已关注") then
        zHttp.delete("https://api.zhihu.com/people/"..authorid.."/followers/"..activity.getSharedData("idx"),posthead,function(a,b)
          if a==200 then
            if 类型=="视频" then
              加载js(mty,followdoc..'.className="Button FollowButton ZVideo-authorFollowButton FEfUrdfMIKpQDJDqkjte Button--blue JmYzaky7MEPMFcJDLNMG"')
              加载js(mty,followdoc..'.innerHTML='..[['<span style="display: inline-flex; align-items: center;">​<svg width="1.2em" height="1.2em" viewBox="0 0 24 24" class="Zi Zi--Plus FollowButton-icon" fill="currentColor"><path fill-rule="evenodd" d="M13.25 3.25a1.25 1.25 0 1 0-2.5 0v7.5h-7.5a1.25 1.25 0 1 0 0 2.5h7.5v7.5a1.25 1.25 0 1 0 2.5 0v-7.5h7.5a1.25 1.25 0 0 0 0-2.5h-7.5v-7.5Z" clip-rule="evenodd"></path></svg></span>关注']])
             else
              加载js(mty,followdoc..'.innerText="关注"')
            end
          end
        end)
       elseif mtext:find("关注") then
        zHttp.post("https://api.zhihu.com/people/"..authorid.."/followers","",posthead,function(a,b)
          if a==200 then
            if 类型=="视频" then
              加载js(mty,followdoc..'.className="Button FollowButton ZVideo-authorFollowButton FEfUrdfMIKpQDJDqkjte Button--primary Button--grey epMJl0lFQuYbC7jrwr_o ZdfrHW7Ef5ZjwFiiBJuS"')
              加载js(mty,followdoc..'.innerText="已关注"')
             else
              加载js(mty,followdoc..'.innerText="已关注"')
            end
           elseif a==500 then
            提示("请登录后使用本功能")
          end
        end)
      end
     elseif consoleMessage.message()=="显示评论" then
      activity.newActivity("comment",{result,mtype.."s"})
     elseif consoleMessage.message()=="查看用户" then
      activity.newActivity("people",{authorid})
     elseif consoleMessage.message()=="收藏" then
      加入收藏夹(result,mtype)
     elseif consoleMessage.message()=="申请转载" then
      加入专栏(result,mtype)
     elseif consoleMessage.message():find("关注") and consoleMessage.message():find("分割") then
      local mtext=consoleMessage.message():match("分割(.+)")
      local 参数
      if 类型=="圆桌" then
        参数="roundtables"
       elseif 类型=="专题" then
        参数="news_specials"
      end
      local geturl="https://www.zhihu.com/api/v4/"..参数.."/"..result.."/followers"
      if mtext=="已关注" then
        zHttp.delete(geturl,head,function(code,content)
          if code==200 or code==204 then
            加载js(mty,follow_content_doc..'.innerText="未关注"')
          end
        end)
       else
        zHttp.post(geturl,"",posthead,function(code,content)
          if code==200 or code==204 then
            加载js(mty,follow_content_doc..'.innerText="已关注"')
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

--pop

if 类型=="本地" then
  mpop={
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
            activity.newActivity("comment",{result,"local",simpletitle,autoname})
          end
        end
      },

      {
        src=图标("cloud"),text="使用网络打开",onClick=function()
          activity.newActivity("column",{result,原类型})
        end
      },

    }
  }
 elseif 类型 then

  mpop={
    tittle=_title.text,
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
          if autoname and fxurl then
            local format="【%s】%s:… %s"
            分享文本(string.format(format,_title.Text,autoname,fxurl))
           else
            local format="【%s】 %s"
            分享文本(string.format(format,_title.Text,content.getUrl()))
          end
        end
      },
      {
        src=图标("chat_bubble"),text="查看评论",onClick=function()
          activity.newActivity("comment",{result,mtype.."s"})

        end
      },
      {
        src=图标("explore"),text="收藏文件夹",onClick=function()
          加入收藏夹(result,mtype)

        end
      },
      {
        src=图标("explore"),text="举报",onClick=function()
          local url="https://www.zhihu.com/report?id="..result.."&type="..mtype
          activity.newActivity("huida",{url.."&source=android&ab_signature=",nil,nil,nil,"举报"})
        end
      },
      {
        src=图标("save"),text="保存在本地",onClick=function()
          local result=get_write_permissions()
          if result~=true then
            return false
          end
          保存()
        end
      },
    }
  }
 else
  mpop={
    tittle=_title.Text,
    list={
    }
  }
end

if 类型=="文章" then
  mpop["tittle"]="文章"
  function 保存()
    if not(文件是否存在(内置存储文件("Download/".._title.Text))) then
      创建文件夹(内置存储文件("Download/".._title.Text))
    end
    创建文件夹(内置存储文件("Download/".._title.Text.."/"..autoname))
    content.saveWebArchive(内置存储文件("Download/".._title.Text.."/"..autoname.."/mht.mht"))
    创建文件(内置存储文件("Download/".._title.Text.."/"..autoname.."/detail.txt"))
    写入文件(内置存储文件("Download/".._title.Text.."/"..autoname.."/detail.txt"),'article_url="'..content.getUrl()..'"')
    提示("保存成功")
  end
 elseif 类型=="想法" then
  mpop["tittle"]="一个想法"
  function 保存()
    创建文件夹(内置存储文件("Download/"..simpletitle))
    创建文件夹(内置存储文件("Download/"..simpletitle.."/"..autoname))
    创建文件(内置存储文件("Download/"..simpletitle.."/"..autoname.."/detail.txt"))
    写入文件(内置存储文件("Download/"..simpletitle.."/"..autoname.."/detail.txt"),'pin_url="'..content.getUrl()..'"')
    content.saveWebArchive(内置存储文件("Download/"..simpletitle.."/"..autoname.."/mht.mht"))
    提示("保存成功")
  end
 elseif 类型=="视频" then
  mpop["tittle"]="视频"
  function 保存()
    创建文件夹(内置存储文件("Download/"..simpletitle))
    创建文件夹(内置存储文件("Download/"..simpletitle.."/"..autoname))
    创建文件(内置存储文件("Download/"..simpletitle.."/"..autoname.."/detail.txt"))
    写入文件(内置存储文件("Download/"..simpletitle.."/"..autoname.."/detail.txt"),'video_url="'..content.getUrl()..'"')
    写入文件(内置存储文件("Download/"..simpletitle.."/"..autoname.."/mht.mht"),'video_id="'..result..'"')
    提示("保存成功")
  end
  table.insert(mpop.list,4,{
    src=图标("chat_bubble"),text="查看保存评论",onClick=function()
      local 保存路径=内置存储文件("Download/"..simpletitle.."/"..autoname)
      if getDirSize(保存路径.."/".."fold/")==0 then
        提示("你还没有收藏评论")
       else
        activity.newActivity("comment",{result,"local",simpletitle,autoname})
      end

    end
  })
 elseif 类型 then
  if 类型~="本地" then
    mpop["tittle"]=类型
    table.remove(mpop.list,3)
    table.remove(mpop.list,3)
    table.remove(mpop.list,3)
    table.remove(mpop.list,3)
  end
 else
  table.remove(mpop.list,2)
  table.remove(mpop.list,2)
  table.remove(mpop.list,2)
  table.remove(mpop.list,2)
  table.remove(mpop.list,2)
end
task(1,function()
  a=MUKPopu(mpop)
end)