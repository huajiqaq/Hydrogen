require "import"
useCustomAppToolbar=true
import "jesse205"
local normalkeys=jesse205.normalkeys

normalkeys.scroll=true

import "com.google.android.material.appbar.AppBarLayout"
import "com.google.android.material.appbar.MaterialToolbar"
import "androidx.appcompat.widget.LinearLayoutCompat"
import "androidx.core.widget.NestedScrollView"

import "android.widget.GridView"
import "com.jesse205.layout.innocentlayout.GridViewLayout"
import "item"
activity.getWindow().requestFeature(Window.FEATURE_ACTIVITY_TRANSITIONS)
activity.setTitle(R.string.jesse205_themePicker)
activity.setContentView(loadlayout("layout"))
--content.setBackgroundColor(MaterialColors.getColor(this, R.attr.colorSurface,0))
activity.setSupportActionBar(toolbar)
activity.SupportActionBar.setDisplayHomeAsUpEnabled(true)

local originalTitle = toolbar.getTitle();
for i=0,toolbar.getChildCount() do
  local view = toolbar.getChildAt(i);
  if luajava.instanceof(view,TextView) then
    local textView = view;
    if textView.getText()==originalTitle then
      textView.setGravity(Gravity.CENTER);
      params = Toolbar.LayoutParams(Toolbar.LayoutParams.WRAP_CONTENT, Toolbar.LayoutParams.MATCH_PARENT);
      params.gravity = Gravity.CENTER;
      textView.setLayoutParams(params);
      textView.setTextSize(18)
    end
  end
end


MaterialSharedAxis=luajava.bindClass("com.google.android.material.transition.platform.MaterialSharedAxis")
enter= MaterialSharedAxis(MaterialSharedAxis.X, true)
enter.addTarget(mainLay)
--mainLay.setBackgroundColor(MaterialColors.getColor(this, R.attr.colorSurface,0))
activity.getWindow().setEnterTransition(enter)
activity.getWindow().setAllowEnterTransitionOverlap(true)

toolbar.Title=activity.getTitle()
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
  if content.name=="Default" then
    themestr="blue"
   elseif content.name=="Monet" then
    themestr="blue"
   else
    themestr=string.lower(content.name)
  end

  local item={
    title={text=content.show.name},
    nowtext={},
    preview={cardBackgroundColor=ContextCompat.getColor(activity.getContext(),R.color["md_theme_"..themestr.."_primaryContainer"])},
    preview_image={colorFilter=ContextCompat.getColor(activity.getContext(),R.color["md_theme_"..themestr.."_primary"])},
    cbg={cardBackgroundColor=ContextCompat.getColor(activity.getContext(),R.color["md_theme_"..themestr.."_surfaceVariant"])},
    accent1={cardBackgroundColor=ContextCompat.getColor(activity.getContext(),R.color["md_theme_"..themestr.."_primary"])},
    accent2={cardBackgroundColor=ContextCompat.getColor(activity.getContext(),R.color["md_theme_"..themestr.."_secondary"])},
    accent3={cardBackgroundColor=ContextCompat.getColor(activity.getContext(),R.color["md_theme_"..themestr.."_tertiary"])},
    accent4={cardBackgroundColor=ContextCompat.getColor(activity.getContext(),R.color["md_theme_"..themestr.."_primaryContainer"])},

    key=content.name,
    message={},
  }
  table.insert(data,item)
  if nowTheme==content.name then
    item.now={visibility=View.VISIBLE}
   else
    item.now={visibility=View.INVISIBLE}
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

--[[mainLay.ViewTreeObserver
.addOnGlobalLayoutListener(ScreenFixUtil.LayoutListenersBuilder.gridViews(mainLay,{gridView}))
]]
