require "import"
import "android.app.*"
import "android.os.*"
import "android.widget.*"
import "mods.muk"
import "androidx.viewpager2.widget.ViewPager2"
import "com.dingyi.adapter.BaseViewPage2Adapter"
import "android.view.*"
import "uk.co.senab.photoview.PhotoView"
import "androidx.viewpager2.widget.ViewPager2$OnPageChangeCallback"
--compile "libs/glide_4.8" --使用 glide 4.8 dex
import "com.bumptech.glide.Glide"
import "com.bumptech.glide.request.RequestOptions"
import "com.bumptech.glide.request.RequestListener"
activity.setContentView(loadlayout("layout/image"))


波纹({download},"方白")

沉浸状态栏()

全屏()

local ls=...
local views={}

mls=require "cjson".decode(ls)


local now=mls[tostring(table.size(mls)-1)]


now_count.text=(tointeger(now)+1)..""

all_count.text=(table.size(mls)-1)..""

local t=BaseViewPage2Adapter(this)

local base=
{
  FrameLayout,
  layout_height="-1",
  layout_width="-1",
  layoutTransition=LayoutTransition()
  .enableTransitionType(LayoutTransition.CHANGING),

  {
    PhotoView,
    id="ph",
    visibility=8,
    --   src="icon.png",  
    layout_height="-1",
    layout_width="-1",
  },
  {
    LinearLayout,
    layout_height="-1",
    layout_width="-1",
    gravity="center",
    id="pg",
    {
      ProgressBar,
      ProgressBarBackground=转0x(primaryc),
    },
  },

}

for i=0,table.size(mls)-2 do
  views[i]={}
  views[i].ids={}
  t.add(loadlayout(base,views[i].ids))

end

picpage.adapter=t




--t.remove(0)--删除控件

--[[
 --[=[i.remove(0)
 .add("m")
 .title("")
 .meassage("")
 .show()
 .
 ]=]
 s.setOrientation(s.ORIENTATION_HORIZONTAL) --横
--]]


--s.isUserInputEnabled=false --禁止滑动(一句代码设置好爽)

-- s.setOrientation(s.ORIENTATION_VERTICAL) --竖

-- print(OnPageChangeCallback)

lastBitmap=""

picpage.registerOnPageChangeCallback(OnPageChangeCallback{--除了名字变，其他和PageView差不多

  onPageSelected=function(i)--选中的页数
    --    print(i)
    now_count.text=(i+1)..""

    local parent=views[i].ids
    if parent.ph.getDrawable()==nil then

      local url=mls[tostring(i)]
      --[[
      task(function(url)
        require "import"
        return loadbitmap(url)
        end,url,function(e)

        parent.ph.setImageBitmap(e)
        parent.pg.Visibility=8
        parent.ph.Visibility=0
        if type(lastBitmap)=="userdata" then
          lastBitmap.recycle()
          System.gc()
          collectgarbage("collect")
        end
        lastBitmap=e
      end)
   ]]


      Glide
      .with(activity)
      .asDrawable()--强制gif支持
      -- .setDefaultRequestOptions(RequestOptions().override(activity.height/1.2, activity.width/1.2))     
      .load(url)
      .addListener(RequestListener{
        onResourceReady=function(a,b,c,d)
          parent.pg.visibility=8
          parent.ph.visibility=0
          return false
        end
      })
      .into(parent.ph)

      parent.pg.Visibility=8
      parent.ph.Visibility=0

      --    Glide.get(activity).clearMemory();

    end
  end,

})


picpage.setCurrentItem(now)


ripple.onClick=function()
  local url=mls[""..picpage.getCurrentItem()]
  Http.download(url,"/sdcard/Pictures/Hydrogen/"..os.time()..".webp",function(code,msg)
    if code==200 then
      提示("已保存到"..msg)
     else
      提示("保存失败")
    end
  end)
end

