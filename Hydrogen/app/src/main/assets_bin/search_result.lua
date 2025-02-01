require "import"
import "mods.muk"
if inSekai then
  local t = activity.getSupportFragmentManager().beginTransaction()
  t.setCustomAnimations(
  android.R.anim.slide_in_left,
  android.R.anim.slide_out_right,
  android.R.anim.slide_in_left,
  android.R.anim.slide_out_right)
  t.add(f1.getId(),LuaFragment(loadlayout("layout/simple")))
  t.addToBackStack(nil)
  t.commit()
  table.insert(fn,{"search_result",1})
 else
  activity.setContentView(loadlayout("layout/simple"))
end
波纹({fh,_more},"圆主题")

初始化历史记录数据(true)

搜索内容,类型,id=...


_title.text="搜索结果"
search_result_item=获取适配器项目布局("search/search_result")

zse96_encrypt=require "model.zse96_encrypt"

search_result_pagetool=require "model.search_result":new(搜索内容,类型,id)
:initpage(simple_recy,simplesr)

task(1,function()
  a=MUKPopu({
    tittle=_title.text,
    list={

    }
  })
end)