require "import"
import "mods.muk"
 if inSekai then
if fn[#fn][2]<2
  local t = activity.getSupportFragmentManager().beginTransaction()
  t.setCustomAnimations(
  android.R.anim.slide_in_left,
  android.R.anim.slide_out_right,
  android.R.anim.slide_in_left,
  android.R.anim.slide_out_right)
  --t.remove(activity.getSupportFragmentManager().findFragmentByTag("answer"))
  t.add(f2.getId(),LuaFragment(loadlayout("layout/simple")),"collection_recommend")
  t.addToBackStack(nil)
  t.commit()
  table.insert(fn,{"collection_recommend",2})
else
local t = activity.getSupportFragmentManager().beginTransaction()
  t.setCustomAnimations(
  android.R.anim.slide_in_left,
  android.R.anim.slide_out_right,
  android.R.anim.slide_in_left,
  android.R.anim.slide_out_right)
  --t.remove(activity.getSupportFragmentManager().findFragmentByTag("answer"))
  t.add(f1.getId(),LuaFragment(loadlayout("layout/simple")),"collection_recommend")
  t.addToBackStack(nil)
  t.commit()
  table.insert(fn,{"collection_recommend",1})
end
 else
  activity.setContentView(loadlayout("layout/simple"))
end
波纹({fh,_more},"圆主题")
edgeToedge(nil,nil,function() local layoutParams = topbar.LayoutParams;
  layoutParams.setMargins(layoutParams.leftMargin, 状态栏高度, layoutParams.rightMargin,layoutParams.bottomMargin);
  topbar.setLayoutParams(layoutParams); end)


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