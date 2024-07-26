require "import"
import "mods.muk"
activity.setContentView(loadlayout("layout/simple"))


波纹({fh,_more},"圆主题")

初始化历史记录数据(true)

_title.text="推荐关注收藏夹"


itemc=获取适配器项目布局("collections/collection_tj")


simple_list.setDividerHeight(0)
adp=LuaAdapter(activity,itemc)
simple_list.Adapter=adp

function 刷新()
  geturl=myurl or "https://api.zhihu.com/explore/collections?offset=20"
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
        if v.type~="collection" then
          return
        end
        local 头像=v.creator.avatar_url
        local 标题=v.title
        local 内容数量=v.item_count
        local 关注数=v.follower_count
        local 预览内容=v.description
        local 是否关注=v.is_following
        local 底部内容=内容数量.."个内容 · "..关注数.."个关注"
        if 是否关注 then
          底部内容=底部内容.." 已关注"
        end
        local 活动="由 "..v.creator.name.." 创建"
        local id=(v.id)
        if 预览内容==false or 预览内容=="" then
          预览内容="无介绍"
        end

        if 无图模式 then
          头像=logopng
        end

        simple_list.Adapter.add{活动=活动,预览内容=预览内容,底部内容=底部内容,标题=标题,图像=头像,id内容=id,isfollow=tostring(是否关注)}
      end
    end
  end)
end

simple_list.onItemClick=function(l,v,c,b)
  activity.newActivity("collections",{v.Tag.id内容.Text,true})
end

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
