require "import"
import "jesse205"
import "android.content.pm.PackageManager"
import "android.text.Html"

import "com.onegravity.rteditor.RTEditorMovementMethod"
import "me.zhanghai.android.fastscroll.FastScrollerBuilder"
import "me.zhanghai.android.fastscroll.FastScrollScrollView"

import "com.jesse205.layout.util.SettingsLayUtil"
import "com.jesse205.widget.AutoToolbarLayout"

import "welcome"
import "agreements"

function buildTitlebar(icon,text)
  return {--设置项(图片,标题)
    CardView;
    layout_width="fill";
    radius=0;
    id="topCard";
    backgroundColor=theme.color.windowBackground;
    {
      LinearLayout;
      layout_width="fill";
      layout_height="fill";
      gravity="center";
      {
        ImageView,
        layout_margin="16dp",
        layout_width="24dp",
        layout_height="24dp",
        imageResource=icon;
        colorFilter=theme.color.colorAccent,
      },
      {
        TextView;
        textSize="16sp";
        textColor=theme.color.textColorPrimary;
        layout_weight=1;
        layout_margin="16dp";
        text=text;
        typeface=Typeface.defaultFromStyle(Typeface.BOLD);
      };
    };
  }
end

function MyPageView()
  local lastX=0
  return luajava.override(PageView,{
    onInterceptTouchEvent=function(super,event)
      if event.getAction()==MotionEvent.ACTION_DOWN then
        lastX=event.getRawX()
      end
      return super(event)
    end,
    onTouchEvent=function(super,event)
      local nowX=event.getRawX()
      if lastX-nowX>0 then
        if NowPage and NowPage.allowNext==false then
          event.setAction(MotionEvent.ACTION_CANCEL)
        end
      end
      lastX=nowX
      return super(event)
    end
  })
end

import "pages.agreementPage"
import "pages.permissionPage"

activity.setTitle(R.string.jesse205_welcome)
activity.setContentView(loadlayout2("layout"))

actionBar=activity.getSupportActionBar()
actionBar.setDisplayHomeAsUpEnabled(true)

ScreenFixContent={
  layoutManagers={},
  orientation={
  },
}

pages={}

function onCreateContextMenu(menu)
  --print(menu)
end


function onOptionsItemSelected(item)
  local id=item.getItemId()
  if id==android.R.id.home then
    onKeyDown(KeyEvent.KEYCODE_BACK)
    onKeyUp(KeyEvent.KEYCODE_BACK)
  end
end

function onConfigurationChanged(config)
  screenConfigDecoder:decodeConfiguration(config)
  for index,content in ipairs(pages) do
    if content.onConfigurationChanged then
      content:onConfigurationChanged(config)
    end
  end
end

function onKeyDown(KeyCode, event)
  TouchingKey = true
end


function onKeyUp(KeyCode,event)
  if TouchingKey then
    TouchingKey = false
    if KeyCode==KeyEvent.KEYCODE_BACK then
      local nowPage=pageView.getCurrentItem()
      if nowPage>0 then
        pageView.showPage(nowPage-1)
        return true
      end
    end
  end
end



for index,content in ipairs(agreements) do
  table.insert(pages,agreementPage(content.title,content.icon,content.name,content.date))
end

table.insert(pages,permissionPage)
NowPage=pages[1]
actionBar.setTitle(NowPage.title)

maxPage=table.size(pages)
--progressBar.setMax((maxPage)*1000)

adp=ArrayPageAdapter()

for index,content in ipairs(pages) do
  adp.add(loadlayout2(content.layout,content))
  if content.onInitLayout then
    content:onInitLayout()
  end
end

pageView.setAdapter(adp)

pageView.setOnPageChangeListener(PageView.OnPageChangeListener{
  onPageScrolled=function(arg0,arg1,arg2)
    --progressBar.setProgress((arg0+arg1+1)*1000)
  end,
  onPageChange=function(view,page)
    local nowPage=pages[page+1]
    local elevationKey=nowPage.elevationKey
    NowPage=nowPage
    if page+1==maxPage then
      nextButton.setText(R.string.jesse205_step_finish)
     else
      nextButton.setText(R.string.jesse205_step_next)
    end
    if page==0 then
      previousButton.setClickable(false)
      previousButton.setVisibility(View.GONE)
     else
      previousButton.setClickable(true)
      previousButton.setVisibility(View.VISIBLE)
    end
    nextButton.setEnabled(not(nowPage.allowNext==false))
    if elevationKey and _G[elevationKey]~=0 then
      MyAnimationUtil.ActionBar.openElevation()
     else
      MyAnimationUtil.ActionBar.closeElevation()

    end
    actionBar.setTitle(nowPage.title)
    actionBar.setSubtitle(nowPage.subtitle)

    actionBar.setHomeAsUpIndicator(nowPage.icon)
  end
})

previousButton.onClick=function()
  local nowPage=pageView.getCurrentItem()
  if nowPage>0 then
    pageView.showPage(nowPage-1)
  end
end
nextButton.onClick=function()
  local nowPage=pageView.getCurrentItem()+1
  if nowPage<maxPage then
    pageView.showPage(nowPage)
   elseif nowPage>=maxPage then
    enteringProgressBar.setVisibility(View.VISIBLE)
    nextButton.setVisibility(View.INVISIBLE)
    --nextButton.setClickable(false)
    setSharedData("welcome",true)
    newActivity(File(activity.getLuaDir()).getParentFile().getParent())
    activity.finish()
  end
end

screenConfigDecoder=ScreenFixUtil.ScreenConfigDecoder(ScreenFixContent)

onConfigurationChanged(activity.getResources().getConfiguration())

