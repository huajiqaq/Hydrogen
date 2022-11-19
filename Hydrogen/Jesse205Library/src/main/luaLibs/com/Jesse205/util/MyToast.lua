local MyToast={}
setmetatable(MyToast,MyToast)

local context=Jesse205.context
--mainLay为全局变量

function MyToast.showToast(text)
  local toast=Toast.makeText(context,text,Toast.LENGTH_SHORT)
  .show()
  return toast
end

function MyToast.showSnackBar(text,view)
  local snackBar=Snackbar.make(view or mainLay or context.getDecorView(),text,Snackbar.LENGTH_SHORT)
  --.setAnimationMode(Snackbar.ANIMATION_MODE_SLIDE)
  .show()
  return snackBar
end


--[[
根据是否有view或者mainLay来是否显示SnackBar
@param text 接收类型为string的文字
@param view SnackBar显示的View，设置false为使用Toast
]]
function MyToast.autoShowToast(text,view)
  if view==nil then
    view=mainLay
  end
  local toast
  if view then
    toast=MyToast.showSnackBar(text,view)
   else
    toast=MyToast.showToast(text)
  end
  return toast
end

--根据网络错误代码显示Toast或SnackBar
function MyToast.showNetErrorToast(code,view)
  if not(NetErrorStr) then
    import "com.Jesse205.util.NetErrorStr"--导入网络错误代码
  end
  return MyToast.autoShowToast(NetErrorStr(code),view)
end

--复制文字然后显示Toast
function MyToast.copyText(text,view)
  _G.copyText(text)
  return MyToast.autoShowToast(R.string.Jesse205_toast_copied,view)
end

--显示“xxx成功/失败”
function MyToast.pcallToToast(successStr,failedStr,succeed)
  local text
  if succeed then
    text=successStr
   else
    text=failedStr
  end
  return MyToast.showToast(text)
end

function MyToast.pcallToSnackbar(view,succeedStr,failedStr,succeed)
  local text
  if succeed then
    text=succeedStr
   else
    text=failedStr
  end
  return MyToast.showSnackBar(view,text)
end

--调用 MyToast() 时
function MyToast.__call(self,text,view)
  return MyToast.autoShowToast(text,view)
end

return MyToast