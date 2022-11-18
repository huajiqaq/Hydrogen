local ThemeUtil={}

local context=Jesse205.context
local theme=_G.theme
local SDK_INT=Build.VERSION.SDK_INT
--local onColorChangedListeners={}
--local selectableItemBackgroundBorderless

ThemeUtil.APPTHEMES={
  {--深海蓝
    name="Default",
    show={
      name=R.string.Jesse205_theme_default,
      preview=0xff4477e0,
    },
  },

  {--水鸭绿
    name="Teal",
    show={
      name=R.string.Jesse205_theme_teal,
      preview=0xff009688,
    },
  },
  {--极客橙
    name="Orange",
    show={
      name=R.string.Jesse205_theme_orange,
      preview=0xFFFFA000,
    },
  },
  {--舒适粉
    name="Pink",
    show={
      name=R.string.Jesse205_theme_pink,
      preview=0xFFFF4081,
    },
  },
  {--新年红
    name="Red",
    show={
      name=R.string.Jesse205_theme_red,
      preview=0xfff44336,
    },
  },
}
ThemeUtil.NowAppTheme=nil

local Name2AppTheme={}
ThemeUtil.Name2AppTheme=Name2AppTheme
for index,content in ipairs(ThemeUtil.APPTHEMES)
  Name2AppTheme[content.name]=content
end


--判断是否是系统夜间模式
local function isSysNightMode()
  return (context.getResources().getConfiguration().uiMode&Configuration.UI_MODE_NIGHT_MASK)==Configuration.UI_MODE_NIGHT_YES
end
ThemeUtil.isSysNightMode=isSysNightMode--这个一般用不到
ThemeUtil.isNightMode=isSysNightMode

--刷新颜色
function ThemeUtil.refreshThemeColor()
  local contextTheme=context.getTheme()
  local array
  array = contextTheme.obtainStyledAttributes({
    android.R.attr.textColorTertiary,
    android.R.attr.textColorPrimary,--普通文字色（黑白）
    android.R.attr.colorPrimary,
    android.R.attr.colorPrimaryDark,
    android.R.attr.colorAccent,--强调色
    android.R.attr.navigationBarColor,--导航栏颜色
    android.R.attr.statusBarColor,--状态栏颜色
    android.R.attr.colorButtonNormal,
    android.R.attr.windowBackground,--背景颜色
    android.R.attr.textColorSecondary,
    R.attr.rippleColorPrimary,--普通波纹（黑白）
    R.attr.rippleColorAccent,--强调波纹
    R.attr.floatingActionButtonBackgroundColor,--悬浮按钮背景
    R.attr.colorBackgroundFloating,--悬浮的背景
    R.attr.strokeColor,--悬浮的背景
    --R.attr.titleTextColor,
    --R.attr.subtitleTextColor,
  })
  local colorList=theme.color
  colorList.textColorTertiary=array.getColor(0,0)
  colorList.textColorPrimary=array.getColor(1,0)
  colorList.colorPrimary=array.getColor(2,0)
  colorList.colorPrimaryDark=array.getColor(3,0)
  colorList.colorAccent=array.getColor(4,0)
  colorList.navigationBarColor=array.getColor(5,0)
  colorList.statusBarColor=array.getColor(6,0)
  colorList.colorButtonNormal=array.getColor(7,0)
  colorList.windowBackground=array.getColor(8,0)
  colorList.textColorSecondary=array.getColor(9,0)
  colorList.rippleColorPrimary=array.getColor(10,0)
  colorList.rippleColorAccent=array.getColor(11,0)
  colorList.floatingActionButtonBackgroundColor=array.getColor(12,0)
  colorList.colorBackgroundFloating=array.getColor(13,0)
  colorList.strokeColor=array.getColor(14,0)
  array.recycle()

  local numberList=theme.number
  array = contextTheme.obtainStyledAttributes({
    android.R.attr.selectableItemBackgroundBorderless,
    android.R.attr.selectableItemBackground,
    R.attr.actionBarTheme,
  })
  numberList.id.selectableItemBackgroundBorderless=array.getResourceId(0,0)
  numberList.id.selectableItemBackground=array.getResourceId(1,0)
  numberList.id.actionBarTheme=array.getResourceId(2,0)
  array.recycle()

  local booleanList=theme.boolean
  array = contextTheme.obtainStyledAttributes({
    R.attr.windowLightNavigationBar,
    R.attr.windowLightStatusBar,
  })
  booleanList.windowLightNavigationBar=array.getBoolean(0,false)
  booleanList.windowLightStatusBar=array.getBoolean(1,false)
  array.recycle()--回收数组

  local array = contextTheme.obtainStyledAttributes(numberList.id.actionBarTheme,{
    android.R.attr.textColorSecondary,
    R.attr.colorControlNormal,
  })
  local actionBarColorList=theme.color.ActionBar
  actionBarColorList.textColorSecondary=array.getColor(0,0)
  actionBarColorList.colorControlNormal=array.getColor(1,0)
  array.recycle()

  array = context.getTheme().obtainStyledAttributes(numberList.id.actionBarTheme,{
    R.attr.elevation,
  })
  numberList.actionBarElevation=array.getDimension(0,0)
  array.recycle()

  return colorList
end

--设置状态栏颜色
function ThemeUtil.setStatusBarColor(color)
  theme.color.statusBarColor=color--保存导航栏颜色
  window.setStatusBarColor(color)
  --ThemeUtil.callOnColorChangedListener("navigationBarColor",color)--响应导航栏颜色改变事件
  return color
end

--设置导航栏颜色
function ThemeUtil.setNavigationbarColor(color)
  theme.color.navigationBarColor=color--保存导航栏颜色
  window.setNavigationBarColor(color)--设置导航栏颜色
  --ThemeUtil.callOnColorChangedListener("navigationBarColor",color)--响应导航栏颜色改变事件
  return color
end

--获取波纹Drawable
function ThemeUtil.getRippleDrawable(color,square)
  local rippleId
  if square then
    rippleId=theme.number.id.selectableItemBackground
   else
    rippleId=theme.number.id.selectableItemBackgroundBorderless
  end
  local drawable=context.getResources().getDrawable(rippleId)--获取RippleDrawable

  if color then--要修改颜色
    if type(color)=="number" then--类型为数字
      drawable.setColor(ColorStateList({{}},{color}))
     else
      drawable.setColor(color)--类型不是数字，或是其他的，直接设置
    end
  end
  return drawable
end
--[[
function ThemeUtil.makeGradientDrawable(Thickness,FrameColor,InsideColor,radiu)
  import "android.graphics.drawable.GradientDrawable"
  local drawable = GradientDrawable()
  drawable.setShape(GradientDrawable.RECTANGLE)
  if Thickness and FrameColor then
    drawable.setStroke(Thickness, FrameColor)
  end
  drawable.setColor(InsideColor)
  if type(radiu)=="number" then
    drawable.setCornerRadius(radiu)
   elseif type(radiu)=="table" then
    drawable.setCornerRadii(radiu)
  end
  return drawable
end]]

--设置软件主题，如："Default"
local function setAppTheme(key)
  setSharedData("theme",key)
  return ThemeUtil
end
ThemeUtil.setAppTheme=setAppTheme

--设置获取软件主题，如："Default"
local function getAppTheme(key)
  return getSharedData("theme")
end
ThemeUtil.getAppTheme=getAppTheme

--刷新UI
function ThemeUtil.refreshUI()
  local themeKey,appTheme
  themeKey=getAppTheme()--获取当前设置的主题
  appTheme=Name2AppTheme[themeKey]--获取主题配置
  if not(appTheme) then--主图里面没有，可能是废除了这个主题
    themeKey="Default"
    appTheme=Name2AppTheme[themeKey]
    setAppTheme(themeKey)--自动设置会默认
  end


  --构建用的主题名字
  local themeString=("Theme_%s_%s"):format(Jesse205.themeType,themeKey)
  if getSharedData("theme_darkactionbar") then--如果是暗色ActionBar
    themeString=themeString.."_DarkActionBar"
  end
  if useCustomAppToolbar then--使用自定义的ToolBar
    themeString=themeString.."_NoActionBar"
  end

  activity.setTheme(R.style[themeString])--设置主题
  themeString=nil

  ThemeUtil.NowAppTheme=appTheme
  local systemUiVisibility=0
  --if not(decorView) then
  decorView=activity.getDecorView()--定要在设置主题之后调用
  --end
  local colorList=theme.color

  if not(useCustomAppToolbar) then
    local actionBar=context.getSupportActionBar()
    _G.actionBar=actionBar
    if actionBar then
      actionBar.setElevation(0)--关闭ActionBar阴影
    end
  end

  ThemeUtil.refreshThemeColor()--刷新一下颜色

  --[[
  if appTheme.color then--动态覆盖颜色
    for index,content in pairs(appTheme.color) do
      colorList[index]=content
    end
  end]]

  if theme.boolean.windowLightNavigationBar and SDK_INT>=26 and not(ThemeUtil.isNightMode()) and not(darkNavigationBar) then--主题默认亮色导航栏
    systemUiVisibility=systemUiVisibility|View.SYSTEM_UI_FLAG_LIGHT_NAVIGATION_BAR--设置亮色导航栏
  end

  if theme.boolean.windowLightStatusBar and SDK_INT >= 23 and not(darkStatusBar) then--默认是亮色状态栏并且不低于安卓6
    systemUiVisibility=systemUiVisibility|View.SYSTEM_UI_FLAG_LIGHT_STATUS_BAR
  end

  decorView.setSystemUiVisibility(systemUiVisibility)
  ThemeUtil.SystemUiVisibility=systemUiVisibility
end

return ThemeUtil