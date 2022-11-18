require "import"
import "Jesse205"
import "com.Jesse205.layout.util.SettingsLayUtil"
import "com.Jesse205.layout.innocentlayout.RecyclerViewLayout"
import "com.Jesse205.app.dialog.EditDialogBuilder"

packageInfo=activity.getPackageManager().getPackageInfo(getPackageName(),0)

import "settings"

activity.setTitle(R.string.settings)
activity.setContentView(loadlayout2(RecyclerViewLayout))

actionBar.setDisplayHomeAsUpEnabled(true)

oldTheme=ThemeUtil.getAppTheme()

configType,config=...

function onOptionsItemSelected(item)
  local id=item.getItemId()
  if id==android.R.id.home then
    activity.finish()
  end
end

function onResume()
  if oldTheme~=ThemeUtil.getAppTheme() then
    activity.recreate()
  end
end

function reloadActivity(closeViews)
  local aRanim=android.R.anim
  local pos,scroll
  if recyclerView then
    if closeViews then
      activity.getDecorView().addView(View(activity).setClickable(true))
    end
    pos=layoutManager.findFirstVisibleItemPosition()
    scroll=recyclerView.getChildAt(0).getTop()
  end
  newActivity("main",aRanim.fade_in,aRanim.fade_out,{"scroll",{pos,scroll}})
  activity.finish()
end

function onItemClick(view,views,key,data)
  if key=="theme_picker" then
    newSubActivity("ThemePicker")
   elseif key=="about" then
    newSubActivity("About")
   elseif key=="theme_darkactionbar" then
    reloadActivity({view,views.switchView})
   else
    if data.action=="editString" then
      EditDialogBuilder.settingDialog(adapter,views,key,data)
    end
  end
end

adapter=SettingsLayUtil.newAdapter(settings,onItemClick)
recyclerView.setAdapter(adapter)
layoutManager=LinearLayoutManager()
recyclerView.setLayoutManager(layoutManager)
recyclerView.addOnScrollListener(RecyclerView.OnScrollListener{
  onScrolled=function(view,dx,dy)
    MyAnimationUtil.RecyclerView.onScroll(view,dx,dy)
  end
})
recyclerView.getViewTreeObserver().addOnGlobalLayoutListener({
  onGlobalLayout=function()
    if activity.isFinishing() then
      return
    end
    MyAnimationUtil.RecyclerView.onScroll(recyclerView,0,0)
  end
})
mainLay.onTouch=function(view,...)
  recyclerView.onTouchEvent(...)
end


if config then
  config=luajava.astable(config)
  if tostring(configType)=="scroll" then
    layoutManager.scrollToPositionWithOffset(config[1],config[2])
  end
end

mainLay.ViewTreeObserver
.addOnGlobalLayoutListener(ScreenFixUtil.LayoutListenersBuilder.listViews(mainLay,{recyclerView}))