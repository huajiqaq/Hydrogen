require "import"
import "jesse205"
import "android.text.Html"
import "com.onegravity.rteditor.RTEditorMovementMethod"--可以选择与点击的MovementMethod
import "me.zhanghai.android.fastscroll.FastScrollerBuilder"
import "me.zhanghai.android.fastscroll.FastScrollScrollView"

activity.setTitle(R.string.jesse205_htmlFileViewer)
activity.setContentView(loadlayout2("com.jesse205.layout.innocentlayout.TextViewLayout"))
actionBar.setDisplayHomeAsUpEnabled(true)
---传入的数据
local data=...

function onOptionsItemSelected(item)
  local id=item.getItemId()
  if id==android.R.id.home then
    activity.finish()
  end
end

function onConfigurationChanged(config)
  --刷新ActionBar阴影
  MyAnimationUtil.ScrollView.onScrollChange(scrollView,scrollView.getScrollX(),scrollView.getScrollY(),0,0)
end

textView.setLinksClickable(true)
textView.setMovementMethod(RTEditorMovementMethod.getInstance())
textView.requestFocusFromTouch()

FastScrollerBuilder(scrollView).useMd2Style().build()

if data.title then
  activity.setTitle(data.title)
end

local path=data.path
local url=data.url
if path then
  local content=io.open(path,"r"):read("*a")
  if tostring(data.text)=="true" then
    textView.setText(content)
   else
    textView.setText(Html.fromHtml(content))
  end
end

scrollView.onScrollChange=function(view,l,t,oldl,oldt)
  MyAnimationUtil.ScrollView.onScrollChange(view,l,t,oldl,oldt)
end
