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
import "com.google.android.material.progressindicator.LinearProgressIndicator"
import "androidx.core.view.ViewCompat"
问题id,回答id=...

--new 0.46 删除滑动监听

local MaterialContainerTransform = luajava.bindClass "com.google.android.material.transition.MaterialContainerTransform"
if inSekai then
  --[[if fn[#fn][1]=="answer" then
activity.getSupportFragmentManager().popBackStack()
    table.remove(fn,#fn)
end]]
  local t = activity.getSupportFragmentManager().beginTransaction()
  t.setCustomAnimations(
  android.R.anim.slide_in_left,
  android.R.anim.slide_out_right,
  android.R.anim.slide_in_left,
  android.R.anim.slide_out_right)
  --t.remove(activity.getSupportFragmentManager().findFragmentByTag("answer"))
  t.add(f2.getId(),LuaFragment(loadlayout("layout/answer")),"answer")
  t.addToBackStack(nil)
  t.commit()
  table.insert(fn,{"answer",2})
 else
  activity.setContentView(loadlayout("layout/answer"))
end



--activity.setContentView(loadlayout("layout/answer"))
设置toolbar(toolbar)

edgeToedge(mainLay,底栏,function()
  pg.setPadding(
  pg.getPaddingLeft(),
  pg.getPaddingTop(),
  pg.getPaddingRight(),
  dp2px(56)+导航栏高度);
end)

local recyclerViewField = ViewPager2.getDeclaredField("mRecyclerView");
recyclerViewField.setAccessible(true);
local recyclerView = recyclerViewField.get(pg);
local touchSlopField = RecyclerView.getDeclaredField("mTouchSlop");
touchSlopField.setAccessible(true);
local touchSlop = touchSlopField.get(recyclerView);
touchSlopField.set(recyclerView, int(touchSlop*2.5));--通过获取原有的最小滑动距离 *n来增加此值

--解决快速滑动出现的bug 点击停止滑动
local AppBarLayoutBehavior=luajava.bindClass "com.hydrogen.AppBarLayoutBehavior"
appbar.LayoutParams.behavior=AppBarLayoutBehavior(this,nil)

波纹({fh,_more,mark,comment,thank,voteup},"圆主题")
波纹({all_root},"方自适应")

import "model.answer"

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


comment.onClick=function()
  local pos=pg.getCurrentItem()
  local mview=数据表[pg.adapter.getItem(pos).id]
  local 回答id=mview.data.id
  if 回答id==nil then
    return 提示("加载中")
  end
  local 保存路径=内置存储文件("Download/".._title.Text.."/"..username.Text)
  ViewCompat.setTransitionName(comment,"t")
  newActivity("comment",{回答id,"answers",保存路径})
end;


回答容器=answer:new(回答id)

local 点赞状态={}
local 感谢状态={}

import "androidx.core.content.ContextCompat"
local 滑动配置保存路径=tostring(ContextCompat.getDataDir(activity)).."/回答页滑动配置.conf"

function 获取回答滑动位置配置()
  local 配置文件内容=读取文件(滑动配置保存路径)
  local 配置={}
  pcall(function()
    配置=luajson.decode(配置文件内容)
  end)
  return 配置
end

function 设置回答滑动位置配置(isremove)
  local pos=pg.getCurrentItem()
  local mview=数据表[pg.adapter.getItem(pos).id]
  local 回答id=mview.data.id

  local content
  if isremove==nil then
    local scroll=mview.ids.content.getScrollY()
    local height=userinfo.height
    content=tostring(scroll-height)
  end

  local 配置=获取回答滑动位置配置()
  配置[tostring(回答id)]=content
  local 配置字符串=luajson.encode(配置)

  --为空就写入为"" 更好看一点
  if 配置字符串=="[]" then
    配置字符串=""
  end

  写入文件(滑动配置保存路径,配置字符串)
  return content
end

function 清空回答滑动位置配置()
  写入文件(滑动配置保存路径,"")
end

mripple.onClick=function()
  local pos=pg.getCurrentItem()
  local mview=数据表[pg.adapter.getItem(pos).id]
  local id=mview.data.author.id
  if id~="0" then
    newActivity("people",{id})
   else
    提示("回答作者已设置匿名")
  end
end

波纹({mripple},"圆自适应")

if activity.getSharedData("回答单页模式")=="true" then
  pg.setUserInputEnabled(false);
end

local detector=GestureDetector(this,{a=lambda _:_})
local isDoubleTap=false
local timeOut=200
detector.setOnDoubleTapListener {
  onDoubleTap=function()
    local pos=pg.getCurrentItem()
    local mview=数据表[pg.adapter.getItem(pos).id]
    mview.ids.content.scrollTo(0, 0)
    isDoubleTap=true
    task(timeOut,function()isDoubleTap=false end)
  end
}

all_root.onClick=function(v)
  if not isDoubleTap then
    task(timeOut,function()
      if not isDoubleTap then
        if 问题id==nil or 问题id=="null" then
          return 提示("加载中")
        end
        newActivity("question",{问题id})
      end
    end)
  end
end

all_root.onLongClick=function()
  local pos=pg.getCurrentItem()
  local mview=数据表[pg.adapter.getItem(pos).id]
  if mview.load~=true
    return 提示("请等待加载完毕进行该操作")
  end

  三按钮对话框("保存","是否保存当前滑动位置?","确认","取消","删除",
  --点击第一个按钮的事件
  function(an)
    设置回答滑动位置配置()
    提示("已保存")
    an.dismiss()
  end,
  --点击第二个按钮事件
  function(an)
    an.dismiss()
  end,
  --点击第三个按钮事件
  function(an)
    设置回答滑动位置配置(true)
    提示("已删除")
    an.dismiss()
  end)
end

all_root.onTouch=function(v,e)
  return detector.onTouchEvent(e)
end

function 数据添加(t,b)

  设置滑动跟随(t.content)
  local ua=getua(t.content)
  t.content.getSettings().setUserAgentString(ua)

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
  --设置 应用 缓存目录
  --开启 应用缓存 功能
  .setSupportZoom(true)
  .setLoadWithOverviewMode(true)
  .setBuiltInZoomControls(true)

  if activity.getSharedData("禁用缓存")=="true" then
    t.content
    .getSettings()
    .setAppCacheEnabled(false)
    .setCacheMode(WebSettings.LOAD_NO_CACHE)
    --关闭 DOM 存储功能
    .setDomStorageEnabled(false)
    --关闭 数据库 存储功能
    .setDatabaseEnabled(false)
   else
    t.content
    .getSettings()
    .setAppCacheEnabled(true)
    .setCacheMode(WebSettings.LOAD_DEFAULT)
    --开启 DOM 存储功能
    .setDomStorageEnabled(true)
    --开启 数据库 存储功能
    .setDatabaseEnabled(true)
  end

  if 无图模式 then
    t.content.getSettings().setBlockNetworkImage(true)
  end

  t.content.BackgroundColor=转0x("#00000000",true);
  t.content.setDownloadListener({
    onDownloadStart=function(链接, UA, 相关信息, 类型, 大小)
      webview下载文件(链接, UA, 相关信息, 类型, 大小)
  end})


  local 回答id=(b.id)
  点赞状态[回答id]=(b.relationship.voting==1 and {true} or {false})[1]
  感谢状态[回答id]=b.relationship.is_thanked

  if 点赞状态[回答id] then
    vote_icon.setImageBitmap(loadbitmap(图标("vote_up")))
    vote_count.setTextColor(转0x(primaryc))
   else
    vote_icon.setImageBitmap(loadbitmap(图标("vote_up_outline")))
    vote_count.setTextColor(转0x(stextc))
  end

  if 感谢状态[回答id] then
    thanks_icon.setImageBitmap(loadbitmap(图标("favorite")))
    thanks_count.setTextColor(转0x(primaryc))
   else
    thanks_icon.setImageBitmap(loadbitmap(图标("favorite_outline")))
    thanks_count.setTextColor(转0x(stextc))
  end

  if not(已记录) then
    初始化历史记录数据(true)
    保存历史记录("回答分割"..回答id,b.question.title,b.excerpt)
    已记录=true
  end


  t.content.removeView(t.content.getChildAt(0))
  t.content.setWebViewClient{
    shouldOverrideUrlLoading=function(view,url)
      if url~=("https://www.zhihu.com/appview/answer/"..(b.id).."") then
        检查链接(url)
        view.stopLoading()
        view.goBack()
      end
    end,
    onPageStarted=function(view,url,favicon)
      加载js(view,获取js("native"))
      网页字体设置(view)
      t.content.setVisibility(8)
      if t.progress~=nil then
        t.progress.setVisibility(0)
      end
      等待doc(view)
      加载js(view,获取js("answer_pages"))
      view.evaluateJavascript(获取js("imgload"),{onReceiveValue=function(b)end})
      加载js(view,获取js("imgplus"))
      加载js(view,获取js("mdcopy"))
    end,
    onPageFinished=function(view,url,favicon)
      t.content.setVisibility(0)
      if t.progress~=nil then
        t.progress.getParent().removeView(t.progress)
        t.progress=nil
      end
--加载js(view,获取js("eruda"))
      屏蔽元素(view,{".AnswerReward",".AppViewRecommendedReading"})

      task(1000,function()
        加载js(view,获取js("answer_code"))
        local 保存滑动位置=获取回答滑动位置配置()[tostring(b.id)] or 0
        if tonumber(保存滑动位置)>0 then
          local 实际滑动位置=保存滑动位置+userinfo.height
          if 实际滑动位置>0 then
            appbar.setExpanded(false);
          end
          t.content.scrollTo(0,实际滑动位置)
          提示("已恢复到上次滑动位置")
        end
      end)

      if this.getSharedData("代码块自动换行")=="true" then
        加载js(t.content,'document.querySelectorAll(".ztext pre").forEach(p => { p.style.whiteSpace = "pre-wrap"; p.style.wordWrap = "break-word"; });')
      end

      if b.content:find("video%-box") then
        if not(getLogin()) then
          提示("该回答含有视频 不登录可能无法显示视频 建议登录")
        end

        加载js(view,"document.cookie='"..获取Cookie("https://www.zhihu.com/").."'")
        加载js(view,获取js("videoload"))

       elseif b.attachment then
        xpcall(function()
          视频链接=b.attachment.video.video_info.playlist.sd.url
          end,function()
          视频链接=b.attachment.video.video_info.playlist.ld.url
          end,function()
          视频链接=b.attachment.video.video_info.playlist.hd.url
        end)
        if 视频链接 then
          加载js(view,'var myvideourl="'..视频链接..'"')
          加载js(view,获取js('videoanswer'))
         else
          AlertDialog.Builder(this)
          .setTitle("提示")
          .setMessage("该回答为视频回答 不登录无法显示视频 如想查看本视频回答中的视频请登录")
          .setCancelable(false)
          .setPositiveButton("我知道了",nil)
          .show()
        end
      end
    end,
    onLoadResource=function(view,url)
    end,
    shouldInterceptRequest=拦截加载}

  local v,s;

  local z=JsInterface{
    execute=function(b)
      if b~=nil then
        --newActivity传入字符串过大会造成闪退 暂时通过setSharedData解决
        this.setSharedData("imagedata",b)
        activity.newActivity("image")
      end
    end
  }

  t.content.addJSInterface(z,"androlua")

  webview查找文字监听(t.content)

  local webview=t.content
  t.content.setWebChromeClient(LuaWebChrome(LuaWebChrome.IWebChrine{
    onProgressChanged=function(view,url,favicon)
      if 全局主题值=="Night" then
        夜间模式回答页(view)
      end
    end,
    onConsoleMessage=function(consoleMessage)
      --打印控制台信息
      if consoleMessage.message():find("开始滑动") then
        webview.requestDisallowInterceptTouchEvent(true)
        pg.setUserInputEnabled(false);
       elseif consoleMessage.message():find("结束滑动") then
        webview.requestDisallowInterceptTouchEvent(false)
        pg.setUserInputEnabled(true);
       elseif consoleMessage.message():find("打印") then
        print(consoleMessage.message())
       elseif consoleMessage.message():find("toast分割") then
        local text=tostring(consoleMessage.message()):match("toast分割(.+)")
        提示(text)
      end
    end,

    onShowCustomView=function(view,url)
      全屏模式=true
      web_video_view=view
      savedScrollY= t.content.getScrollY()
      t.content.setVisibility(8)
      activity.getDecorView().addView(web_video_view)
      --      this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_LANDSCAPE)
      全屏()
    end,
    onHideCustomView=function(view,url)
      全屏模式=false
      t.content.setVisibility(0)
      activity.getDecorView().removeView(web_video_view)
      --      this.setRequestedOrientation(ActivityInfo.SCREEN_ORIENTATION_PORTRAIT);
      取消全屏()
      Handler().postDelayed(Runnable({
        run=function()
          t.content.scrollTo(0, savedScrollY);
        end,
      }),200)
    end,
  }))


  t.content.loadUrl("https://www.zhihu.com/appview/answer/"..(b.id).."")
  t.content.setVisibility(0)


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
        pg.scrollTo(x,0)
      end
    }.start()
    isshow=true
    activity.setSharedData("test",tonumber(activity.getSharedData("test") or 0)+1)
  end
end

function 初始化页(mviews)
  if mviews.load==true then
    vote_count.Text=(mviews.data.voteup_count)..""
    thanks_count.Text=(mviews.data.thanks_count)..""
    favlists_count.Text=(mviews.data.favlists_count)..""
    comment.onLongClick=function()
      提示((mviews.data.comment_count).."条评论")
      return true
    end
    loadglide(usericon,mviews.data.author.avatar_url)
    if mviews.data.author.headline=="" then
      userheadline.Text="Ta还没有签名哦~"
     else
      userheadline.Text=mviews.data.author.headline
    end
    username.Text=mviews.data.author.name
    local 回答id=mviews.data.id

    if 点赞状态[回答id] then
      vote_icon.setImageBitmap(loadbitmap(图标("vote_up")))
      vote_count.setTextColor(转0x(primaryc))
     else
      vote_icon.setImageBitmap(loadbitmap(图标("vote_up_outline")))
      vote_count.setTextColor(转0x(stextc))
    end

    if 感谢状态[回答id] then
      thanks_icon.setImageBitmap(loadbitmap(图标("favorite")))
      thanks_count.setTextColor(转0x(primaryc))
     else
      thanks_icon.setImageBitmap(loadbitmap(图标("favorite_outline")))
      thanks_count.setTextColor(转0x(stextc))
    end

  end
end

function 加载页(mviews,isleftadd)
  if mviews==nil then
    return Error("错误 找不到views")
  end

  if not(mviews.load) then --判断是否加载过没有
    回答容器:getOneData(function(cb,r)--获取1条数据
      if cb==false then
        mviews.load=nil
        提示("已经没有更多数据了")
        pg.adapter.remove(pos)
        pg.setCurrentItem(pos-1,false)
        重表状态=true
       else
        pcall(function()
          if table.find(查重表,cb.id) then
            mviews.load=nil
            重表状态=true
           else
            重表状态=false
          end
          查重表[cb.id]=cb.id
        end)

        mviews.data={
          voteup_count=cb.voteup_count,
          thanks_count=cb.thanks_count,
          favlists_count=cb.favlists_count,
          comment_count=cb.comment_count,
          id=cb.id,
          author={
            avatar_url=cb.author.avatar_url,
            headline=cb.author.headline,
            name=cb.author.name,
            id=cb.author.id
          }
        }

        数据添加(mviews.ids,cb) --添加数据

        mviews.load=true

        初始化页(mviews)

      end
    end,isleftadd)
  end
end

function 首次设置()
  defer local question_base=answer
  :getinfo(回答id,function(tab)
    all_answer.Text="点击查看全部"..(tab.answer_count).."个回答 >"
    问题id=tab.id
    if tab.answer_count==1 then
      回答容器.isleft=true
    end
    _title.Text=tab.title
  end)


  for i=1,3 do
    pg.setCurrentItem(1,false)--设置正确的列
  end
end

isshow=false

pg.adapter=BaseViewPage2Adapter(this)

id表={}
数据表={}
查重表={}
上次page=0


--首先先加入多个view

--加入两个view 防止无法直接左滑

for i=1,2 do
  id表[pg.adapter.getItemCount()+1]={}
  local 加入view=loadlayout("layout/answer_list",id表[pg.adapter.getItemCount()+1])
  pg.adapter.add(加入view)
  数据表[加入view.id]={
    data={},
    ids=id表[pg.adapter.getItemCount()],
  }
end

pg.registerOnPageChangeCallback(OnPageChangeCallback{--除了名字变，其他和PageView差不多
  onPageScrolled=function(pos,positionOffset,positionOffsetPixels)
    if positionOffsetPixels==0 then
      appbar.setExpanded(true);
      --判断页面是否在开头or结尾 是否需要添加
      if pg.adapter.getItemCount()==pos+1 then
        if 回答容器.isright then
          pg.setCurrentItem(pos-1,false)
          return 提示("前面没有内容啦")
        end
        id表[pg.adapter.getItemCount()+1]={}
        local 加入view=loadlayout("layout/answer_list",id表[pg.adapter.getItemCount()+1])
        pg.adapter.add(加入view)
        数据表[加入view.id]={
          data={},
          ids=id表[pg.adapter.getItemCount()],
        }
        local mviews=数据表[pg.adapter.getItem(pos).id]
        加载页(mviews)
       elseif pos==0 and pg.adapter.getItemCount()>=0
        if 回答容器.isleft then
          pg.setCurrentItem(1,false)
          return 提示("已经到最左了")
        end
        id表[pg.adapter.getItemCount()+1]={}
        local 加入view=loadlayout("layout/answer_list",id表[pg.adapter.getItemCount()+1])
        pg.adapter.insert(加入view,0)
        数据表[加入view.id]={
          data={},
          ids=id表[pg.adapter.getItemCount()],
        }
        local pos=pg.getCurrentItem()+1
        local mviews=数据表[pg.adapter.getItem(pos).id]
        加载页(mviews,true)
        --判断是否加载过
       elseif pg.adapter.getItemCount()>=0 then
        local pos=pg.getCurrentItem()
        local mviews=数据表[pg.adapter.getItem(pos).id]
        if mviews.load==true then
          回答容器.getid=mviews.data.id
          初始化页(mviews)
        end
      end
    end
  end,
  onPageScrollStateChanged=function (state)
  end
})


首次设置()

ll.background=answerDrawable

function onDestroy()
  for i=1,#数据表 do
    数据表[i].ids.content.destroy()
    System.gc()
  end
end

if this.getSharedData("禁用缓存")=="true" then
  function onStop()
    for i=1,#数据表 do
      数据表[i].ids.content.clearCache(true)
      数据表[i].ids.content.clearFormData()
      数据表[i].ids.content.clearHistory()
      System.gc()
    end
  end
end

local voteup_data={}

voteup.onClick=function()
  local pos=pg.getCurrentItem()
  local mview=数据表[pg.adapter.getItem(pos).id]
  local 回答id=mview.data.id
  if 回答id==nil then
    return 提示("加载中")
  end
  if not voteup_data[回答id] then
    local addvoteup,removevoteup
    if 点赞状态[回答id] then
      addvoteup=tostring(tointeger(vote_count.text))
      removevoteup=tostring(tointeger(vote_count.text-1))
     else
      addvoteup=tostring(tointeger(vote_count.text+1))
      removevoteup=tostring(tointeger(vote_count.text))
    end
    voteup_data[回答id]={
      [1]=addvoteup,
      [2]=removevoteup
    }
  end
  if not 点赞状态[回答id] then
    zHttp.post("https://api.zhihu.com/answers/"..回答id.."/voters",'{"type":"up"}',posthead,function(code,content)
      if code==200 then
        提示("点赞成功")
        点赞状态[回答id]=true
        local data=luajson.decode(content)
        vote_count.text=voteup_data[回答id][1]
        mview.data.voteup_count=vote_count.text
        vote_icon.setImageBitmap(loadbitmap(图标("vote_up")))
        vote_count.setTextColor(转0x(primaryc))
       elseif code==401 then
        提示("请登录后使用本功能")
      end
    end)
   else
    zHttp.post("https://api.zhihu.com/answers/"..回答id.."/voters",'{"type":"neutral"}',posthead,function(code,content)
      if code==200 then
        提示("取消点赞成功")
        点赞状态[回答id]=false
        local data=luajson.decode(content)
        vote_count.text=voteup_data[回答id][2]
        mview.data.voteup_count=vote_count.text
        vote_icon.setImageBitmap(loadbitmap(图标("vote_up_outline")))
        vote_count.setTextColor(转0x(stextc))
       elseif code==401 then
        提示("请登录后使用本功能")
      end
    end)
  end
end

local thank_data={}

thank.onClick=function()
  local pos=pg.getCurrentItem()
  local mview=数据表[pg.adapter.getItem(pos).id]
  local 回答id=mview.data.id
  if 回答id==nil then
    return 提示("加载中")
  end
  if not thank_data[回答id] then
    local addthank,removethank
    if 感谢状态[回答id] then
      addthank=tostring(tointeger(thanks_count.text))
      removethank=tostring(tointeger(thanks_count.text-1))
     else
      addthank=tostring(tointeger(thanks_count.text+1))
      removethank=tostring(tointeger(thanks_count.text))
    end
    thank_data[回答id]={
      [1]=addthank,
      [2]=removethank
    }
  end
  if not 感谢状态[回答id] then
    zHttp.post("https://www.zhihu.com/api/v4/zreaction",'{"content_type":"answers","content_id":"'..回答id..'","action_type":"emojis","action_value":"red_heart"}',posthead,function(code,content)
      if code==200 then
        提示("表达感谢成功")
        感谢状态[回答id]=true
        local data=luajson.decode(content)
        thanks_count.text=thank_data[回答id][1]
        mview.data.thanks_count=thanks_count.text
        thanks_icon.setImageBitmap(loadbitmap(图标("favorite")))
        thanks_count.setTextColor(转0x(primaryc))
       elseif code==401 then
        提示("请登录后使用本功能")
      end
    end)
   else
    zHttp.delete("https://www.zhihu.com/api/v4/zreaction?content_type=answers&content_id="..回答id.."&action_type=emojis&action_value=",posthead,function(code,content)
      if code==200 then
        提示("取消感谢成功")
        感谢状态[回答id]=false
        local data=luajson.decode(content)
        thanks_count.text=thank_data[回答id][2]
        mview.data.thanks_count=thanks_count.text
        thanks_icon.setImageBitmap(loadbitmap(图标("favorite_outline")))
        thanks_count.setTextColor(转0x(stextc))
       elseif code==401 then
        提示("请登录后使用本功能")
      end
    end)
  end
end

local click=0

mark.onClick=function()
  local url=数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.content.getUrl()
  加入收藏夹(url:match("answer/(.+)"),"answer")
end

mark.onLongClick=function()
  local url=数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.content.getUrl()
  加入默认收藏夹(url:match("answer/(.+)"),"answer")
  return true
end

function onKeyDown(code,event)
  if this.getSharedData("音量键选择tab")~="true" or 全屏模式==true then
    return false
  end
  if code==KeyEvent.KEYCODE_VOLUME_UP then
    return true;
   elseif code== KeyEvent.KEYCODE_VOLUME_DOWN then
    return true;
  end

end

function onKeyUp(code,event)
  if this.getSharedData("音量键选择tab")~="true" or 全屏模式==true then
    return false
  end
  --上键上一页 下键下一页
  if code==KeyEvent.KEYCODE_VOLUME_UP then
    pg.setCurrentItem(pg.getCurrentItem()-1)
    return true;
   elseif code== KeyEvent.KEYCODE_VOLUME_DOWN then
    pg.setCurrentItem(pg.getCurrentItem()+1)
    return true;
  end
end

task(1,function()
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
          local format="【回答】【%s】%s: %s"
          分享文本(string.format(format,_title.Text,username.Text,"https://www.zhihu.com/question/"..问题id.."/answer/"..url:match("answer/(.+)")))
        end,
        onLongClick=function()
          local url=数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.content.getUrl()
          if url==nil then
            提示("加载中")
            return
          end
          local format="【回答】【%s】%s: %s"
          分享文本(string.format(format,_title.Text,username.Text,"https://www.zhihu.com/question/"..问题id.."/answer/"..url:match("answer/(.+)")),true)
        end
      },

      {
        src=图标("chat_bubble"),text="查看评论",onClick=function()

          local pos=pg.getCurrentItem()
          local mview=数据表[pg.adapter.getItem(pos).id]
          local 回答id=mview.data.id
          if 回答id==nil then
            return 提示("加载中")
          end

          local 保存路径=内置存储文件("Download/".._title.Text.."/"..username.Text)
          newActivity("comment",{回答id,"answers",保存路径})

        end
      },
      {
        src=图标("get_app"),text="保存到本地",onClick=function()

          local result=get_write_permissions()
          if result~=true then
            return false
          end

          local pgnum=pg.adapter.getItem(pg.getCurrentItem()).id
          local pgids=数据表[pgnum].ids

          local 保存路径=内置存储文件("Download/".._title.Text.."/"..username.Text)
          写入内容='question_id="'..问题id..'"\n'
          写入内容=写入内容..'answer_id="'..回答id..'"\n'
          写入内容=写入内容..'thanks_count="'..thanks_count.Text..'"\n'
          写入内容=写入内容..'vote_count="'..vote_count.Text..'"\n'
          写入内容=写入内容..'favlists_count="'..favlists_count.Text..'"\n'
          写入内容=写入内容..'author="'..username.Text..'"\n'
          写入内容=写入内容..'headline="'..userheadline.Text..'"\n'
          写入文件(保存路径.."/detail.txt",写入内容)
          this.newActivity("saveweb",{pgids.content.getUrl(),保存路径,写入内容})
        end,
        onLongClick=function()
          local pgnum=pg.adapter.getItem(pg.getCurrentItem()).id
          local pgids=数据表[pgnum].ids
          local content=pgids.content

          content.evaluateJavascript('getmd()',{onReceiveValue=function(b)
              提示("请选择一个保存位置")
              CREATE_FILE_REQUEST_CODE=9999
              import "android.content.Intent"
              intent = Intent(Intent.ACTION_CREATE_DOCUMENT);
              intent.addCategory(Intent.CATEGORY_OPENABLE);
              intent.setType("application/octet-stream");
              intent.putExtra(Intent.EXTRA_TITLE, _title.Text.."_"..username.Text..".md");
              this.startActivityForResult(intent, CREATE_FILE_REQUEST_CODE);
              saf_writeText=b
          end})
        end
      },

      {
        src=图标("book"),text="加入收藏夹",onClick=function()
          local url=数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.content.getUrl()
          加入收藏夹(url:match("answer/(.+)"),"answer")
        end,
        onLongClick=function()
          local url=数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.content.getUrl()
          加入默认收藏夹(url:match("answer/(.+)"),"answer")
        end
      },

      {
        src=图标("book"),text="举报",onClick=function()

          local pos=pg.getCurrentItem()
          local mview=数据表[pg.adapter.getItem(pos).id]
          local 回答id=mview.data.id
          if 回答id==nil then
            return 提示("加载中")
          end

          local url="https://www.zhihu.com/report?id="..回答id.."&type=answer"
          newActivity("browser",{url.."&source=android&ab_signature=","举报"})
        end
      },

      {
        src=图标("search"),text="在网页查找内容",onClick=function()
          local content=数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.content
          webview查找文字(content)
        end
      },

    }
  })
end)

if activity.getSharedData("回答提示0.04")==nil
  AlertDialog.Builder(this)
  .setTitle("小提示")
  .setCancelable(false)
  .setMessage("你可双击标题回到顶部 长按标题来保存滑动位置(保存后下次打开会自动滑动到指定位置)")
  .setPositiveButton("我知道了",{onClick=function() activity.setSharedData("回答提示0.04","true") end})
  .show()
end


function onActivityResult(a,b,c)
  if b==100 then
    activity.recreate()
  end
end

if this.getSharedData("显示虚拟滑动按键")=="true" then
  bottom_parent.Visibility=0
  up_button.onClick=function()
    local pos=pg.getCurrentItem()
    local mview=数据表[pg.adapter.getItem(pos).id]
    local id表=mview.ids
    local content=id表.content
    content.scrollBy(0, -content.height+dp2px(40));
    if content.getScrollY()<=0 then
      appbar.setExpanded(true,false);
    end
  end
  down_button.onClick=function()
    local pos=pg.getCurrentItem()
    local mview=数据表[pg.adapter.getItem(pos).id]
    local id表=mview.ids
    local content=id表.content
    content.scrollBy(0, (content.height-dp2px(40)));
    appbar.setExpanded(false,false);
  end
end