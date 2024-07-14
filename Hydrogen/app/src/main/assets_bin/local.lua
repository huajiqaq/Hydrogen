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

filedir=内置存储文件("Download/"..title.."/"..author.."/mht.mht")
xxx=读取文件(内置存储文件("Download/"..title.."/"..author.."/detail.txt"))

--new 0.5184 引入mhtml2html解析mhtml 去除大量mhtml替换逻辑
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
  activity.newActivity("column",{mynum,mytype,true,filedir,title,author})
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

mripple.onClick=function()
  提示("请点击右上角「使用网络打开」打开原回答页后查看")
end
波纹({mripple},"圆自适应")

task(1,function()
  顶栏高度=toolbar.height
end)



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

mark.onClick=function()
  local 保存路径=内置存储文件("Download/"..title:gsub("/","or").."/"..username.text)
  if getDirSize(保存路径.."/".."fold/")==0 then
    提示("你还没有收藏评论")
   else
    activity.newActivity("comment",{nil,"local",title,username.text})
  end
end

波纹({mark},"圆主题")

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
    if b=="getmhtml" then
      return 读取文件(filedir)
    end
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
    if 全局主题值=="Day" then
    end
  end,
  onLoadResource=function(view,url)
  end,
}

t.content.setWebChromeClient(LuaWebChrome(LuaWebChrome.IWebChrine{
  onProgressChanged=function(view,url,favicon)
end}))


myuri = Uri.fromFile(File(this.getLuaDir().."/mhtml2html.html")).toString();

t.content.loadUrl(myuri)
t.content.setVisibility(0)

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