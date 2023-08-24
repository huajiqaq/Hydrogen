require "import"
import "mods.muk"
import "com.lua.*"
import "android.text.method.LinkMovementMethod"
import "android.text.Html"
import "java.net.URL"
import "android.webkit.WebChromeClient"
import "android.content.pm.ActivityInfo"
import "android.graphics.PathMeasure"

activity.setContentView(loadlayout("layout/local"))

title,author=...

波纹({fh,_more,mark},"圆主题")
波纹({all_root},"方自适应")

filedir=内置存储文件("Download/"..title.."/"..author.."/mht.mht")

myuri = Uri.fromFile(File(filedir)).toString();

_title.text=title
xxx=读取文件(内置存储文件("Download/"..title.."/"..author.."/detail.txt"))

if not(xxx:match("question_id")) then


  local function replace_string(file_name, old_string, new_string)
    -- 读取文件内容
    local f = io.open(file_name, "r")
    local s = f:read("*a")
    f:close()

    -- 查找old_string的位置
    local i, j = string.find(s, old_string)
    if i then -- 如果存在

      -- 向上查找@media screen {的位置
      local k = string.find(s, '@media screen {', 1, true)

      -- 查找------MultipartBoundary前面的位置
      local l = string.find(s, '------MultipartBoundary', i, true) - 1

      -- 替换@media screen {到------MultipartBoundary前面的文字为new_string
      local new_s = string.sub(s, 1, k - 1) .. new_string .. "\n" .. string.sub(s, l + 1)

      -- 写入文件
      local f = io.open(file_name, "w")
      f:write(new_s)
      f:close()

     else -- 如果不存在
      if this.getSharedData("调式模式")=="true" then
        提示(old_string .. "在文件中没有找到")
      end
    end
    return
  end

  -- 定义append_string函数
  local function append_string(file_name, target_string, append_string)
    -- 读取文件内容
    local f = io.open(file_name, "r")
    local s = f:read("*a")
    f:close()

    -- 查找target_string的位置
    local i, j = string.find(s, target_string)
    if i then -- 如果存在

      -- 在target_string后添加append_string
      local new_s = string.sub(s, 1, j) .. append_string .. string.sub(s, j + 1)

      -- 写入文件
      local f = io.open(file_name, "w")
      f:write(new_s)
      f:close()

     else -- 如果不存在
      if this.getSharedData("调式模式")=="true" then
        提示(target_string .. "在文件中没有找到")
      end
      return
    end
  end

  -- 打开 mhtml 文件
  local file = io.open (filedir, "r+")
  -- 读取文件内容
  local content = file:read ("*a")
  --获取个数
  local _,count = content:gsub("dark%-mode","")
  file:close()
  if count==1 then
    append_string(filedir, 'https://pic4.zhimg.com/">', '<svg id="dark-mode-svg" style="height: 0; width: 0; display: none;"><filter id="dark-mode-filter" x="0" y="0" width="99999" height="99999"><feColorMatrix type="matrix" values="0.283 -0.567 -0.567 0 0.925 -0.567 0.283 -0.567 0 0.925 -0.567 -0.567 0.283 0 0.925 0 0 0 1 0"></feColorMatrix></filter><filter id="dark-mode-reverse-filter" x="0" y="0" width="99999" height="99999"><feColorMatrix type="matrix" values="0.333 -0.667 -0.667 0 1 -0.667 0.333 -0.667 0 1 -0.667 -0.667 0.333 0 1 0 0 0 1 0"></feColorMatrix></filter></svg><meta name="theme-color" content="#131313">')
    if content:find("#dark%-mode%-reverse%-filter") then
      replace_string(filedir, 'url%("#dark%-mode%-reverse%-filter"%)', [[@media screen {
  img, .sr-backdrop { filter: url("#dark-mode-filter-a") !important;
}]])
      -- 打开 mhtml 文件
      file = io.open (filedir, "r+")
      -- 读取文件内容
      content = file:read ("*a")
      file:close()
    end
    _,count = content:gsub("dark%-mode","")
  end

  if count>1 then
    local _,mycount = content:gsub('height: 0; width: 0; display: none;"><filter',"")
    if mycount==0 then
      替换文件字符串(filedir,'height: 0; width: 0;"><filter ','height: 0; width: 0; display: none;"><filter')
    end
    if 全局主题值=="Night" then
      if content:find("#dark%-mode%-filter%-a") then
        replace_string(filedir, 'url%("#dark%-mode%-filter%-a"%)', [[@media screen {
  html { filter: url("#dark-mode-filter") !important; }
  img, video, iframe, canvas, :not(object):not(body) > embed, object, svg image, [style*="background:url"], [style*="background-image:url"], [style*="background: url"], [style*="background-image: url"], [background], twitterwidget, .sr-reader, .no-dark-mode, .sr-backdrop { filter: url("#dark-mode-reverse-filter") !important; }
  [style*="background:url"] *, [style*="background-image:url"] *, [style*="background: url"] *, [style*="background-image: url"] *, input, [background] *, img[src^="https://s0.wp.com/latex.php"], twitterwidget .NaturalImage-image { filter: none !important; }
  html { text-shadow: 0px 0px 0px !important; }
  ::-webkit-scrollbar { background-color: rgb(32, 35, 36); color: rgb(171, 164, 153); }
  ::-webkit-scrollbar-thumb { background-color: rgb(69, 74, 77); }
  ::-webkit-scrollbar-thumb:hover { background-color: rgb(87, 94, 98); }
  ::-webkit-scrollbar-thumb:active { background-color: rgb(72, 78, 81); }
  ::-webkit-scrollbar-corner { background-color: rgb(24, 26, 27); }
  html { background: rgb(255, 255, 255) !important; }
}

@media print {
  .no-print { display: none !important; }
}]])
      end
     else
      if content:find("#dark%-mode%-filter") then
        replace_string(filedir, 'url%("#dark%-mode%-filter"%)', [[@media screen {
  img, .sr-backdrop { filter: url("#dark-mode-filter-a") !important;
}]])
      end
    end
  end

  local mynum = string.match(xxx, "(%d+)[^/]*$")
  if xxx:match("article")
    mytype="文章"
   elseif xxx:match("pin")
    mytype="想法"
   elseif xxx:match("video")
    mytype="视频"
    activity.finish()
    activity.newActivity("column",{mynum,mytype})
    return
  end
  activity.finish()
  activity.newActivity("column",{mynum,mytype,true,myuri,title,author})
  return
end

-- 打开 mhtml 文件
local file = io.open (filedir, "r+")
-- 读取文件内容
local content = file:read ("*a")

if content:find("body, body %*")==nil and content:find("oribody, oribody %*")==nil then
  -- 查找 html[data-android] 的位置
  local s, e = string.find (content, "html%[data%-android%]")
  -- 如果找到了
  if s then
    -- 定义要追加的样式代码
    style = "body, body * { background-color: rgb(25, 25, 25) !important; color: rgb(204, 204, 204) !important; }\n\n"
    -- 在 html[data-android] 前面插入样式代码
    content = content:sub (1, s - 1) .. style .. content:sub (s)
    -- 回到文件开头
    file:seek ("set")
    -- 写入修改后的内容
    file:write (content)
  end
end
-- 关闭文件
file:close ()
-- 打开 html 文件
local file = io.open (filedir, "r+")
-- 读取文件内容
local content = file:read ("*a")
if content:find("body, body *") then
  if 全局主题值~="Night" then
    替换文件字符串(filedir,"body, body %*","oribody, oribody *")
  end
 elseif content:find("oribody, oribody *") then
  if 全局主题值=="Night" then
    替换文件字符串(filedir,"oribody, oribody %*","body, body *")
  end
end

file:close()

--在这里加载url会没载入webview设置 放到最后加载
--webview.loadUrl(myuri)

if this.getSharedData("关闭硬件加速")=="true" then
  webview.setLayerType(View.LAYER_TYPE_SOFTWARE, nil)
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

--new 0.1102 精准测量高度
task(1,function()
  local location,底栏高度,悬浮按钮高度
  location = int[2];
  ll.getLocationOnScreen(location)
  底栏高度=location[1]
  location = int[2];
  mark.getLocationOnScreen(location)
  悬浮按钮高度=location[1]
  悬浮按钮高度差=底栏高度-悬浮按钮高度
end)


local function 设置滑动跟随(t)
  t.onScrollChange=function(vew,x,y,lx,ly)
    if y<=2 then--解决滑到顶了还是没有到顶的bug
      llb.y=0
      mark_parent.y=0
      return
    end
    if t.canScrollVertically(1)~=true then--解决滑倒底了还是没到底的bug new 0.1102
      llb.y=dp2px(56)+悬浮按钮高度差
      mark_parent.y=dp2px(56)+悬浮按钮高度差
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
      if llb.y<=dp2px(56)+悬浮按钮高度差 then --精准测量高度差 防止无法隐藏全部的bug new 0.1102
        --if llb.y<=dp2px(56)+dp2px(26) then --没到底就向底移动(上滑)，+26dp是悬浮球高
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
  end,
  onPageFinished=function(view,url,favicon)
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

webview.loadUrl(myuri)

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

      {
        src=图标("cloud"),text="使用网络打开",onClick=function()
          local questionid=xxx:match[[question_id="(.-)"]]
          local answerid=xxx:match[[answer_id="(.-)"]]
          activity.newActivity("answer",{questionid,answerid})
        end
      },

    }
  })
end)

if activity.getSharedData("异常提示0.02")==nil
  AlertDialog.Builder(this)
  .setTitle("小提示")
  .setCancelable(false)
  .setMessage("如果部分回答显示不完整 可以点击右上角「关闭硬件加速」 关闭动画会卡顿 如果没有问题请不要点击 出现其他异常情况都可以尝试关闭 另外 可以在设置中一键关闭之后所有的硬件加速")
  .setPositiveButton("我知道了",{onClick=function() activity.setSharedData("异常提示0.02","true") end})
  .show()
end