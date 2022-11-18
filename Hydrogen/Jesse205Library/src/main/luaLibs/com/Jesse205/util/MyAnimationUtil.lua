--module(...,package.seeall)
local MyAnimationUtil={}
import "android.animation.ObjectAnimator"
import "android.view.animation.DecelerateInterpolator"
import "android.view.animation.AccelerateInterpolator"

--保存一下ActionBar，快速响应
MyAnimationUtil.actionBar=actionBar or activity.getSupportActionBar()

LastActionBarElevation=0

--ListView动画
--[[
效果：
1.当ListView未在顶端时打开ActionBar阴影
2.当ListView在顶端时关闭阴影
]]

MyAnimationUtil.ListView={}
function MyAnimationUtil.ListView.onScroll(view,firstVisibleItem,visibleItemCount,totalItemCount,actionBar,contrast,mandatory)
  if notSafeModeEnable then
    local contrast=contrast or "LastActionBarElevation"
    local childView=view.getChildAt(0)
    if childView then
      local top=childView.getTop()
      if (top>=0 and firstVisibleItem==0) and (_G[contrast]~=0 or mandatory) then
        _G[contrast]=0
        MyAnimationUtil.ActionBar.closeElevation(actionBar)
       elseif (top<0 or firstVisibleItem>0) and (_G[contrast]==0 or mandatory) then
        _G[contrast]=theme.number.actionBarElevation
        MyAnimationUtil.ActionBar.openElevation(actionBar)
      end
     else
      _G[contrast]=0
      MyAnimationUtil.ActionBar.closeElevation(actionBar)
    end
  end
end

--RecyclerView动画
--[[
效果：
1.当RecyclerView未在顶端时打开ActionBar阴影
2.当RecyclerView在顶端时关闭阴影
]]
MyAnimationUtil.RecyclerView={}
function MyAnimationUtil.RecyclerView.onScroll(view,dx,dy,actionBar,contrast,mandatory)
  if notSafeModeEnable then
    local contrast=contrast or "LastActionBarElevation"
    local canScroll=view.canScrollVertically(-1)
    if not(canScroll) and (_G[contrast]~=0 or mandatory) then
      _G[contrast]=0
      MyAnimationUtil.ActionBar.closeElevation(actionBar)
     elseif canScroll and (_G[contrast]==0 or mandatory) then
      _G[contrast]=theme.number.actionBarElevation
      MyAnimationUtil.ActionBar.openElevation(actionBar)
    end
  end
end

--ScrollView动画
--[[
效果：
1.当ScrollView未在顶端时打开ActionBar阴影
2.当ScrollView在顶端时关闭阴影
]]
MyAnimationUtil.ScrollView={}
function MyAnimationUtil.ScrollView.onScrollChange(view,l,t,oldl,oldt,actionBar,contrast,mandatory)
  if notSafeModeEnable then
    local contrast=contrast or "LastActionBarElevation"
    if t<=0 and (_G[contrast]~=0 or mandatory) then
      _G[contrast]=0
      MyAnimationUtil.ActionBar.closeElevation(actionBar)
     elseif t>0 and (_G[contrast]==0 or mandatory) then
      _G[contrast]=theme.number.actionBarElevation
      MyAnimationUtil.ActionBar.openElevation(actionBar)
    end
  end
end

--ActionBar动画
--[[
效果：
1.开启/关闭ActionBar阴影
]]
MyAnimationUtil.ActionBar={}
function MyAnimationUtil.ActionBar.openElevation(actionBar)
  return ObjectAnimator.ofFloat(actionBar or MyAnimationUtil.actionBar, "elevation", {theme.number.actionBarElevation})
  .setDuration(200)
  .setInterpolator(DecelerateInterpolator())
  .start()
end

function MyAnimationUtil.ActionBar.closeElevation(actionBar)
  return ObjectAnimator.ofFloat(actionBar or MyAnimationUtil.actionBar, "elevation", {0})
  .setDuration(200)
  .setInterpolator(AccelerateInterpolator())
  .start()
end

return MyAnimationUtil