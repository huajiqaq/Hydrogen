require "import"
-- 新增 使用自定义toolbar
useCustomAppToolbar=true
import "jesse205"
import "android.text.method.LinkMovementMethod"
import "android.text.util.Linkify"

import "licences"
import "item"

activity.setTitle(R.string.jesse205_openSourceLicense)

import "com.google.android.material.appbar.AppBarLayout"
import "com.google.android.material.appbar.MaterialToolbar"
import "androidx.appcompat.widget.LinearLayoutCompat"
import "androidx.core.widget.NestedScrollView"

activity.setContentView(loadlayout("layout",_ENV))
--actionBar.setDisplayHomeAsUpEnabled(true)
activity.setSupportActionBar(toolbar)
activity.SupportActionBar.setDisplayHomeAsUpEnabled(true)

local originalTitle = toolbar.getTitle();
for i=0,toolbar.getChildCount() do
  local view = toolbar.getChildAt(i);
  if luajava.instanceof(view,TextView) then
    local textView = view;
    if textView.getText()==originalTitle then
      textView.setTextSize(18)
    end
  end
end


fileBasePath=activity.getLuaPath("../../licences/%s.txt")

function onOptionsItemSelected(item)
  local id=item.getItemId()
  if id==android.R.id.home then
    activity.finish()
  end
end

function onConfigurationChanged(config)
  screenConfigDecoder:decodeConfiguration(config)
end

adapter=LuaCustRecyclerAdapter(AdapterCreator({
  getItemCount=function()
    return #licences
  end,
  getItemViewType=function(position)
    return 0
  end,
  onCreateViewHolder=function(parent,viewType)
    local ids={}
    local view=loadlayout2(item,ids)
    local holder=LuaCustRecyclerHolder(view)
    view.setTag(ids)
    local cardViewChild=ids.cardViewChild
    local licenseView=ids.license
    cardViewChild.setBackground(ThemeUtil.getRippleDrawable(theme.color.rippleColorPrimary))
    cardViewChild.onClick=function()
      local url=ids._data.url
      if url then
        openUrl(url)
      end
    end
    licenseView.setBackground(ThemeUtil.getRippleDrawable(theme.color.rippleColorPrimary,true))
    licenseView.onClick=function(view)
      local data=ids._data
      local path=data.path
      if path then
        newSubActivity("HtmlFileViewer",{{title=data.license or data.licenseName,path=path,text=true}})
      end
    end
    return holder
  end,

  onBindViewHolder=function(holder,position)
    local data=licences[position+1]
    local tag=holder.view.getTag()
    tag._data=data
    local name=data.name
    local message=data.message
    local license=data.license
    local licenseName=data.licenseName
    tag.name.text=name

    local messageView=tag.message
    local licenseView=tag.license
    if message then
      messageView.text=message
      messageView.setVisibility(View.VISIBLE)
     else
      messageView.setVisibility(View.GONE)
    end
    if license then
      licenseView.text=licenseName or license
      licenseView.setVisibility(View.VISIBLE)
      local filePath=fileBasePath:format(license or licenseName)
      local paint=licenseView.getPaint()
      if File(filePath).isFile() then
        data.path=filePath
      end
     else
      licenseView.setVisibility(View.GONE)
    end
    tag.cardViewChild.setClickable(toboolean(data.url))
  end,
}))

layoutManager=StaggeredGridLayoutManager(1,StaggeredGridLayoutManager.VERTICAL)
recyclerView.setPadding(math.dp2int(8),0,math.dp2int(8),0)
recyclerView.setAdapter(adapter)
recyclerView.setLayoutManager(layoutManager)
recyclerView.addOnScrollListener(RecyclerView.OnScrollListener{
  onScrolled=function(view,dx,dy)
    MyAnimationUtil.RecyclerView.onScroll(view,dx,dy,sideAppBarLayout,"LastSideActionBarElevation")
  end
})
recyclerView.getViewTreeObserver().addOnGlobalLayoutListener({
  onGlobalLayout=function()
    if activity.isFinishing() then
      return
    end
    MyAnimationUtil.RecyclerView.onScroll(recyclerView,0,0,sideAppBarLayout,"LastSideActionBarElevation")
  end
})

screenConfigDecoder=ScreenFixUtil.ScreenConfigDecoder({
  layoutManagers={layoutManager},
})

onConfigurationChanged(activity.getResources().getConfiguration())