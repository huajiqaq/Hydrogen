require "import"
import "mods.muk"

import "com.lua.custrecycleradapter.*"
import "androidx.recyclerview.widget.*"
import "android.widget.ImageView$ScaleType"

import "com.google.android.material.bottomnavigation.BottomNavigationView"
import "androidx.viewpager.widget.ViewPager"
import "androidx.swiperefreshlayout.widget.*"
import "com.google.android.material.tabs.TabLayout"
import "com.bumptech.glide.Glide"

activity.setContentView(loadlayout("layout/home"))

设置toolbar(toolbar)

初始化历史记录数据()

if activity.getSharedData("第一次提示") ==nil then
  双按钮对话框("注意","该软件仅供交流学习，严禁用于商业用途，请于下载后的24小时内卸载","登录","知道了",function(an)
    activity.setSharedData("第一次提示","x")
    跳转页面("login")
    关闭对话框(an)
    activity.finish()
    end,function(an)
    activity.setSharedData("第一次提示","x")
    关闭对话框(an)
  end)
end

if activity.getSharedData("第一次提示") and activity.getSharedData("开源提示")==nil then
  activity.setSharedData("开源提示","true")
  双按钮对话框("提示","本软件已开源 请问是否跳转开源页面?","我知道了","跳转开源地址",function(an)
    关闭对话框(an) end,function(an)
    关闭对话框(an) 浏览器打开("https://gitee.com/huajicloud/Hydrogen/")
  end)
end


if this.getSharedData("自动清理缓存") == nil then
  this.setSharedData("自动清理缓存","true")
end

if this.getSharedData("全屏模式") == nil then
  this.setSharedData("全屏模式","false")
end

if this.getSharedData("font_size")==nil then
  this.setSharedData("font_size","20")
end

if this.getSharedData("Setting_Auto_Night_Mode")==nil then
  activity.setSharedData("Setting_Auto_Night_Mode","true")
end

pagadp=SWKLuaPagerAdapter()

local home_layout_table=require("layout/home_layout/page_home")

if not this.getSharedData("home_cof") then
  --格式为底栏,底栏,启动页 最后一个为启动页
  this.setSharedData('home_cof','推荐,热榜,关注,推荐')
end

local 启动页=this.getSharedData("home_cof")
local home_items = {}
for item in 启动页:gmatch('[^,]+') do
  table.insert(home_items, item)
end
local starthome=table.remove(home_items)

home_pageinfo={
  推荐={
    menu= { MenuItem,
      title = "主页",
      id = "home_tab",
      enabled=true;
      icon = 图标("home");
    },
    lay=home_layout_table[1],
    init=function()
      --推荐
      home_pagetool=require "model.home_recommend"
      :new()
      :initpage(home_recy,homesr)
      return home_pagetool
    end,
    refer=function(isclear)
      if isclear==true or HometabLayout.getTabCount()==0 then
        return 加载主页tab()
      end
      home_pagetool:refer(nil,nil,true)
    end,
    getrecy=function()
      return home_recy
    end
  },
  想法={
    menu= { MenuItem,
      title = "想法",
      id = "think_tab",
      enabled=true;
      icon = 图标("bubble_chart")
    },
    lay=home_layout_table[2],
    init=function()
      --想法
      thinker_pagetool=require "model.home_thinker"
      :new()
      :initpage(think_recy,thinksr)
      return thinker_pagetool
    end,
    refer=function(isclear)
      if isclear then
        return thinker_pagetool
        :clearItem(1)
        :refer(1)
      end
      thinker_pagetool:refer(nil,nil,true)
    end,
    getrecy=function()
      return think_recy
    end
  },
  热榜={
    menu= { MenuItem,
      title = "热榜",
      id = "hot_tab",
      enabled=true;
      icon = 图标("fire")
    },
    lay=home_layout_table[3],
    init=function()
      --热榜
      hot_pagetool=require "model.home_hot"
      :new()
      :initpage(hot_recy,hotsr)
      return hot_pagetool
    end,
    refer=function()
      hot_pagetool:getData(false,true)
    end,
    getrecy=function()
      return hot_recy
    end
  },
  关注={
    menu= { MenuItem,
      title = "关注",
      id = "following_tab",
      enabled=true;
      icon = 图标("group")
    },
    lay=home_layout_table[4],
    init=function()
      --关注
      follow_pagetool=require "model.home_follow"
      :new()
      :initpage(follow_vpg,followTab)
      return follow_pagetool
    end,
    refer=function(isclear)
      if not(getLogin()) then
        提示("请登录后使用本功能")
       else
        if isclear then
          return follow_pagetool
          :clearItem()
          :refer()
        end
        follow_pagetool:refer(nil,nil,true)
      end
    end,
    getrecy=function()
      return follow_pagetool:getItem()
    end
  }
}

local menu={}
local pageinfo_keys={}
for i,item ipairs(home_items)
  local home_pageinfo=home_pageinfo[item]
  pageinfo_keys[item]=i-1
  if home_pageinfo then
    pagadp.add(loadlayout(home_pageinfo.lay))
    table.insert(menu,home_pageinfo.menu)
    home_pageinfo.init()
   else
    error("错误 找不到"..item)
  end
end

optmenu={}
loadmenu(bnv.getMenu(), menu, optmenu, 3)
bnv.setLabelVisibilityMode(1)

page_home.setAdapter(pagadp)
local startindex=pageinfo_keys[starthome]
page_home.setCurrentItem(startindex,false)


bnv.getMenu().getItem(startindex).setChecked(true)
_title.text=(bnv.getMenu().getItem(startindex).getTitle())


for i=0,bnv.getMenu().size()-1 do
  bnv.getChildAt(0).getChildAt(i).onLongClick=function()
    return true
  end
end

local recommend_index=pageinfo_keys.推荐
if recommend_index then
  bnv.getChildAt(0).getChildAt(recommend_index).onLongClick=function()
    if page_home.getCurrentItem()~=recommend_index or HometabLayout.getTabCount()==0 then
      return true
    end
    import "com.google.android.material.bottomsheet.*"

    import "com.google.android.material.chip.ChipGroup"
    import "com.google.android.material.chip.Chip"

    local gd2 = GradientDrawable()
    gd2.setColor(转0x(backgroundc))--填充
    local radius=dp2px(16)
    gd2.setCornerRadii({radius,radius,radius,radius,0,0,0,0})--圆角
    gd2.setShape(0)--形状，0矩形，1圆形，2线，3环形
    local dann={
      LinearLayout;
      layout_width=-1;
      layout_height=-1;
      {
        LinearLayout;
        orientation="vertical";
        layout_width=-1;
        layout_height=-2;
        Elevation="4dp";
        BackgroundDrawable=gd2;
        id="ztbj";
        {
          CardView;
          layout_gravity="center",
          CardBackgroundColor=转0x(cardedge);
          radius="3dp",
          Elevation="0dp";
          layout_height="6dp",
          layout_width="56dp",
          layout_marginTop="12dp";
        };
        {
          TextView;
          layout_width=-1;
          layout_height=-2;
          textSize="20sp";
          layout_marginTop="24dp";
          layout_marginLeft="24dp";
          layout_marginRight="24dp";
          Text="tab切换";
          Typeface=字体("product-Bold");
          textColor=转0x(primaryc);
        };
        {
          HorizontalScrollView;
          layout_marginTop="8dp";
          layout_marginLeft="24dp";
          layout_marginRight="24dp";
          layout_marginBottom="8dp",
          id="horizontalscrollview",
          {
            ChipGroup;
            singleLine=true,
            layout_width="match";
            layout_height="wrap";
            singleSelection=true,
            id="chipgroup"
          };
        },
        {
          LinearLayout;
          orientation="horizontal";
          layout_width=-1;
          layout_height=-2;
          gravity="right|center";
          {
            MaterialButton;
            layout_marginTop="16dp";
            layout_marginLeft="16dp";
            layout_marginRight="16dp";
            layout_marginBottom="16dp";
            textColor=转0x(backgroundc);
            text="关闭";
            id="close";
            Typeface=字体("product-Bold");
          };
        };
      };
    };


    local tmpview={}
    local bottomSheetDialog = BottomSheetDialog(this)
    bottomSheetDialog.setContentView(loadlayout2(dann,tmpview))

    local chipdialog=bottomSheetDialog.show()
    MDC_R=luajava.bindClass"com.google.android.material.R"

    local function createchip(text)
      return loadlayout2({
        Chip_Suggestion_Elevated;
        layout_width="wrap_content";
        layout_height="wrap_content";
        text=text;
        checked=true,
        checkable = true,
        style=MDC_R.style.Widget_Material3_Chip_Filter
      })
    end

    for i = 1,HometabLayout.getTabCount() do
      local itemnum=i-1
      local text=HometabLayout.getTabAt(itemnum).Text
      tmpview.chipgroup.addView(createchip(text))
    end

    local index=HometabLayout.getSelectedTabPosition()
    local checkedchip=tmpview.chipgroup.getChildAt(index)
    checkedchip.checked=true
    tmpview.chipgroup.post{
      run=function ()
        tmpview.horizontalscrollview.smoothScrollTo(checkedchip.getLeft(), checkedchip.getTop());
    end}

    function getCheckedPos(str)
      for i = 1,tmpview.chipgroup.childCount do
        if tmpview.chipgroup.getChildAt(i-1).text==str then
          return i-1
        end
      end
    end

    tmpview.chipgroup.setOnCheckedChangeListener(ChipGroup.OnCheckedChangeListener{
      onCheckedChanged=function(chipgroup,id)
        if id==-1 then
          return
        end
        local chip=chipgroup.findViewById(id);
        if checkedchip.text==chip.text then
          return
        end
        双按钮对话框("提示","确定要选择"..chip.text.."吗","选择","取消",function (an)
          local pos=getCheckedPos(chip.text)
          local tab=HometabLayout.getTabAt(pos);
          tab.select()
          提示("选择成功")
          chipdialog.dismiss()
          an.dismiss()
          end,function(an)
          chip.checked=false
          checkedchip.checked=true
          an.dismiss()
        end,false)
      end
    })

    local an=bottomSheetDialog.show()
    tmpview.close.onClick=function()
      an.dismiss()
    end;
    return true
  end
end

local NavlastClickTime = 0
local NavlastClickedItem

function bnv.onNavigationItemSelected(item)
  item = item.getTitle();
  if item =="主页" then
    item="推荐"
  end

  local currentTime = SystemClock.uptimeMillis()
  local pos=pageinfo_keys[item]

  if lastClickedItem == item and currentTime - lastClickTime < 200 then
    home_pageinfo[item].getrecy().smoothScrollToPosition(0)
   else
    lastClickTime = currentTime
    lastClickedItem = item
    page_home.setCurrentItem(pos)
  end
end

page_home.addOnPageChangeListener(ViewPager.OnPageChangeListener {

  onPageScrolled=function(position, positionOffset, positionOffsetPixels)
  end;

  onPageSelected=function(position)
    local pos=position+1
    local home_item=home_items[pos]
    home_pageinfo[home_item].refer()

    for i=0,bnv.getChildCount() do
      bnv.getMenu().getItem(i).setChecked(false)
    end

    bnv.getMenu().getItem(position).setChecked(true)
    _title.text=(bnv.getMenu().getItem(position).getTitle())

  end;

  onPageScrollStateChanged=function(state)

  end
});

local function set_drawer(z)
  local z=z or 1
  _drawer.getChildAt(0).translationX=_drawer_root.width*z
end

function onStart()
  --防止偶尔出现的显示bug
  if _drawer.isDrawerOpen(Gravity.LEFT) then
    set_drawer()
  end
end

_drawer.setDrawerListener(DrawerLayout.DrawerListener{
  onDrawerSlide=function(v,z)
    --侧滑滑动事件
    local k=_drawer.isDrawerOpen(3)
    local dz
    if k==false then
      dz=z*180
     else
      dz=-z*180
    end
    --与标题栏图标联动
    _menu.rotation=dz
    if z>0.5 then
      _menu.scaleX=1-z*0.08
      _menu.scaleY=1-z*0.08
     else
      _menu.scaleX=1
      _menu.scaleY=1
    end
    _menu_1.rotation=z*45
    _menu_2.scaleX=1-z/3.8
    _menu_3.rotation=-z*45
    _menu_1.scaleX=1-z/2.4
    _menu_1.setTranslationY(z*3.2)
    _menu_1.setTranslationX(z*8.)
    _menu_3.scaleX=1-z/2.4
    _menu_3.setTranslationY(-z*3.2)
    _menu_3.setTranslationX(z*8)
    _drawer.setScrimColor(0)
    set_drawer(z)
end})

ch_item_checked_background = GradientDrawable()
.setShape(GradientDrawable.RECTANGLE)
.setColor(转0x(primaryc)-0xde000000)
.setCornerRadii({0,0,dp2px(24),dp2px(24),dp2px(24),dp2px(24),0,0});

ch_item_nochecked_background = GradientDrawable()
.setShape(GradientDrawable.RECTANGLE)
.setCornerRadii({0,0,dp2px(24),dp2px(24),dp2px(24),dp2px(24),0,0});

--导入必要的包
import "com.google.android.material.shape.CornerFamily";
import "com.google.android.material.shape.ShapeAppearanceModel";

shapeAppearanceModel = ShapeAppearanceModel()
.toBuilder()
.setTopLeftCorner(CornerFamily.ROUNDED, 0)
.setTopRightCorner(CornerFamily.ROUNDED, dp2px(24,true))
.setBottomRightCorner(CornerFamily.ROUNDED, dp2px(24,true))
.setBottomLeftCorner(CornerFamily.ROUNDED, 0)
.build();


--侧滑列表项目
drawer_item={

  {--侧滑项目 (type1)
    RelativeLayout;
    layout_width="-1";
    layout_height="48dp";
    BackgroundColor=backgroundc;
    {
      --设置clickable后会和listview的冲突 所以直接每次onclick绑定了
      MaterialCardView;
      id="cardv";
      layout_width="-1";
      layout_height="-1";
      StrokeColor=cardedge;
      CardBackgroundColor=backgroundc;
      layout_marginTop="1dp";
      layout_marginRight="8dp";
      StrokeWidth=0;
      ShapeAppearanceModel=shapeAppearanceModel;
      clickable=true;
      onClick=function(view)
        侧滑列表点击事件(获取listview顶部布局(view))
      end,
      {
        LinearLayout;
        layout_width="-1";
        layout_height="-1";
        gravity="center|left";
        {
          ImageView;
          id="iv";
          ColorFilter=textc;
          layout_marginLeft="24dp";
          layout_width="24dp";
          layout_height="24dp";
        };
        {
          TextView;
          layout_marginLeft="16dp";
          Typeface=字体("product");
          textColor=textc;
          id="tv";
          textSize=标题文字大小;
        };
      };
    };
  };

  {--侧滑_分割线 (type2)
    LinearLayout;
    layout_width="-1";
    layout_height="-2";
    gravity="center|left";
    onClick=function()end;
    {
      TextView;
      layout_width="-1";
      layout_height="3px";
      background=cardback,
      layout_marginTop="8dp";
      layout_marginBottom="8dp";
    };
  };
};

-- new 0.518 重写逻辑 解决部分机型波纹绘制不正确

--侧滑列表适配器
adp=LuaMultiAdapter(activity,drawer_item)

--侧滑项目
ch_table={
  "分割线",
  {"主页","home"},
  {"收藏","book"},
  {"日报","work"},
  {"关注","list_alt"},
  {"更多","menu"},
  "分割线",
  {"本地","inbox"},
  {"历史","history"},
  {"设置","settings"},
};


for i,v in ipairs(ch_table) do
  if v=="分割线"then
    adp.add{__type=2}
   else
    adp.add{__type=1,cardv={},iv={src=图标(v[2])},tv={text=v[1]}}
  end
end

adp.notifyDataSetChanged()
drawer_lv.setAdapter(adp)

--侧滑列表高亮项目函数
function ch_light(n)
  local data=adp.getData()
  for i, item in ipairs(data) do
    if item.tv then
      if item.tv.text==n then
        item.cardv.CardBackgroundColor=转0x(primaryc)-0xde000000
        item.iv.ColorFilter=转0x(primaryc)
        item.tv.textColor=转0x(primaryc)
       else
        item.cardv.CardBackgroundColor=转0x(backgroundc)
        item.iv.ColorFilter=转0x(textc)
        item.tv.textColor=转0x(textc)
      end
    end
  end
  adp.notifyDataSetChanged()
end

task(1,function()
  ch_light("主页")--设置高亮项目为“主页”
end)

function 切换布局(s)

  if s=="收藏" then
    setmyToolip(_ask,"新建收藏夹")
    _ask.onClick=function()
      if not(getLogin()) then
        return 提示("你可能需要登录")
      end
      if collection_pagetool==nil then
        提示("收藏加载中")
        return true
      end
      新建收藏夹(function(mytext,myid,ispublic)

        collection_pagetool
        :clearItem(1)
        :refer(1)

      end)
    end

    if isstart=="true" then
      a=MUKPopu({
        tittle="菜单",
        list={
          {src=图标("search"),text="在收藏中搜索",onClick=function()
              if not(getLogin()) then
                return 提示("请登录后使用本功能")
              end
              InputLayout={
                LinearLayout;
                orientation="vertical";
                Focusable=true,
                FocusableInTouchMode=true,
                {
                  EditText;
                  hint="输入";
                  layout_marginTop="5dp";
                  layout_marginLeft="10dp",
                  layout_marginRight="10dp",
                  layout_width="match_parent";
                  layout_gravity="center",
                  id="edit";
                };
              };

              AlertDialog.Builder(this)
              .setTitle("请输入")
              .setView(loadlayout(InputLayout))
              .setPositiveButton("确定", {onClick=function()
                  activity.newActivity("search_result",{edit.text,"collection"})
              end})
              .setNegativeButton("取消", nil)
              .show();
          end},
          {src=图标("email"),text="反馈",onClick=function()
              跳转页面("feedback")
          end},
          {src=图标("info"),text="关于",onClick=function()
              跳转页面("about")
          end},
        }
      })
    end

   else
    setmyToolip(_ask,"提问")
    _ask.onClick=function()
      if not(getLogin()) then
        return 提示("你可能需要登录")
      end
      task(20,function()
        activity.newActivity("browser",{"https://www.zhihu.com/messages","提问"})
      end)
    end
    a=MUKPopu({
      tittle="菜单",
      list={
        {src=图标("email"),text="反馈",onClick=function()
            跳转页面("feedback")
        end},
        {src=图标("info"),text="关于",onClick=function()
            跳转页面("about")
        end},
      }
    })

  end

  local allviews={
    主页={
      page_home,
      bottombar
    },
    日报={
      page_daily
    },
    关注={
      page_follow
    },
    收藏={
      page_collections
    }
  }

  local showviews=allviews[s]
  if not showviews then
    return
  end

  for k,v in ipairs(showviews)
    v.Visibility=View.VISIBLE
  end

  allviews[s]=nil

  for k,v in pairs(allviews)
    for _,v ipairs(v)
      v.Visibility=View.GONE
    end
  end

  ch_light(s)
  _title.setText(s)

end

--侧滑列表点击事件
function 侧滑列表点击事件(v)
  --项目点击事件
  local s=v.Tag.tv.Text

  switch s
   case "收藏"
    if getLogin()~=true then
      提示("请登录后使用本功能")
      return true
    end
    collection_pagetool:refer(nil,nil,true)
   case "日报"
    daily_pagetool:getData(nil,true)
   case "关注"
    if getLogin()~=true then
      提示("请登录后使用本功能")
      return true
    end
    followcontent_pagetool:refer(nil,nil,true)
   case "本地"
    task(300,function()activity.newActivity("local_list")end)
   case "设置"
    task(300,function()activity.newActivity("settings")end)
   case "历史"
    task(300,function()activity.newActivity("history")end)
   case "更多"

    if not(getLogin()) then
      return 提示("请登录后使用本功能")
    end
    task(20,function()
      AlertDialog.Builder(this)
      .setTitle("请选择")
      .setSingleChoiceItems({"通知","私信","设置","屏蔽用户管理","圆桌","专题"}, 0,{onClick=function(v,p)
          local mtab={"https://www.zhihu.com/notifications","https://www.zhihu.com/messages","https://www.zhihu.com/settings/account","屏蔽用户管理","https://www.zhihu.com/appview/roundtable","https://www.zhihu.com/appview/special"}
          jumpurl=mtab[p+1]
      end})
      .setNegativeButton("确定", {onClick=function()
          if jumpurl=="屏蔽用户管理" then
            jumpurl=nil
            return activity.newActivity("people_list",{"我的屏蔽用户列表"})
          end
          --防止没选中 nil
          activity.newActivity("browser",{jumpurl or "https://www.zhihu.com/notifications"})
          jumpurl=nil
      end})
      .show();
    end)
  end

  切换布局(s)

  task(1,function()
    _drawer.closeDrawer(Gravity.LEFT)--关闭侧滑
  end)
end

--日报
daily_pagetool=require "model.home_daily"
:new()
:initpage(daily_recy,dailysr)

--收藏
collection_pagetool=require "model.home_collection"
:new()
:initpage(collection_vpg,CollectiontabLayout)

--关注内容
followcontent_pagetool=require "model.follow_content"
:new()
:initpage(followpage,followtabLayout)


--设置波纹（部分机型不显示，因为不支持setColor）（19 6-6发现及修复因为不支持setColor而导致的报错问题)
波纹({_menu,_more,_search,_ask,page1,page2,page3,page5,page4,pagetest},"圆主题")
波纹({open_source},"方主题")
波纹({侧滑头},"方自适应")
波纹({注销},"圆自适应")


function 加载主页tab()

  if not HometabLayout then
    return
  end

  zHttp.get("https://api.zhihu.com/feed-root/sections/query/v2",head,function(code,content)
    if code==200 then
      HometabLayout.setVisibility(0)
      local decoded_content = luajson.decode(content)
      if this.getSharedData("关闭全站")~="true" then
        table.insert(decoded_content.selected_sections, 1, {
          section_name="全站",
          section_id=nil,
          sub_page_id=nil,
        })
      end

      if HometabLayout.getTabCount()>0 then
        HometabLayout.removeAllTabs()
      end

      hometab={}

      for _,v ipairs(decoded_content.selected_sections) do
        local sub_page_id=v.sub_page_id
        local section_id=v.section_id
        table.insert(hometab,{
          sub_page_id=sub_page_id,
          section_id=section_id,
        })
        local tab=HometabLayout.newTab()
        tab.setText(v.section_name)
        HometabLayout.addTab(tab)
      end

      HometabLayout.addOnTabSelectedListener(TabLayout.OnTabSelectedListener {
        onTabSelected=function(tab)
          --选择时触发
          local pos=tab.getPosition()+1
          local section_id=hometab[pos]["section_id"]
          local sub_page_id=hometab[pos]["sub_page_id"]
          if section_id==nil then
            home_pagetool:setUrlItem("https://api.zhihu.com/topstory/recommend?tsp_ad_cardredesign=0&feed_card_exp=card_corner|1&v_serial=1&isDoubleFlow=0&action=down&refresh_scene=0&scroll=up&limit=10&start_type=cold&device=phone&short_container_setting_value=0&include_guide_relation=false")
           else
            if sub_page_id then
              home_pagetool:setUrlItem("https://api.zhihu.com/feed-root/section/"..section_id.."?sub_page_id="..sub_page_id.."&channelStyle=0")
             else
              home_pagetool:setUrlItem("https://api.zhihu.com/feed-root/section/"..section_id.."?channelStyle=0")
            end
          end
          home_pagetool:clearItem()
          :refer()
        end,

        onTabUnselected=function(tab)
          --未选择时触发
        end,

        onTabReselected=function(tab)
          --选中之后再次点击即复选时触发
          home_pagetool:clearItem(pos,true)
          :refer(nil,true)
        end,
      });


      --延迟防止滑动
      HometabLayout.postDelayed(Runnable{
        run=function()
          local tab=HometabLayout.getTabAt(0);
          tab.select()
      end},300);

     else
      HometabLayout.setVisibility(8)
      home_pagetool:refer(nil,nil,true)
    end
  end)
end

function 成功登录回调()
  setHead()
  collection_pagetool:setUrls({
    "https://api.zhihu.com/people/"..activity.getSharedData("idx").."/collections_v2?offset=0&limit=20",
    "https://api.zhihu.com/people/"..activity.getSharedData("idx").."/following_collections?offset=0"
  })
  followcontent_pagetool:setUrls({
    "https://api.zhihu.com/people/"..activity.getSharedData("idx").."/".."following_questions".."?limit=10",
    "https://api.zhihu.com/people/"..activity.getSharedData("idx").."/".."following_collections".."?limit=10",
    "https://api.zhihu.com/people/"..activity.getSharedData("idx").."/".."following_topics".."?limit=10",
    "https://api.zhihu.com/people/"..activity.getSharedData("idx").."/".."following_columns".."?limit=10",
    "https://api.zhihu.com/people/"..activity.getSharedData("idx").."/".."followees".."?limit=10",
    "https://api.zhihu.com/people/"..activity.getSharedData("idx").."/".."following_news_specials".."?limit=10",
    "https://api.zhihu.com/people/"..activity.getSharedData("idx").."/".."following_roundtables".."?limit=10",
  })

  local pos=page_home.getCurrentItem()+1
  local home_item=home_items[pos]
  home_pageinfo[home_item].refer(true)

end


function getuserinfo()

  local myurl= 'https://www.zhihu.com/api/v4/me'

  zHttp.get(myurl,head,function(code,content)

    if code==200 then--判断网站状态
      local data=luajson.decode(content)
      local 名字=data.name
      local 头像=data.avatar_url
      local 签名=data.headline
      local uid=data.id
      activity.setSharedData("idx",uid)
      侧滑头.onClick=function()
        activity.newActivity("people",{uid})
      end
      loadglide(头像id,头像,false)
      名字id.Text=名字
      if #签名:gsub(" ","")<1 then
        签名id.Text="你还没有签名呢"
       else
        签名id.Text=签名
      end
      sign_out.setVisibility(View.VISIBLE)
      成功登录回调()
     else
      --状态码不为200的事件
      侧滑头.onClick=function()
        activity.newActivity("login")
      end
      HometabLayout.setVisibility(8)
      loadglide(头像id,logopng)
      名字id.Text="未登录，点击登录"
      签名id.Text="获取失败"
      sign_out.setVisibility(8)

    end
  end)

end

getuserinfo()

function onActivityResult(a,b,c)
  if b==100 then
    getuserinfo()
   elseif b==1200 then --夜间模式开启
    设置主题()
   elseif b==1300 then
    加载主页tab()
   elseif b==1600 then
    collection_pagetool
    :clearItem(1)
    :refer(1)
  end
end


local opentab={}
function check()
  if activity.getSharedData("自动打开剪贴板上的知乎链接")~="true" then return end
  import "android.content.*"
  --导入包
  local url=activity.getSystemService(Context.CLIPBOARD_SERVICE).getText()

  url=tostring(url)

  if opentab[url]~=true then
    if url:find("zhihu.com") and 检查链接(url,true) then
      双按钮对话框("提示","检测到剪贴板里含有知乎链接，是否打开？","打开","取消",function(an)关闭对话框(an)
        opentab[url]=true
        检查链接(url)
      end
      ,function(an)
        opentab[url]=true
        关闭对话框(an)
      end)
    end
  end
end

function onResume()
  activity.getDecorView().post{run=function()check()end}
end


if this.getSharedData("自动检测更新")=="true" then
  local update_api="https://gitee.com/api/v5/repos/huaji110/huajicloud/contents/zhihu_hydrogen.html?access_token=abd6732c1c009c3912cbfc683e10dc45"
  Http.get(update_api,head,function(code,content)
    if code==200 then
      local content_json=luajson.decode(content)
      local content=base64dec(content_json.content)
      updateversioncode=tonumber(content:match("updateversioncode%=(.+),updateversioncode"))
      isstart=content:match("start%=(.+),start")
      support_version=tonumber(content:match("supportversion%=(.+),supportversion"))
      this.setSharedData("解析zse开关",isstart)
      if updateversioncode > versionCode and tonumber(activity.getSharedData("version"))~=updateversioncode then
        updateversionname=content:match("updateversionname%=(.+),updateversionname")
        updateinfo=content:match("updateinfo%=(.+),updateinfo")
        updateurl=tostring(content:match("updateurl%=(.+),updateurl"))
        if versionCode >= support_version then
          myupdatedialog=AlertDialog.Builder(this)
          .setTitle("检测到最新版本")
          .setMessage("最新版本："..updateversionname.."("..updateversioncode..")\n"..updateinfo)
          .setCancelable(false)
          .setPositiveButton("立即更新",nil)
          .setNeutralButton("忽略本次更新",{onClick=function() activity.setSharedData("version",tostring(updateversioncode)) end})
          .show()
          myupdatedialog.create()
          myupdatedialog.getButton(myupdatedialog.BUTTON_POSITIVE).onClick=function()
            local result=get_write_permissions()
            if result~=true then
              return false
            end
            下载文件对话框("下载安装包中",updateurl,"Hydrogen.apk",false)
          end
         else
          下载方法=content:match("nosupportWay%=(.+),nosupportWay")
          下载提示=content:match("nosupportTip%=(.+),nosupportTip")
          myupdatedialog=AlertDialog.Builder(this)
          .setTitle("检测到最新版本")
          .setMessage("最新版本："..updateversionname.."("..updateversioncode..")\n"..updateinfo)
          .setCancelable(false)
          .setPositiveButton("立即更新",nil)
          .setNeutralButton("暂不更新",{onClick=function() 提示("本次更新为强制更新 下次打开软件会再次提示哦") end})
          .show()
          myupdatedialog.create()
          myupdatedialog.getButton(myupdatedialog.BUTTON_POSITIVE).onClick=function()
            if 下载方法=="native" then
              local result=get_write_permissions()
              if result~=true then
                return false
              end
              下载文件对话框("下载安装包中",updateurl,"Hydrogen.apk",false)
             else
              提示(下载提示)
              浏览器打开(updateurl)
            end
          end
        end
      end
     else
      myupdatedialog=AlertDialog.Builder(this)
      .setTitle("提示")
      .setMessage("检测版本失败 如若是网络问题 请找到网络信号良好的地方使用 如果检查网络后不是网络问题 请打开官网更新 或前往项目页查看往下滑查看最新下载链接 如果开源项目页没了 软件就是寄了")
      .setCancelable(false)
      .setPositiveButton("官网",nil)
      .setNeutralButton("忽略",nil)
      .setNegativeButton("项目页",nil)
      .show()
      myupdatedialog.findViewById(android.R.id.message).TextIsSelectable=true
      myupdatedialog.getButton(myupdatedialog.BUTTON_POSITIVE).onClick=function()
        浏览器打开("https://huajiqaq.github.io/myhydrogen")
      end
      myupdatedialog.getButton(myupdatedialog.BUTTON_NEGATIVE).onClick=function()
        浏览器打开("https://gitee.com/huajicloud/hydrogen")
      end
      myupdatedialog.getButton(myupdatedialog.BUTTON_NEUTRAL).onClick=function()
        myupdatedialog.dismiss()
      end

    end
  end)
end

if activity.getSharedData("自动清理缓存")=="true" then
  清理内存()
end

task(1,function()
  a=MUKPopu({
    tittle="菜单",
    list={
      {src=图标("email"),text="反馈",onClick=function()
          跳转页面("feedback")
      end},
      {src=图标("info"),text="关于",onClick=function()
          跳转页面("about")
      end},
    }
  })
end)


lastclick = os.time() - 2
function onKeyDown(code,event)
  local now = os.time()
  if string.find(tostring(event),"KEYCODE_BACK") ~= nil then
    --监听返回键
    if a and a.pop.isShowing() then
      --如果菜单显示，关闭菜单并阻止返回键
      a.pop.dismiss()
      return true
    end
    if _drawer.isDrawerOpen(Gravity.LEFT) then
      --如果左侧侧滑显示，关闭左侧侧滑并阻止返回键
      _drawer.closeDrawer(Gravity.LEFT)
      return true
    end
    if now - lastclick > 2 then
      --双击退出
      提示("再按一次退出")
      lastclick = now
      return true
    end
  end

  if this.getSharedData("音量键选择tab")~="true" then
    return false
  end
  local allcount=HometabLayout.getTabCount()
  if page_home.getCurrentItem()~=0 or allcount<1 then
    return false
  end
  --音量键up
  if code==KeyEvent.KEYCODE_VOLUME_UP then
    mcount=HometabLayout.getSelectedTabPosition()+1
    if mcount== allcount then
      提示("后面没内容了")
      return true
    end
    local tab=HometabLayout.getTabAt(mcount);
    tab.select()
    return true;
    --音量键down
   elseif code== KeyEvent.KEYCODE_VOLUME_DOWN then
    mcount=HometabLayout.getSelectedTabPosition()-1
    if mcount<0 then
      提示("前面没内容了")
      return true
    end
    local tab=HometabLayout.getTabAt(mcount);
    tab.select()
    return true;
  end

end

data=...
function onCreate()
  if data then
    local intent=tostring(data.getData())
    检查意图(intent)
  end
end

if not(this.getSharedData("hometip0.02")) then
  task(50,function()
    if _drawer.isDrawerOpen(Gravity.LEFT) then
      --如果左侧侧滑显示，关闭左侧侧滑并阻止返回键
      _drawer.closeDrawer(Gravity.LEFT)
      return
    end
    _drawer.openDrawer(Gravity.LEFT)
    AlertDialog.Builder(this)
    .setTitle("小提示")
    .setCancelable(false)
    .setMessage("你可点击更多来查看更多功能")
    .setPositiveButton("我知道了",{onClick=function() activity.setSharedData("hometip0.02","true") end})
    .show()
  end)
end

if not(this.getSharedData("updatetip0.01"))and Build.VERSION.SDK_INT <=28 then
  AlertDialog.Builder(this)
  .setTitle("小提示")
  .setCancelable(false)
  .setMessage("如果webview版本过低 可能导致软件基本功能无法使用 建议升级webview使用 升级方法请自行查找")
  .setPositiveButton("我知道了",{onClick=function() activity.setSharedData("updatetip0.01","true") end})
  .show()
end

local packageName = this.getPackageName();
--创建一个Intent对象，用于启动该应用的主Activity
local launchIntent = this.getPackageManager().getLaunchIntentForPackage(packageName);
if launchIntent ~= nil then
  -- 获取应用的ComponentName
  componentName = launchIntent.getComponent();
  if componentName ~= nil then
    --使用PackageManager清除应用图标缓存
    packageManager = this.getPackageManager();
    packageManager.clearPackagePreferredActivities(packageName);
    --禁用应用图标并重新启用
    packageManager.setComponentEnabledSetting(componentName,
    PackageManager.COMPONENT_ENABLED_STATE_DISABLED, PackageManager.DONT_KILL_APP);
    packageManager.setComponentEnabledSetting(componentName,
    PackageManager.COMPONENT_ENABLED_STATE_ENABLED, PackageManager.DONT_KILL_APP);
  end
end

if this.getSharedData("切换webview")=="true" then
  if pcall(function() this.getPackageManager().getPackageInfo(webview_packagename,0) end)==false then
    this.setSharedData("切换webview","false")
    return showSimpleDialog("提示","检测不到谷歌浏览器 已自动关闭切换webview")
  end
  import "com.norman.webviewup.lib.WebViewUpgrade"
  import "com.norman.webviewup.lib.source.UpgradePackageSource"
  if WebViewUpgrade.getUpgradeWebViewPackageName()==webview_packagename then
    local upgradeSource = UpgradePackageSource(this.getApplicationContext(),webview_packagename);
    WebViewUpgrade.upgrade(upgradeSource);
  end
end

if this.getSharedData("智能无图模式")=="true" then
  function onStart()
    if 无图模式提醒==true then
      return
    end
    connMgr= this.getSystemService(Context.CONNECTIVITY_SERVICE);
    info=connMgr.getActiveNetworkInfo()
    netType=info.getType()

    if netType==ConnectivityManager.TYPE_WIFI then
      isWifiConn=info.isConnected();
    end

    if netType==ConnectivityManager.TYPE_MOBILE then
      isMobileConn=info.isConnected();
    end

    无图模式=Boolean.valueOf(activity.getSharedData("不加载图片"))
    if isWifiConn and 无图模式==true then
      双按钮对话框("提示","当前在WiFi下 是否关闭不加载图片","关闭","暂不关闭",function(an)
        activity.setSharedData("不加载图片","false")
        提示("关闭不加载图片成功")
        关闭对话框(an)
        end,function(an)
        无图模式提醒=true
        关闭对话框(an)
      end)
     elseif isMobileConn and 无图模式==false then
      双按钮对话框("提示","当前在流量下 是否开启不加载图片","开启","暂不开启",function(an)
        activity.setSharedData("不加载图片","true")
        提示("开启不加载图片成功")
        关闭对话框(an)
        end,function(an)
        无图模式提醒=true
        关闭对话框(an)
      end)
    end
  end
end