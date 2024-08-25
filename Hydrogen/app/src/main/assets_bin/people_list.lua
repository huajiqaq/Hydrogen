require "import"
import "mods.muk"
activity.setContentView(loadlayout("layout/simple"))

波纹({fh,_more},"圆主题")

初始化历史记录数据(true)

title,people_id=...
_title.text=title

if title:find("关注") then
  类型="followees"
 elseif title:find("粉丝") then
  类型="followers"
 else
  类型="block_all"
end

peopeo_list_item=获取适配器项目布局("people/people_list")

people_list_base=require "model.people_list":new(people_id,类型)
:initpage(simple_recy,simplesr)

task(1,function()
  if 类型:find("block") then
    a=MUKPopu({
      tittle=_title.text,
      list={
        {src=图标("format_align_left"),text="全部黑名单",onClick=function()
            simple_list.Adapter.clear()
            add=true
            myurl=false
            murl="https://api.zhihu.com/settings/blocked_users?filter=all"
        end},
        {src=图标("notes"),text="瓦力黑名单",onClick=function()
            simple_list.Adapter.clear()
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