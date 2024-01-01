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
问题id,回答id,问题对象,是否记录历史记录,在线页数=...

local 是否加载滑动跟随=this.getSharedData("回答底栏设置滑动跟随")

if 是否加载滑动跟随~="true" then
  activity.setContentView(loadlayout("layout/answer_nomove"))
  function 设置滑动跟随()
    return true
  end
  function monPageScrollStateChanged(state)
  end
 else
  activity.setContentView(loadlayout("layout/answer"))

  --new 0.1102 精准测量高度
  task(1,function()
    local location,底栏坐标,悬浮按钮坐标
    location = int[2];
    ll.getLocationOnScreen(location)
    底栏坐标=location[1]
    location = int[2];
    comment.getLocationOnScreen(location)
    悬浮按钮坐标=location[1]
    底栏高度=ll.height
    悬浮按钮高度差=底栏坐标-悬浮按钮坐标
  end)


  function 设置滑动跟随(t)
    t.onScrollChange=function(view,x,y,lx,ly)
      if y<=2 then--解决滑到顶了还是没有到顶的bug
        llb.y=0
        comment_parent.y=0
        return
      end
      if t.canScrollVertically(1)~=true then--解决滑倒底了还是没到底的bug new 0.1102
        llb.y=底栏高度+悬浮按钮高度差
        comment_parent.y=底栏高度+悬浮按钮高度差
      end
      if ly>y then --上次滑动y大于这次y就是向上滑
        if llb.y<=0 or math.abs(y-ly)>=底栏高度 then --这个or为了防止快速大滑动 new 0.1103更改 精准测量
          --if llb.y<=0 or math.abs(y-ly)>=dp2px(56) then --这个or为了防止快速大滑动
          llb.y=0
          comment_parent.y=0
         else
          llb.y=llb.y-math.abs(y-ly)
          comment_parent.y=comment_parent.y-math.abs(y-ly)
        end
       else
        if llb.y<=底栏高度+悬浮按钮高度差 then --精准测量高度差 防止无法隐藏全部的bug new 0.1102
          --if llb.y<=dp2px(56)+dp2px(26) then --没到底就向底移动(上滑)，+26dp是悬浮球高
          llb.y=llb.y+math.abs(y-ly)
          comment_parent.y=comment_parent.y+math.abs(y-ly)
        end
      end
    end
  end

  function monPageScrollStateChanged(state)
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

end

波纹({fh,_more,mark,comment,thank,voteup},"圆主题")
波纹({all_root},"方自适应")

import "model.answer"

comment.onClick=function()
  xpcall(function()
    local pos=pg.getCurrentItem()
    local mview=数据表[pg.adapter.getItem(pos).id]
    local 回答id=mview.data.id
    if 回答id==nil then
      return 提示("加载中")
    end
    activity.newActivity("comment",{(回答id),"answers",_title.Text,mview.ids.username.Text})
    end,function()
    提示("请稍等")
  end)
end;


回答容器=answer:new(问题id)

if 回答id then
  回答容器.getid=回答id
end

local 点赞状态={}
local 感谢状态={}

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
          if 问题id==nil or 问题id=="null" then
            return 提示("加载中")
          end
          activity.newActivity("question",{问题id})
        end
      end)
    end
  end

  all_root.onTouch=function(v,e)
    return detector.onTouchEvent(e)
  end

  t.content.setHorizontalScrollBarEnabled(false);
  t.content.setVerticalScrollBarEnabled(false);


  if activity.getSharedData("标题简略化")~="true" then
    _title.Text=b.question.title:gsub("/",[[ 或 ]])
   else
    _title.Text="回答"
  end


  if b.author.name=="知乎用户" then
    zHttp.get("https://api.zhihu.com/people/"..b.author.id.."/profile?profile_new_version=1",head,function(code,content)
      if code==200 then
        local data=luajson.decode(content)
        t.userheadline.Text=data.headline
        t.username.Text=data.name
        loadglide(t.usericon,data.avatar_url)
      end
    end)
   else

    loadglide(t.usericon,b.author.avatar_url)

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

  波纹({t.ripple},"圆自适应")

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

  t.content.setDownloadListener({
    onDownloadStart=function(链接, UA, 相关信息, 类型, 大小)
      webview下载文件(链接, UA, 相关信息, 类型, 大小)
  end})

  local 回答id=(b.id)
  点赞状态[回答id]=(b.relationship.voting==1 and {true} or {false})[1]
  感谢状态[回答id]=b.relationship.is_thanked

  if 点赞状态[回答id] then
    vote_count.setTextColor(转0x(primaryc))
   else
    vote_count.setTextColor(转0x(stextc))
  end

  if 感谢状态[回答id] then
    thanks_count.setTextColor(转0x(primaryc))
   else
    thanks_count.setTextColor(转0x(stextc))
  end

  if 是否记录历史记录 and not(已记录) then
    初始化历史记录数据(true)
    保存历史记录(_title.Text,问题id.."分割"..回答id,50)
    已记录=true
  end

  if this.getSharedData("关闭硬件加速")=="true" then
    t.msrcroll.setLayerType(View.LAYER_TYPE_SOFTWARE, nil)
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
      t.content.setVisibility(8)
      if t.progress~=nil then
        t.progress.setVisibility(0)
      end
      等待doc(view)
      加载js(view,获取js("zhihugif"))
    end,
    onPageFinished=function(view,url,favicon)
      t.content.setVisibility(0)
      if t.progress~=nil then
        t.progress.getParent().removeView(t.progress)
        t.progress=nil
      end
      屏蔽元素(view,{".AnswerReward"})

      if b.content:find("video%-box") then
        if not(getLogin()) then
          AlertDialog.Builder(this)
          .setTitle("提示")
          .setMessage("该回答含有视频 不登录可能无法显示视频 建议登录")
          .setCancelable(false)
          .setPositiveButton("我知道了",nil)
          .show()
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
      view.evaluateJavascript(获取js("imgload"),{onReceiveValue=function(b)end})
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
      if 全局主题值=="Night" then
        黑暗页(view)
      end
    end,
    onShowCustomView=function(z,a,b)
      v=a
      t.msrcroll.setVisibility(8)
      activity.getWindow().getDecorView().setSystemUiVisibility(5639)
      activity.getDecorView().addView(v)
    end,
    onHideCustomView=function()
      t.msrcroll.setVisibility(0)
      activity.getDecorView().removeView(v)
      activity.getWindow().getDecorView().setSystemUiVisibility(8208)
    end
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


function 加载页(mviews,pos,isleftadd,isload)
  if mviews==nil then return end
  if #mviews.ids.username.Text==0 and mviews.load==nil then --判断是否加载过没有
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

        pcall(function()
          mviews.pageinfo=cb.pagination_info
        end)

        if mviews.data==nil or mviews.data.voteup_count==nil then
          mviews.data=cb
        end

        if mviews.data and mviews.data.voteup_count and 重表状态==false and not(isload) then

          vote_count.Text=(mviews.data.voteup_count)..""
          thanks_count.Text=(mviews.data.thanks_count)..""
          comment_count.Text=(mviews.data.comment_count)..""
        end

        数据添加(mviews.ids,cb) --添加数据

        mviews.load=true

        if not(isload) then
          if this.getSharedData("回答预加载(beta)")=="true" and isloaded then
            if not(isleftadd) then
              local mviews=数据表[pg.adapter.getItem(pos+1).id]
              加载页(mviews,pos+1,false,true)
             else
              local mviews=数据表[pg.adapter.getItem(pos-1).id]
              加载页(mviews,pos-1,true,true)
            end
          end
         else
          if not(isleftadd) then
            --调整pageinfo 防止数据对不上
            local mviews=数据表[pg.adapter.getItem(pos-1).id]
            回答容器.pageinfo=mviews.pageinfo
            回答容器.isleft=(#回答容器.pageinfo.prev_answer_ids>0 and {false} or {true})[1]
            回答容器.isright=(#回答容器.pageinfo.next_answer_ids>0 and {false} or {true})[1]
            --再新建一页 防止误触右滑事件
            id表[pg.adapter.getItemCount()+1]={}
            local 加入view=loadlayout("layout/answer_list",id表[pg.adapter.getItemCount()+1])
            pg.adapter.add(加入view)
            数据表[加入view.id]={
              data={},
              ids=id表[pg.adapter.getItemCount()],
            }
           else
            --调整pageinfo 防止数据对不上
            local mviews=数据表[pg.adapter.getItem(pos+1).id]
            回答容器.pageinfo=mviews.pageinfo
            回答容器.isleft=(#回答容器.pageinfo.prev_answer_ids>0 and {false} or {true})[1]
            回答容器.isright=(#回答容器.pageinfo.next_answer_ids>0 and {false} or {true})[1]
            --再新建一页 防止误触右滑事件
            id表[pg.adapter.getItemCount()+1]={}
            local 加入view=loadlayout("layout/answer_list",id表[pg.adapter.getItemCount()+1])
            pg.adapter.insert(加入view,0)
            数据表[加入view.id]={
              data={},
              ids=id表[pg.adapter.getItemCount()],
            }
          end

          function mviews.loadfun()
            if not(isleftadd) then
              if 回答容器.isright then
                mviews.loadfun=nil
                return
              end

              id表[pg.adapter.getItemCount()+1]={}
              local 加入view=loadlayout("layout/answer_list",id表[pg.adapter.getItemCount()+1])
              pg.adapter.add(加入view)


              数据表[加入view.id]={
                data={},
                ids=id表[pg.adapter.getItemCount()],
              }

              local mviews=数据表[pg.adapter.getItem(pos+1).id]
              if mviews.load==true then
                mviews.loadfun=nil
                return
              end
              加载页(mviews,pos+1,false,true)
             else
              if 回答容器.isleft then
                mviews.loadfun=nil
                return
              end
              id表[pg.adapter.getItemCount()+1]={}

              local 加入view=loadlayout("layout/answer_list",id表[pg.adapter.getItemCount()+1])

              pg.adapter.insert(加入view,0)

              数据表[加入view.id]={
                data={},
                ids=id表[pg.adapter.getItemCount()],
              }
              local pos=pg.getCurrentItem()+1
              local mviews=数据表[pg.adapter.getItem(pos-1).id]
              if mviews.load==true then
                mviews.loadfun=nil
                return
              end
              加载页(mviews,pos-1,true,true)
            end

            mviews.loadfun=nil
          end

          if isloaded~=true then
            isloaded=true
          end

        end

      end
    end,isleftadd or (pos==0 and 回答容器.one==nil and pos<=上次page and 回答容器.is_add==true and 回答容器.isleft==false and pg.adapter.getItemCount()>1))
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

isloaded=false

pg.registerOnPageChangeCallback(OnPageChangeCallback{--除了名字变，其他和PageView差不多
  onPageScrolled=function(pos,positionOffset,positionOffsetPixels)
    if positionOffsetPixels==0 then

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
        加载页(mviews,pos)


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
        加载页(mviews,pos,true)

        --判断是否加载过
       elseif pg.adapter.getItemCount()>=0 then

        local pos=pg.getCurrentItem()
        local mviews=数据表[pg.adapter.getItem(pos).id]

        if mviews.load==true then
          --更新pageinfo
          local pageinfodata=mviews.pageinfo
          回答容器.pageinfo=pageinfodata
          --在请求后再次判断是否在最左or最右端
          回答容器.isleft=(#回答容器.pageinfo.prev_answer_ids>0 and {false} or {true})[1]
          回答容器.isright=(#回答容器.pageinfo.next_answer_ids>0 and {false} or {true})[1]
          --暂时没用的参数
          回答容器.now=pageinfodata.index

          if mviews.loadfun then
            mviews.loadfun()
          end

          --判断更新底栏数据
          if mviews.data and mviews.data.id then
            if mviews.data.voteup_count then
              vote_count.Text=(mviews.data.voteup_count)..""
              thanks_count.Text=(mviews.data.thanks_count)..""
              comment_count.Text=(mviews.data.comment_count)..""

              local 回答id=mviews.data.id
              if 点赞状态[回答id] then
                vote_count.setTextColor(转0x(primaryc))
               else
                vote_count.setTextColor(转0x(stextc))
              end

              if 感谢状态[回答id] then
                thanks_count.setTextColor(转0x(primaryc))
               else
                thanks_count.setTextColor(转0x(stextc))
              end

             else
              local include="?&include=cmment_count,voteup_count,thanks_count;voteup_count,cmment_count,thanks_count,badge[?(type=best_answerer)].topics"
              zHttp.get("https://api.zhihu.com/answers/"..mviews.data.id..include,head,function(a,b)
                if a==200 then
                  mviews.data=luajson.decode(b).data[1]
                  vote_count.Text=(mviews.data.voteup_count)..""
                  thanks_count.Text=(mviews.data.thanks_count)..""
                  comment_count.Text=(mviews.data.comment_count)..""

                  if 点赞状态[回答id] then
                    vote_count.setTextColor(转0x(primaryc))
                   else
                    vote_count.setTextColor(转0x(stextc))
                  end

                  if 感谢状态[回答id] then
                    thanks_count.setTextColor(转0x(primaryc))
                   else
                    thanks_count.setTextColor(转0x(stextc))
                  end

                end
              end)
            end
          end

        end
      end

      上次page=a

    end

  end,

  onPageScrollStateChanged=monPageScrollStateChanged
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

          url="https://www.zhihu.com/answer/"..url:match("answer/(.+)")

          activity.newActivity("huida",{url,nil,true})

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

          activity.newActivity("comment",{回答id,"answers"})

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

          local 保存路径=内置存储文件("Download/".._title.Text.."/"..pgids.username.Text)

          if not(文件是否存在(内置存储文件("Download/".._title.Text))) then
            创建文件夹(内置存储文件("Download/".._title.Text))
          end

          创建文件夹(保存路径)
          创建文件(内置存储文件("Download/".._title.Text.."/"..pgids.username.Text.."/detail.txt"))
          写入内容='question_id="'..问题id..'"\n'
          写入内容=写入内容..'answer_id="'..回答id..'"\n'
          写入内容=写入内容..'thanks_count="'..thanks_count.Text..'"\n'
          写入内容=写入内容..'vote_count="'..vote_count.Text..'"\n'
          写入内容=写入内容..'comment_count="'..comment_count.Text..'"\n'
          写入内容=写入内容..'author="'..pgids.username.Text..'"\n'
          写入内容=写入内容..'headline="'..pgids.userheadline.Text..'"\n'
          写入文件(保存路径.."/detail.txt",写入内容)
          pgids.content.saveWebArchive(内置存储文件("Download/".._title.Text.."/"..pgids.username.Text.."/mht.mht"))
          提示("保存成功")
        end
      },

      {
        src=图标("book"),text="加入收藏夹",onClick=function()
          local url=数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.content.getUrl()
          加入收藏夹(url:match("answer/(.+)"),"answer")
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
          activity.newActivity("huida",{url.."&source=android&ab_signature=",nil,nil,nil,"举报"})
        end
      },

      {
        src=图标("build"),text="关闭硬件加速",onClick=function()
          AlertDialog.Builder(this)
          .setTitle("提示")
          .setMessage("你确认要关闭当前页的硬件加速吗 关闭后滑动可能会造成卡顿 如果当前页显示正常请不要关闭")
          .setPositiveButton("关闭",{onClick=function(v)
              数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.msrcroll.setLayerType(View.LAYER_TYPE_SOFTWARE, nil);
              数据表[pg.adapter.getItem(pg.getCurrentItem()).id].ids.content.reload()
              提示("关闭成功")
          end})
          .setNeutralButton("取消",{onClick=function(v)
          end})
          .show()
        end
      },
    }
  })
end)

if activity.getSharedData("回答提示0.03")==nil
  AlertDialog.Builder(this)
  .setTitle("小提示")
  .setCancelable(false)
  .setMessage("支持点赞 点击感谢按钮 双击标题回到顶部")
  .setPositiveButton("我知道了",{onClick=function() activity.setSharedData("回答提示0.03","true") end})
  .show()
end

if activity.getSharedData("异常提示0.02")==nil
  AlertDialog.Builder(this)
  .setTitle("小提示")
  .setCancelable(false)
  .setMessage("如果部分回答显示不完整 可以点击右上角「关闭硬件加速」 关闭动画会卡顿 如果没有问题请不要点击 出现其他异常情况都可以尝试关闭 另外 可以在设置中一键关闭之后所有的硬件加速")
  .setPositiveButton("我知道了",{onClick=function() activity.setSharedData("异常提示0.02","true") end})
  .show()
end


function onActivityResult(a,b,c)
  if b==100 then
    activity.recreate()
  end
end