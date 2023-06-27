require "import"
import "mods.muk"
import "com.google.android.material.tabs.TabLayout"

activity.setContentView(loadlayout("layout/topic"))
topic_id=...
波纹({fh,page1,page2,page3},"圆主题")
topic_page.setCurrentItem(1,false)
初始化历史记录数据(true)

TopictabLayout.setupWithViewPager(topic_page)

local TopicTable={"话题资料","精华","全部问题"}

if TopictabLayout.getTabCount()==0 then
  for i=1, #TopicTable do
    local tab=TopictabLayout.newTab()
    local pagenum=i-1
    tab.view.onClick=function() changepage(pagenum) end
    TopictabLayout.addTab(tab)
  end
end

--setupWithViewPager设置的必须手动设置text
for i=1, #TopicTable do
  local itemnum=i-1
  TopictabLayout.getTabAt(itemnum).setText(TopicTable[i]);
end


function changepage(z)
  topic_page.setCurrentItem(z,false)
end


--local api="https://api.zhihu.com/topics/"..topic_id
local api="https://api.zhihu.com/v5.1/topics/"..topic_id.."?include=meta%2Cmeta.casts%2Cmeta.medias%2Cmeta.playlist%2Cmeta.awards%2Cmeta.pubinfo%2Cmeta.parameters%2Cvote%2Crank_list_info%2Cmeta.review_question%2Crelated_topics%2Crelated_topics.vote%2Cmeta.game_medias%2Cmeta.game_parameters%2Cmeta.team_parameters%2Cmeta.sports_parameters%2Cclub%2Ctimeline%2Cuniversity%2Cheader_video%2Cactivity%2Cpin_template"
zHttp.get(api,head,function(code,content)
  if code==200 then
    data=require "cjson".decode(content)
    _title.text=data.name
    _image.setImageBitmap(loadbitmap(data.avatar_url))
    _bigimage.setImageBitmap(loadbitmap(data.avatar_url))
    if data.introduction==""then
      _excerpt.text="暂无话题描述"
     else
      _excerpt.text=data.introduction
    end
  end
end)


best_itemc=获取适配器项目布局("topic/topic_best")


nexturl=""
isend=false
pager=1

function 精华刷新(pager,url)

  --  local posturl = url or "https://www.zhihu.com/api/v4/topics/"..topic_id.."/feeds/essence"

  local posturl = url or "https://api.zhihu.com/v5.1/topics/"..topic_id.."/feeds/essence"


  if pager <2 then
    local best_adp=LuaAdapter(activity,datas,best_itemc)
    best_list.Adapter=best_adp
  end

  local json=require "cjson"
  zHttp.get(posturl,head,function(code,content)
    --print(content)
    if code==200 then

      for k,v in ipairs(json.decode(content).data) do
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
          --[[        xpcall(function()
          title=v.target.question.title
          id=tointeger(v.target.question.id or 1).."分割"..tointeger(v.target.id)
          end,function()
          title=v.target.title
          id="文章分割"..tointeger(v.target.id)
        end)]]
          if v.target.type=="answer" then
            title=v.target.question.title
            id=tointeger(v.target.question.id or 1).."分割"..tointeger(v.target.id)
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
            id="视频分割"..videourl
          end

          local voteup_count=tointeger(v.target.voteup_count)
          local comment_count=tointeger(v.target.comment_count)
          best_list.Adapter.add{best_excerpt=excerpt,best_title=title,best_comment_count=comment_count,best_id=id,best_voteup_count=voteup_count}
         elseif v.target.type=="topic_sticky_module" then
          if v.target.data then

            for q,w in ipairs(v.target.data) do
              local voteup_count=tointeger(w.target.voteup_count)
              local comment_count=tointeger(w.target.comment_count)
              if w.target.type=="answer" then
                title=w.target.question.title
                id=tointeger(w.target.question.id or 1).."分割"..tointeger(w.target.id)
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
              best_list.Adapter.add{best_excerpt=excerpt,best_title=title,best_comment_count=comment_count,best_id=id,best_voteup_count=voteup_count}
            end
          end
        end
      end

      local data=json.decode(content)
      isend=data.paging.is_end
      nextUrl=data.paging.next
    end
  end)
end

精华刷新(1)

isadd=true

best_list.setOnScrollListener{
  onScrollStateChanged=function(view,scrollState)
    if scrollState == 0 then
      if view.getCount() >1 and view.getLastVisiblePosition() == view.getCount() - 1 then
        pager=pager+1
        精华刷新(pager,nextUrl)
        System.gc()
      end
    end
  end
}





all_itemc=获取适配器项目布局("topic/topic_all")


all_nexturl=""
all_isend=false

function 所有刷新(all_pager,url)

  local posturl = url or "https://api.zhihu.com/topics/"..topic_id.."/unanswered_questions?offset=0&limit=8"


  if all_pager <2 then
    local all_adp=LuaAdapter(activity,all_datas,all_itemc)
    all_list.Adapter=all_adp
  end

  local json=require "cjson"
  zHttp.get(posturl,head,function(code,content)
    if code==200 then
      for k,v in ipairs(json.decode(content).data) do
        local title=v.target.title
        local id=tointeger(v.target.id)
        local answer_count=tointeger(v.target.answer_count).."个回答"
        local follower_count=tointeger(v.target.follower_count).."人关注"
        all_list.Adapter.add{all_title=title,all_follower_count=follower_count,all_answer_count=answer_count,all_id=id}
      end

      local data=json.decode(content)
      all_isend=data.paging.is_end
      all_nexturl=data.paging.next

    end
  end)
end

所有刷新(1)
all_pager=2

all_list.setOnScrollListener{
  onScrollStateChanged=function(view,scrollState)
    if scrollState == 0 then
      if view.getCount() >1 and view.getLastVisiblePosition() == view.getCount() - 1 then
        all_pager=2
        所有刷新(all_pager,all_nexturl)
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


best_list.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(parent,v,pos,id)


    local open=activity.getSharedData("内部浏览器查看回答")
    if tostring(v.Tag.best_id.text):find("文章分割") then

      activity.newActivity("column",{tostring(v.Tag.best_id.Text):match("文章分割(.+)"),tostring(v.Tag.best_id.Text):match("分割(.+)")})
     elseif tostring(v.Tag.best_id.text):find("视频分割") then
      activity.newActivity("huida",{tostring(v.Tag.best_id.Text):match("视频分割(.+)")})
     elseif tostring(v.Tag.best_id.text):find("问题分割") then
      activity.newActivity("question",{tostring(v.Tag.best_id.Text):match("问题分割(.+)")})
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