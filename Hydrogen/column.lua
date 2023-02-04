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

--下面是监听滑动代码部分，

local result,类型=...

if 类型==nil or 类型:match("%d") then
  类型="文章"
end

初始化历史记录数据(true)

ishavepic=true

activity.setContentView(loadlayout("layout/column_parent"))


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

--[[task(1,function()
  ades=menus.getHeight()
  mbt=_title.getY()
  bhj.Alpha=0
  gft.alpha=0
  if mty.getHeight()<(ades*2)+bit.getHeight() then
    layoutParams = mty.getLayoutParams();
    layoutParams.setMargins(0,ades,0,0);--4个参数按顺序分别是左上右下
    layoutParams.height =bit.getHeight()-(mby.getHeight()/3)--hsn
    mty.setLayoutParams(layoutParams);
   else
    layoutParams = mty.getLayoutParams();
    layoutParams.setMargins(0,ades,0,0);--4个参数按顺序分别是左上右下
    mty.setLayoutParams(layoutParams);
  end
end)


function 恢复白色()
  ishavepic=false
  mn.setTranslationY(-((mbys.getHeight())/2))
  linearParams = menus.getLayoutParams()
  linearParams.height =(mbys.getHeight()/4)+hsn
  menus.setLayoutParams(linearParams)
  gft.alpha=1
  bhj.alpha=1
  layoutParams = mty.getLayoutParams();
  layoutParams.setMargins(0,dp2px(56),0,0);--4个参数按顺序分别是左上右下
  mty.setLayoutParams(layoutParams);
end


function 恢复沉浸()
  ishavepic=true
  mn.setTranslationY(0)

  linearParams = menus.getLayoutParams()
  linearParams.height =mbys.getHeight()+((mby.getHeight()/2.2)+hsn)
  menus.setLayoutParams(linearParams)

  gft.alpha=0
  bhj.alpha=0
  if mty.getHeight()<(ades*2)+bit.getHeight() then
    layoutParams = mty.getLayoutParams();
    layoutParams.setMargins(0,ades,0,0);--4个参数按顺序分别是左上右下
    layoutParams.height =bit.getHeight()-(mby.getHeight()/3)-hsn
    mty.setLayoutParams(layoutParams);
   else
    layoutParams = mty.getLayoutParams();
    layoutParams.setMargins(0,ades,0,0);--4个参数按顺序分别是左上右下
    mty.setLayoutParams(layoutParams);
  end
end

ase=true


version_sdk = Build.VERSION.SDK


function bit.onScrollChange(a,b,j,y,u)
  if ishavepic==false then
    --    bit.ScrollTo(205,0)
    return
  end
  scale = j / mbys.getHeight();

  if CoordProg~=nil then
    CoordProg(scale<=1 and scale or 1)
  end
  if j==0 then

    linearParams = menus.getLayoutParams()
    linearParams.height =mbys.getHeight()+((mby.getHeight()/2.2)+hsn)
    menus.setLayoutParams(linearParams)
    mn.setTranslationY(0)

   elseif j > 0 and j <= mbys.getHeight() then

    scale = j / mbys.getHeight();
    alpha = (255 * scale);
    if CoordProg~=nil then
      CoordProg(scale)
    end
    mn.setTranslationY((-j/3))
    linearParams = menus.getLayoutParams()
    linearParams.height =((mbys.getHeight()/4)+hsn)+(mbys.getHeight()-((j/mbys.getHeight())*mbys.getHeight()))
    menus.setLayoutParams(linearParams)

   else

    mn.setTranslationY(-((mbys.getHeight())/2))
    linearParams = menus.getLayoutParams()
    linearParams.height =(mbys.getHeight()/4)+hsn
    menus.setLayoutParams(linearParams)
    if CoordTop~=nil then
      CoordTop()
    end
  end
end

]]
--监听滑动代码 结束


_title.Text="加载中"

mcolumn=column:new(result)


urls=0


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
        _title.Text=url.title
        urls=url
        --  恢复白色()
        content.loadUrl("https://www.zhihu.com/appview/p/"..result)
        保存历史记录(_title.Text,"文章分割"..result,50)
      end
    end)
   elseif 类型=="想法" then
    content.setVisibility(0)

    _title.Text="查看想法"
    Http.get("https://www.zhihu.com/api/v4/pins/"..result,function(code,content)
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
    Http.get("https://www.zhihu.com/api/v4/zvideos/"..result,function(code,content)
      simpletitle=require "cjson".decode(content).title
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
    -- 恢复白色()
  end
  --[[      if #url.title_image>0 then

        task(function(url)return loadbitmap(url)
          end,url.title_image,function(url)
          恢复沉浸()
          mn.setImageBitmap(url)
          content.setVisibility(0)
          content.loadUrl("https://www.zhihu.com/appview/p/"..result)
        end)
       else
        恢复白色()
        content.setVisibility(0)
        content.loadUrl("https://www.zhihu.com/appview/p/"..result)
      end]]


end

ur=false

function 高斯模糊(id,tp,radius1,radius2)
  function blur( context, bitmap, blurRadius)
    local renderScript = RenderScript.create(context);
    local blurScript = ScriptIntrinsicBlur.create(renderScript, Element.U8_4(renderScript));
    local inAllocation = Allocation.createFromBitmap(renderScript, bitmap);
    local outputBitmap = bitmap;
    local outAllocation = Allocation.createTyped(renderScript, inAllocation.getType());
    blurScript.setRadius(blurRadius);
    blurScript.setInput(inAllocation);
    blurScript.forEach(outAllocation);
    outAllocation.copyTo(outputBitmap);
    inAllocation.destroy();
    outAllocation.destroy();
    renderScript.destroy();
    blurScript.destroy();

    return outputBitmap;
  end

  bitmap=tp

  function blurAndZoom(context,bitmap,blurRadius,scale)
    return zoomBitmap(blur(context,zoomBitmap(bitmap, 1 / scale), blurRadius), scale);
  end

  function zoomBitmap(bitmap,scale)
    local w = bitmap.getWidth();
    local h = bitmap.getHeight();
    local matrix = Matrix();
    matrix.postScale(scale, scale);
    local mbitmap = Bitmap.createBitmap(bitmap, 0, 0, w, h, matrix, true);

    return mbitmap;
  end


  local 加深后的图片=blurAndZoom(activity,bitmap,radius1,radius2)



  id.setImageBitmap(加深后的图片)
end

--置顶事件
function CoordBottom()

end
--事件
function CoordTop()
  --  setTitleColor(转0x(primaryc))


end
--移动监听事件
function CoordProg(num)
  local ss=num
  if num<0.3 then
    gft.alpha=0
    _title.alpha=0
   elseif num<0.35 then
    gft.animate().alpha(num).setDuration(150).start()
    _title.animate().alpha(num).setDuration(150).start()
    return
  end
  gft.alpha=(lambda ss:ss<0.3 and 0 or ss)(ss)
  _title.alpha=(lambda ss:ss<0.3 and 0 or ss)(ss)

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
.setAllowFileAccess(false)
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
  --        //开启 数据库 存储功能
  .setDatabaseEnabled(false)
 else
  content
  .getSettings()
  .setAppCacheEnabled(true)
  .setCacheMode(2)
  --//开启 DOM 存储功能
  .setDomStorageEnabled(true)
  --        //开启 数据库 存储功能
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

      --      if 全局主题值=="Night" then
      --        加载js(view,[[(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=50,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#]]..backgroundc:sub(4,#backgroundc)..[[ !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]])
      --      end

    end
  end,
  onPageStarted=function(view,url,favicon)
    --网页加载
    等待doc(view)
    if 全局主题值=="Night" then
      黑暗模式主题(view)
     else
      白天主题(view)
      --      加载js(view,[[(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=50,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#]]..backgroundc:sub(4,#backgroundc)..[[ !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]])
    end

  end,
  onPageFinished=function(v,l)
    if 全局主题值=="Night" then
      黑暗模式主题(v)
    end
    加载js(v,[[
	function yh() {
	if 		(document.getElementsByClassName("css-p13kqn")[0]) {
				document.getElementsByClassName("css-p13kqn")[0].style.display = "none"
	}
		if 		(document.getElementsByClassName("css-1cgfj2y")[0]) {
					document.getElementsByClassName("css-1cgfj2y")[0].style.display = "none"
	}
		if 		(document.getElementsByClassName("css-1pxm4lx")[0]) {
					document.getElementsByClassName("css-1pxm4lx")[0].style.display = "none"
	}
		document.getElementsByClassName("PreviewCommentInput")[0].style.display = "none"
		document.getElementsByClassName("PreviewCommentSection-viewAllButton")[0].onclick = function() {
			console.log("显示评论")
		}
	}
	waitForKeyElements(' [class="PreviewCommentInput"]', yh);
   ]])
  end,
  onLoadResource=function(view,url)
    --网页加载完成
    --        print(backgroundc:sub(4,#backgroundc))

    --    if 全局主题值=="Night" then
    --      加载js(view,[[(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=50,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#]]..backgroundc:sub(4,#backgroundc)..[[ !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]])
    --    end
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

--


--退出时去除bitmap的内存

function onDestroy()
  content.destroy()
  System.gc()
  LuaUtil.rmDir(File(tostring(ContextCompat.getDataDir(activity)).."/cache"))
  collectgarbage("collect")
  pcall(
  function()
    local a=mn.getDrawable()
    a.setImageDrawable(nil)
    b.getBitmap().recycle()
  end)
end

--pop

if 类型=="文章" then
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
          activity.newActivity("comment",{result,"articles"})

        end
      },
      {
        src=图标("explore"),text="收藏文件夹",onClick=function()
          加入收藏夹(result,"article")

        end
      },
      {
        src=图标("save"),text="保存在本地",onClick=function()
          创建文件夹(内置存储文件("Download/".._title.Text))
          创建文件夹(内置存储文件("Download/".._title.Text.."/"..autoname))
          content.saveWebArchive(内置存储文件("Download/".._title.Text.."/"..autoname.."/mht.mht"))
          创建文件(内置存储文件("Download/".._title.Text.."/"..autoname.."/detail.txt"))

          写入文件(内置存储文件("Download/".._title.Text.."/"..autoname.."/detail.txt"),'article_url="'..content.getUrl()..'"')

          提示("保存成功")
        end
      }
    }
  })

 elseif 类型=="想法" then
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
          activity.newActivity("comment",{result,"pins",nil,nil,tostring(comment_count)})

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
      }
    }
  })
 elseif 类型=="视频" then
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
          activity.newActivity("comment",{result,"zvideos",nil,nil,tostring(comment_count)})

        end
      },
      {
        src=图标("explore"),text="收藏文件夹",onClick=function()
          加入收藏夹(result,"zvideo")

        end
      },
    }
  })
end
