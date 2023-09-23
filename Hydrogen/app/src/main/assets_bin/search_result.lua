require "import"
import "mods.muk"
activity.setContentView(loadlayout("layout/history"))


波纹({fh,_more},"圆主题")

初始化历史记录数据(true)

str=...


_title.text="收藏搜索结果"
_more.setVisibility(8)
tabv.setVisibility(8)
itemc=获取适配器项目布局("search_result/search_result")

history_list.setDividerHeight(0)
adp=MyLuaAdapter(activity,itemc)
history_list.Adapter=adp


function 刷新()
  local 请求链接="https://www.zhihu.com/api/v4/search_v3?gk_version=gz-gaokao&q="..urlEncode(str).."&t=favlist&lc_idx=0&correction=1&offset=0&advertCount=0&limit=20&is_real_time=0&show_all_topics=0&search_source=History&filter_fields=&city=&pin_flow=false&ruid=undefined&recq=undefined&is_merger=1&raw_query=page_source%3Dmy_collection"
  search_base=require "model.dohttp"
  :new(下一页数据 or 请求链接)
  :setresultfunc(function(data)
    -- local 搜索结果数量=tointeger(data.search_action_info.lc_idx)
    下一页数据=data.paging.next
    for i,v in ipairs(data.data) do
      local 预览内容=v.object.excerpt
      local 点赞数=tointeger(v.object.voteup_count)
      local 评论数=tointeger(v.object.comment_count)
      local 头像=v.object.author.avatar_url
      if v.object.type=="answer" then
        活动="回答了问题"
        问题id=tointeger(v.object.question.id) or "null"
        问题id=问题id.."分割"..tointeger(v.object.id)
        标题=v.object.question.name
       elseif v.object.type=="topic" then
        history_list.Adapter.add{people_action=活动,people_art={Visibility=8},people_palne={Visibility=8},people_comment={Visibility=8},people_question="话题分割"..v.object.id,people_title=v.object.name,people_image=头像}
        return
       elseif v.object.type=="question" then
        活动="发布了问题"
        问题id=tointeger(v.object.id).."问题分割"
        标题=v.object.title
       elseif v.object.type=="column" then
        活动="发表了专栏"
        问题id="专栏分割"..v.object.id.."专栏标题"..v.object.title
        评论数=tointeger(v.object.items_count)
        标题=v.object.title

       elseif v.object.type=="collection" then
        return
       elseif v.object.type=="pin" then
        活动="发布了想法"
        标题=v.object.author.name.."发布了想法"
        问题id="想法分割"..v.object.id
        预览内容=v.object.content[1].content
       elseif v.object.type=="zvideo" then
        活动="发布了视频"
        xpcall(function()
          videourl=v.object.video.playlist.sd.url
          end,function()
          videourl=v.object.video.playlist.ld.url
          end,function()
          videourl=v.object.video.playlist.hd.url
        end)
        问题id="视频分割"..videourl
        标题=v.object.title
       else
        活动="发表了文章"
        问题id="文章分割"..tointeger(v.object.id)
        标题=v.object.title
      end
      history_list.Adapter.add{people_action=活动,people_art=预览内容,people_vote=点赞数,people_comment=评论数,people_question=问题id,people_title=标题,people_image=头像}
      history_list.Adapter.notifyDataSetChanged()
    end
  end)
  search_base:getData(nil,nil,function(content)
    local data=luajson.decode(content)
    if data.paging.is_end==false then
      add=true
     else
      提示("没有新内容了")
    end
  end)
end


history_list.onItemClick=function(l,v,c,b)
  local open=activity.getSharedData("内部浏览器查看回答")
  if tostring(v.Tag.people_question.text):find("文章分割") then
    activity.newActivity("column",{tostring(v.Tag.people_question.Text):match("文章分割(.+)"),tostring(v.Tag.people_question.Text):match("分割(.+)")})
   elseif tostring(v.Tag.people_question.text):find("话题分割") then
    activity.newActivity("huida",{"https://www.zhihu.com/topic/"..tostring(v.Tag.people_question.Text):match("话题分割(.+)")})
   elseif tostring(v.Tag.people_question.text):find("问题分割") then
    activity.newActivity("question",{tostring(v.Tag.people_question.Text):match("(.+)问题分割")})
   elseif tostring(v.Tag.people_question.text):find("想法分割") then
    activity.newActivity("column",{tostring(v.Tag.people_question.Text):match("想法分割(.+)"),"想法"})
   elseif tostring(v.Tag.people_question.Text):find("视频分割") then
    activity.newActivity("column",{tostring(v.Tag.people_question.Text):match("视频分割(.+)"),"视频"})
   elseif tostring(v.Tag.people_question.Text):find("专栏分割") then
    activity.newActivity("people_column",{tostring(v.Tag.people_question.Text):match("专栏分割(.+)专栏标题"),tostring(v.Tag.people_question.Text):match("专栏标题(.+)")})
   else
    if open=="false" then
      保存历史记录(v.Tag.people_title.Text,v.Tag.people_url.Text,50)
      activity.newActivity("answer",{tostring(v.Tag.people_question.Text):match("(.+)分割"),tostring(v.Tag.people_question.Text):match("分割(.+)")})
     else
      activity.newActivity("huida",{"https://www.zhihu.com/question/"..tostring(v.Tag.follow_id.Text):match("(.+)分割").."/answer/"..tostring(v.Tag.follow_id.Text):match("分割(.+)")})
    end
  end
end

add=true

history_list.setOnScrollListener{
  onScroll=function(view,a,b,c)
    if a+b==c and add then
      add=false
      提示("搜索中 请耐心等待")
      刷新()
      System.gc()
    end
  end
}