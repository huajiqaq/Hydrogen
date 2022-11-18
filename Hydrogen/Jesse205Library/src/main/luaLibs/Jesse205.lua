local Jesse205={}
_G.Jesse205=Jesse205
Jesse205._VERSION="12.0.2 (Pro)"--库版本名
Jesse205._VERSIONCODE=120299--库版本号
Jesse205._ENV=_ENV
Jesse205.themeType="Jesse205"--主题类型

require "import"--导入import
import "loadlayout2"
local context=activity or service--当前context
Jesse205.context=context
local resources=context.getResources()--当前resources
_G.resources=resources
R=luajava.bindClass(context.getPackageName()..".R")

if activity then
  window=activity.getWindow()
  notLoadTheme=notLoadTheme or false
  useCustomAppToolbar=useCustomAppToolbar or false
 else--没有activity不加载主题
  notLoadTheme=true
end

application=activity.getApplication()
safeModeEnable=application.get("safeModeEnable") or false
notSafeModeEnable=not(safeModeEnable)


--JavaAPI转LuaAPI
local activity2luaApi={
  "newActivity","getSupportActionBar",
  "getSharedData","setSharedData",
  "getString","getPackageName",
}
for index,content in ipairs(activity2luaApi) do
  _G[content]=function(...)
    return context[content](...)
  end
end
activity2luaApi=nil

import "android.os.Environment"
import "android.content.res.Configuration"

import "com.Jesse205.lua.math"--导入更强大的math
import "com.Jesse205.lua.string"--导入更强大的string
import "com.Jesse205.app.AppPath"--导入路径

if initApp then--初始化APP
  import "com.Jesse205.app.initApp"
end

import "android.view.View"--加载主题要用
import "android.os.Build"

--加载主题
--在get某东西（ActionBar等）前必须把主题搞定
if not(notLoadTheme) then
  theme={
    color={
      Ripple={},
      Light={},
      Dark={},
      ActionBar={},
    },
    number={
      id={},
      Dimension={},
    },
    boolean={}
  }
  local colors,dimens
  local color=theme.color
  local ripple=color.Ripple
  local light=color.Light
  local dark=color.Dark
  local number=theme.number
  local dimension=number.Dimension

  setmetatable(color,{--普通颜色
    __index=function(self,key)
      local value=resources.getColor(R.color["Jesse205_"..key])
      self[key]=value
      return value
    end
  })
  setmetatable(ripple,{--波纹颜色
    __index=function(self,key)
      local value=resources.getColor(R.color["Jesse205_"..key.."_Ripple"])
      self[key]=value
      return value
    end
  })
  setmetatable(light,{--偏亮颜色
    __index=function(self,key)
      local value=resources.getColor(R.color["Jesse205_"..key.."_Light"])
      self[key]=value
      return value
    end
  })
  setmetatable(dark,{--偏暗颜色
    __index=function(self,key)
      local value=resources.getColor(R.color["Jesse205_"..key.."_Dark"])
      self[key]=value
      return value
    end
  })
  setmetatable(number,{--数字
    __index=function(self,key)
      local value=resources.getInteger(R.integer["Jesse205_"..key])
      self[key]=value
      return value
    end
  })
  setmetatable(dimension,{--数字
    __index=function(self,key)
      local value=resources.getDimension(R.dimen["Jesse205_"..key])
      self[key]=value
      return value
    end
  })
  import "com.Jesse205.app.ThemeUtil"
  ThemeUtil.refreshUI()
end

--导入常用的包
import "androidx.appcompat.widget.*"
import "androidx.appcompat.app.*"
import "androidx.appcompat.view.*"

import "android.widget.*"
import "android.app.*"
import "android.os.*"
import "android.view.*"
import "android.view.inputmethod.InputMethodManager"
--import "android.content.*"
--import "android.graphics.*"

--导入常用类
import "android.graphics.Bitmap"
import "android.graphics.Color"
import "android.graphics.Typeface"
import "android.graphics.drawable.GradientDrawable"

import "androidx.core.app.ActivityCompat"
import "androidx.core.content.ContextCompat"
import "androidx.core.view.MenuItemCompat"

import "androidx.coordinatorlayout.widget.CoordinatorLayout"
import "androidx.swiperefreshlayout.widget.SwipeRefreshLayout"
import "androidx.cardview.widget.CardView"

import "androidx.recyclerview.widget.RecyclerView"
import "androidx.recyclerview.widget.StaggeredGridLayoutManager"
import "androidx.recyclerview.widget.LinearLayoutManager"

import "android.animation.LayoutTransition"

import "android.net.Uri"
import "android.content.Intent"
import "android.content.Context"
import "android.content.res.ColorStateList"
import "android.content.pm.PackageManager"

--导入常用的Material类
--import "com.google.android.material.tabs.TabLayout"
import "com.google.android.material.appbar.AppBarLayout"
import "com.google.android.material.card.MaterialCardView"--卡片
import "com.google.android.material.button.MaterialButton"--按钮
import "com.google.android.material.snackbar.Snackbar"
import "com.google.android.material.textfield.TextInputEditText"--输入框
import "com.google.android.material.textfield.TextInputLayout"

--import "java.io.*"--导入IO
import "java.io.File"
import "java.io.FileInputStream"
import "java.io.FileOutputStream"


--import "com.Jesse205.adapter.*"--导入Adapter

import "com.lua.custrecycleradapter.AdapterCreator"--导入LuaCustRecyclerAdapter及相关类
import "com.lua.custrecycleradapter.LuaCustRecyclerAdapter"
import "com.lua.custrecycleradapter.LuaCustRecyclerHolder"

--import "com.androlua.LuaUtil"
import "com.Jesse205.app.PermissionUtil"

import "com.Jesse205.util.MyStyleUtil"
import "com.Jesse205.util.MyToast"--导入MyToast
--import "com.Jesse205.util.NetErrorStr"--导入网络错误代码
import "com.Jesse205.util.MyAnimationUtil"--导入动画Util
import "com.Jesse205.util.ScreenFixUtil"--导入屏幕适配工具

--导入各种风格的控件
import "com.Jesse205.widget.StyleWidget"
--import "com.Jesse205.widget.AutoToolbarLayout"
--import "com.Jesse205.widget.AutoCollapsingToolbarLayout"

--导入各种布局表
import "com.Jesse205.layout.MyTextInputLayout"
--import "com.Jesse205.layout.MyEditDialogLayout"
--import "com.Jesse205.layout.MySearchLayout"

import "com.bumptech.glide.Glide"--导入Glide
import "com.baidu.mobstat.StatService"--百度移动统计

inputMethodService=activity.getSystemService(Context.INPUT_METHOD_SERVICE)

--自动获取当地语言的对象
local phoneLanguage
function getLocalLangObj(zh,en)
  if not(phoneLanguage) then
    import "java.util.Locale"
    phoneLanguage = Locale.getDefault().getLanguage();
  end
  if phoneLanguage=="zh" then
    return zh or en
   else
    return en or zh
  end
end

--复制文字
function copyText(text)
  context.getSystemService(Context.CLIPBOARD_SERVICE).setText(text)
end


--通过id格式化字符串
function formatResStr(id,values)
  return String.format(context.getString(id),values)
end

--在浏览器打开链接
function openInBrowser(url)
  local viewIntent = Intent("android.intent.action.VIEW",Uri.parse(url))
  activity.startActivity(viewIntent)
end
openUrl=openInBrowser--通常情况下，应用不自带内置浏览器

--[[
相对路径转绝对路径

@param path 要转换的相对路径
@param localPath 相对的目录
]]
function rel2AbsPath(path,localPath)
  if path and not(path:find("^/")) then
    return localPath.."/"..path
   else
    return path
  end
end

--将value转换为boolean类型
function toboolean(value)
  if value then
    return true
   else
    return false
  end
end



--进入Lua子页面
function newSubActivity(name,...)
  local nowDirFile=File(context.getLuaDir())
  local parentDirFile=nowDirFile.getParentFile()
  if nowDirFile.getName()=="sub" then
    newActivity(name,...)
   elseif parentDirFile.getName()=="sub" then
    if name:find("/") then
      newActivity(parentDirFile.getPath().."/"..name,...)
     else
      newActivity(parentDirFile.getPath().."/"..name.."/main.lua",...)
    end
   else
    newActivity("sub/"..name,...)
  end
end

function getColorStateList(id)
  return resources.getColorStateList(id)
end

--好用的加载中对话框
--[[
showLoadingDia：
@param message 信息
@param title 标题
@param cancelable 是否可以取消
]]
local loadingDia
function showLoadingDia(message,title,cancelable)
  if not(loadingDia) then
    loadingDia=ProgressDialog(context)
    loadingDia.setProgressStyle(ProgressDialog.STYLE_SPINNER)--进度条类型
    loadingDia.setTitle(title or context.getString(R.string.Jesse205_loading))--标题
    loadingDia.setCancelable(cancelable or false)--是否可以取消
    loadingDia.setCanceledOnTouchOutside(cancelable or false)--是否可以点击外面取消
    loadingDia.setOnCancelListener{
      onCancel=function()
        loadingDia=nil--如果取消了，就把 loadingDia 赋值为空，视为没有正在展示的加载中对话框
    end}
    loadingDia.show()
  end
  loadingDia.setMessage(message or context.getString(R.string.Jesse205_loading))
end
function closeLoadingDia()
  if loadingDia then
    loadingDia.dismiss()
    loadingDia=nil
  end
end
function getNowLoadingDia()
  return loadingDia
end

function showSimpleDialog(title,message)
  return AlertDialog.Builder(context)
  .setTitle(title)
  .setMessage(message)
  .setPositiveButton(android.R.string.ok,nil)
  .show()
end
--showDialog=showSimpleDialog
showErrorDialog=showSimpleDialog

--自动初始化一个LayoutTransition
function newLayoutTransition()
  if notSafeModeEnable then
    return LayoutTransition().enableTransitionType(LayoutTransition.CHANGING)
  end
end

--以下为复写事件
function onError(title,message)
  showErrorDialog(tostring(title),tostring(message))
  return true
end
--activity.setDebug(false)


--导入共享代码
import "AppSharedCode"

return Jesse205