require "import"
import "mods.muk"
import "com.lua.*"
import "android.text.method.LinkMovementMethod"
import "android.text.Html"
import "java.net.URL"
import "com.bumptech.glide.Glide"
import "androidx.viewpager2.widget.ViewPager2"
import "com.dingyi.adapter.BaseViewPage2Adapter"
import "android.view.*"
import "androidx.viewpager2.widget.ViewPager2$OnPageChangeCallback"
import "android.webkit.WebChromeClient"
import "android.content.pm.ActivityInfo"
import "android.graphics.PathMeasure"
import "android.webkit.ValueCallback"
问题id,回答id,问题对象,是否记录历史记录,在线页数=...

activity.setContentView(loadlayout("layout/answer"))

波纹({fh,_more,mark,comment,thank,voteup},"圆主题")
波纹({all_root},"方自适应")


import "model.question"
import "model.answer"

comment.onClick=function()
  xpcall(function()
    activity.newActivity("comment",{tointeger(数据表[pg.adapter.getItem(pg.getCurrentItem()).id].data.id).."","answers",_title.Text,数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.username.Text})
    end,function()
    提示("请稍等")
  end)
end;


local function 设置滑动跟随(t)
  t.onScrollChange=function(view,x,y,lx,ly)

    if y<=2 then--解决滑到顶了还是没有到顶的bug
      llb.y=0
      comment_parent.y=0
      return
    end
    if ly>y then --上次滑动y大于这次y就是向上滑
      if llb.y<=0 or math.abs(y-ly)>=dp2px(56) then --这个or为了防止快速大滑动
        llb.y=0
        comment_parent.y=0
       else
        llb.y=llb.y-math.abs(y-ly)
        comment_parent.y=comment_parent.y-math.abs(y-ly)
      end
     else
      if llb.y<=dp2px(56)+dp2px(26) then --没到底就向底移动(上滑)，+26dp是悬浮球高
        llb.y=llb.y+math.abs(y-ly)
        comment_parent.y=comment_parent.y+math.abs(y-ly)
      end
    end
  end
end




回答容器=answer:new(问题id)


if 问题对象 then
  回答容器:addAII(require "cjson".decode(tostring(问题对象)))
  if 在线页数 then
    回答容器.now=在线页数
  end
end

--

function 数据添加(t,b)
  local detector=GestureDetector(this,{a=lambda _:_})


  local isDoubleTap=false
  local timeOut=200
  detector.setOnDoubleTapListener {
    onDoubleTap=function()
      t.msrcroll.smoothScrollTo(0, 0)
      isDoubleTap=true
      task(timeOut,function()isDoubleTap=false end)
    end
  }

  all_root.onClick=function(v)
    if not isDoubleTap then
      task(timeOut,function()
        if not isDoubleTap then
          activity.newActivity("question",{问题id})
        end
      end)
    end
  end

  all_root.onLongClick=function(v)
    --  print(回答容器.now)
    if 回答容器.isleft==false then
      if not 问题对象 then
        双按钮对话框("提示","无法获取上一个回答 如若想获取请在问题页点击回答","跳转","取消",function()
          关闭对话框(an) activity.newActivity("question",{问题id}) end,function()
          关闭对话框(an)
        end)
        return
      end
      双按钮对话框("提示","是否要切换上一个回答","是的","取消",function()
        关闭对话框(an) 提示("切换中") activity.finish() activity.newActivity("answer",{问题id,回答id,问题对象,false,回答容器.now-1}) end,function()
        关闭对话框(an)
      end)
     else
      提示("不能左滑了")
    end
  end

  all_root.onTouch=function(v,e)
    return detector.onTouchEvent(e)
  end

  t.content.setHorizontalScrollBarEnabled(false);
  t.content.setVerticalScrollBarEnabled(false);

  t.content.setVisibility(0)
  if not(b) then return end

  defer local question_base=require "model.question":new(tointeger(b.question.id))
  :getData(function(tab)
    all_answer.Text="点击查看全部"..tointeger(tab.answer_count).."个回答 >"

  end)

  if activity.getSharedData("标题简略化")~="true" then
    _title.Text=b.question.title:gsub("/",[[ 或 ]])
   else
    _title.Text="回答"
  end


  if b.author.name=="知乎用户" then
    Http.get("https://api.zhihu.com/people/"..b.author.id,{
      ["cookie"] = 获取Cookie("https://www.zhihu.com/")
      },function(code,content)
      if code==200 then
        local data=require "cjson".decode(content)
        t.userheadline.Text=data.headline
        t.username.Text=data.name
        Glide.with(this).load(data.avatar_url).into(t.usericon)
        Glide.get(this).clearMemory();
      end
    end)
   else

    Glide
    .with(this)
    .load(b.author.avatar_url)
    .into(t.usericon)

    Glide.get(this).clearMemory();


    if b.author.headline=="" then
      t.userheadline.Text="Ta还没有签名哦~"
     else
      t.userheadline.Text=b.author.headline
    end



    t.username.Text=b.author.name

  end

  t.ripple.onClick=function()
    local id=b.author.id
    if id~="0" then
      activity.newActivity("people",{id})
     else
      提示("回答作者已设置匿名")
    end
  end

  波纹({t.ripple},"圆黑")

  t.userinfo.post{
    run=function()
      local linearParams = t.ripple.getLayoutParams()
      linearParams.width =t.userinfo.width
      linearParams.height = t.userinfo.height
      t.ripple.setLayoutParams(linearParams)
    end
  }

  t.msrcroll.smoothScrollTo(0,0)

  设置滑动跟随(t.msrcroll)


  t.content
  .getSettings()
  .setLayoutAlgorithm(WebSettings.LayoutAlgorithm.SINGLE_COLUMN)
  .setJavaScriptEnabled(true)--设置支持Js
  .setJavaScriptCanOpenWindowsAutomatically(true)
  .setUseWideViewPort(true)
  .setDefaultTextEncodingName("utf-8")
  .setLoadsImagesAutomatically(true)
  .setAllowFileAccess(false)
  .setDatabasePath(APP_CACHEDIR)
  --//设置 应用 缓存目录
  --  .setAppCachePath(APP_CACHEDIR)
  --     //开启 应用缓存 功能
  .setSupportZoom(true)
  .setLoadWithOverviewMode(true)
  .setBuiltInZoomControls(true)

  if activity.getSharedData("禁用缓存")=="true"
    t.content
    .getSettings()
    .setAppCacheEnabled(false)
    .setCacheMode(WebSettings.LOAD_NO_CACHE)
    --//开启 DOM 存储功能
    .setDomStorageEnabled(false)
    --        //开启 数据库 存储功能
    .setDatabaseEnabled(false)
   else
    t.content
    .getSettings()
    .setAppCacheEnabled(true)
    .setCacheMode(2)
    --//开启 DOM 存储功能
    .setDomStorageEnabled(true)
    --        //开启 数据库 存储功能
    .setDatabaseEnabled(true)
  end


  回答id=tointeger(b.id)
  点击感谢状态=b.relationship.is_thanked

  if 是否记录历史记录 and not(已记录) then
    初始化历史记录数据(true)
    保存历史记录(_title.Text,问题id.."分割"..回答id,50)
    已记录=true
  end

  t.content.removeView(t.content.getChildAt(0))
  --t.content.setbackground(0x01000000)

  t.content.setWebViewClient{
    shouldOverrideUrlLoading=function(view,url)
      if url~=("https://www.zhihu.com/appview/answer/"..tointeger(b.id).."") then
        检查链接(url)
        view.stopLoading()
        view.goBack()
      end
    end,
    onPageStarted=function(view,url,favicon)
      等待doc(view)
      if 全局主题值=="Night" then
        --       加载js(view,[[javascript:(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=50,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#]]..backgroundc:sub(4,#backgroundc)..[[ !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]])
        加载js(view,[[javascript:(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=80,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#]]..backgroundc:sub(4,#backgroundc)..[[ !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]])
        --   黑暗模式主题(view)
      end
    end,
    onPageFinished=function(view,url,favicon)
      加载js(view,[[
	function yh() {
		document.getElementsByClassName("AnswerReward")[0].style.display = "none"
	}
	waitForKeyElements(' [class="AnswerReward"]', yh);
   ]])

      --      if activity.getSharedData("加载回答中存在的视频(beta)")=="true" then
      if b.content:find("video%-box") then
        Http.get("https://www.zhihu.com/api/v4/me",{
          ["cookie"] = 获取Cookie("https://www.zhihu.com/");
          },function(code,content)
          if code==401 then
            AlertDialog.Builder(this)
            .setTitle("提示")
            .setMessage("该回答含有视频 不登录可能无法显示视频 建议登录")
            .setCancelable(false)
            .setPositiveButton("我知道了",nil)
            .show()
          end
          return
        end)

        加载js(view,[["document.cookie="..获取Cookie("https://www.zhihu.com/")]])
        加载js(view,[[
  function setvideo () {
    if (document.getElementsByClassName("video-box").length>0 && typeof(document.getElementsByClassName("video-box")[0].href)!="undefined") {
    for (i = 0; i<document.getElementsByClassName("video-box").length; i++) {
        (function(i){
       
            var k =decodeURIComponent(document.getElementsByClassName("video-box")[i].href).match(/\/video\/(\S*)/)[1]
            var xhr = new XMLHttpRequest();
            var url = "https://lens.zhihu.com/api/v4/videos/"+k;
            xhr.open("get", url);
            xhr.onreadystatechange = function () {
                if (xhr.readyState == 4) {
				if (xhr.status == 200) {
				    videohtml= xhr.responseText
					var getvideourlhtml = JSON.parse(videohtml);
						try{
		videourl=getvideourlhtml.playlist.SD.play_url
	}catch(err){				//抓住throw抛出的错误
	if (getvideourlhtml.playlist.LD.play_url) {
	videourl= getvideourlhtml.playlist.LD.play_url  
	} else if (getvideourlhtml.playlist.HD.play_url) {
	videourl= getvideourlhtml.playlist.HD.play_url  
	}
	}
	
                    document.getElementsByClassName("video-box")[i].outerHTML='<div class="video-box"><video src=' +videourl +  ' style="margin: auto;width: 100%;" controls=""></video></div>'
					} else {
					}
                }
            };
            xhr.send(null);
        })(i);
    }
}
}
waitForKeyElements(' [class="video-box"]', setvideo);
]])
        --[==[
      if not b.attachment then
        view.evaluateJavascript('document.getElementsByClassName("video-box").length>0?"true":"false"',ValueCallback({
          onReceiveValue=function(value)
          提示(value)
            if value=='"true"' then
              Http.get("https://www.zhihu.com/api/v4/me",{
                ["cookie"] = 获取Cookie("https://www.zhihu.com/");
                },function(code,content)
                if code==401 then
                  AlertDialog.Builder(this)
                  .setTitle("提示")
                  .setMessage("该回答含有视频 不登录可能无法显示视频 建议登录")
                  .setCancelable(false)
                  .setPositiveButton("我知道了",nil)
                  .show()
                end
                return
              end)
              
              加载js(view,[["document.cookie="..获取Cookie("https://www.zhihu.com/")]])
              加载js(view,[[
  function setvideo () {
    if (document.getElementsByClassName("video-box").length>0 && typeof(document.getElementsByClassName("video-box")[0].href)!="undefined") {
    for (i = 0; i<document.getElementsByClassName("video-box").length; i++) {
        (function(i){
       
            var k =decodeURIComponent(document.getElementsByClassName("video-box")[i].href).match(/\/video\/(\S*)/)[1]
            var xhr = new XMLHttpRequest();
            var url = "https://lens.zhihu.com/api/v4/videos/"+k;
            xhr.open("get", url);
            xhr.onreadystatechange = function () {
                if (xhr.readyState == 4) {
				if (xhr.status == 200) {
				    videohtml= xhr.responseText
					var getvideourlhtml = JSON.parse(videohtml);
						try{
		videourl=getvideourlhtml.playlist.SD.play_url
	}catch(err){				//抓住throw抛出的错误
	if (getvideourlhtml.playlist.LD.play_url) {
	videourl= getvideourlhtml.playlist.LD.play_url  
	} else if (getvideourlhtml.playlist.HD.play_url) {
	videourl= getvideourlhtml.playlist.HD.play_url  
	}
	}
	
                    document.getElementsByClassName("video-box")[i].outerHTML='<div class="video-box"><video src=' +videourl +  ' style="margin: auto;width: 100%;" controls=""></video></div>'
					} else {
					}
                }
            };
            xhr.send(null);
        })(i);
    }
}
}
waitForKeyElements(' [class="video-box"]', setvideo);
]])
            end
          end
        }))
        ]==]

       elseif b.attachment then
        --       else
        xpcall(function()
          视频链接=b.attachment.video.video_info.playlist.sd.url
          end,function()
          视频链接=b.attachment.video.video_info.playlist.ld.url
          end,function()
          视频链接=b.attachment.video.video_info.playlist.hd.url
        end)
        加载js(view,[[
  function setmyvideo() {
var videotext=document.createElement('div')
videotext.className="ExtraInfo"
videotext.innerText="该回答为视频回答"
document.getElementsByClassName("ExtraInfo")[0].insertBefore(videotext,document.getElementsByClassName("ExtraInfo")[0].firstChild);
var videourl=document.createElement('div')
videourl.className="video-box"
videourl.innerHTML='<video style="margin: auto;width: 100%;"]].." src=" ..视频链接.. [[ controls=""></video>'
document.getElementsByClassName("RichText ztext")[0].insertBefore(videourl,document.getElementsByClassName("RichText ztext")[0].firstChild);
}
waitForKeyElements('.RichText.ztext', setmyvideo);
]])

      end


      --    end
      if 全局主题值=="Night" then
        加载js(view,[[javascript:(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=80,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#]]..backgroundc:sub(4,#backgroundc)..[[ !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]])
      end
    end,
    onLoadResource=function(view,url)
      --      if 全局主题值=="Night" then
      --        加载js(view,[[javascript:(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=50,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#]]..backgroundc:sub(4,#backgroundc)..[[ !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]])
      --      end
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
      if b~=nil then
        activity.newActivity("image",{b})
      end
    end
  }

  t.content.addJSInterface(z,"androlua")

  t.content.setWebChromeClient(luajava.override(WebChromeClient,{
    onProgressChanged=function(super,view,url,favicon)
      --      if 全局主题值=="Night" then
      --        加载js(view,[[javascript:(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=50,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#]]..backgroundc:sub(4,#backgroundc)..[[ !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]])
      --      end
    end,
    onShowCustomView=function(z,a,b)
      v=a
      s=t.msrcroll.getScrollY()
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

      t.msrcroll.smoothScrollTo(0,s)

    end
  }))


  t.content.loadUrl("https://www.zhihu.com/appview/answer/"..tointeger(b.id).."")

  function onTouch(v,event)
    Log.e(TAG,"pull_to_refresh_view====>onTouch")
    t.content.onTouchEvent(event)
    return false
  end

  if tonumber(activity.getSharedData("test") or "0") <3 and pg.getCurrentItem()==0 and not(isshow) then
    ValueAnimator.ofFloat({0,activity.getWidth()*0.07,0})
    .setDuration(400)
    .setRepeatCount(1)
    .addUpdateListener{
      onAnimationUpdate=function(a)
        local x=a.getAnimatedValue()
        pg.scrollTo(x,0)--activity.getWidth()*1.2,0)
      end
    }.start()
    isshow=true
    activity.setSharedData("test",tonumber(activity.getSharedData("test") or 0)+1)
  end
end


function 加载页(mviews,a,b)
  if mviews==nil then return end
  if #mviews.ids.username.Text==0 and mviews.load==nil then --判断是否加载过没有
    回答容器:getOneData(function(cb,r)--获取1条数据

      if cb==false then
        mviews.load=nil
        if r then
          decoded_content = require "cjson".decode(r)
          if decoded_content.error and decoded_content.error.message and decoded_content.error.redirect then
            AlertDialog.Builder(this)
            .setTitle("提示")
            .setMessage(decoded_content.error.message)
            .setCancelable(false)
            .setPositiveButton("立即跳转",{onClick=function() activity.newActivity("huida",{decoded_content.error.redirect}) 提示("已跳转 成功后请自行退出") end})
            .show()
           else
            提示("获取回答出错 "..r or "")
          end
        end
        提示("已经没有更多数据了")
        pg.adapter.remove(a)
        pg.setCurrentItem(a-1,false)
        重表状态=true
       else

        pcall(function()

          if table.find(查重表,cb.id) then
            pg.adapter.remove(a)
            pg.setCurrentItem(a-1,false)
            mviews.load=nil
            重表状态=true
           else
            重表状态=false
          end

          查重表[cb.id]=cb.id

        end)

        if mviews.data==nil or mviews.data.voteup_count==nil then
          mviews.data=cb
        end

        if mviews.data and mviews.data.voteup_count and 重表状态==false then

          vote_count.Text=tointeger(mviews.data.voteup_count)..""
          thanks_count.Text=tointeger(mviews.data.thanks_count)..""
          comment_count.Text=tointeger(mviews.data.comment_count)..""
        end

        数据添加(mviews.ids,cb) --添加数据

        --        print(数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.content.getUrl())
        mviews.load=true
      end
    end,b or (a==0 and 回答容器.one==nil and a<=上次page and 回答容器.is_add==true and 回答容器.isleft==false and pg.adapter.getItemCount()>1))
   else

    if mviews.data and mviews.data.id then
      if mviews.data.voteup_count then
        vote_count.Text=tointeger(mviews.data.voteup_count)..""
        thanks_count.Text=tointeger(mviews.data.thanks_count)..""
        comment_count.Text=tointeger(mviews.data.comment_count)..""
        --[[
       else
        local include="?&include=cmment_count,voteup_count,thanks_count;voteup_count,cmment_count,thanks_count,badge[?(type=best_answerer)].topics"
        Http.get("https://api.zhihu.com/answers/"..mviews.data.id..include,head,function(a,b)
          if a==200 then
            mviews.data=require "cjson".decode(b).data[1]
            vote_count.Text=tointeger(mviews.data.voteup_count)..""
            thanks_count.Text=tointeger(mviews.data.thanks_count)..""
            comment_count.Text=tointeger(mviews.data.comment_count)..""
          end
        end)
        ]]
      end
    end
  end
end


--



function 首次设置()
  defer local question_base=require "model.question":new(问题id)
  :getData(function(tab)
    all_answer.Text="点击查看全部"..tointeger(tab.answer_count).."个回答 >"
    if tab.answer_count==1 then
      回答容器.isleft=true
    end
  end)


  for i=1,3 do
    pg.setCurrentItem(0,false)--设置正确的列
  end
end

isshow=false

pg.adapter=BaseViewPage2Adapter(this)

id表={}
数据表={}
查重表={}
上次page=0


--首先先加入多个view

id表[pg.adapter.getItemCount()+1]={}

local 加入view=loadlayout("layout/answer_list",id表[pg.adapter.getItemCount()+1])

pg.adapter.add(加入view)

数据表[加入view.id]={
  data={},
  ids=id表[pg.adapter.getItemCount()],
}



pg.registerOnPageChangeCallback(OnPageChangeCallback{--除了名字变，其他和PageView差不多
  onPageScrolled=function(a,b,c)
    --  print(回答容器.now)
    if c==0 then


      --判断页面是否在开头or结尾 是否需要添加

      if pg.adapter.getItemCount()==a+1 then

        id表[pg.adapter.getItemCount()+1]={}

        local 加入view=loadlayout("layout/answer_list",id表[pg.adapter.getItemCount()+1])

        pg.adapter.add(加入view)


        数据表[加入view.id]={
          data={},
          ids=id表[pg.adapter.getItemCount()],
        }


        local mviews=数据表[pg.adapter.getItem(a+1).id]

        if this.getSharedData("回答预加载(beta)")=="true" then

          加载页(mviews,a+1,false)
        end

       elseif a==0 and 回答容器.isleft==false and pg.adapter.getItemCount()>=1
        id表[pg.adapter.getItemCount()+1]={}
        if 回答容器.isleft==false or 回答容器.now==1 then
          if activity.getSharedData("左滑提示0.01")==nil then
            AlertDialog.Builder(this)
            .setTitle("小提示")
            .setCancelable(false)
            .setMessage("由于左滑有一些bug 已取消左滑刷新内容 如若想要使用请长按问题标题来实现该操作")
            .setPositiveButton("我知道了",{onClick=function() activity.setSharedData("左滑提示0.01","true") end})
            .show()
          end
          local mviews=数据表[pg.adapter.getItem(a).id]
          if mviews.data and mviews.data.id then
            if mviews.data.voteup_count then
              vote_count.Text=tointeger(mviews.data.voteup_count)..""
              thanks_count.Text=tointeger(mviews.data.thanks_count)..""
              comment_count.Text=tointeger(mviews.data.comment_count)..""
            end
          end
          return false
        end

        local 加入view=loadlayout("layout/answer_list",id表[pg.adapter.getItemCount()+1])

        pg.adapter.insert(加入view,0)

        数据表[加入view.id]={
          data={},
          ids=id表[pg.adapter.getItemCount()],
        }
        --      local mviews=数据表[pg.adapter.getItem(a+1).id]
        --      加载页(mviews,a+1)
        --      return

      end

      local mviews=数据表[pg.adapter.getItem(a).id]
      加载页(mviews,a)
      --[[
      local mviews=数据表[pg.adapter.getItem(a).id]
      加载页(mviews,a)
]]

      --[[
      if mviews.data and mviews.data.id then
        if mviews.data.voteup_count then
          vote_count.Text=tointeger(mviews.data.voteup_count)..""
          thanks_count.Text=tointeger(mviews.data.thanks_count)..""
          comment_count.Text=tointeger(mviews.data.comment_count)..""
         else
          local include="?&include=cmment_count,voteup_count,thanks_count;voteup_count,cmment_count,thanks_count,badge[?(type=best_answerer)].topics"
          Http.get("https://api.zhihu.com/answers/"..mviews.data.id..include,head,function(a,b)
            if a==200 then
              mviews.data=require "cjson".decode(b).data[1]
              vote_count.Text=tointeger(mviews.data.voteup_count)..""
              thanks_count.Text=tointeger(mviews.data.thanks_count)..""
              comment_count.Text=tointeger(mviews.data.comment_count)..""
            end
          end)
        end
      end]]

      上次page=a

    end

  end,

  onPageScrollStateChanged=function(state)--监听页面滑动
    if state==1 then
      ValueAnimator.ofFloat({comment_parent.y,dp2px(56)+dp2px(26)})
      .setDuration(200)
      .setRepeatCount(0)
      .addUpdateListener{
        onAnimationUpdate=function(a)
          local x=a.getAnimatedValue()
          llb.y=x
          comment_parent.y=x
        end
      }.start()
     elseif state==2 then
      ValueAnimator.ofFloat({comment_parent.y,0})
      .setDuration(200)
      .setRepeatCount(0)
      .addUpdateListener{
        onAnimationUpdate=function(a)
          local x=a.getAnimatedValue()
          llb.y=x
          comment_parent.y=x
        end
      }.start()
    end

  end
})


if 回答id and 问题对象==nil then
  回答容器.data[1]={}
  回答容器.data[1].id=回答id
end

首次设置()

--[[

local answerDrawable=LuaDrawable(function(mCanvas,mPaint,mDrawable)

  mPaint.setColor(0xff000000)
  .setAntiAlias(true)
  .setStrokeWidth(20)
  .setStyle(Paint.Style.FILL)
  .setStrokeCap(Paint.Cap.ROUND)

  local w=mDrawable.getBounds().right
  local h=mDrawable.getBounds().bottom

  local mPath=Path()

  
  mPath.moveTo(w, h); --移动到右下角
  mPath.lineTo(0, h); --移动到左下角
  mPath.lineTo(0, h-dp2px(56)) --移动到左上角
  
  local x=comment.parent.x
  local width=comment.parent.width
  
   
  comment.parent.visibility=8
   
  mPath.lineTo(x-dp2px(6),h-dp2px(56)) --移动到悬浮球的左上
  
  mPath.quadTo(x-dp2px(1),h-dp2px(56),x-dp2px(1),h-dp2px(50))
 
  mPath.quadTo(x-dp2px(6)+width/2+dp2px(6),h-dp2px(4),x+width+dp2px(6),h-dp2px(54))
  
  mPath.quadTo(x+width+dp2px(3),h-dp2px(56),x+width+dp2px(6),h-dp2px(56))
 
  
  mPath.lineTo(w, h-dp2px(56));--移动到右上角
  mPath.lineTo(w, h); --移动到右下角
 
  mCanvas.drawColor(0x00000000)
  --mPaint.setShadowLayer(dp2px(1), 0, dp2px(-1), 0xff000000);
  mCanvas.drawPath(mPath, mPaint);

  mPath.close();
end)

]]

ll.background=answerDrawable

function onDestroy()
  for i=1,#数据表 do
    数据表[i].ids.content.destroy()
    System.gc()
  end
end


local voted={}
local unvoted={}
voteup.onClick=function()
  if not voted[回答id] then
    voted[回答id]=tostring(tointeger(vote_count.text+1))
    unvoted[回答id]=tostring(tointeger(vote_count.text))
  end
  local head={
    ["cookie"] = 获取Cookie("https://www.zhihu.com/");
    ["Content-Type"] = "application/json"
  }
  Http.post("https://api.zhihu.com/answers/"..回答id.."/voters",'{"type":"up"}',head,function(code,content)
    if code==200 then
      提示("点赞成功")
      vote_count.text=voted[回答id]
     elseif code==400
      Http.post("https://api.zhihu.com/answers/"..回答id.."/voters",'{"type":"neutral"}',head,function(code,content)
        if code==200 then
          提示("取消点赞成功")
          vote_count.text=unvoted[回答id]
        end
      end)
     elseif code==401 then
      提示("请登录后使用本功能")
    end
  end)
end
local thanked={}
local unthanked={}
thank.onClick=function()
  if not thanked[回答id] then
    thanked[回答id]=tostring(tointeger(thanks_count.text+1))
    unthanked[回答id]=tostring(tointeger(thanks_count.text))
  end
  apiurl="https://www.zhihu.com/api/v4/zreaction"
  head={
    ["cookie"] = 获取Cookie("https://www.zhihu.com/");
    ["Content-Type"] = "application/json"
  }
  if not 点击感谢状态 then
    Http.post(apiurl,'{"content_type":"answers","content_id":"'..回答id..'","action_type":"emojis","action_value":"red_heart"}',head,function(code,content)
      if code==200 then
        点击感谢状态=true
        提示("表达感谢成功")
        thanks_count.text=thanked[回答id]
       elseif code==401 then
        提示("请登录后使用本功能")
      end
    end)
   else
    Http.delete(apiurl.."?content_type=answers&content_id="..回答id.."&action_type=emojis&action_value=",head,function(code,content)
      if code==200 then
        提示("取消感谢成功")
        thanks_count.text=unthanked[回答id]
        点击感谢状态=false
       elseif code==401 then
        提示("请登录后使用本功能")
      end
    end)

  end
end

local click=0

mark.onClick=function()
  --[[
  --[=[  if click==0 then
    click=1
   elseif click==1 then
    click=0
  end
  if click==1 then
    --  mark.setColorFilter(PorterDuffColorFilter(转0x(secondaryc),PorterDuff.Mode.SRC_ATOP));
    创建文件(内置存储文件("Collection/".._title.Text))]]
  --    写入文件(内置存储文件("Collection/".._title.Text),[[question_id="]]..问题id..[["
  --]]..[[answer_id="]]..回答id..[["
  --]]..[[vote_count="]]..vote_count.Text..[["
  --]]..[[comment_count="]]..comment_count.Text..[["
  --]]..[[author="]]..数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.username.Text..[["
  --]]
  --    )
  --    提示("已收藏")
  --       elseif click==0 then
  --  mark.setColorFilter(PorterDuffColorFilter(转0x(primaryc),PorterDuff.Mode.SRC_ATOP));
  --    删除文件(内置存储文件("Collection/".._title.Text))
  --    提示("已取消收藏")

  -- end]=]
  --
  --  xpcall(function()
  --    创建文件夹(内置存储文件("Collection/".._title.Text))
  --    创建文件夹(内置存储文件("Collection/".._title.Text.."/"..数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.username.Text))
  --    创建文件(内置存储文件("Collection/".._title.Text.."/"..数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.username.Text.."/detail.txt"))
  --   写入文件(内置存储文件("Collection/".._title.Text.."/"..数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.username.Text.."/detail.txt"),[[question_id="]]..问题id..[["
  --]]..[[answer_id="]]..回答id..[["
  --]])
  --    提示("收藏成功")
  --    end,function()
  --    提示("收藏失败 可能是未授予本地存储权限")
  --  end)
  local url=数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.content.getUrl()
  加入收藏夹(url:match("answer/(.+)"),"answer")

end

a=MUKPopu({
  tittle="回答",
  list={
    {
      src=图标("refresh"),text="刷新",onClick=function()

        数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.content.reload()

        提示("刷新中")
      end
    },

    {
      src=图标("share"),text="分享",onClick=function()

        local url=数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.content.getUrl()

        if url==nil then
          提示("加载中")
          return
        end

        local format="【%s】%s:… %s"

        分享文本(string.format(format,_title.Text,数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.username.Text,"https://www.zhihu.com/question/"..问题id.."/answer/"..url:match("answer/(.+)")))

      end
    },

    {
      src=图标("explore"),text="内部浏览器打开",onClick=function()

        local url=数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.content.getUrl()

        if url==nil then
          提示("加载中")
          return
        end

        url=" https://www.zhihu.com/question/"..问题id.."/answer/"..url:match("answer/(.+)")

        activity.newActivity("huida",{url,nil,true})

      end
    },
    {
      src=图标("chat_bubble"),text="查看评论",onClick=function()

        activity.newActivity("comment",{回答id,"answers"})

      end
    },
    {
      src=图标("get_app"),text="保存到本地",onClick=function()

        if 文件是否存在(内置存储文件("Download/".._title.Text))then

          xpcall(function()
            创建文件夹(内置存储文件("Download/".._title.Text.."/"..数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.username.Text))
            创建文件(内置存储文件("Download/".._title.Text.."/"..数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.username.Text.."/detail.txt"))
            写入文件(内置存储文件("Download/".._title.Text.."/"..数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.username.Text.."/detail.txt"),[[question_id="]]..问题id..[["
]]..[[answer_id="]]..回答id..[["
]]..[[thanks_count="]]..thanks_count.Text..[["
]]..[[vote_count="]]..vote_count.Text..[["
]]..[[comment_count="]]..comment_count.Text..[["
]]..[[author="]]..数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.username.Text..[["
]]..[[headline="]]..数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.userheadline.Text..[["
]])
            数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.content.saveWebArchive(内置存储文件("Download/".._title.Text.."/"..数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.username.Text.."/mht.mht"))
            提示("保存成功")
            end,function()
            提示("保存失败 可能是未授予本地存储权限")

          end)

         else
          xpcall(function()
            创建文件夹(内置存储文件("Download/".._title.Text))
            创建文件夹(内置存储文件("Download/".._title.Text.."/"..数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.username.Text))
            创建文件(内置存储文件("Download/".._title.Text.."/"..数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.username.Text.."/detail.txt"))
            写入文件(内置存储文件("Download/".._title.Text.."/"..数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.username.Text.."/detail.txt"),[[question_id="]]..问题id..[["
]]..[[answer_id="]]..回答id..[["
]]..[[thanks_count="]]..thanks_count.Text..[["
]]..[[vote_count="]]..vote_count.Text..[["
]]..[[comment_count="]]..comment_count.Text..[["
]]..[[author="]]..数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.username.Text..[["
]]..[[headline="]]..数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.userheadline.Text..[["
]])
            数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.content.saveWebArchive(内置存储文件("Download/".._title.Text.."/"..数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.username.Text.."/mht.mht"))
            提示("保存成功")
            end,function()
            提示("保存失败 可能是未授予本地存储权限")
          end)

        end

      end
    },

    {
      src=图标("book"),text="加入收藏夹",onClick=function()
        local url=数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.content.getUrl()
        加入收藏夹(url:match("answer/(.+)"),"answer")
      end
    },


  }
})

if activity.getSharedData("回答提示0.03")==nil
  AlertDialog.Builder(this)
  .setTitle("小提示")
  .setCancelable(false)
  .setMessage("支持点赞 点击感谢按钮 双击标题回到顶部")
  .setPositiveButton("我知道了",{onClick=function() activity.setSharedData("回答提示0.03","true") end})
  .show()
end

function onActivityResult(a,b,c)
  if b==100 then
    activity.recreate()
  end
end

--[[
if this.getSharedData("使用音量键滑动")=="true" then
function onKeyDown(keycode,event)
  if keycode==24 then
    pg.setCurrentItem(pg.getCurrentItem()+1,false)
    return true
  elseif keycode==25 then
    pg.setCurrentItem(pg.getCurrentItem()-1,false)
    return true
    else
    return false
  end
end
end
]]