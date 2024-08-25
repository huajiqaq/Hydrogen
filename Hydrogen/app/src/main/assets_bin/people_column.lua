require "import"
import "mods.muk"
activity.setContentView(loadlayout("layout/simple"))

波纹({fh,_more},"圆主题")

初始化历史记录数据(true)

id=...
_title.text="专栏"

peple_column_item=获取适配器项目布局("people/people_column")

保存历史记录(title,"专栏分割"..id,50)

people_list_column_base=require "model.people_column":new(id)
:initpage(simple_recy,simplesr)

task(1,function()
  a=MUKPopu({
    tittle=_title.text,
    list={

    }
  })
end)