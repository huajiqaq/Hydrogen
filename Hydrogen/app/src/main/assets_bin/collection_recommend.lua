require "import"
import "mods.muk"
activity.setContentView(loadlayout("layout/simple"))


波纹({fh,_more},"圆主题")

初始化历史记录数据(true)

_title.text="推荐关注收藏夹"


collection_recommend_item=获取适配器项目布局("collections/collection_recommend")


collection_recommend_pagetool=require "model.collection_recommend":new(id)
:initpage(simple_recy,simplesr)

task(1,function()
  a=MUKPopu({
    tittle=_title.text,
    list={

    }
  })
end)