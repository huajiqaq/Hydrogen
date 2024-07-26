require "import"

import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "android.view.*"
import "android.view.animation.*"
import "android.view.animation.Animation$AnimationListener"
import "android.view.animation.AccelerateDecelerateInterpolator"
import "android.view.inputmethod.InputMethodManager"
import "android.animation.*"
import "views.MyTab"
import "android.webkit.CookieSyncManager"
import "android.webkit.CookieManager"
import "android.content.Context"

import "com.androlua.LuaWebView$JsInterface"

import "android.net.*"

import "android.text.*"
import "android.text.style.*"
import "android.content.*"
import "android.content.res.*"
import "android.content.pm.PackageManager"
import "android.content.pm.ApplicationInfo"
import "android.content.ContentResolver"

import "android.graphics.*"
import "android.graphics.Matrix"
import "android.graphics.Bitmap"
import "android.graphics.BitmapFactory"
import "android.graphics.Typeface"
import "android.graphics.drawable.*"
import "android.graphics.PorterDuff"
import "android.graphics.PorterDuffColorFilter"

import "android.renderscript.*"
import "android.renderscript.Element"
import "android.renderscript.Allocation"
import "android.renderscript.ScriptIntrinsicBlur"
import "android.renderscript.RenderScript"

import "java.lang.Math"

import "java.security.*"

import "java.io.*"
import "java.io.File"
import "java.io.InputStream"

import "java.util.*"

import "java.net.URL"

import "android.content.res.ColorStateList"
import "android.content.pm.PackageManager"
import "android.content.Intent"
import "android.net.Uri"
import "android.util.Base64"

import "androidx.*"
import "androidx.appcompat.*"
import "androidx.core.app.*"

import "android.webkit.WebSettings"
import "android.webkit.MimeTypeMap"

import "android.provider.Settings"

import "android.Manifest"

import "android.animation.Animator"
import "android.animation.ValueAnimator"
import "android.animation.LayoutTransition"

import "androidx.core.content.ContextCompat"
import "com.google.android.material.card.MaterialCardView"

local function contains_any(test_string)
  for word in string.gmatch(this.getSharedData("屏蔽词"), "%S+") do
    if string.find(test_string, word, 1, true) then
      return true
    end
  end
  return false
end


ori_MyLuaAdapter=luajava.bindClass "com.hydrogen.adapter.MyLuaAdapter"

function MyLuaAdapter(context,table1,table2)
  local layout,data
  if not(table2) then
    data={}
    layout=table1
   else
    data=table1 or {}
    layout=table2
  end
  local mt = {
    __newindex = function(t, k, v)
      local 匹配内容=v.标题..v.预览内容
      if contains_any(匹配内容) then
        return
      end
      rawset(t, k, v)
    end
  }
  if this.getSharedData("屏蔽词") and this.getSharedData("屏蔽词"):gsub(" ","")~="" then
    setmetatable(data, mt)
  end
  return ori_MyLuaAdapter(context,data,layout)
end

import "com.hydrogen.view.NoScrollListView"
import "com.hydrogen.view.NoScrollGridView"

import "com.google.android.material.appbar.*"
import "androidx.core.widget.NestedScrollView"