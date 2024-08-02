require "import"
import "mods.muk"
import "com.google.android.material.tabs.TabLayout"

activity.setContentView(loadlayout("layout/topic"))
设置toolbar(toolbar)
topic_id=...
波纹({fh,page1,page2,page3},"圆主题")

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

local conf={
  view=topic_page,
  tabview=TopictabLayout,
  bindstr="topic",
  addcanclick=true,
  defpage=2,
}

MyPageTool:new(conf)

local TopicTable={"详情","讨论","想法","视频","问题"}
topic_pageTool:addPage(2,TopicTable,4)

topic_page.setCurrentItem(1,false)
初始化历史记录数据(true)

local api="https://api.zhihu.com/v5.1/topics/"..topic_id.."?include=meta%2Cmeta.casts%2Cmeta.medias%2Cmeta.playlist%2Cmeta.awards%2Cmeta.pubinfo%2Cmeta.parameters%2Cvote%2Crank_list_info%2Cmeta.review_question%2Crelated_topics%2Crelated_topics.vote%2Cmeta.game_medias%2Cmeta.game_parameters%2Cmeta.team_parameters%2Cmeta.sports_parameters%2Cclub%2Ctimeline%2Cuniversity%2Cheader_video%2Cactivity%2Cpin_template"
zHttp.get(api,head,function(code,content)
  if code==200 then
    data=luajson.decode(content)
    _title.text=data.name
    loadglide(_image,data.avatar_url,false)
    loadglide(_bigimage,data.avatar_url,false)
    if data.introduction==""then
      _excerpt.text="暂无话题描述"
     else
      _excerpt.text=data.introduction
    end
  end
end)


best_itemc=获取适配器项目布局("topic/topic_best")
all_itemc=获取适配器项目布局("topic/topic_all")

function resolve_topic(v,adapter)
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
      local 底部内容=answer_count.." · "..follower_count
      adapter.add{标题=title,底部内容=底部内容,id内容=id}
      return
     elseif v.target.type=="article" then
      title=v.target.title
      id="文章分割"..(v.target.id)
     elseif v.target.type=="zvideo" then
      title=v.target.title
      if excerpt_data=="" then
        local excerpt_data="[视频]"
        excerpt=name.." : "..excerpt_data
      end
      id="视频分割"..v.target.id
     elseif v.target.type=="pin" then
      title=v.target.title
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
    adapter.add {预览内容=excerpt,标题=title,评论数=comment_count,id内容=id,点赞数=voteup_count}
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
          title=w.target.title
          id="视频分割"..w.target.id
         elseif w.target.type=="question" then
          title=w.target.title
          voteup_count=(w.target.answer_count)
          id="问题分割"..(w.target.id)
        end
        adapter.add {预览内容=excerpt,标题=title,评论数=comment_count,id内容=id,点赞数=voteup_count}
      end
    end
  end
end

tabmemu={
  [1]={"essence","timeline_activity","top_activity"},
  [2]={"pin-new","pin-hot"},
  [3]={"new_zvideo","top_zvideo"},
  [4]={"new_question","top_question"},
}

function 获取url(type)
  return "https://api.zhihu.com/v5.1/topics/"..topic_id.."/feeds/"..type
end

pop3={
  tittle="话题",
  list={
    {src=图标("insert_chart"),text="按精华排序",onClick=function()
        --只有第一个有三个 所以可以写死
        local thispage=topic_pageTool:getItem(1)
        topic_pageTool:setUrlItem(1,获取url(tabmemu[1][1]))
        topic_pageTool:clearItem(1)
    end},
    {src=图标("format_align_left"),text="按时间顺序",onClick=function()
        local thispage=topic_pageTool:getItem(1)
        topic_pageTool:setUrlItem(1,获取url(tabmemu[1][2]))
        topic_pageTool:clearItem(1)
    end},
    {src=图标("notes"),text="按热度顺序",onClick=function()
        local thispage=topic_pageTool:getItem(1)
        topic_pageTool:setUrlItem(1,获取url(tabmemu[1][3]))
        topic_pageTool:clearItem(1)
    end},
  }
}

pop2={
  tittle="话题",
  list={
    {src=图标("format_align_left"),text="按时间顺序",onClick=function()
        local pos=TopictabLayout.getSelectedTabPosition()
        local thispage=topic_pageTool:getItem(pos)
        topic_pageTool:setUrlItem(pos,获取url(tabmemu[pos][1]))
        topic_pageTool:clearItem(pos)
    end},
    {src=图标("notes"),text="按热度顺序",onClick=function()
        local pos=TopictabLayout.getSelectedTabPosition()
        local thispage=topic_pageTool:getItem(pos)
        topic_pageTool:setUrlItem(pos,获取url(tabmemu[pos][2]))
        topic_pageTool:clearItem(pos)
    end},
  }
}

task(1,function()
  local pos=TopictabLayout.getSelectedTabPosition();
  a=MUKPopu(pop3)
end)

if activity.getSharedData("话题提示0.01")==nil
  AlertDialog.Builder(this)
  .setTitle("小提示")
  .setCancelable(false)
  .setMessage("你可以点击右上角切换排列顺序哦")
  .setPositiveButton("我知道了",{onClick=function() activity.setSharedData("话题提示0.01","true") end})
  .show()
end

local mconf={
  itemc={
    multiple=true,
    [1]=best_itemc,
    [2]=best_itemc,
    [3]=best_itemc,
    [4]=all_itemc
  },
  onclick=function(parent,v,pos,id)
    if v.Tag.标题 then
      点击事件判断(v.Tag.id内容.text,v.Tag.标题.Text)
     else
      点击事件判断(v.Tag.id内容.text)
    end
  end,
  onlongclick=nil,
  defurl={
    "https://api.zhihu.com/v5.1/topics/"..topic_id.."/feeds/".."essence",
    "https://api.zhihu.com/v5.1/topics/"..topic_id.."/feeds/".."pin-hot",
    "https://api.zhihu.com/v5.1/topics/"..topic_id.."/feeds/".."top_zvideo",
    "https://api.zhihu.com/v5.1/topics/"..topic_id.."/feeds/".."top_question",
  },
  head="head",
  func=function(v,pos,adapter)
    resolve_topic(v,adapter)
  end,
  dofunc=function(pos)
    if pos==0 then
      a=MUKPopu({
        tittle="话题",
        list={
        }
      })
      return false
     elseif pos==1 then
      a=MUKPopu(pop3)
     else
      a=MUKPopu(pop2)
    end
  end,
  funcstr="精华刷新"
}

topic_pageTool:createfunc(mconf)
topic_pageTool:setOnTabListener()

精华刷新(true)