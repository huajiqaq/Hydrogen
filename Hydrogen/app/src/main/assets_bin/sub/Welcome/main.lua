require "import"
import "jesse205"

import "android.content.pm.PackageManager"
import "android.text.Html"
import "androidx.core.content.res.ResourcesCompat"

import "com.onegravity.rteditor.RTEditorMovementMethod"

import "com.jesse205.layout.util.SettingsLayUtil"
import "com.jesse205.widget.AutoToolbarLayout"

import "welcome"
import "agreements"
import "android.provider.Settings"


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
        Typeface=ResourcesCompat.getFont(activity, R.font.product);
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

activity.getSupportActionBar().hide()
activity.setTitle(R.string.jesse205_welcome)
activity.setContentView(loadlayout2("layout"))

local luapath=File(luajava.luadir).getParentFile().getParentFile().toString()
package.path = package.path..";"..luapath.."/?.lua"
require("mods.muk")
edgeToedge(mainLay)
  
  
pages={}


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
table.insert(pages,updateInfoPage)
NowPage=pages[1]


maxPage=table.size(pages)
adp=ArrayPageAdapter()

for index,content in ipairs(pages) do
  adp.add(loadlayout2(content.layout,content))
  if content.onInitLayout then
    content:onInitLayout()
  end
end

pageView.setAdapter(adp)

pageView.setOnPageChangeListener(PageView.OnPageChangeListener{
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
    title.Text=nowPage.title
    if nowPage.subtitle then
      subtitle.Text=nowPage.subtitle
      subtitle.Visibility=0
     else
      subtitle.Text=""
      subtitle.Visibility=8
    end
    titleicon.setImageResource(nowPage.icon)
    titleicon.setColorFilter(theme.color.colorAccent)
    title.setTextColor(theme.color.textColorPrimary)

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
    setSharedData("welcome",true)
    newActivity(File(activity.getLuaDir()).getParentFile().getParent(),true)
    activity.finish()
  end
end