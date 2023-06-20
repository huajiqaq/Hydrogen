require "import"
import "jesse205"
local normalkeys=jesse205.normalkeys

normalkeys.scroll=true

import "android.widget.GridView"
import "com.jesse205.layout.innocentlayout.GridViewLayout"
import "item"

activity.setTitle(R.string.jesse205_themePicker)
activity.setContentView(loadlayout2(GridViewLayout))
activity.getSupportActionBar().setDisplayHomeAsUpEnabled(true)

function onOptionsItemSelected()
  activity.finish()
end


gridView.onScroll=function(view,firstVisibleItem,visibleItemCount,totalItemCount)
  MyAnimationUtil.ListView.onScroll(view,firstVisibleItem,visibleItemCount,totalItemCount)
end

local nowTheme=ThemeUtil.getAppTheme()

data={}
adapter=LuaAdapter(activity, data,item)
gridView.setAdapter(adapter)

for index,content in pairs(ThemeUtil.getAppThemes()) do
  --print(index)
  local item={
    title={text=content.show.name},
    preview={cardBackgroundColor=content.show.preview},
    key=content.name,
    message={},
  }
  table.insert(data,item)
  if nowTheme==content.name then
    item.now={visibility=View.VISIBLE}
   else
    item.now={visibility=View.GONE}
  end
end


adapter.notifyDataSetChanged()

scroll=...
if scroll then
  scroll=luajava.astable(scroll)
  gridView.setSelection(scroll[1])
end

gridView.onItemClick=function(id,v,zero,one)
  local key=data[one].key
  if nowTheme~=key then
    ThemeUtil.setAppTheme(key)
    local aRanim=android.R.anim
    local pos=gridView.getFirstVisiblePosition()
    local scroll=gridView.getChildAt(0).getTop()
    newActivity("main",aRanim.fade_in,aRanim.fade_out,{{pos,scroll}})
    activity.finish()
    gridView.setEnabled(false)
  end
end

mainLay.ViewTreeObserver
.addOnGlobalLayoutListener(ScreenFixUtil.LayoutListenersBuilder.gridViews(mainLay,{gridView}))

