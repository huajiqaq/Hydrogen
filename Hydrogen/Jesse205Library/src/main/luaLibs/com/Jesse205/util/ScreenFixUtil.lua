local ScreenFixUtil={}
local resources=resources
--[[
function ScreenFixUtil.getNavigationBarHeight()
  local resourceId = resources.getIdentifier("navigation_bar_height","dimen", "android");
  local height = resources.getDimensionPixelSize(resourceId)
  return height
end
function ScreenFixUtil.getStatusBarHeight()
  local resourceId=resources.getIdentifier("status_bar_height", "dimen","android")
  local height=resources.getDimensionPixelSize(resourceId)
  return height
end

function ScreenFixUtil.getSmallestScreenWidthDp()
  return resources.getConfiguration().smallestScreenWidthDp
end

function ScreenFixUtil.getScreenRealSize()
  import "android.util.DisplayMetrics"
  local wm=activity.getSystemService(Context.WINDOW_SERVICE)
  local displayMetrics=DisplayMetrics()
  wm.getDefaultDisplay().getRealMetrics(displayMetrics)
  return displayMetrics.widthPixels,displayMetrics.heightPixels
end]]

function ScreenFixUtil.getDensityDpi()
  import "android.util.DisplayMetrics"
  local dm=DisplayMetrics()
  activity.WindowManager.getDefaultDisplay().getMetrics(dm)
  return dm.densityDpi
end

local function getViewSize(view)
  return view.getMeasuredWidth(),view.getMeasuredHeight()
end
ScreenFixUtil.getViewSize=getViewSize

local function setLayoutManagersSpanCount(layoutManagers,count)
  if layoutManagers then
    for index=1,#layoutManagers do
      layoutManagers[index].setSpanCount(count)
    end
  end
end
ScreenFixUtil.setLayoutManagersSpanCount=setLayoutManagersSpanCount

local function setLayoutsOrientation(lays,orientation)
  if lays then
    for index=1,#lays do
      lays[index].setOrientation(orientation)
    end
  end
end
ScreenFixUtil.setLayoutsOrientation=setLayoutsOrientation

local function setLayoutsSize(lays,height,width)
  if lays then
    for index=1,#lays do
      local content=lays[index]
      local linearParams=content.getLayoutParams()
      if height then
        linearParams.height=height
      end
      if width then
        linearParams.width=width
      end
      content.setLayoutParams(linearParams)
    end
  end
end
ScreenFixUtil.setLayoutsSize=setLayoutsSize


local function setGridViewsNumColumns(gridViews,columns)
  if gridViews then
    for index=1,#gridViews do
      gridViews[index].setNumColumns(columns)
    end
  end
end
ScreenFixUtil.setGridViewsNumColumns=setGridViewsNumColumns

local function getDeviceTypeFromWidth(width)
  if width<theme.number.Dimension.padWidth then--判断设备类型
    return "phone"
   elseif width<theme.number.Dimension.pcWidth then
    return "pad"
   else
    return "pc"
  end
end
ScreenFixUtil.getDeviceTypeFromWidth=getDeviceTypeFromWidth

local function getDeviceTypeFromWidthDp(widthDp)
  if widthDp<theme.number.padWidthDp then--判断设备类型
    return "phone"
   elseif widthDp<theme.number.pcWidthDp then
    return "pad"
   else
    return "pc"
  end
end
ScreenFixUtil.getDeviceTypeFromWidthDp=getDeviceTypeFromWidthDp

local LayoutListenersBuilder={
  singleCardViews=function(parentView,views)
    local oldWidth=0
    return function()
      local width=parentView.getMeasuredWidth()
      if oldWidth~=width then
        if width>math.dp2int(640+32) then
          setLayoutsSize(views,nil,math.dp2int(640))
         else
          setLayoutsSize(views,nil,-1)
        end
        oldWidth=width
      end
    end
  end,
  layoutManagers=function(parentView,layoutManagers)
    local oldWidth=0
    return function()
      local width=parentView.getMeasuredWidth()
      if oldWidth~=width then
        local device=getDeviceTypeFromWidth(width)
        if device=="phone" then--手机视图，横向2个
          setLayoutManagersSpanCount(layoutManagers,1)
         elseif device=="pad" then--平板视图，横向4个
          setLayoutManagersSpanCount(layoutManagers,2)
         elseif device=="pc" then--电脑视图，横向6个
          setLayoutManagersSpanCount(layoutManagers,4)
        end
        oldWidth=width

      end
    end
  end,
  gridViews=function(parentView,gridViews)
    local oldWidth=0
    return function()
      local width=parentView.getMeasuredWidth()
      if oldWidth~=width then
        local device=getDeviceTypeFromWidth(width)
        if device=="phone" then--手机视图
          setGridViewsNumColumns(gridViews,1)
         elseif device=="pad" then--平板视图
          setGridViewsNumColumns(gridViews,2)
         elseif device=="pc" then--电脑视图
          setGridViewsNumColumns(gridViews,4)
        end
        oldWidth=width

      end
    end
  end,
  listViews=function(parentView,listViews)
    local oldWidth=0
    return function()
      local width=parentView.getMeasuredWidth()
      if oldWidth~=width then
        if width<math.dp2int(704) then--屏幕宽度小于704dp，那就填充整个屏幕
          setLayoutsSize(listViews,nil,-1)
         elseif width<math.dp2int(1000) then--屏幕宽度大于等于704dp且小于1000dp，固定宽度为704dp
          setLayoutsSize(listViews,nil,math.dp2int(704))
         else--屏幕宽度大于等于1000dp，固定宽度为800dp
          setLayoutsSize(listViews,nil,math.dp2int(800))
        end
        oldWidth=width
      end
    end
  end,
  deviceByWidth=function(parentView,onDeviceByWidthChanged,defaultDevice)
    local oldWidth=0
    local device=defaultDevice or "phone"
    return function()
      local width=parentView.getMeasuredWidth()
      if oldWidth~=width then
        local newDevice=getDeviceTypeFromWidth(width)
        if newDevice~=device then
          onDeviceByWidthChanged(newDevice,device)
          device=newDevice
        end
        oldWidth=width
      end
    end
  end
}

ScreenFixUtil.LayoutListenersBuilder=LayoutListenersBuilder



local ScreenConfigDecoder={
  --device="phone",
  deviceByWidth="phone",
}
ScreenFixUtil.ScreenConfigDecoder=ScreenConfigDecoder
setmetatable(ScreenConfigDecoder,ScreenConfigDecoder)

--[[
{
  device={
    phone=function()
    pad=function()
    pc=function()
    }
  orientation={
    identical={LinearLayout...}
    different={LinearLayout...}
    }
  fillParent={View...}
  layoutManagers={LayoutManager...}
  singleCardViews={View...}
  }
]]
function ScreenConfigDecoder.__call(self,events)
  self=table.clone(self)
  self.events=events
  return self
end

function ScreenConfigDecoder.decodeConfiguration(self,config)
  local smallestScreenWidthDp=config.smallestScreenWidthDp--最小宽度（dp）
  local screenWidthDp=config.screenWidthDp--屏幕宽度（单位为dp）
  local screenWidth=math.dp2int(screenWidthDp)--转换为像素

  local events=self.events
  local orientationLays=events.orientation
  local layoutManagers=events.layoutManagers--用于设置横向数目
  local singleCardViews=events.singleCardViews--用于设置卡片最大宽度
  local listViews=events.listViews--列表的
  local gridViews=events.gridViews--和layoutManagers作用差不多
  local fillParentViews=events.fillParentViews--充填的

  local onDeviceChanged=events.onDeviceChanged--当设备类型切换时调用
  local onDeviceByWidthChanged=events.onDeviceByWidthChanged--当以屏幕宽度判断的设备切换时调用
  local identicalLays,differentLays--同向，异向（屏幕方向）
  local orientation=config.orientation


  if orientationLays then
    identicalLays=orientationLays.identical
    differentLays=orientationLays.different
  end

  --local oldDevice=self.device
  local oldDeviceByWidth=self.deviceByWidth

  local device,deviceByWidth
  --[[
  if smallestScreenWidthDp~=self.smallestScreenWidthDp then--最小宽度改变时
    device=getDeviceTypeFromWidthDp(smallestScreenWidthDp)
    self.smallestScreenWidthDp=smallestScreenWidthDp
    self.device=device
   else--没改变最小宽度，说明设备类型没改变
    device=oldDevice
  end]]

  if screenWidthDp~=self.screenWidthDp then--最小宽度改变时
    deviceByWidth=getDeviceTypeFromWidthDp(screenWidthDp)
    self.screenWidthDp=screenWidthDp
    self.deviceByWidth=deviceByWidth
   else--没改变最小宽度，说明设备类型没改变
    deviceByWidth=oldDeviceByWidth
  end


  if orientation~=self.orientation or device~=self.device then--切换屏幕方向或切换设备类型时

    if orientation==Configuration.ORIENTATION_LANDSCAPE then--横屏时
      setLayoutsOrientation(identicalLays,LinearLayout.HORIZONTAL)
      setLayoutsOrientation(differentLays,LinearLayout.VERTICAL)
      setLayoutsSize(fillParentViews,-1,-2)
      --[[
      if device=="phone" then--手机视图，横向2个
        setLayoutManagersSpanCount(layoutManagers,2)
        setGridViewsNumColumns(gridViews,2)
       elseif device=="pad" then--平板视图，横向4个
        setLayoutManagersSpanCount(layoutManagers,4)
        setGridViewsNumColumns(gridViews,4)
       elseif device=="pc" then--电脑视图，横向6个
        setLayoutManagersSpanCount(layoutManagers,6)
        setGridViewsNumColumns(gridViews,6)
      end]]
     else
      setLayoutsOrientation(identicalLays,LinearLayout.VERTICAL)
      setLayoutsOrientation(differentLays,LinearLayout.HORIZONTAL)
      setLayoutsSize(fillParentViews,-2,-1)
      --[[
      if device=="phone" then--手机视图，横向1个
        setLayoutManagersSpanCount(layoutManagers,1)
        setGridViewsNumColumns(gridViews,1)
       elseif device=="pad" then--平板视图，横向2个
        setLayoutManagersSpanCount(layoutManagers,2)
        setGridViewsNumColumns(gridViews,2)
       elseif device=="pc" then--电脑视图，横向4个
        setLayoutManagersSpanCount(layoutManagers,4)
        setGridViewsNumColumns(gridViews,4)
      end]]
    end
    self.orientation=config.orientation
  end


  if deviceByWidth=="phone" then--手机视图
    setLayoutManagersSpanCount(layoutManagers,1)
    setGridViewsNumColumns(gridViews,1)
   elseif deviceByWidth=="pad" then--平板视图
    setLayoutManagersSpanCount(layoutManagers,2)
    setGridViewsNumColumns(gridViews,2)
   elseif deviceByWidth=="pc" then--电脑视图
    setLayoutManagersSpanCount(layoutManagers,4)
    setGridViewsNumColumns(gridViews,4)
  end


  if singleCardViews then
    if screenWidthDp>640+32 then
      setLayoutsSize(singleCardViews,nil,math.dp2int(640))
     else
      setLayoutsSize(singleCardViews,nil,-1)
    end
  end

  if listViews then
    if screenWidthDp<704 then--屏幕宽度小于704dp，那就填充整个屏幕
      setLayoutsSize(listViews,nil,-1)
     elseif screenWidthDp<1000 then--屏幕宽度大于等于704dp且小于1000dp，固定宽度为704dp
      setLayoutsSize(listViews,nil,math.dp2int(704))
     else--屏幕宽度大于等于1000dp，固定宽度为800dp
      setLayoutsSize(listViews,nil,math.dp2int(800))
    end
  end

  self:decodeMenus(screenWidthDp)

  if deviceByWidth~=oldDeviceByWidth then--设备类型切换时
    if onDeviceByWidthChanged then
      onDeviceByWidthChanged(deviceByWidth,oldDeviceByWidth)
    end
  end

end

function ScreenConfigDecoder.decodeMenus(self,screenWidthDp)
  local events=self.events
  local menus=events.menus
  if menus then
    if self.menuAppliedWidthDp~=screenWidthDp then
      self.menuAppliedWidthDp=screenWidthDp
      for showWidthDp,content in pairs(menus) do
        for index=1,#content do
          local menuItem=content[index]
          if showWidthDp<=screenWidthDp then
            MenuItemCompat.setShowAsAction(menuItem, MenuItemCompat.SHOW_AS_ACTION_ALWAYS)
           else
            MenuItemCompat.setShowAsAction(menuItem, MenuItemCompat.SHOW_AS_ACTION_NEVER)
          end
        end
      end
    end
  end
end

return ScreenFixUtil
