require "import"
import "mods.muk"
import "com.lua.*"

collections_id=...

if inSekai then
local t = activity.getSupportFragmentManager().beginTransaction()
  t.setCustomAnimations(
  android.R.anim.slide_in_left,
  android.R.anim.slide_out_right,
  android.R.anim.slide_in_left,
  android.R.anim.slide_out_right)
  --t.remove(activity.getSupportFragmentManager().findFragmentByTag("answer"))
  t.add(f1.getId(),LuaFragment(loadlayout("layout/collections")),"collections")
  t.addToBackStack(nil)
  t.commit()
  table.insert(fn,{"collections",1})
 else
  activity.setContentView(loadlayout("layout/collections"))
end
collections_base=require "model.collections":new(collections_id)
:getData(function(tab)

  collection_pagetool=collections_base:initpage(collection_recy,collectionsr)

  _title.Text=tab.title
  
  local isfollow=tab.creator.id~=this.getSharedData("idx")

  if isfollow then
    local mview=pop.list[3]
    mview.onClick=function(text)
      if text=="关注" then
        zHttp.post("https://api.zhihu.com/collections/"..collections_id.."/followers","",posthead,function(code,json)
          if code==200 then
            mview.src=图标("close")
            mview.text="取关"
            提示("已关注")
            a=MUKPopu(pop)
            activity.setResult(1600,nil)
          end
        end)
       else
        zHttp.delete("https://api.zhihu.com/collections/"..collections_id.."/followers/"..activity.getSharedData("idx"),head,function(code,json)
          if code==200 then
            提示("已取关")
            mview.src=图标("add")
            mview.text="关注"
            a=MUKPopu(pop)
            activity.setResult(1600,nil)
          end
        end)
      end
    end
    table.remove(pop.list,2)
    if tab.is_following then
      mview.src=图标("close")
      mview.text="取关"
     else
      mview.src=图标("add")
      mview.text="关注"
    end
    a=MUKPopu(pop)

  end

end)

初始化历史记录数据(true)

波纹({fh,_more},"圆主题")

collection_item=获取适配器项目布局("collections/collections")

pop={
  tittle="收藏",
  list={

    {src=图标("email"),text="反馈",onClick=function()
        activity.newActivity("feedback")
    end},

    {src=图标("close"),text="删除收藏夹",onClick=function()
        if not(collections_id) then
          return 提示("本地收藏不支持此功能")
        end
        双按钮对话框("删除收藏夹","删除收藏夹？该操作不可撤消！","是的","点错了",function(an)
          an.dismiss()
          zHttp.delete("https://api.zhihu.com/collections/"..collections_id,head,function(code,json)
            if code==200 then
              提示("已删除")
              activity.setResult(1600,nil)
            end
          end)
        end,function(an)an.dismiss()end)
    end},
    {
      src=图标("close"),text="举报",onClick=function()
        local url="https://www.zhihu.com/report?id="..collections_id.."&type=favlist"
        newActivity("browser",{url.."&source=android&ab_signature=","举报"})
      end
    },
  }
}

a=MUKPopu(pop)