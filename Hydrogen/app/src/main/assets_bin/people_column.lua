require "import"
import "mods.muk"
设置视图("layout/simple")

波纹({fh,_more},"圆主题")


id=...
_title.text="专栏"

peple_column_item=获取适配器项目布局("people/people_column")

people_list_column_base=require "model.people_column":new(id)
:initpage(simple_recy,simplesr)

task(1,function()
  a=MUKPopu({
    tittle=_title.text,
    list={

    }
  })
end)