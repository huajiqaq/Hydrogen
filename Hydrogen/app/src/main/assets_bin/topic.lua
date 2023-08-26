require "import"
import "mods.muk"
import "com.google.android.material.tabs.TabLayout"

activity.setContentView(loadlayout("layout/topic"))
topic_id=...
波纹({fh,page1,page2,page3},"圆主题")
topic_page.setCurrentItem(1,false)
初始化历史记录数据(true)

TopictabLayout.setupWithViewPager(topic_page)

local TopicTable={"详情","讨论","想法","视频","问题"}

--setupWithViewPager设置的必须手动设置text
for i=1, #TopicTable do
  local itemnum=i-1
  TopictabLayout.getTabAt(itemnum).setText(TopicTable[i]);
end


--local api="https://api.zhihu.com/topics/"..topic_id
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


mallpager={best_list,think_list,video_list}
reftype={"essence","pin-hot","top_zvideo"}
nexturl={false,false,false}
isend={false,false,false}
isadd={true,true,true}

function 精华刷新(istab)
  local pos=TopictabLayout.getSelectedTabPosition();

  if mallpager[pos].Adapter and istab then
    return
  end

  local posturl = nexturl[pos] or "https://api.zhihu.com/v5.1/topics/"..topic_id.."/feeds/"..reftype[pos]


  if mallpager[pos].Adapter==nil then

    mallpager[pos].setOnItemClickListener(AdapterView.OnItemClickListener{
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
            activity.newActivity("huida",{"https://www.zhihu.com/question/"..tostring(v.Tag.best_id.Text):match("(.+)分割").."/answer/"..tostring(v.Tag.best_id.Text):match("分割(.+)")})
          end
        end
      end
    })

    isadd[pos]=true

    mallpager[pos].setOnScrollListener{
      onScrollStateChanged=function(view,scrollState)
        if scrollState == 0 then
          if view.getCount() >1 and view.getLastVisiblePosition() == view.getCount() - 1 then
            精华刷新()
            System.gc()
          end
        end
      end
    }
    local best_adp=LuaAdapter(activity,datas,best_itemc)
    mallpager[pos].Adapter=best_adp
  end

  zHttp.get(posturl,head,function(code,content)
    --print(content)
    if code==200 then

      for k,v in ipairs(luajson.decode(content).data) do
        --        local name=v.target.author.name
        --local excerpt=name.." : "..v.target.excerpt:gsub("<b>",""):gsub("</b>","")

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
            id=tointeger(v.target.question.id) or "null"
            id=id.."分割"..tointeger(v.target.id)
           elseif v.target.type=="article" then
            title=v.target.title
            id="文章分割"..tointeger(v.target.id)

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
           elseif v.type=="pin" then
            local excerpt_data=v.target.excerpt or ""
            title=v.title
            if title==nil or title==""
              title="一个想法"
            end
            id="想法分割"..tointeger(v.target.id)
          end

          local voteup_count=tointeger(v.target.voteup_count)
          local comment_count=tointeger(v.target.comment_count)
          mallpager[pos].Adapter.add{best_excerpt=excerpt,best_title=title,best_comment_count=comment_count,best_id=id,best_voteup_count=voteup_count}
         elseif v.target.type=="topic_sticky_module" then
          if v.target.data then

            for q,w in ipairs(v.target.data) do
              local voteup_count=tointeger(w.target.voteup_count)
              local comment_count=tointeger(w.target.comment_count)
              if w.target.type=="answer" then
                title=w.target.question.title
                id=tointeger(w.target.question.id).."分割"..tointeger(w.target.id)
               elseif w.target.type=="article" then
                title=w.target.title
                id="文章分割"..tointeger(w.target.id)

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
                voteup_count=tointeger(w.target.answer_count)
                id="问题分割"..tointeger(w.target.id)
              end
              mallpager[pos].Adapter.add{best_excerpt=excerpt,best_title=title,best_comment_count=comment_count,best_id=id,best_voteup_count=voteup_count}
            end
          end
        end
      end

      local data=luajson.decode(content)
      isend[pos]=data.paging.is_end
      nexturl[pos]=data.paging.next
    end
  end)
end

精华刷新()

all_type="top_question"

function 所有刷新(istab)

  if all_list.Adapter and istab then
    return
  end

  local posturl = all_nexturl or "https://api.zhihu.com/v5.1/topics/"..topic_id.."/feeds/"..all_type

  if all_list.Adapter==nil then
    all_itemc=获取适配器项目布局("topic/topic_all")
    all_nexturl=""
    all_isend=false
    all_list.setOnScrollListener{
      onScrollStateChanged=function(view,scrollState)
        if scrollState == 0 then
          if view.getCount() >1 and view.getLastVisiblePosition() == view.getCount() - 1 then
            all_nexturl=replace_domain (all_nexturl,"api.zhihu.com")
            所有刷新()
            System.gc()
          end
        end
      end
    }

    all_list.setOnItemClickListener(AdapterView.OnItemClickListener{
      onItemClick=function(parent,v,pos,id)

        local open=activity.getSharedData("内部浏览器查看回答")
        if tostring(v.Tag.all_id.text):find("文章分割") then
          activity.newActivity("column",{tostring(v.Tag.all_id.Text):match("文章分割(.+)"),tostring(v.Tag.all_id.Text):match("分割(.+)")})
         else

          保存历史记录(v.Tag.all_title.Text,v.Tag.all_id.Text,50)

          if open=="false" then
            activity.newActivity("question",{v.Tag.all_id.Text,nil})
           else
            activity.newActivity("huida",{"https://www.zhihu.com/question/"..tostring(v.Tag.all_id.Text)})
          end
        end
      end
    })

    local all_adp=LuaAdapter(activity,all_datas,all_itemc)
    all_list.Adapter=all_adp
  end

  zHttp.get(posturl,head,function(code,content)
    if code==200 then
      for k,v in ipairs(luajson.decode(content).data) do
        local title=v.target.title
        local id=tointeger(v.target.id)
        local answer_count=tointeger(v.target.answer_count).."个回答"
        local follower_count=tointeger(v.target.follower_count).."人关注"
        all_list.Adapter.add{all_title=title,all_follower_count=follower_count,all_answer_count=answer_count,all_id=id}
      end

      local data=luajson.decode(content)
      all_isend=data.paging.is_end
      all_nexturl=data.paging.next

    end
  end)
end

-- 定义一个函数，接受一个URL字符串作为参数
local function replace_domain (url,replace_str)
  -- 使用string.match函数，从URL中提取域名
  local domain = string.match (url, "https?://([^/]+)")
  -- 如果域名不是replace_str，就用string.gsub函数，将域名替换
  if domain ~= replace_str then
    if domain then
      url = string.gsub (url, domain, replace_str)
     else
      return 提示(url.."不是一个有效的http链接")
    end
  end
  -- 返回替换后的URL字符串
  return url
end

TopictabLayout.addOnTabSelectedListener(TabLayout.OnTabSelectedListener {
  onTabSelected=function(tab)
    --选择时触发
    local pos=tab.getPosition()+1
    if pos==2 then
      精华刷新(true)
      task(1,function()
        a=MUKPopu({
          tittle="话题",
          list={
            {src=图标("insert_chart"),text="按精华排序",onClick=function()
                mallpager[pos-1].Adapter.clear()
                nexturl[1],isend[1]=false
                reftype[1]="essence"
                精华刷新()
            end},
            {src=图标("format_align_left"),text="按时间顺序",onClick=function()
                mallpager[pos-1].Adapter.clear()
                nexturl[1],isend[1]=false
                reftype[1]="timeline_activity"
                精华刷新()
            end},
            {src=图标("notes"),text="按热度顺序",onClick=function()
                mallpager[pos-1].Adapter.clear()
                nexturl[1],isend[1]=false
                reftype[1]="top_activity"
                精华刷新()
            end},
          }
        })
      end)
     elseif pos==3 then
      精华刷新(true)
      task(1,function()
        a=MUKPopu({
          tittle="话题",
          list={
            {src=图标("format_align_left"),text="按时间顺序",onClick=function()
                mallpager[pos-1].Adapter.clear()
                nexturl[2],isend[2]=false
                reftype[2]="pin-new"
                精华刷新()
            end},
            {src=图标("notes"),text="按热度顺序",onClick=function()
                mallpager[pos-1].Adapter.clear()
                nexturl[2],isend[2]=false
                reftype[2]="pin-hot"
                精华刷新()
            end},
          }
        })
      end)
     elseif pos==4 then
      精华刷新(true)
      task(1,function()
        a=MUKPopu({
          tittle="话题",
          list={
            {src=图标("format_align_left"),text="按时间顺序",onClick=function()
                mallpager[pos-1].Adapter.clear()
                nexturl[3],isend[3]=false
                reftype[3]="new_zvideo"
                精华刷新()
            end},
            {src=图标("notes"),text="按热度顺序",onClick=function()
                mallpager[pos-1].Adapter.clear()
                nexturl[3],isend[3]=false
                reftype[3]="top_zvideo"
                精华刷新()
            end},
          }
        })
      end)
     elseif pos==5 then
      所有刷新(true)
      task(1,function()
        a=MUKPopu({
          tittle="话题",
          list={
            {src=图标("format_align_left"),text="按时间顺序",onClick=function()
                all_list.Adapter.clear()
                all_nexturl,all_isend=false
                all_type="new_question"
                所有刷新()
            end},
            {src=图标("notes"),text="按热度顺序",onClick=function()
                all_list.Adapter.clear()
                all_nexturl,all_isend=false
                all_type="top_question"
                所有刷新()
            end},
          }
        })
      end)
     else
      task(1,function()
        a=MUKPopu({
          tittle="话题",
          list={},
        })
      end)
    end
  end,
});

task(1,function()
  local pos=TopictabLayout.getSelectedTabPosition();
  a=MUKPopu({
    tittle="话题",
    list={
      {src=图标("insert_chart"),text="按精华排序",onClick=function()
          mallpager[pos].Adapter.clear()
          nexturl[pos],isend[pos]=nil
          reftype[pos]="essence"
          精华刷新()
      end},
      {src=图标("format_align_left"),text="按时间顺序",onClick=function()
          mallpager[pos].Adapter.clear()
          nexturl[pos],isend[pos]=nil
          reftype[pos]="timeline_activity"
          精华刷新()
      end},
      {src=图标("notes"),text="按热度顺序",onClick=function()
          mallpager[pos].Adapter.clear()
          nexturl[pos],isend[pos]=nil
          reftype[pos]="top_activity"
          精华刷新()
      end},
    }
  })
end)

if activity.getSharedData("话题提示0.01")==nil
  AlertDialog.Builder(this)
  .setTitle("小提示")
  .setCancelable(false)
  .setMessage("你可以点击右上角切换排列顺序哦")
  .setPositiveButton("我知道了",{onClick=function() activity.setSharedData("话题提示0.01","true") end})
  .show()
end