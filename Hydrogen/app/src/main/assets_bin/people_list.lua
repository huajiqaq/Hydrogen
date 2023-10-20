require "import"
import "mods.muk"
activity.setContentView(loadlayout("layout/history"))


波纹({fh,_more},"圆主题")

初始化历史记录数据(true)

title,murl,是否屏蔽=...
_title.text=title

if 是否屏蔽 then
  murl="https://api.zhihu.com/settings/blocked_users?filter=all"
  onclick=function(view)
    local rootview=view.getParent().getParent().getParent().getParent()
    local 用户id=rootview.Tag.people_id.text
    local following=rootview.Tag.following

    if following.Text=="屏蔽" then
      zHttp.post("https://api.zhihu.com/settings/blocked_users","people_id="..用户id,apphead,function(code,json)
        if code==200 or code==201 then
          following.Text="取消屏蔽";
        end
      end)
     elseif following.Text=="取消屏蔽" then
      zHttp.delete("https://api.zhihu.com/settings/blocked_users/"..用户id,posthead,function(code,json)
        if code==200 then
          following.Text="屏蔽";
        end
      end)
     else
      提示("加载中")
    end
  end
  判断文本=function()
    return "取消屏蔽"
  end
 else
  onclick=function(view)
    local rootview=view.getParent().getParent().getParent().getParent()
    local 用户id=rootview.Tag.people_id.text
    local following=rootview.Tag.following
    if following.Text=="关注"
      zHttp.post("https://api.zhihu.com/people/"..用户id.."/followers","",posthead,function(a,b)
        if a==200 then
          following.Text="取关";
         elseif a==500 then
          提示("请登录后使用本功能")
        end
      end)
     elseif following.Text=="取关"
      zHttp.delete("https://api.zhihu.com/people/"..用户id.."/followers/"..activity.getSharedData("idx"),posthead,function(a,b)
        if a==200 then
          following.Text="关注";
        end
      end)
     else
      提示("加载中")
    end
  end
  判断文本=function(v)
    local 文本
    if v.is_following then
      文本="取关";
     else
      文本="关注";
    end
    return 文本
  end
end

tabv.setVisibility(8)
itemc=获取适配器项目布局("people/people_list")


history_list.setDividerHeight(0)
adp=MyLuaAdapter(activity,itemc)
history_list.Adapter=adp

function 刷新()
  geturl=myurl or murl
  zHttp.get(geturl,head,function(code,content)
    if code==200 then
      if luajson.decode(content).paging.next then
        testurl=luajson.decode(content).paging.next
        if testurl:find("http://") then
          testurl=string.gsub(testurl,"http://","https://",1)
        end
        myurl=testurl
      end
      if luajson.decode(content).paging.is_end and isclear~="clear" then
        提示("已经没有更多内容了")
       else
        add=true
      end
      for i,v in ipairs(luajson.decode(content).data) do
        if v.type=="people" then
          local 头像=v.avatar_url
          local 名字=v.name
          local 签名=v.headline
          local 用户id=v.id
          local 文本
          if 签名=="" then
            签名="无签名"
          end

          文本=判断文本(v)

          history_list.Adapter.add{
            people_image=头像,
            username=名字,
            userheadline=签名,
            people_id=用户id,
            following={
              Text=文本;
              onClick=function(view)
                onclick(view)
              end
            },
          }
        end
      end
    end
  end)
end

history_list.onItemClick=function(l,v,c,b)
  activity.newActivity("people",{v.Tag.people_id.text})
end

add=true

history_list.setOnScrollListener{
  onScroll=function(view,a,b,c)
    if a+b==c and add then
      add=false
      刷新()
      System.gc()
    end
  end
}

task(1,function()
  if 是否屏蔽 then
    a=MUKPopu({
      tittle=_title.text,
      list={
        {src=图标("format_align_left"),text="全部黑名单",onClick=function()
            history_list.Adapter.clear()
            add=true
            myurl=false
            murl="https://api.zhihu.com/settings/blocked_users?filter=all"
        end},
        {src=图标("notes"),text="瓦力黑名单",onClick=function()
            history_list.Adapter.clear()
            add=true
            myurl=false
            murl="https://api.zhihu.com/settings/blocked_users?filter=walle"
        end},
      }
    })
   else
    a=MUKPopu({
      tittle=_title.text,
      list={

      }
    })
  end
end)