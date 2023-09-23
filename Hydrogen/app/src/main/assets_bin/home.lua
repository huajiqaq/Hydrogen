require "import"
import "mods.muk"

import "android.os.Handler"
import "java.lang.Runnable"
import "android.widget.ImageView$ScaleType"
import "com.lua.custrecycleradapter.*"
import "androidx.recyclerview.widget.*"

import "com.google.android.material.bottomnavigation.BottomNavigationView"
import "androidx.viewpager.widget.ViewPager"
import "androidx.core.widget.NestedScrollView"
import "androidx.appcompat.widget.LinearLayoutCompat"
import "com.google.android.material.appbar.*"
import "com.google.android.material.floatingactionbutton.FloatingActionButton"

import "androidx.swiperefreshlayout.widget.*"
import "com.google.android.material.tabs.TabLayout"

import "com.bumptech.glide.Glide"

--import "com.daimajia.androidanimations.library.Techniques"
--import "com.daimajia.androidanimations.library.YoYo"
import "com.getkeepsafe.taptargetview.*"

activity.setSupportActionBar(toolbar)
activity.setContentView(loadlayout("layout/home"))

初始化历史记录数据(true)

if activity.getSharedData("第一次提示") ==nil then
  双按钮对话框("注意","该软件仅供交流学习，严禁用于商业用途，请于下载后的24小时内卸载","登录","知道了",function()
    activity.setSharedData("第一次提示","x")
    跳转页面("login")
    关闭对话框(an)
    activity.finish()
    end,function()
    activity.setSharedData("第一次提示","x")
    关闭对话框(an)
  end)
end

if activity.getSharedData("第一次提示") and activity.getSharedData("开源提示")==nil then
  activity.setSharedData("开源提示","true")
  双按钮对话框("提示","本软件已开源 请问是否跳转开源页面?","我知道了","跳转开源地址",function()
  关闭对话框(an) end,function()
    关闭对话框(an) 浏览器打开("https://gitee.com/huajicloud/Hydrogen/")
  end)
end


if this.getSharedData("自动清理缓存") == nil then
  this.setSharedData("自动清理缓存","true")
end

if this.getSharedData("标题简略化") == nil then
  this.setSharedData("标题简略化","false")
end

if this.getSharedData("全屏模式") == nil then
  this.setSharedData("全屏模式","false")
end

if this.getSharedData("开启想法") == nil then
  this.setSharedData("开启想法","false")
end

if this.getSharedData("font_size")==nil then
  this.setSharedData("font_size","20")
end

if this.getSharedData("Setting_Auto_Night_Mode")==nil then
  activity.setSharedData("Setting_Auto_Night_Mode","true")
end

pagadp=SWKLuaPagerAdapter()

local home_layout_table=require("layout/home_layout/page_home")

m = {
  { MenuItem,
    title = "主页",
    id = "home_tab",
    enabled=true;
    icon = 图标("home");
  },
  { MenuItem,
    title = "想法",
    id = "think_tab",
    enabled=true;
    icon = 图标("bubble_chart")
  },
  { MenuItem,
    title = "热榜",
    id = "hot_tab",
    enabled=true;
    icon = 图标("fire")
  },
  { MenuItem,
    title = "关注",
    id = "following_tab",
    enabled=true;
    icon = 图标("group")
  },

}

if this.getSharedData("开启想法")=="true" then
  home_list={["推荐"]=0,["想法"]=1,["热榜"]=2,["关注"]=3}
 elseif this.getSharedData("开启想法")=="false" then
  home_list={["推荐"]=0,["热榜"]=1,["关注"]=2}
  if this.getSharedData("starthome")=="想法" then
    this.setSharedData("starthome","推荐")
    提示("由于想法已关闭 主页为想法 为避免异常已调整主页为推荐")
  end

  table.remove(home_layout_table,2)
  table.remove(m,2)
end

for i =1,#home_layout_table do
  pagadp.add(loadlayout(home_layout_table[i]))
end



page_home.setAdapter(pagadp)

optmenu = {}
loadmenu(bnv.getMenu(), m, optmenu, 3)


_title.setText("主页")

--主页布局
itemc2=获取适配器项目布局("home/home_layout")
requrl={}

function 切换页面(z)--切换主页Page函数
  if this.getSharedData("开启想法")~="true" and z>0 then
    page_home.setCurrentItem(z-1)
   else
    page_home.setCurrentItem(z)
  end
end

homeapphead=table.clone(apphead)
homeapphead["x-close-recommend"]="0"
homeapphead["x-feed-prefetch"]="1"

homeapphead1=table.clone(apphead)
homeapphead1["scroll"]="down"

function resolve_feed(v)

  --    local 点赞数=tointeger(v.target.voteup_count)
  --    local 评论数=tointeger(v.target.comment_count)
  v.extra.type=string.lower(v.extra.type)
  if v.type~="common_card" then
    return false
  end
  if #v.common_card.footline.elements==1 then
    底部内容=v.common_card.footline.elements[1].text.panel_text
   elseif #v.common_card.footline.elements==2
    底部内容=v.common_card.footline.elements[2].text.panel_text
   elseif #v.common_card.footline.elements==3
    local 底部tab={}
    for e, c in pairs(v.common_card.footline.elements) do
      if c.interactive_button then
        table.insert(底部tab,c.interactive_button.interactive_button.text.panel_text)
       else
        table.insert(底部tab,c.button.text.panel_text)
      end
    end
    底部内容=底部tab[1].." 赞同 · "..底部tab[1].." 收藏 · "..底部tab[3].." 评论"
  end
  if 底部内容==nil then
    底部内容="未知"
  end
  底部内容=底部内容:gsub("等 ","")
  local 标题,问题id等;
  local 作者=v.common_card.feed_content.source_line.elements[2].text.panel_text
  --[[
    if type(v.target.excerpt)=="nil" or v.target.excerpt=="" then
      if v.target.thumbnail_extra_info then
        v.target.excerpt="[视频]"
      end
    end
  ]]
  local 预览内容
  --print(dump(v))
  if v.extra.type=="pin" then
    问题id等="想法分割"..v.extra.id--由于想法的id长达18位，而cJSON无法解析这么长的数字，所以暂时用截取url结尾的数字字符串来获取id
    标题=作者.."发表了想法"
    if v.common_card.feed_content.content then
      预览内容=作者.." : "..v.common_card.feed_content.content.panel_text
     elseif v.common_card.feed_content.video
      预览内容=作者.." : ".."[视频]"
    end
   elseif v.extra.type=="answer" then
    问题id等="null"
    问题id等=问题id等.."分割"..tointeger(v.extra.id)
    标题=v.common_card.feed_content.title.panel_text
    if v.common_card.feed_content.content then
      预览内容=作者.." : "..v.common_card.feed_content.content.panel_text
     elseif v.common_card.feed_content.video
      预览内容=作者.." : ".."[视频]"
    end
   elseif v.extra.type=="article" then--????????没有测到这个推荐流
    问题id等="文章分割"..tointeger(v.extra.id)
    标题=v.common_card.feed_content.title.panel_text
    if v.common_card.feed_content.content then
      预览内容=作者.." : "..v.common_card.feed_content.content.panel_text
     elseif v.common_card.feed_content.video
      预览内容=作者.." : ".."[视频]"
    end
   elseif v.extra.type=="zvideo" then
    问题id等="视频分割"..v.extra.id
    标题=v.common_card.feed_content.title.panel_text
    预览内容=作者.." : ".."[视频]"
   else
    if this.getSharedData("调式模式")=="true" then
      提示("未知类型"..v.extra.type or "无法获取type".." id"..v.extra.id or "无法获取id")
    end
    return false
  end
  local testy=v.brief
  local testk='"t"'
  return {底部内容=底部内容,标题2=标题,文章2=预览内容,链接2=问题id等,testy=testy,testk=testk}
end

function 主页推荐刷新(isprev)

  local result=tointeger(choosebutton)

  local myrequrl
  local addargs="&start_type=warm&tsp_ad_cardredesign=0&v_serial=1"

  if requrl[result] then
    if isprev then
      myrequrl=requrl[result]["prev"]..addargs
     else
      myrequrl=requrl[result]["next"]..addargs
    end
  end
  local murl
  if choose_sub then
    murl="https://api.zhihu.com/feed-root/section/"..result.."?sub_page_id="..tointeger(choose_sub).."&channelStyle=0"
   else
    murl="https://api.zhihu.com/feed-root/section/"..result.."?channelStyle=0"
  end
  local url= myrequrl or murl
  zHttp.get(url,homeapphead1,function(code,content)
    if code==200 then
      homeapphead1["x-close-recommend"]="0"
      decoded_content = luajson.decode(content)
      if decoded_content.paging.is_end==false then
        requrl[result]={
          ["next"] = decoded_content.paging.next,
          ["prev"] = decoded_content.paging.previous,
        }
        主页加载数据长度=0
        for k,v in ipairs(decoded_content.data) do
          local 添加数据=resolve_feed(v)
          if 添加数据 then
            主页加载数据长度=主页加载数据长度+1
            table.insert(list2.adapter.getData(),添加数据)
          end
        end
        task(1,function() list2.adapter.notifyDataSetChanged()end)
      end
    end
  end)
end

function 主页随机推荐 (isprev)

  local myrequrl
  local addargs="&start_type=warm&refresh_scene=0&device=phone&short_container_setting_value=1"

  if requrl[-1] then
    if isprev then
      myrequrl=requrl[-1]["prev"]..addargs
     else
      myrequrl=requrl[-1]["next"]..addargs
    end
  end
  local posturl = myrequrl or "https://api.zhihu.com/topstory/recommend?tsp_ad_cardredesign=0&feed_card_exp=card_corner|1&v_serial=1&isDoubleFlow=0&action=down&refresh_scene=0&scroll=up&limit=10&start_type=cold&device=phone&short_container_setting_value=2"
  zHttp.get(posturl,homeapphead,function(code,content)
    if code==200 then
      homeapphead["x-feed-prefetch"]="0"
      decoded_content = luajson.decode(content)
      主页加载数据长度=0
      for k,v in ipairs(decoded_content.data) do
        local 添加数据=resolve_feed(v)
        if 添加数据 then
          主页加载数据长度=主页加载数据长度+1
          table.insert(list2.adapter.getData(),添加数据)
        end
      end
      task(1,function() list2.adapter.notifyDataSetChanged()end)
      requrl[-1] = {
        ["next"] = decoded_content.paging.next,
        ["prev"] = decoded_content.paging.previous,
      }
     elseif code==401 then
      activity.setSharedData("signdata",nil)
      清除所有cookie()
      提示("请登录后访问推荐，http错误码401")
     else
      提示("获取数据失败，请检查网络是否正常，http错误码"..code)
    end

  end)
end


function 主页刷新(isclear,isprev)

  if not list2.adapter or isclear then

    homeapphead["x-feed-prefetch"]="1"
    homeapphead1["x-close-recommend"]=nil

    local yxuan_adpqy=LuaAdapter(activity,itemc2)
    list2.adapter=yxuan_adpqy

    list2.setOnItemClickListener(AdapterView.OnItemClickListener{
      onItemClick=function(parent,v,pos,id)

        v.Tag.testk.Text='"r"'
        list2.adapter.getData()[list2.getPositionForView(v)+1].testk='"r"'

        local postdata=luajson.encode(v.Tag.testy.Text)
        postdata=urlEncode('[['..v.Tag.testk.Text..','..postdata..']]')
        postdata="targets="..postdata

        zHttp.post("https://api.zhihu.com/lastread/touch/v2",postdata,apphead,function(code,content)
          if code==200 then
          end
        end)


        local open=activity.getSharedData("内部浏览器查看回答")
        if tostring(v.Tag.链接2.text):find("文章分割") then

          activity.newActivity("column",{tostring(v.Tag.链接2.Text):match("文章分割(.+)"),tostring(v.Tag.链接2.Text):match("分割(.+)")})

         elseif tostring(v.Tag.链接2.text):find("想法分割") then
          activity.newActivity("column",{tostring(v.Tag.链接2.Text):match("想法分割(.+)"),"想法"})

         elseif tostring(v.Tag.链接2.text):find("视频分割") then
          activity.newActivity("column",{tostring(v.Tag.链接2.Text):match("视频分割(.+)"),"视频"})

         else

          保存历史记录(v.Tag.标题2.Text,v.Tag.链接2.Text,50)

          if open=="false" then

            activity.newActivity("answer",{tostring(v.Tag.链接2.Text):match("(.+)分割"),tostring(v.Tag.链接2.Text):match("分割(.+)")})
           else
            activity.newActivity("huida",{"https://www.zhihu.com/question/"..tostring(v.Tag.链接2.Text):match("(.+)分割").."/answer/"..tostring(v.Tag.链接2.Text):match("分割(.+)")})
          end
        end
      end
    })

    list2.setOnItemLongClickListener(AdapterView.OnItemLongClickListener{
      onItemLongClick=function(parent, v, pos,id)
        local mytype
        local myid
        if tostring(v.Tag.链接2.text):find("文章分割") then
          mytype="article"
          myid=tostring(v.Tag.链接2.Text):match("文章分割(.+)")
         elseif tostring(v.Tag.链接2.text):find("想法分割") then
          mytype="pin"
          myid=tostring(v.Tag.链接2.Text):match("想法分割(.+)")
         elseif tostring(v.Tag.链接2.text):find("视频分割") then
          mytype="zvideo"
          myid=tostring(v.Tag.链接2.Text):match("视频分割(.+)")
         else
          mytype="answer"
          myid=tostring(v.Tag.链接2.Text):match("分割(.+)")
        end
        zHttp.get("https://api.zhihu.com/negative-feedback/panel?scene_code=RECOMMEND&content_type="..mytype.."&content_token="..myid,apphead,function(code,content)
          if code==200 then
            local pop=PopupMenu(activity,v)
            menu=pop.Menu
            local data=luajson.decode(content).data.items
            for k,v in ipairs(data) do
              local mbutton=v.raw_button
              local method=string.lower(mbutton.action.method)
              menu.add(mbutton.text.panel_text).onMenuItemClick=function()
                if mbutton.action.backend_url then
                  zHttp.request(mbutton.action.backend_url,method,"",apphead,function(code,content)
                    if code==200 then
                      提示(mbutton.text.toast_text)
                    end
                  end)
                 elseif mbutton.action.intent_url then
                  activity.newActivity("huida",{mbutton.action.intent_url.."&source=android&ab_signature=",nil,nil,nil,"举报"})
                end
              end
              pop.show()--显示
            end
          end
        end)
        return true
      end
    })

    可以加载主页=true


    list2.setOnScrollListener{
      onScroll=function(view,a,b,c)
        if a+b==c and 可以加载主页 then

          if 主页加载数据长度 then
            local num=#list2.adapter.getData()-tonumber(主页加载数据长度)+1
            local postdata=""
            for i=num,#list2.adapter.getData() do
              local local_postdata=luajson.encode(list2.adapter.getData()[i].testy)
              local addstr
              if i~=#list2.adapter.getData() then
                addstr=","
               else
                addstr=""
              end
              local_postdata='['..list2.adapter.getData()[i].testk..','..local_postdata..']'..addstr
              postdata=postdata..local_postdata
            end
            postdata="targets="..urlEncode("["..postdata.."]")

            zHttp.post("https://api.zhihu.com/lastread/touch/v2",postdata,apphead,function(code,content)
              if code==200 then
              end
            end)
          end

          主页刷新()
          System.gc()
          homesr.setRefreshing(true)
          可以加载主页=false
          Handler().postDelayed(Runnable({
            run=function()
              可以加载主页=true
              homesr.setRefreshing(false);
            end,
          }),1000)
        end
      end
    }

    return

  end
  if choosebutton==nil then
    主页随机推荐(isprev)
   elseif choosebutton then
    主页推荐刷新(isprev)
  end
end

homesr.setProgressBackgroundColorSchemeColor(转0x(backgroundc));
homesr.setColorSchemeColors({转0x(primaryc)});
homesr.setOnRefreshListener({
  onRefresh=function()
    主页刷新(true,true)
    Handler().postDelayed(Runnable({
      run=function()
        homesr.setRefreshing(false);
      end,
    }),1000)

  end,
});

主页刷新()

function bnv.onNavigationItemSelected(item)
  item = item.getTitle();
  activity.setTitle(item)
  if item =="主页" then item="推荐" end
  page_home.setCurrentItem(home_list[item])
  return true;
end

page_home.addOnPageChangeListener(ViewPager.OnPageChangeListener {

  onPageScrolled=function( position, positionOffset, positionOffsetPixels)

  end;


  onPageSelected=function(position)
    local pos=position
    if this.getSharedData("开启想法") ~="true" then
      pos=pos+1
    end
    if position == 0 then
      pos=position
    end
    for i=0,bnv.getChildCount() do
      bnv.getMenu().getItem(i).setChecked(false)
    end
    bnv.getMenu().getItem(position).setChecked(true)
    _title.text=(bnv.getMenu().getItem(position).getTitle())

    if pos == 1 then
      想法刷新()
    end

    if pos == 2 then
      import "model.hot"
      hotdata=hot:new()
      hotdata:getPartition(function()
        热榜刷新()
      end)
    end

    if pos == 3 then
      关注刷新(nil,false)
    end
  end;

  onPageScrollStateChanged=function(state)

  end
});

function 日报刷新(isclear)

  if not(itemc3) or isclear then
    itemc3=获取适配器项目布局("home/home_daily")
    thisdata=1
    yuxun_adpqy=LuaAdapter(activity,itemc3)
    list1.Adapter=yuxun_adpqy
    news={}
    list1.setOnItemClickListener(AdapterView.OnItemClickListener{
      onItemClick=function(parent,v,pos,id)
        --    activity.newActivity("huida",{"https://daily.zhihu.com/story/"..v.Tag.导向链接3.Text})
        activity.newActivity("huida",{v.Tag.导向链接3.Text})
      end

    })

    dailysr.setProgressBackgroundColorSchemeColor(转0x(backgroundc));
    dailysr.setColorSchemeColors({转0x(primaryc)});
    dailysr.setOnRefreshListener({
      onRefresh=function()
        日报刷新(true)
        Handler().postDelayed(Runnable({
          run=function()
            dailysr.setRefreshing(false);
          end,
        }),1000)

      end,
    });

    可以加载日报=true

    list1.setOnScrollListener{
      onScroll=function(view,a,b,c)
        if a+b==c and 可以加载日报 and view.adapter.getCount()>0 then
          日报刷新()
          dailysr.setRefreshing(true)
          System.gc()
          可以加载日报=false
          Handler().postDelayed(Runnable({
            run=function()
              可以加载日报=true
              dailysr.setRefreshing(false);
            end,
          }),1000)
        end
      end
    }


  end

  --链接='http://www.zhihudaily.me/'
  thisdata=thisdata-1
  import "android.icu.text.SimpleDateFormat"
  cal=Calendar.getInstance();
  cal.add(Calendar.DATE,tointeger(thisdata));
  d=cal.getTime();
  sp= SimpleDateFormat("yyyyMMdd");
  ZUOTIAN=sp.format(d);
  链接 = 'https://kanzhihu.pro/api/news/'..tostring(ZUOTIAN)
  Http.get(链接,head,function(code,content)
    --  news[tostring(ZUOTIAN)]=content
    if code==200 then
     else
      return
    end
    if thisdata==0 then
      newnews=content
     elseif thisdata==-1 then
      if content==newnews
        return
      end
    end

    for k,v in ipairs(luajson.decode(content).data.stories) do
      table.insert(yuxun_adpqy.getData(),{标题3=v.title,导向链接3=v.url})
      task(1,function() yuxun_adpqy.notifyDataSetChanged()end)
    end
  end)
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
    _drawer.getChildAt(0).translationX=_drawer.getChildAt(1).getChildAt(0).width*z
end})

ch_item_checked_background = GradientDrawable()
.setShape(GradientDrawable.RECTANGLE)
.setColor(转0x(primaryc)-0xde000000)
.setCornerRadii({0,0,dp2px(24),dp2px(24),dp2px(24),dp2px(24),0,0});

ch_item_nochecked_background = GradientDrawable()
.setShape(GradientDrawable.RECTANGLE)
.setCornerRadii({0,0,dp2px(24),dp2px(24),dp2px(24),dp2px(24),0,0});


--侧滑列表项目
drawer_item={
  {--侧滑标题 (type1)
    LinearLayout;
    Focusable=true;
    layout_width="fill";
    layout_height="wrap";
    {
      TextView;
      id="title";
      textSize="14sp";
      textColor=primaryc;
      layout_marginTop="8dp";
      layout_marginLeft="16dp";
      Typeface=字体("product");
    };
  };

  {--侧滑项目 (type2)
    RelativeLayout;
    layout_width="-1";
    layout_height="48dp";
    BackgroundColor=backgroundc;
    {
      MaterialCardView;
      layout_width="-1";
      layout_height="-1";
      StrokeColor=cardedge;
      CardBackgroundColor=backgroundc;
      layout_marginTop="1dp";
      layout_marginRight="8dp";
      StrokeWidth=0,
      Background=ch_item_nochecked_background;
      {
        LinearLayout;
        layout_width="-1";
        layout_height="-1";
        gravity="center|left";
        ripple="圆自适应";
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
          id="tv";
          layout_marginLeft="16dp";
          textSize="14sp";
          Typeface=字体("product");
        };
      };
    };
  };

  {--侧滑项目_选中项 (type3)
    RelativeLayout;
    layout_width="-1";
    layout_height="48dp";
    BackgroundColor=backgroundc;
    {
      MaterialCardView;
      layout_width="-1";
      layout_height="-1";
      CardBackgroundColor=转0x(primaryc)-0xde000000;
      layout_marginTop="1dp";
      layout_marginRight="8dp";
      StrokeWidth=0,
      Background=ch_item_checked_background;
      {
        LinearLayout;
        layout_width="-1";
        layout_height="-1";
        gravity="center|left";
        ripple="圆自适应";
        {
          ImageView;
          id="iv";
          ColorFilter=primaryc;
          layout_marginLeft="24dp";
          layout_width="24dp";
          layout_height="24dp";
        };
        {
          TextView;
          id="tv";
          layout_marginLeft="16dp";
          textSize="14sp";
          textColor=primaryc;
          Typeface=字体("product");
        };
      };
    };
  };

  {--侧滑_分割线 (type4)
    LinearLayout;
    layout_width="-1";
    layout_height="-2";
    gravity="center|left";
    onClick=function()end;
    {
      TextView;
      layout_width="-1";
      layout_height="3px";
      --     background=cardedge,
      background=cardback,
      layout_marginTop="8dp";
      layout_marginBottom="8dp";
    };
  };
};


--侧滑列表适配器
adp=LuaMultiAdapter(activity,drawer_item)
adp.add{__type=4}
adp.add{__type=3,iv={src=图标("home")},tv="主页"}
adp.add{__type=2,iv={src=图标("book")},tv="收藏"}
adp.add{__type=2,iv={src=图标("work")},tv="日报"}
adp.add{__type=2,iv={src=图标("bubble_chart")},tv="想法"}
adp.add{__type=4}
adp.add{__type=2,iv={src=图标("settings")},tv="设置"}
adp.add{__type=4}
adp.add{__type=2,iv={src=图标("settings")},tv="设置"}
adp.add{__type=2,iv={src=图标("settings")},tv="测试"}
adp.add{__type=2,iv={src=图标("bug_report")},tv="Cookie"}
drawer_lv.setAdapter(adp)

--侧滑项目
ch_table={
  "分割线",
  {"主页","home",},
  {"收藏","book",},
  {"日报","work",},
  {"消息","message",},
  "分割线",
  {"一文","insert_drive_file",},
  {"本地","inbox",},
  "分割线",
  {"历史","history",},
  {"设置","settings",},
};



--侧滑列表高亮项目函数
function ch_light(n)
  adp.clear()
  for i,v in ipairs(ch_table) do
    if v=="分割线"then
      adp.add{__type=4}
     elseif n==v[1] then
      adp.add{__type=3,iv={src=图标(v[2])},tv=v[1]}
     else
      adp.add{__type=2,iv={src=图标(v[2])},tv=v[1]}
    end
  end
end

ch_light("主页")--设置高亮项目为“主页”
--侧滑列表点击事件
drawer_lv.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(id,v,zero,one)
    --项目点击事件
    local s=v.Tag.tv.Text

    if s=="退出" then--判断项目并执行代码
      关闭页面()
     elseif s=="主页" then
      --setmyToolip在loadlayout中
      setmyToolip(_ask,"提问")
      _ask.onClick=function()
        if not(getLogin()) then
          return 提示("你可能需要登录")
        end
        task(20,function()
          activity.newActivity("huida",{"https://www.zhihu.com/messages","提问",true})
        end)
      end
      ch_light("主页")
      if isstart=="true" then
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
      --显示主页viewpager
      控件显示(page_home)
      --显示主页底部栏
      控件显示(bottombar)
      控件隐藏(page_daily)
      控件隐藏(page_collections)
      切换页面(0)
      _title.setText("主页")
     elseif s=="日报" then
      setmyToolip(_ask,"提问")
      _ask.onClick=function()
        if not(getLogin()) then
          return 提示("你可能需要登录")
        end
        task(20,function()
          activity.newActivity("huida",{"https://www.zhihu.com/messages","提问",true})
        end)
      end
      ch_light("日报")
      日报刷新()
      --隐藏主页viewpager
      控件隐藏(page_home)
      --隐藏主页底部栏
      控件隐藏(bottombar)
      控件隐藏(page_collections)
      控件可见(page_daily)
      _title.setText("日报")
     elseif s=="收藏" then
      setmyToolip(_ask,"新建收藏夹")
      _ask.onClick=function()
        if not(getLogin()) then
          return 提示("你可能需要登录")
        end
        新建收藏夹(function(mytext,myid,ispublic)

          list4.adapter.add{
            collections_title={
              text=mytext,
            },
            is_lock=is_public==false and 图标("https") or nil,

            collections_art={
              text="0个内容"
            },
            collections_item={
              text="0"
            },
            collections_follower={
              text="0"
            },
            collections_id={
              text=tostring(myid)

            },
          }

        end)
      end
      ch_light("收藏")
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
                .setPositiveButton("确定", {onClick=function() activity.newActivity("search_result",{edit.text}) end})
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
      --隐藏主页viewpager
      控件隐藏(page_home)
      --隐藏主页底部栏
      控件隐藏(bottombar)
      控件隐藏(page_daily)
      控件可见(page_collections)
      task(400,function()收藏刷新(true) end)
      _title.setText("收藏")
     elseif s=="本地" then
      task(300,function()activity.newActivity("local_list")end)
     elseif s=="debug" then
      task(300,function()activity.newActivity("feedback")end)
     elseif s=="设置" then
      task(300,function()activity.newActivity("settings")end)
     elseif s=="一文" then
      task(300,function()activity.newActivity("artical")end)
     elseif s=="Cookie" then
      双按钮对话框("查看Cookie", 获取Cookie("https://www.zhihu.com/"),"复制","关闭",function()复制文本(获取Cookie("https://www.zhihu.com/"))提示("已复制到剪切板")关闭对话框(an)end,function()关闭对话框(an)end)
     elseif s=="历史" then
      task(300,function()activity.newActivity("history")end)
     elseif s=="消息" then

      if not(getLogin()) then
        return 提示("请登录后使用本功能")
      end
      task(20,function()
        AlertDialog.Builder(this)
        .setTitle("请选择")
        .setSingleChoiceItems({"通知","私信"}, 0,{onClick=function(v,p)
            if p==0 then
              jumpurl="https://www.zhihu.com/notifications"
            end
            if p==1 then
              jumpurl ="https://www.zhihu.com/messages"
            end
        end})
        .setNegativeButton("确定", {onClick=function() if jumpurl==nil then jumpurl="https://www.zhihu.com/notifications" end activity.newActivity("huida",{jumpurl,true,true}) jumpurl=nil 提示("如显示不全请自行缩放") end})
        .show();
      end)
     else
      Snakebar(s)

    end
    task(1,function()
      require "import"
      _drawer.closeDrawer(Gravity.LEFT)--关闭侧滑
    end)
end})




function 热榜刷新(isclear)

  if isclear or not(itemc) then

    itemc=获取适配器项目布局("home/home_hot")

    import "androidx.recyclerview.widget.LinearLayoutManager"

    热榜adp=LuaCustRecyclerAdapter(AdapterCreator({

      getItemCount=function()
        return #myhotdata
      end,

      getItemViewType=function(position)
        local data=myhotdata[position+1]
        if data.热图片.Visibility==0 then
          return 0
         else
          return 1
        end
      end,

      onCreateViewHolder=function(parent,viewType)
        local views={}
        local loaditemc
        if viewType==1 or activity.getSharedData("热榜关闭图片")=="true" then
          loaditemc=获取适配器项目布局("home/home_hot_noimage")
         else
          loaditemc=itemc
        end
        if activity.getSharedData("热榜关闭热度")=="true" then
          --tab索引的view为id为热度的view
          loaditemc[2][2][2][2][2][4][3]=nil
        end
        holder=LuaCustRecyclerHolder(loadlayout(loaditemc,views))
        holder.view.setTag(views)
        return holder
      end,

      onBindViewHolder=function(holder,position)
        local view=holder.view.getTag()
        local data=myhotdata[position+1]
        view.标题.text=data.标题
        if view.热度 then
          view.热度.text=tostring(data.热度)
        end
        view.排行.text=tostring(data.排行)
        view.导向链接.text=data.导向链接
        波纹({view.hot_ripple},"圆自适应")

        view.content.onClick=function()
          local open=activity.getSharedData("内部浏览器查看回答")
          if tostring(view.导向链接.text):find("文章分割") then
            activity.newActivity("column",{tostring(view.导向链接.Text):match("文章分割(.+)"),tostring(view.导向链接.Text):match("分割(.+)")})

           elseif tostring(view.导向链接.text):find("想法分割") then
            activity.newActivity("column",{tostring(view.链接2.Text):match("想法分割(.+)"),"想法"})
           else
            保存历史记录(view.标题.Text,view.导向链接.Text,50)
            if open=="false" then
              activity.newActivity("question",{view.导向链接.Text,nil})
             else
              activity.newActivity("huida",{"https://www.zhihu.com/question/"..tostring(view.导向链接.Text)})
            end
          end
        end

        if view.热图片 then
          loadglide(view.热图片,data.热图片.src)
        end

      end,
    }))


    myhotdata={}
    list3.setAdapter(热榜adp)
    list3.setLayoutManager(LinearLayoutManager(this,RecyclerView.VERTICAL,false))

    hotsr.setProgressBackgroundColorSchemeColor(转0x(backgroundc));
    hotsr.setColorSchemeColors({转0x(primaryc)});
    hotsr.setOnRefreshListener({
      onRefresh=function()
        热榜刷新(true)
        Handler().postDelayed(Runnable({
          run=function()
            hotsr.setRefreshing(false);
          end,
        }),1000)

      end,
    });

    pcall(function()热榜adp.clear()end)
    Handler().postDelayed(Runnable({
      run=function()
        zHttp.get(hotdata:getValue(nil,true),head,function(code,content)
          if code==200 then--判断网站状态
            local tab=luajson.decode(content).data

            for i=1,#tab do
              local 标题,热度,排行,导向链接=tab[i].target.title,tab[i].detail_text,i,tointeger(tab[i].target.id)..""
              local 热榜图片=tab[i].children[1].thumbnail
              if tab[i].target.type=="article" then
                导向链接="文章分割"..tointeger(tab[i].target.id)
              end
              table.insert(myhotdata,{标题=标题,热度=热度,排行=排行,导向链接=导向链接,热图片={src=热榜图片,Visibility=#热榜图片>0 and 0 or 8}})
            end
            热榜adp.notifyDataSetChanged()
           else
            --错误时的操作
          end
        end)
      end
    }),120)
  end
end

followapphead = table.clone(apphead)
followapphead["x-moments-ab-param"] = "follow_tab=1";


function 关注刷新(isclear,isprev,num)
  -- origin15.19 更改
  if num==nil then
    num=1
  end
  if isclear==nil and moments_tab and moments_tab[num] then
    if moments_tab[num].isend then
      return 提示("没有新内容了")
    end
    return false
  end
  local alltype={"recommend","timeline","pin"}
  local allsr={gsr_j,gsr_t,gsr_p}
  local allpage={list9,list10,list11}
  local thispage=allpage[num]
  local thissr=allsr[num]
  可以加载关注={true,true,true}
  if followpos then
    num=followpos
  end
  if isclear or not(follow_itemc) or moments_tab[num]==nil then


    if followTab.getTabCount()==0 then
      followTab.setupWithViewPager(fpage)
      local followTable={"精选","最新","想法"}

      --setupWithViewPager设置的必须手动设置text
      for i=1, #followTable do
        local itemnum=i-1
        local tab=followTab.getTabAt(itemnum)
        tab.setText(followTable[i]);
      end

      followTab.addOnTabSelectedListener(TabLayout.OnTabSelectedListener {
        onTabSelected=function(tab)
          --选择时触发
          local pos=tab.getPosition()+1
          followpos=pos
          关注刷新(nil,false,pos)
        end,

        onTabUnselected=function(tab)
          --未选择时触发
        end,

        onTabReselected=function(tab)
          --选中之后再次点击即复选时触发
          local pos=tab.getPosition()+1
          followpos=pos
          关注刷新(true,false,pos)
        end,
      });


    end


    --关注布局
    follow_itemc=获取适配器项目布局("home/home_following")
    if moments_tab==nil then
      moments_tab={}
    end
    moments_tab[num]={
      prev=false,
      nexturl=false,
      isend=false
    }

    thissr.setProgressBackgroundColorSchemeColor(转0x(backgroundc));
    thissr.setColorSchemeColors({转0x(primaryc)});
    thissr.setOnRefreshListener({
      onRefresh=function()
        关注刷新(true,true,num)
        Handler().postDelayed(Runnable({
          run=function()
            thissr.setRefreshing(false);
          end,
        }),1000)

      end,
    });

    可以加载关注[num]=true

    thispage.setOnItemClickListener(AdapterView.OnItemClickListener{
      onItemClick=function(parent,v,pos,id)
        local open=activity.getSharedData("内部浏览器查看回答")
        if tostring(v.Tag.follow_id.text):find("问题分割") then
          activity.newActivity("question",{tostring(v.Tag.follow_id.Text):match("问题分割(.+)"),true})
         elseif tostring(v.Tag.follow_id.text):find("文章分割") then
          activity.newActivity("column",{tostring(v.Tag.follow_id.Text):match("文章分割(.+)"),tostring(v.Tag.follow_id.Text):match("分割(.+)")})
         elseif tostring(v.Tag.follow_id.text):find("视频分割") then
          activity.newActivity("column",{tostring(v.Tag.follow_id.Text):match("视频分割(.+)"),"视频"})
         elseif tostring(v.Tag.follow_id.text):find("想法分割") then
          activity.newActivity("column",{tostring(v.Tag.follow_id.Text):match("想法分割(.+)"),"想法"})


         else
          保存历史记录(v.Tag.follow_title.Text,v.Tag.follow_id.Text,50)

          if open=="false" then
            activity.newActivity("answer",{tostring(v.Tag.follow_id.Text):match("(.+)分割"),tostring(v.Tag.follow_id.Text):match("分割(.+)")})
           else
            activity.newActivity("huida",{"https://www.zhihu.com/question/"..tostring(v.Tag.follow_id.Text):match("(.+)分割").."/answer/"..tostring(v.Tag.follow_id.Text):match("分割(.+)")})
          end
        end
      end
    })

    local qqadpqy=MyLuaAdapter(activity,follow_itemc)
    thispage.Adapter=qqadpqy

    thispage.setOnScrollListener{
      onScroll=function(view,a,b,c)
        if a+b==c and 可以加载关注[num] and view.adapter.getCount()>0 then
          关注刷新(false,false,num)
          System.gc()
          thissr.setRefreshing(true)
          可以加载关注[num]=false
          Handler().postDelayed(Runnable({
            run=function()
              thissr.setRefreshing(false);
            end,
          }),1000)
        end
      end
    }

  end

  if moments_tab[num].isend then
    return 提示("已经到底了")
  end

  local posturl
  if isprev and moments_tab[num].prev then
    posturl = moments_tab[num].prev
   else
    posturl = moments_tab[num].nexturl or "https://api.zhihu.com/moments_v3?feed_type="..alltype[num]
  end

  if not(getLogin()) then
    return 提示("请登录后使用本功能")
  end

  zHttp.get(posturl,followapphead,function(code,content)
    if code==200 then
      local data=luajson.decode(content)

      moments_tab[num].isend=data.paging.is_end
      moments_tab[num].prev=data.paging.previous
      moments_tab[num].nexturl=data.paging.next

      if moments_tab[num].isend==false then
        可以加载关注[num]=true
       elseif moments_tab[num].isend then
        提示("没有新内容了")
      end

      for k,v in ipairs(data.data) do
        if v.type=="moments_feed" then
          local 关注作者头像=v.target.author.avatar_url
          local 点赞数=tointeger(v.target.voteup_count)
          local 评论数=tointeger(v.target.comment_count)
          local 标题=v.target.title
          local 作者名称=v.source.actor.name
          local 动作=作者名称..v.source.action_text
          local 时间=时间戳(v.source.action_time)
          local 预览内容=v.target.excerpt
          if v.target.type=="answer" then
            问题id等=tointeger(v.target.question.id) or "null"
            问题id等=问题id等.."分割"..tointeger(v.target.id)
            标题=v.target.question.title
           elseif v.target.type=="question" then
            问题id等="问题分割"..tointeger(v.target.id)
            标题=v.target.title
           elseif v.target.type=="article"
            问题id等="文章分割"..tointeger(v.target.id)
            标题=v.target.title
           elseif v.target.type=="pin"
            问题id等="想法分割"..tointeger(v.target.id)
            标题=v.target.title
           elseif v.target.type=="moments_pin"
            if 标题==nil or 标题=="" then
              标题="一个想法"
            end
            问题id等="想法分割"..tointeger(v.target.id)
            点赞数=tointeger(v.target.reaction_count)
            预览内容=v.target.content[1].content
           elseif v.target.type=="zvideo"
            问题id等="视频分割"..tointeger(v.target.id)
            标题=v.target.title
            if 预览内容==nil or 预览内容=="" then
              预览内容="[视频]"
            end
          end
          thispage.Adapter.add{follow_voteup=点赞数,follow_title=标题,follow_art=预览内容,follow_comment=评论数,follow_id=问题id等,follow_name=动作,follow_time=时间,follow_image=关注作者头像}

         elseif v.type=="feed_item_index_group" then

          local 关注作者头像=v.actors[1].avatar_url
          -- 示例 12345万 赞同 · 67890 收藏 · 123456 评论
          local 数据=get_number_and_following(v.target.desc)
          local 点赞数=tointeger(数据[1])
          local 评论数=tointeger(数据[3])
          local 标题=v.target.title
          local 作者名称=v.target.author
          local 动作=作者名称..v.action_text
          local 时间=时间戳(v.action_time)
          local 预览内容=v.target.digest
          if v.target.type=="answer" then
            问题id等=tointeger(questonid) or "null"
            问题id等=问题id等.."分割"..tointeger(v.target.id)
            标题=v.target.title
           elseif v.target.type=="question" then
            问题id等="问题分割"..tointeger(v.target.id)
            标题=v.target.title
           elseif v.target.type=="article"
            问题id等="文章分割"..tointeger(v.target.id)
            标题=v.target.title
           elseif v.target.type=="pin"
            问题id等="想法分割"..tointeger(v.target.id)
            标题=v.target.title
           elseif v.target.type=="zvideo"
            问题id等="视频分割"..tointeger(v.target.id)
            标题=v.target.title
            if 预览内容==nil or 预览内容=="" then
              预览内容="[视频]"
            end
          end
          thispage.Adapter.add{follow_voteup=点赞数,follow_title=标题,follow_art=预览内容,follow_comment=评论数,follow_id=问题id等,follow_name=动作,follow_time=时间,follow_image=关注作者头像}
         elseif v.type=="item_group_card" then
          for e,q in ipairs(v.data) do

            local 关注作者头像=v.actor.avatar_url
            -- 示例 12345万 赞同 · 67890 收藏 · 123456 评论
            local 数据=get_number_and_following(q.desc)
            local 点赞数=tointeger(数据[1])
            local 评论数=tointeger(数据[3])
            local 标题=q.title
            local 作者名称=v.actor.name
            local 动作=作者名称..v.action_text
            local 时间=时间戳(v.action_time)
            local 预览内容=q.digest
            if q.type=="answer" then
              问题id等="null"
              问题id等=问题id等.."分割"..tointeger(q.id)
              标题=q.title
             elseif q.type=="question" then
              问题id等="问题分割"..tointeger(q.id)
              标题=q.title
             elseif q.type=="article"
              问题id等="文章分割"..tointeger(q.id)
              标题=q.title
             elseif q.type=="pin"
              问题id等="想法分割"..tointeger(q.id)
              标题=q.title
             elseif q.type=="zvideo"
              问题id等="视频分割"..tointeger(q.id)
              标题=q.title
              if 预览内容==nil or 预览内容=="" then
                预览内容="[视频]"
              end
            end
            thispage.Adapter.add{follow_voteup=点赞数,follow_title=标题,follow_art=预览内容,follow_comment=评论数,follow_id=问题id等,follow_name=动作,follow_time=时间,follow_image=关注作者头像}
          end

         elseif v.type=="recommend_user_card_list" then
          --推荐关注用户
         elseif v.type=="moments_recommend_followed_group"
          --用户推荐卡片
        end
      end
    end
  end)
end

function 想法刷新(isclear)
  if not(itemcc) or isclear then

    itemcc=获取适配器项目布局("home/home_thinker")
    mytab={}

    adapter=LuaCustRecyclerAdapter(AdapterCreator({

      getItemCount=function()
        return #mytab
      end,

      getItemViewType=function(position)
        return 0
      end,

      onCreateViewHolder=function(parent,viewType)
        local views={}
        holder=LuaCustRecyclerHolder(loadlayout(itemcc,views))
        holder.view.setTag(views)
        return holder
      end,

      onBindViewHolder=function(holder,position)
        view=holder.view.getTag()

        url=mytab[position+1].url
        import "android.util.DisplayMetrics"
        dm=DisplayMetrics()
        activity.getWindowManager().getDefaultDisplay().getMetrics(dm);

        loadglide(view.img,url)

        view.tv.Text=StringHelper.Sub(mytab[position+1].title,1,20).."....."


        --子项目点击事件
        view.it.onClick=function(v)
          activity.newActivity("column",{mytab[position+1].tzurl,"想法"})
          return true
        end

      end,
    }))

    thinksr.setProgressBackgroundColorSchemeColor(转0x(backgroundc));
    thinksr.setColorSchemeColors({转0x(primaryc)});
    thinksr.setOnRefreshListener({
      onRefresh=function()
        想法刷新(true)
        Handler().postDelayed(Runnable({
          run=function()
            thinksr.setRefreshing(false);
          end,
        }),1000)

      end,
    });

    recy.addOnScrollListener(RecyclerView.OnScrollListener{
      onScrollStateChanged=function(recyclerView,newState)
      end,
      onScrolled=function(recyclerView,dx,dy)
        local lastChildView,lastChildBottom,recyclerBottom,lastPosition
        --得到当前显示的最后一个item的view
        lastChildView = recyclerView.getLayoutManager().getChildAt(recyclerView.getLayoutManager().getChildCount()-1);
        --得到lastChildView的bottom坐标值
        lastChildBottom = lastChildView.getBottom();
        --得到Recyclerview的底部坐标减去底部padding值，也就是显示内容最底部的坐标
        recyclerBottom = recyclerView.getBottom()-recyclerView.getPaddingBottom();
        --通过这个lastChildView得到这个view当前的position值
        lastPosition = recyclerView.getLayoutManager().getPosition(lastChildView);
        --判断lastChildView的bottom值跟recyclerBottom
        --判断lastPosition是不是最后一个position
        --如果两个条件都满足则说明是真正的滑动到了底部
        if(lastChildBottom == recyclerBottom and lastPosition == recyclerView.getLayoutManager().getItemCount()-1 )
          thinksr.setRefreshing(true)
          想法刷新()
          System.gc()
          Handler().postDelayed(Runnable({
            run=function()
              thinksr.setRefreshing(false);
            end,
          }),1000)
        end
      end
    });


    mytab={}
    recy.setAdapter(adapter)
    recy.setLayoutManager(StaggeredGridLayoutManager(2,StaggeredGridLayoutManager.VERTICAL))
    thisurl=nil
  end
  local geturl=thisurl or "https://api.zhihu.com/prague/feed?offset=0&limit=10"
  zHttp.get(geturl,head,function(code,content)
    if code==200 then--判断网站状态
      thisurl=luajson.decode(content).paging.next
      for i,v in ipairs(luajson.decode(content).data) do
        local url
        xpcall(function()
          url=v.target.images[1].url
          end,function()
          url=v.target.video.thumbnail
        end)
        local title=v.target.excerpt
        local tzurl=v.target.url:match("pin/(.-)?")
        local num=#mytab
        table.insert(mytab,{url=url,title=title,tzurl=tzurl})
        adapter.notifyItemRangeInserted(num,#mytab)
      end
     else
      --错误时的操作
    end
  end)

end

可以加载收藏={}
collection_isend={}
collection_nexturl={}


function 收藏刷新(isclear)
  if CollectiontabLayout.getTabCount()==0 then
    CollectiontabLayout.setupWithViewPager(page)
    local CollectionTable={"我的","关注"}
    --setupWithViewPager设置的必须手动设置text
    for i=1, #CollectionTable do
      local itemnum=i-1
      local tab=CollectiontabLayout.getTabAt(itemnum)
      tab.setText(CollectionTable[i]);
    end
    CollectiontabLayout.addOnTabSelectedListener(TabLayout.OnTabSelectedListener {
      onTabSelected=function(tab)
        --选择时触发
        local pos=tab.getPosition()+1
        followpos=pos
        收藏刷新(false)
      end,

      onTabUnselected=function(tab)
        --未选择时触发
      end,

      onTabReselected=function(tab)
        --选中之后再次点击即复选时触发
        收藏刷新(true)
      end,
    });

  end

  local allsr={csr,dsr}
  local allpage={list4,list8}
  local pos=CollectiontabLayout.getSelectedTabPosition()+1;
  local thispage=allpage[pos]
  local thissr=allsr[pos]
  if thispage.adapter and isclear==false
    return
  end
  if not(thispage.adapter) or isclear then

    local allitemc={获取适配器项目布局("home/home_collections"),获取适配器项目布局("home/home_shared_collections")}
    local allonclick={
      AdapterView.OnItemClickListener{
        onItemClick=function(parent,v,pos,id)
          activity.newActivity("collections",{v.Tag.collections_id.Text})
        end
      },
      AdapterView.OnItemClickListener{
        onItemClick=function(parent,v,pos,id)
          if v.Tag.mc_title.text=="推荐关注收藏夹" then
            activity.newActivity("collections_tj")
            return
          end
          activity.newActivity("collections",{v.Tag.mc_id.Text,true})
        end
      },
    }

    local alladd={
      {
        collections_title={
          text="本地收藏",
        },
        collections_art={
          text="你猜有几个内容？",
        },
        is_lock=图标("https"),
        collections_item={
          text="0",
        },
        collections_follower={
          text="0",
        },
        collections_id={
          text="local"
        },
      },
      {
        mc_image="https://picx.zhimg.com/50/v2-abed1a8c04700ba7d72b45195223e0ff_xl.jpg",
        mc_name={
          text="为你推荐"
        },
        mc_title={
          text="推荐关注收藏夹"
        },
        mc_follower={
          text=""
        },
        mc_id={
          text="",
        },
        background={foreground=Ripple(nil,转0x(ripplec),"方")},
      },
    }


    thispage.setOnItemClickListener(allonclick[pos])

    thissr.setColorSchemeColors({转0x(primaryc)});
    thissr.setOnRefreshListener({
      onRefresh=function()
        收藏刷新(true)
        Handler().postDelayed(Runnable({
          run=function()
            thissr.setRefreshing(false);
          end,
        }),1000)

      end,
    });

    thispage.adapter=MyLuaAdapter(activity,allitemc[pos])

    table.insert(thispage.adapter.getData(),alladd[pos])

    可以加载收藏[pos]=true
    collection_isend[pos]=false
    collection_nexturl[pos]=false

    thispage.setOnScrollListener{
      onScroll=function(view,a,b,c)
        if a+b==c and 可以加载收藏[pos] then
          可以加载收藏[pos]=false
          收藏刷新()
          thissr.setRefreshing(true)
          System.gc()
          Handler().postDelayed(Runnable({
            run=function()
              thissr.setRefreshing(false);
            end,
          }),1000)
        end
      end
    }

    return
  end
  if pos==1 then
    local collections_url= collection_nexturl[1] or "https://api.zhihu.com/people/"..activity.getSharedData("idx").."/collections_v2?offset=0&limit=20"
    zHttp.get(collections_url,head,function(code,content)
      if code==200 then
        local data=luajson.decode(content)
        collection_isend[1]=data.paging.is_end
        collection_nexturl[1]=data.paging.next
        if collection_isend[1]==false then
          可以加载收藏[1]=true
         elseif collection_isend[1] then
          提示("没有新内容了")
        end
        for k,v in ipairs(data.data) do
          list4.adapter.add{
            collections_title={
              text=v.title,
            },
            is_lock=v.is_public==false and 图标("https") or nil,

            collections_art={
              text=""..tointeger(v.item_count).."个内容"
            },
            collections_item={
              text=math.floor(v.comment_count)..""
            },
            collections_follower={
              text=tointeger(v.follower_count)..""
            },
            collections_id={
              text=tostring(v.id)

            },
          }
        end

       else
        提示("获取收藏列表失败")
      end
    end)
    return
  end

  if pos==2 then
    local mc_url=collection_nexturl[2] or "https://api.zhihu.com/people/"..activity.getSharedData("idx").."/following_collections?offset=0"

    zHttp.get(mc_url,head,function(c,ct)
      if c==200 then

        local data=luajson.decode(ct)

        collection_isend[2]=data.paging.is_end
        collection_nexturl[2]=data.paging.next
        if collection_isend[2]==false then
          可以加载收藏[2]=true
         elseif collection_isend[2] then
          提示("没有新内容了")
        end

        for k,v in ipairs(data.data) do

          list8.adapter.add{
            mc_image=v.creator.avatar_url,
            mc_name={
              text="由 "..v.creator.name.." 创建"
            },
            mc_title={
              text=v.title
            },
            mc_follower={
              text=math.floor(v.follower_count).."人关注"
            },
            mc_id={
              text=tostring(v.id),
            },
            background={foreground=Ripple(nil,转0x(ripplec),"方")},
          }
        end

       else
        提示("获取收藏列表失败")
      end
    end)
    return
  end

end

--设置波纹（部分机型不显示，因为不支持setColor）（19 6-6发现及修复因为不支持setColor而导致的报错问题)
波纹({_menu,_more,_search,_ask,page1,page2,page3,page5,page4,pagetest},"圆主题")
波纹({open_source},"方主题")
波纹({侧滑头},"方自适应")
波纹({注销},"圆自适应")

--获取首页启动什么
local starthome=this.getSharedData("starthome")

--没有就设置主页为推荐
if not starthome then
  this.setSharedData("starthome","推荐")
  starthome=this.getSharedData("starthome")
end

--从home_list取出启动页
page_home.setCurrentItem(home_list[starthome],false)

function getuserinfo()

  local myurl= 'https://www.zhihu.com/api/v4/me'

  zHttp.get(myurl,head,function(code,content)

    if code==200 then--判断网站状态
      local data=luajson.decode(content)
      local 名字=data.name
      local 头像=data.avatar_url
      local 签名=data.headline
      local uid=data.id--用tointeger不行数值太大了会
      activity.setSharedData("idx",uid)
      ---      activity.setSharedData("name",名字)
      loadglide(头像id,头像)
      名字id.Text=名字
      if #签名:gsub(" ","")<1 then
        签名id.Text="你还没有签名呢"
       else
        签名id.Text=签名
      end
      侧滑头.onClick=function()
        activity.newActivity("people",{uid})
      end
      sign_out.setVisibility(View.VISIBLE)

      zHttp.get("https://api.zhihu.com/feed-root/sections/query/v2",head,function(code,content)
        if code==200 then
          HometabLayout.setVisibility(0)
          local decoded_content = luajson.decode(content)
          --    提示(luajson.decode(content).selected_sections[1].section_name)
          table.insert(decoded_content.selected_sections, 1, {
            section_name="全站",
            section_id=nil,
            sub_page_id=nil,
          })

          if HometabLayout.getTabCount()>0 then
            for i = HometabLayout.getTabCount(), 1, -1 do
              local itemnum=i-1
              HometabLayout.removeTabAt(itemnum)
            end
          end

          for i=1, #decoded_content.selected_sections do
            --提示(tostring(i))
            if HometabLayout.getTabCount()<i+1 and decoded_content.selected_sections[i].section_name~="圈子" then
              local tab=HometabLayout.newTab()
              tab.setText(decoded_content.selected_sections[i].section_name)
              tab.view.onClick=function()
                choose_sub=decoded_content.selected_sections[i].sub_page_id
                choosebutton=decoded_content.selected_sections[i].section_id
                主页刷新(true,true)
              end
              HometabLayout.addTab(tab)
            end
          end
         else
          --HometabLayout.setVisibility(8)
        end
      end)


     else
      --状态码不为200的事件
      HometabLayout.setVisibility(8)
    end
  end)

end

getuserinfo()

function onActivityResult(a,b,c)
  if b==100 then
    setHead()
    getuserinfo()
   elseif b==1200 then --夜间模式开启
    设置主题()
   elseif b==200 then
    activity.finish()
   elseif b==1500 then
    初始化历史记录数据(true)
   elseif b==1600 then
    收藏刷新(true)
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
      双按钮对话框("提示","检测到剪贴板里含有知乎链接，是否打开？","打开","",function()关闭对话框(an)
        opentab[url]=true
        检查链接(url)
      end)
    end
  end
end

function onResume()
  activity.getDecorView().post{run=function()check()end}
end



if not(this.getSharedData("内部浏览器查看回答")) then
  activity.setSharedData("内部浏览器查看回答","false")
end

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
        .setNeutralButton("暂不更新",{onClick=function() activity.setSharedData("version",tostring(updateversioncode)) end})
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
    .setNeutralButton("退出软件",nil)
    .setNegativeButton("项目页",nil)
    .show()
    myupdatedialog.findViewById(android.R.id.message).TextIsSelectable=true
    myupdatedialog.getButton(myupdatedialog.BUTTON_POSITIVE).onClick=function()
      浏览器打开("https://myhydrogen.gitee.io")
    end
    myupdatedialog.getButton(myupdatedialog.BUTTON_NEGATIVE).onClick=function()
      浏览器打开("https://gitee.com/huajicloud/hydrogen")
    end
    myupdatedialog.getButton(myupdatedialog.BUTTON_NEUTRAL).onClick=function()
      activity.finish()
    end

  end
end)

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
    if a.pop.isShowing() then
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
      Snakebar("再按一次退出")
      lastclick = now
      return true
    end
  end
end

data=...
function onCreate()
  if data then
    local intent=tostring(data.getData())
    检查意图(intent)
  end
end

if not(this.getSharedData("hometip0.01")) then
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
    .setMessage("如想使用私信 通知功能 请展开侧边栏的信息按钮")
    .setPositiveButton("我知道了",{onClick=function() activity.setSharedData("hometip0.01","true") end})
    .show()
  end)
end


if Build.VERSION.SDK_INT >=30 then

  if activity.getSharedData("安卓11迁移文件夹0.01")~="true" then
    local 默认文件夹=Environment.getExternalStorageDirectory().toString().."/Hydrogen"
    local 私有目录=activity.getExternalFilesDir(nil).toString()
    if not 文件夹是否存在(私有目录) then
      创建文件夹(私有目录)
    end
    if not 文件夹是否存在(私有目录.."/Hydrogen") then
      创建文件夹(私有目录.."/Hydrogen")
    end
    if Environment.isExternalStorageManager()==true then
      File(默认文件夹).renameTo(File(私有目录.."/Hydrogen"))
    end
    if activity.getSharedData("安卓11迁移文件夹")~="true" then
      local tishi=AlertDialog.Builder(this)
      .setTitle("提示")
      .setMessage("检测到你的软件版本大于安卓10 由于安卓的限制 导致无法保存文件在带有特殊字符串的文件夹 但应用私有目录无限制 所以 软件已自动将文件夹迁移到软件的在android/data的目录内 但迁移后 卸载软件或清除软件数据也会删除对应保存的数据 为了应对 在本地列表的菜单的功能中支持导入/导出android/data的文件")
      .setCancelable(false)
      .setPositiveButton("我知道了",{onClick=function() activity.setSharedData("安卓11迁移文件夹0.01","true") end})
      .show()
      tishi.findViewById(android.R.id.message).TextIsSelectable=true
    end
  end
end