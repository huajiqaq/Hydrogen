require "import"
import "mods.muk"
import "com.ua.*"

chrome = import "com.lua.LuaWebChrome"
client = import "com.lua.LuaWebViewclient"
callback = import "com.androlua.LuaWebView$LuaWebViewClient"


liulanurl,docode,ischeck,fxurl=...

activity.setContentView(loadlayout("layout/huida"))

波纹({fh,_more},"圆主题")

liulan.loadUrl(liulanurl)

if docode~=nil then
  liulan.getSettings().setUserAgentString("Mozilla/5.0 (Macintosh; Intel Mac OS X 10_15_2) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/79.0.3945.130 Safari/537.36")
  -- else
 elseif liulanurl:match("zhihu") and not liulanurl:match("zvideo") then
  liulan.getSettings().setUserAgentString("Mozilla/5.0 (Android 9; MI ) AppleWebKit/537.36 (KHTML) Version/4.0 Chrome/74.0.3729.136 mobile SearchCraft/2.8.2 baiduboxapp/3.2.5.10")--设置UA
end

liulan.removeView(liulan.getChildAt(0))

if liulanurl=="https://www.zhihu.com" then
  liulan.setVisibility(View.INVISIBLE)
  dl=ProgressDialog.show(activity,nil,'加载中 请耐心等待')
  dl.show()
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
    if _title.text~="搜索" then
      if liulanurl~="https://www.zhihu.com" and activity.getSharedData("标题简略化")~="true" then
        _title.text=(title)
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
    --              acceptTypes = fileChooserParams.getAcceptTypes();
    --[[   i =  Intent(Intent.ACTION_GET_CONTENT);
            i.addCategory(Intent.CATEGORY_OPENABLE);
           i.setType("image/*");
            activity.startActivityForResult(Intent.createChooser(i, "Image Chooser"), 10011);]]
    local intent= Intent(Intent.ACTION_PICK)
    intent.setType("image/*")
    this.startActivityForResult(intent, 1)
    return true;
  end,

  onConsoleMessage=function(consoleMessage)
    --打印控制台信息
    if consoleMessage.message()=="提问加载完成" then
      dl.dismiss()
      _title.text="提问"
      liulan.setVisibility(View.VISIBLE)
    end
  end,

  onShowCustomView=function(view,url)
    liulan.setVisibility(liulan.GONE);
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
    if url:sub(1,4)~="http" then
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
      检查链接(url)
      --      if ischeck==nil then 检查链接(url) else return false end
    end
    return true
  end,
  onPageStarted=function(view,url,favicon)

    --[[    if tostring(docode):match("默认") ~=true then load(docode)(tostring(url)) end--登录判断]]

    加载js(view,[[var setooo

function waitForKeyElements(selectorOrFunction, callback, waitOnce, interval, maxIntervals) {
	if (typeof waitOnce === "undefined") {
		waitOnce = true;
	}
	if (typeof interval === "undefined") {
		interval = 300;
	}
	if (typeof maxIntervals === "undefined") {
		maxIntervals = -1;
	}
	var targetNodes =
		typeof selectorOrFunction === "function" ? selectorOrFunction() : document.querySelectorAll(selectorOrFunction);

	var targetsFound = targetNodes && targetNodes.length > 0;
	if (targetsFound) {
		targetNodes.forEach(function(targetNode) {
			var attrAlreadyFound = "data-userscript-alreadyFound";
			var alreadyFound = targetNode.getAttribute(attrAlreadyFound) || false;
			if (!alreadyFound) {
				var cancelFound = callback(targetNode);
				if (cancelFound) {
					targetsFound = false;
				} else {
					targetNode.setAttribute(attrAlreadyFound, true);
				}
			}
		});
	}

	if (maxIntervals !== 0 && !(targetsFound && waitOnce)) {
		maxIntervals -= 1;
		setTimeout(function() {
			waitForKeyElements(selectorOrFunction, callback, waitOnce, interval, maxIntervals);
		}, interval);
	}
}

window.open=function() { return false }

function emulateMouseClick(element) {
  // 创建事件
  var event = document.createEvent("MouseEvents");
  // 定义事件 参数： type, bubbles, cancelable
  event.initEvent("click", true, true);
  // 触发对象可以是任何元素或其他事件目标
  element.dispatchEvent(event);
}
]])

    if liulanurl:match("zhihu") and liulanurl:match("answer") then
      加载js(view,[[
    function setq() {
let observer = new MutationObserver(() => {
	if (document.getElementsByClassName("Body--Android Body--Tablet Body--BaiduApp")[0].style.position == "fixed")
		document.getElementsByClassName("css-1cqr2ue")[0].style.width = '100%',
		document.getElementsByClassName("Button css-1x9te0t")[0].style.position = 'unset'
});

// 监听body元素的属性变化
observer.observe(document.getElementsByClassName("Body--Android Body--Tablet Body--BaiduApp")[0], {
	attributes: true,
	attributeFilter: ['style', 'position']
});
}



waitForKeyElements(' [class="Body--Android Body--Tablet Body--BaiduApp"]', setq)
    ]])
    end


  end,
  onLoadResource=function(view,url)
    --    加载js(view,[[window.open=function() { return false }]])
    --    if 全局主题值=="Night" then
    --      加载js(view,[[(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=50,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#]]..backgroundc:sub(4,#backgroundc)..[[ !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]])
    --    end
    --    if docode then 屏蔽元素(view,{"SignFlowHomepage-footer"}) end

  end,
  onPageFinished=function(view,url)
    if 全局主题值=="Night" then
      加载js(view,[[(function(){var styleElem=null,doc=document,ie=doc.all,fontColor=50,sel="body,body *";styleElem=createCSS(sel,setStyle(fontColor),styleElem);function setStyle(fontColor){var colorArr=[fontColor,fontColor,fontColor];return"background-color:#]]..backgroundc:sub(4,#backgroundc)..[[ !important;color:RGB("+colorArr.join("%,")+"%) !important;"}function createCSS(sel,decl,styleElem){var doc=document,h=doc.getElementsByTagName("head")[0],styleElem=styleElem;if(!styleElem){s=doc.createElement("style");s.setAttribute("type","text/css");styleElem=ie?doc.styleSheets[doc.styleSheets.length-1]:h.appendChild(s)}if(ie){styleElem.addRule(sel,decl)}else{styleElem.innerHTML="";styleElem.appendChild(doc.createTextNode(sel+" {"+decl+"}"))}return styleElem}})();]])
    end
    if docode~="默认" then 屏蔽元素(view,{"SignFlowHomepage-footer"})
    end
    if liulanurl=="https://www.zhihu.com" then
      加载js(view,[[
    document.getElementById("root").style.display="none"
    function set() {
    document.getElementsByClassName("Button Modal-closeButton")[0].style.display="none"
    document.getElementsByClassName("Modal Modal--large")[0].style.width="-webkit-fill-available"
    
    let observer = new MutationObserver(() => {
	if (document.getElementsByClassName("Modal-wrapper Modal-wrapper--transparent")[0]) {
   document.getElementsByClassName("Modal Modal--default Editable-videoModal")[0].style.width="unset"
alert("如若无关闭按钮 请点击空白处关闭")
}
});
   
   observer.observe(document.getElementsByClassName("Modal-wrapper")[0], {
	attributes: true,
	attributeFilter: ['class','className']
});
console.log("提问加载完成")
    }
    waitForKeyElements(' [class="Button Modal-closeButton Button--plain"]', set)    
    function setq() {
    emulateMouseClick(document.getElementsByClassName("Button SearchBar-askButton")[0])
    }
    waitForKeyElements(' [class="Button SearchBar-askButton css-rf6mh0 Button--primary Button--blue"]', setq)    
    ]]
      )
    end
end}



liulan.getSettings()
.setLayoutAlgorithm(WebSettings.LayoutAlgorithm.SINGLE_COLUMN)
.setJavaScriptEnabled(true)--设置支持Js
--  .setSupportZoom(true)
.setLoadWithOverviewMode(true)
--.setUseWideViewPort(true)
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
--     //开启 应用缓存 功能

.setUseWideViewPort(true)
.setBuiltInZoomControls(true)
.setSupportZoom(true)


if activity.getSharedData("禁用缓存")=="true"
  liulan
  .getSettings()
  .setAppCacheEnabled(false)
  --//开启 DOM 存储功能
  .setDomStorageEnabled(true)
  --        //开启 数据库 存储功能
  .setDatabaseEnabled(true)
  .setCacheMode(WebSettings.LOAD_NO_CACHE);
 else
  liulan
  .getSettings()
  .setAppCacheEnabled(true)
  --//开启 DOM 存储功能
  .setDomStorageEnabled(true)
  --        //开启 数据库 存储功能
  .setDatabaseEnabled(true)
  .setCacheMode(2)
end

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
