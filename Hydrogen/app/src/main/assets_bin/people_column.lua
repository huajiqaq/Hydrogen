require "import"
import "mods.muk"
activity.setContentView(loadlayout("layout/simple"))

波纹({fh,_more},"圆主题")

初始化历史记录数据(true)

id,title=...
_title.text=title

itemc=获取适配器项目布局("people/people_column")


simple_list.setDividerHeight(0)
adp=LuaAdapter(activity,itemc)
simple_list.Adapter=adp

function 刷新()
  geturl=myurl or "https://api.zhihu.com/columns/"..id.."/items"
  zHttp.get(geturl,head,function(code,content)
    if code==200 then
      if luajson.decode(content).paging.next then
        testurl=luajson.decode(content).paging.next
        if testurl:find("http://") then
          testurl=string.gsub(testurl,"http://","https://",1)
        end
        myurl=testurl
      end
      if luajson.decode(content).paging.is_end then
        提示("已经没有更多内容了")
       else
        add=true
      end
      for i,v in ipairs(luajson.decode(content).data) do
        local 头像=v.author.avatar_url
        local 预览内容=v.excerpt
        local 点赞数=(v.voteup_count)
        local 评论数=(v.comment_count)
        if 无图模式 then
          头像=logopng
        end
        if v.type=="answer" then
          活动="回答了问题"
          问题id=(v.question.id) or "null"
          问题id=问题id.."分割"..(v.id)
          标题=v.question.title
         elseif v.type=="topic" then
          people_list.Adapter.add{活动=活动,预览内容={Visibility=8},评论数={Visibility=8},id内容="话题分割"..v.id,标题=v.name,图像=头像}
          return
         elseif v.type=="question" then
          活动="发布了问题"
          问题id=(v.id).."问题分割"
          标题=v.title
         elseif v.type=="column" then
          活动="发表了专栏"
          问题id="文章分割"..v.id
          评论数=(v.items_count)
          标题=v.title

         elseif v.type=="collection" then
          return
         elseif v.type=="pin" then
          活动="发布了想法"
          标题=v.author.name.."发布了想法"
          问题id="想法分割"..v.id
          预览内容=v.content[1].content
         elseif v.type=="zvideo" then
          --视频并未直接暴露在接口内 需自己根据api获取视频链接
          活动="发布了视频"
          问题id="视频分割"..v.id
          标题=v.title
         else
          活动="发表了文章"
          问题id="文章分割"..(v.id)
          标题=v.title
        end
        simple_list.Adapter.add{活动=活动,预览内容=预览内容,点赞数=点赞数,评论数=评论数,id内容=问题id,标题=标题,图像=头像}
      end
    end
  end)
end

simple_list.onItemClick=function(l,v,c,b)
  点击事件判断(v.Tag.id内容.Text,v.Tag.标题.Text)
end

保存历史记录(title,"专栏分割"..id,50)

add=true

simple_list.setOnScrollListener{
  onScroll=function(view,a,b,c)
    if a+b==c and add then
      add=false
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