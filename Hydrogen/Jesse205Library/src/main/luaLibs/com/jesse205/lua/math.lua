import "android.util.TypedValue"
local dp2intCache={}
jesse205.dp2intCache=dp2intCache
--[[清理dp2int缓存方法：
table.clear(Jesse205.dp2intCache)
]]
--其他关于屏幕数据获取方法已更改到ScreenFixUtil
function math.dp2int(dpValue)
  local cache=dp2intCache[dpValue]
  if cache then
    return cache
   else
    local cache=TypedValue.applyDimension(TypedValue.COMPLEX_UNIT_DIP, dpValue, resources.getDisplayMetrics())
    dp2intCache[dpValue]=cache
    return cache
  end
end
function math.px2sp(pxValue)
  local scale=resources.getDisplayMetrics().scaledDensity
  return pxValue/scale
end
