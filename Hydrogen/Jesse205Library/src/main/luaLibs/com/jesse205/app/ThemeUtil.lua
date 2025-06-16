local ThemeUtil={}
local ThemeUtilJava=luajava.bindClass("com.jesse205.app.ThemeUtil")
local context=jesse205.context
local theme=_G.theme
local SDK_INT=Build.VERSION.SDK_INT

local supportedThemeName={
  Default=true,
  Monet=true,
  Teal=true,
  Orange=true,
  Pink=true,
  Red=true,
}

function ThemeUtil.getAppThemes()
  return {
    {--深海蓝
      name="Default",
      show={
        name=R.string.jesse205_theme_default,
        preview=0xff3F51B5,
      },
    },
    {--莫奈
      name="Monet",
      show={
        name="monet",
        preview=0xff3F51B5,
      },
    },

    {--水鸭绿
      name="Teal",
      show={
        name=R.string.jesse205_theme_teal,
        preview=0xff009688,
      },
    },
    {--极客橙
      name="Orange",
      show={
        name=R.string.jesse205_theme_orange,
        preview=0xFFFFA000,
      },
    },
    {--舒适粉
      name="Pink",
      show={
        name=R.string.jesse205_theme_pink,
        preview=0xFFFF4081,
      },
    },
    {--新年红
      name="Red",
      show={
        name=R.string.jesse205_theme_red,
        preview=0xFFD32F2F,
      },
    },
  }
end

--判断是否是系统夜间模式
local function isSysNightMode()
  return ThemeUtilJava.isSysNightMode(context)
end
ThemeUtil.isSysNightMode=isSysNightMode--这个一般用不到
ThemeUtil.isNightMode=isSysNightMode


local function setStyledAttributes(contextTheme,applyTable,androidAttrs,appAttrs,getFunc,defaultValue,style)
  local idList={}
  local androidLength,appLength=#androidAttrs,#appAttrs
  for index=1,androidLength do
    table.insert(idList,android.R.attr[androidAttrs[index]])
  end
  for index=1,appLength do
    table.insert(idList,R.attr[appAttrs[index]])
  end
  local array
  if style then
    array = contextTheme.obtainStyledAttributes(style,idList)
   else
    array = contextTheme.obtainStyledAttributes(idList)
  end
  if defaultValue==nil then
    for index=1,androidLength do
      applyTable[androidAttrs[index]]=array[getFunc](index-1)
    end
    for index=1,appLength do
      applyTable[appAttrs[index]]=array[getFunc](index+androidLength-1)
    end
   else
    for index=1,androidLength do
      applyTable[androidAttrs[index]]=array[getFunc](index-1,defaultValue)
    end
    for index=1,appLength do
      applyTable[appAttrs[index]]=array[getFunc](index+androidLength-1,defaultValue)
    end
  end
  array.recycle()
  luajava.clear(array)
  idList=nil
end

--刷新颜色
function ThemeUtil.refreshThemeColor()
  local contextTheme=context.getTheme()
  local nullTable={}
  local numberList=theme.number
  --颜色
  setStyledAttributes(contextTheme,theme.color,{
    "textColorTertiary","textColorPrimary","textColorSecondary",--文字颜色
    "colorPrimary","colorPrimaryDark","colorAccent",
    "navigationBarColor","statusBarColor",--系统UI颜色
    "colorButtonNormal","windowBackground"
  },
  {
    "rippleColorPrimary","rippleColorAccent",--波纹颜色
    "floatingActionButtonBackgroundColor",--悬浮球背景颜色
    "colorBackgroundFloating","strokeColor",
  },"getColor",0)

  setStyledAttributes(contextTheme,numberList.id,{
    "selectableItemBackgroundBorderless","selectableItemBackground",
  },
  {
    "actionBarTheme",
  },"getResourceId",0)

  setStyledAttributes(contextTheme,theme.boolean,nullTable,{
    "windowLightStatusBar","windowLightNavigationBar",
  },"getBoolean",false)

  --标题栏主题
  setStyledAttributes(contextTheme,theme.color.ActionBar,{
    "textColorSecondary",
  },
  {
    "colorControlNormal","rippleColorPrimary","cardBackgroundColor",
  },"getColor",0,numberList.id.actionBarTheme)

  local array = context.getTheme().obtainStyledAttributes(numberList.id.actionBarTheme,{
    R.attr.elevation
  })
  numberList.actionBarElevation=array.getDimension(0,0)
  array.recycle()
  luajava.clear(array)

  --就这么神奇
  local array = context.getTheme().obtainStyledAttributes(numberList.id.actionBarTheme,{
    R.attr.cardBackgroundColor
  })
  theme.color.ActionBar.cardBackgroundColor=array.getColor(0,0)
  array.recycle()
  luajava.clear(array)
end

--设置状态栏颜色
function ThemeUtil.setStatusBarColor(color)
  theme.color.statusBarColor=color--保存导航栏颜色
  window.setStatusBarColor(color)
  return color
end

---设置导航栏颜色
---@param color number 颜色值
function ThemeUtil.setNavigationbarColor(color)
  theme.color.navigationBarColor=color--保存导航栏颜色
  window.setNavigationBarColor(color)--设置导航栏颜色
  return color
end

--透明系统栏
function ThemeUtil.applyAplhaSystemBar()
  decorView.setSystemUiVisibility(
  decorView.getSystemUiVisibility()|
  View.SYSTEM_UI_FLAG_LAYOUT_FULLSCREEN
  |View.SYSTEM_UI_FLAG_LAYOUT_STABLE
  |View.SYSTEM_UI_FLAG_LAYOUT_HIDE_NAVIGATION)
  window.setStatusBarColor(0)
  window.setNavigationBarColor(0)
end

--获取波纹Drawable
function ThemeUtil.getRippleDrawable(color,square)
  local rippleId=square and theme.number.id.selectableItemBackground
  or theme.number.id.selectableItemBackgroundBorderless

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

local function isGrayNavigationBarSystem()
  return ThemeUtilJava.isGrayNavigationBarSystem()
end
ThemeUtil.isGrayNavigationBarSystem=isGrayNavigationBarSystem

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
  local themeKey
  themeKey=getAppTheme()--获取当前设置的主题
  if not(supportedThemeName[themeKey]) then--主图里面没有，可能是废除了这个主题
    themeKey="Default"
    setAppTheme(themeKey)--自动设置会默认
  end

  --构建用的主题名字
  local themeString=("Theme_%s_%s"):format(jesse205.themeType,themeKey)
  if getSharedData("theme_darkactionbar") then--如果是暗色ActionBar
    themeString=themeString.."_DarkActionBar"
  end
  if useCustomAppToolbar then--使用自定义的ToolBar
    themeString=themeString.."_NoActionBar"
  end
  activity.setTheme(R.style[themeString])--设置主题
  themeString=nil

  local systemUiVisibility=0
  decorView=activity.getDecorView()--定要在设置主题之后调用
  local colorList=theme.color

  if not(useCustomAppToolbar) then
    local actionBar=context.getSupportActionBar()
    _G.actionBar=actionBar
    if actionBar then
      actionBar.setElevation(0)--关闭ActionBar阴影
    end
  end

  ThemeUtil.refreshThemeColor()--刷新一下颜色

  if isGrayNavigationBarSystem() then
    ThemeUtil.setNavigationbarColor(theme.color.windowBackground)
  end

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