require "import"
import "mods.muk"
activity.setContentView(loadlayout("layout/simple"))

波纹({fh,_more},"圆主题")

初始化历史记录数据(true)

str=...


_title.text="收藏搜索结果"
itemc=获取适配器项目布局("search/search_result")

simple_list.setDividerHeight(0)
adp=MyLuaAdapter(activity,itemc)
simple_list.Adapter=adp


function 刷新()
  local 请求链接="https://www.zhihu.com/api/v4/search_v3?gk_version=gz-gaokao&q="..urlEncode(str).."&t=favlist&lc_idx=0&correction=1&offset=0&advertCount=0&limit=20&is_real_time=0&show_all_topics=0&search_source=History&filter_fields=&city=&pin_flow=false&ruid=undefined&recq=undefined&is_merger=1&raw_query=page_source%3Dmy_collection"
  search_base=require "model.dohttp"
  :new(下一页数据 or 请求链接)
  :setresultfunc(function(data)
    下一页数据=data.paging.next
    for i,v in ipairs(data.data) do
      local 预览内容=v.object.excerpt
      local 点赞数=(v.object.voteup_count)
      local 评论数=(v.object.comment_count)
      local 头像=v.object.author.avatar_url
      if 无图模式 then
        头像=logopng
      end
      if v.object.type=="answer" then
        活动="回答了问题"
        问题id=(v.object.question.id) or "null"
        问题id=问题id.."分割"..(v.object.id)
        标题=v.object.question.name
       elseif v.object.type=="topic" then
        simple_list.Adapter.add{活动=活动,预览内容={Visibility=8},people_palne={Visibility=8},评论数={Visibility=8},id内容="话题分割"..v.object.id,标题=v.object.name,图像=头像}
        return
       elseif v.object.type=="question" then
        活动="发布了问题"
        问题id=(v.object.id).."问题分割"
        标题=v.object.title
       elseif v.object.type=="column" then
        活动="发表了专栏"
        问题id="专栏分割"..v.object.id.."专栏标题"..v.object.title
        评论数=(v.object.items_count)
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
        问题id="视频分割"..v.object.id
        标题=v.object.title
       else
        活动="发表了文章"
        问题id="文章分割"..(v.object.id)
        标题=v.object.title
      end
      simple_list.Adapter.add{活动=活动,预览内容=Html.fromHtml(预览内容),点赞数=点赞数,评论数=评论数,id内容=问题id,标题=Html.fromHtml(标题),图像=头像}
      simple_list.Adapter.notifyDataSetChanged()
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


simple_list.onItemClick=function(l,v,c,b)
  点击事件判断(v.Tag.id内容.Text,v.Tag.标题.Text)
end

add=true

simple_list.setOnScrollListener{
  onScroll=function(view,a,b,c)
    if a+b==c and add then
      add=false
      提示("搜索中 请耐心等待")
      刷新()
      System.gc()
    end
  end
}

task(1,function()
  a=MUKPopu({
    tittle=_title.text,
    list={

    }
  })
end)