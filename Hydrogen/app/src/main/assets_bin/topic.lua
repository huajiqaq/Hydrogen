require "import"
import "mods.muk"
import "com.google.android.material.tabs.TabLayout"

activity.setContentView(loadlayout("layout/topic"))
topic_id=...
波纹({fh,page1,page2,page3},"圆主题")

local allnum=5

local topic_pages={
  LinearLayout;
  layout_height="-1",
  layout_width="-1",
  {
    MaterialCardView;
    layout_height="-2";
    CardBackgroundColor=cardedge,
    Elevation="0";
    layout_width="-1";
    layout_margin="16dp";
    layout_marginTop="8dp";
    layout_marginBottom="8dp";
    radius=cardradius;
    StrokeColor=cardedge;
    StrokeWidth=dp2px(1),

    {
      LinearLayout;
      layout_width="-1",
      orientation="vertical";
      {
        CircleImageView;
        layout_gravity="center";
        layout_marginTop="16dp",
        layout_height="72dp",
        layout_width="72dp",
        id="_bigimage"
      };
      {
        TextView;
        id="_excerpt",
        textColor=textc,
        textSize="14sp",
        Typeface=字体("product");
        textIsSelectable=true;
        layout_margin="16dp",
        layout_marginBottom="8dp",
      };
    };
  };
};

pagadp=SWKLuaPagerAdapter()

pagadp.add(loadlayout(topic_pages))
topic_page.setAdapter(pagadp)
initpage(topic_page,"topic",allnum,true,1)

topic_page.setCurrentItem(1,false)
初始化历史记录数据(true)
TopictabLayout.setupWithViewPager(topic_page)

local TopicTable={"详情","讨论","想法","视频","问题"}

--setupWithViewPager设置的必须手动设置text
for i=1, #TopicTable do
  local itemnum=i-1
  TopictabLayout.getTabAt(itemnum).Text=TopicTable[i]
end


local api="https://api.zhihu.com/v5.1/topics/"..topic_id.."?include=meta%2Cmeta.casts%2Cmeta.medias%2Cmeta.playlist%2Cmeta.awards%2Cmeta.pubinfo%2Cmeta.parameters%2Cvote%2Crank_list_info%2Cmeta.review_question%2Crelated_topics%2Crelated_topics.vote%2Cmeta.game_medias%2Cmeta.game_parameters%2Cmeta.team_parameters%2Cmeta.sports_parameters%2Cclub%2Ctimeline%2Cuniversity%2Cheader_video%2Cactivity%2Cpin_template"
zHttp.get(api,head,function(code,content)
  if code==200 then
    data=luajson.decode(content)
    _title.text=data.name
    loadglide(_image,data.avatar_url)
    loadglide(_bigimage,data.avatar_url)
    if data.introduction==""then
      _excerpt.text="暂无话题描述"
     else
      _excerpt.text=data.introduction
    end
  end
end)


best_itemc=获取适配器项目布局("topic/topic_best")
all_itemc=获取适配器项目布局("topic/topic_all")


reftype={"essence","pin-hot","top_zvideo","top_question"}
nexturl={false,false,false,false}
isend={false,false,false,false}
isadd={true,true,true,true}
itemc={best_itemc,best_itemc,best_itemc,all_itemc}

function 精华刷新(istab)
  local pos=TopictabLayout.getSelectedTabPosition()
  local madapter=getpage(topic_page,"topic",pos,allnum,true,1)

  if madapter.Adapter and istab then
    return
  end

  local posturl = nexturl[pos] or "https://api.zhihu.com/v5.1/topics/"..topic_id.."/feeds/"..reftype[pos]


  if madapter.Adapter==nil then

    madapter.setOnItemClickListener(AdapterView.OnItemClickListener{
      onItemClick=function(parent,v,pos,id)


        local open=activity.getSharedData("内部浏览器查看回答")
        if tostring(v.Tag.best_id.text):find("文章分割") then

          activity.newActivity("column",{tostring(v.Tag.best_id.Text):match("文章分割(.+)"),tostring(v.Tag.best_id.Text):match("分割(.+)")})
         elseif tostring(v.Tag.best_id.text):find("视频分割") then
          activity.newActivity("huida",{tostring(v.Tag.best_id.Text):match("视频分割(.+)")})
         elseif tostring(v.Tag.best_id.text):find("问题分割") then
          activity.newActivity("question",{tostring(v.Tag.best_id.Text):match("问题分割(.+)")})
         elseif tostring(v.Tag.best_id.text):find("想法分割") then
          activity.newActivity("column",{tostring(v.Tag.best_id.Text):match("想法分割(.+)"),"想法"})

         else

          保存历史记录(v.Tag.best_title.Text,v.Tag.best_id.Text,50)

          if open=="false" then

            activity.newActivity("answer",{tostring(v.Tag.best_id.Text):match("(.+)分割"),tostring(v.Tag.best_id.Text):match("分割(.+)")})
           else
            activity.newActivity("huida",{"https://www.zhihu.com/answer/"..tostring(v.Tag.best_id.Text):match("分割(.+)")})
          end
        end
      end
    })


    local best_adp=LuaAdapter(activity,datas,itemc[pos])
    madapter.Adapter=best_adp

    isadd[pos]=true


    madapter.setOnScrollListener{
      onScroll=function(view,a,b,c)
        if a+b==c and isadd[pos] then
          isadd[pos]=false
          精华刷新()
          System.gc()
        end
      end
    }
    return
  end


  zHttp.get(posturl,head,function(code,content)
    if code==200 then

      for k,v in ipairs(luajson.decode(content).data) do

        xpcall(function()
          name=v.target.author.name
          end,function()
          name=""
        end)
        if name~="" then
          local excerpt_data=v.target.excerpt or ""
          local excerpt=name.." : "..excerpt_data
          if v.target.type=="answer" then
            title=v.target.question.title
            id=(v.target.question.id) or "null"
            id=id.."分割"..(v.target.id)
           elseif v.target.type=="question" then
            local title=v.target.title
            local id=(v.target.id)
            local answer_count=(v.target.answer_count).."个回答"
            local follower_count=(v.target.follower_count).."人关注"
            id="问题分割"..(v.target.id)
            madapter.Adapter.add{all_title=title,all_follower_count=follower_count,all_answer_count=answer_count,best_id=id}
            continue
           elseif v.target.type=="article" then
            title=v.target.title
            id="文章分割"..(v.target.id)

           elseif v.target.type=="zvideo" then
            title=v.target.title
            xpcall(function()
              videourl=v.target.video.playlist.sd.url
              end,function()
              videourl=v.target.video.playlist.ld.url
              end,function()
              videourl=v.target.video.playlist.hd.url
            end)

            if excerpt_data=="" then
              local excerpt_data="[视频]"
              excerpt=name.." : "..excerpt_data
            end
            id="视频分割"..videourl
           elseif v.target.type=="pin" then
            title=v.target.content[1].title
            if title==nil or title==""
              title="一个想法"
            end
            id="想法分割"..v.target.id
          end

          pcall(function()
            excerpt=Html.fromHtml(v.target.content[1].content)
          end)

          local voteup_count=(v.target.voteup_count) or (v.target.like_count) or (v.target.counter.applaud)
          local comment_count=(v.target.comment_count) or (v.target.comment_count) or (v.target.counter.comment)
          madapter.Adapter.add{best_excerpt=excerpt,best_title=title,best_comment_count=comment_count,best_id=id,best_voteup_count=voteup_count}
         elseif v.target.type=="topic_sticky_module" then
          if v.target.data then

            for q,w in ipairs(v.target.data) do
              local voteup_count=(w.target.voteup_count)
              local comment_count=(w.target.comment_count)
              if w.target.type=="answer" then
                title=w.target.question.title
                id=(w.target.question.id).."分割"..(w.target.id)
               elseif w.target.type=="article" then
                title=w.target.title
                id="文章分割"..(w.target.id)

               elseif w.target.type=="zvideo" then
                xpcall(function()
                  videourl=w.target.video.playlist.sd.url
                  end,function()
                  videourl=w.target.video.playlist.ld.url
                  end,function()
                  videourl=w.target.video.playlist.hd.url
                end)
                title=w.target.title
                id="视频分割"..videourl
               elseif w.target.type=="question" then
                title=w.target.title
                voteup_count=(w.target.answer_count)
                id="问题分割"..(w.target.id)
              end
              madapter.Adapter.add{best_excerpt=excerpt,best_title=title,best_comment_count=comment_count,best_id=id,best_voteup_count=voteup_count}
            end
          end
        end
      end

      local data=luajson.decode(content)
      isend[pos]=data.paging.is_end
      nexturl[pos]=data.paging.next

      if isend[pos]==false then
        isadd[pos]=true
       else
        提示("没有新内容了")
      end

    end
  end)
end

精华刷新(true)

tabmemu={
  [1]={"essence","timeline_activity","top_activity"},
  [2]={"pin-new","pin-hot"},
  [3]={"new_zvideo","top_zvideo"},
  [4]={"new_question","top_question"},
}

mpop={
  tittle="话题",
  list={
    {src=图标("insert_chart"),text="按精华排序",onClick=function()
        --只有第一个有三个 所以可以写死
        local mallpager=getpage(topic_page,"topic",1,allnum,true,1)
        mallpager.Adapter.clear()
        nexturl[1],isend[1]=false
        reftype[1]=tabmemu[1][1]
    end},
    {src=图标("format_align_left"),text="按时间顺序",onClick=function()
        local mallpager=getpage(topic_page,"topic",1,allnum,true,1)
        mallpager.Adapter.clear()
        nexturl[1],isend[1]=false
        reftype[1]=tabmemu[1][2]
    end},
    {src=图标("notes"),text="按热度顺序",onClick=function()
        local mallpager=getpage(topic_page,"topic",1,allnum,true,1)
        mallpager.Adapter.clear()
        nexturl[1],isend[1]=false
        reftype[1]=tabmemu[1][3]
    end},
  }
}

mmpop={
  tittle="话题",
  list={
    {src=图标("format_align_left"),text="按时间顺序",onClick=function()
        local pos=TopictabLayout.getSelectedTabPosition()
        local mallpager=getpage(topic_page,"topic",pos,allnum,true,1)
        mallpager.Adapter.clear()
        nexturl[pos],isend[pos]=false
        reftype[pos]=tabmemu[pos][1]
    end},
    {src=图标("notes"),text="按热度顺序",onClick=function()
        local pos=TopictabLayout.getSelectedTabPosition()
        local mallpager=getpage(topic_page,"topic",pos,allnum,true,1)
        mallpager.Adapter.clear()
        nexturl[pos],isend[pos]=false
        reftype[pos]=tabmemu[pos][2]
    end},
  }
}

canclick_topic={true,true,true,true}
TopictabLayout.addOnTabSelectedListener(TabLayout.OnTabSelectedListener {
  onTabSelected=function(tab)
    --选择时触发
    local pos=tab.getPosition()
    if canclick_topic[pos] then
      canclick_topic[pos]=false
      Handler().postDelayed(Runnable({
        run=function()
          canclick_topic[pos]=true
        end,
      }),1050)
     else
      return false
    end
    if pos==0 then
     else
      精华刷新(true)
      if pos==1 then
        a=MUKPopu(mpop)
       else
        a=MUKPopu(mmpop)
      end
    end
  end,
});

task(1,function()
  local pos=TopictabLayout.getSelectedTabPosition();
  a=MUKPopu(mpop)
end)

if activity.getSharedData("话题提示0.01")==nil
  AlertDialog.Builder(this)
  .setTitle("小提示")
  .setCancelable(false)
  .setMessage("你可以点击右上角切换排列顺序哦")
  .setPositiveButton("我知道了",{onClick=function() activity.setSharedData("话题提示0.01","true") end})
  .show()
end