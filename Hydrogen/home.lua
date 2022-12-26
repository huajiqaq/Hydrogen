require "import"
import "mods.muk"
import "android.support.v4.widget.*"
import "android.os.Handler"
import "java.lang.Runnable"
import "com.michael.NoScrollListView"
import "com.michael.NoScrollGridView"
import "android.widget.ImageView$ScaleType"
import "com.lua.custrecycleradapter.*"
import "androidx.recyclerview.widget.*"

activity.setContentView(loadlayout("layout/home"))
--设置视图


初始化历史记录数据(true)

local function firsttip ()
  activity.setSharedData("禁用缓存","true")
  双按钮对话框("提示","软件默认开启「禁用缓存」和 想法功能 你可以在设置中手动设置此开关","我知道了","跳转设置",function()
  关闭对话框(an) end,function()
    关闭对话框(an) 跳转页面("settings")
  end)
end

debugmode=true

local ccc=activity.getSharedData("第一次提示")
if ccc ==nil then
  双按钮对话框("注意","该软件仅供交流学习，严禁用于商业用途，请于下载后的24小时内卸载","登录","知道了",function()
    activity.setSharedData("第一次提示","x")
    跳转页面("login")
    关闭对话框(an)
    end,function()
    activity.setSharedData("第一次提示","x")
    关闭对话框(an)
    firsttip ()
  end)
end

local lll=activity.getSharedData("禁用缓存")
if lll==nil and ccc~=nil then
  firsttip ()
end

local qqq=activity.getSharedData("开启想法")

if qqq==nil then
  activity.setSharedData("开启想法","true")
 elseif qqq=="false" then
  adpp=page_home_p.getAdapter()
  adpp.remove(1)
  adpp.notifyDataSetChanged()
  pagetest.setVisibility(View.GONE)
end

if ccc and lll and activity.getSharedData("开源提示")==nil then
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

if this.getSharedData("全屏模式") then
  this.setSharedData("全屏模式","false")
end

--侧滑滑动事件
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
    --   感觉不太美观(底栏降下后会留出一片空白 不如不降下去
    --   page_home.getChildAt(1).y=(page_home.getChildAt(1).height*z)+page_home.getChildAt(0).height
end})

ch_item_checked_background = GradientDrawable()
.setShape(GradientDrawable.RECTANGLE)
.setColor(转0x(primaryc)-0xde000000)
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
    LinearLayout;
    layout_width="-1";
    layout_height="48dp";
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
      id="tv";
      layout_marginLeft="16dp";
      textSize="14sp";
      textColor=textc;
      Typeface=字体("product");
    };
  };

  {--侧滑项目_选中项 (type3)
    RelativeLayout;
    layout_width="-1";
    layout_height="48dp";
    {
      LinearLayout;
      layout_width="-1";
      layout_height="-1";
      layout_marginRight="8dp";
      BackgroundDrawable=ch_item_checked_background;
    };
    {
      LinearLayout;
      layout_width="-1";
      layout_height="-1";
      gravity="center|left";
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
      background=cardbackc,
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
  --   {"debug","settings",},
  --  {"Cookie","bug_report",},
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
      ch_light("主页")
      if okstart=="true" then
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
      控件隐藏(page_daily)
      控件隐藏(page_collections)
      控件可见(page_home)
      切换页面(0)
      _title.Text="Hydrogen"
     elseif s=="日报" then
      ch_light("日报")
      if okstart=="true" then
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
      日报刷新()
      控件隐藏(page_home)
      控件隐藏(page_collections)
      控件可见(page_daily)
      _title.Text="日报"
     elseif s=="收藏" then
      ch_light("收藏")
      if okstart=="true" then
        a=MUKPopu({
          tittle="菜单",
          list={
            {src=图标("search"),text="在收藏中搜索",onClick=function()
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
      控件隐藏(page_home)
      控件隐藏(page_daily)
      控件可见(page_collections)
      task(400,收藏刷新)
      _title.Text="收藏"
     elseif s=="本地" then
      activity.newActivity("local_list")
     elseif s=="debug" then
      activity.newActivity("feedback")
     elseif s=="设置" then
      task(300,function()activity.newActivity("settings")end)
     elseif s=="一文" then
      --activity.newActivity("artical")
      task(300,function()activity.newActivity("artical")end)
     elseif s=="Cookie" then
      双按钮对话框("查看Cookie", 获取Cookie("https://www.zhihu.com/"),"复制","关闭",function()复制文本(获取Cookie("https://www.zhihu.com/"))提示("已复制到剪切板")关闭对话框(an)end,function()关闭对话框(an)end)
     elseif s=="历史" then
      --  activity.newActivity("history")
      task(300,function()activity.newActivity("history")end)
     elseif s=="消息" then

      if 状态=="未登录" then
        提示("你可能需要登录")
       else
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
      end
     else
      Snakebar(s)

    end
    task(1,function()
      require "import"
      _drawer.closeDrawer(Gravity.LEFT)--关闭侧滑
    end)
end})



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

function showD(id)--主页底栏项目高亮动画
  local kidt=id.getChildAt(0)
  local kidw=id.getChildAt(1)
  animatorSet = AnimatorSet()
  local tscaleX = ObjectAnimator.ofFloat(kidt, "scaleX", {kidt.scaleX, 1.0})
  local tscaleY = ObjectAnimator.ofFloat(kidt, "scaleY", {kidt.scaleY, 1.0})
  local wscaleX = ObjectAnimator.ofFloat(kidw, "scaleX", {kidw.scaleX, 1.0})
  local wscaleY = ObjectAnimator.ofFloat(kidw, "scaleY", {kidw.scaleY, 1.0})
  animatorSet.setDuration(256)
  animatorSet.setInterpolator(DecelerateInterpolator());
  animatorSet.play(tscaleX).with(tscaleY).with(wscaleX).with(wscaleY)
  animatorSet.start();
end

function closeD(id)--主页底栏项目灰色动画
  local gkidt=id.getChildAt(0)
  local gkidw=id.getChildAt(1)
  ganimatorSet = AnimatorSet()
  local gtscaleX = ObjectAnimator.ofFloat(gkidt, "scaleX", {gkidt.scaleX, 0.9})
  local gtscaleY = ObjectAnimator.ofFloat(gkidt, "scaleY", {gkidt.scaleY, 0.9})
  local gwscaleX = ObjectAnimator.ofFloat(gkidw, "scaleX", {gkidw.scaleX, 0.9})
  local gwscaleY = ObjectAnimator.ofFloat(gkidw, "scaleY", {gkidw.scaleY, 0.9})
  ganimatorSet.setDuration(256)
  ganimatorSet.setInterpolator(DecelerateInterpolator());
  ganimatorSet.play(gtscaleX).with(gtscaleY).with(gwscaleX).with(gwscaleY)
  ganimatorSet.start();
end

function homepage1()
  Http.get("https://api.zhihu.com/feed-root/sections/query/v2",access_token_head,function(code,content)
    if code==200 then
      local decoded_content = require "cjson".decode(content)
      --    提示(require "cjson".decode(content).selected_sections[1].section_name)
      for i=1, #decoded_content.selected_sections do
        --提示(tostring(i))
        if homehome~="ok" then
          hometab:addTab("全站",function() pcall(function()list2.adapter.clear()end) choosebutton=nil 随机推荐() end)
          homehome="ok"
        end
        if hometab:getCount()<i+1 and decoded_content.selected_sections[i].section_name~="圈子" then
          hometab:addTab(
          decoded_content.selected_sections[i].section_name,function() pcall(
            function()list2.adapter.clear()end
            ) choosebutton=decoded_content.selected_sections[i].section_id 主页推荐刷新(
            decoded_content.selected_sections[i].section_id
            ) end
          )
        end
      end
    end
  end)
  c1=x
  _title.setText("Hydrogen")

  showD(page1)
  closeD(page2)
  closeD(page3)
  if qqq=="true" then
    closeD(pagetest)
  end
end

function homepage2()
  _title.setText("想法")
  c2=x

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
      layoutParams=view.img.getLayoutParams()
      import "android.util.DisplayMetrics"
      dm=DisplayMetrics()
      activity.getWindowManager().getDefaultDisplay().getMetrics(dm);
      hj=loadbitmap(url)
      wtt=hj.getWidth()
      kkk=dm.widthPixels-80
      ooo=kkk/2
      koo=ooo/wtt
      layoutParams.width=ooo
      layoutParams.height=hj.getHeight()*koo


      view.img.setImageBitmap(hj)
      view.img.setLayoutParams(layoutParams)

      --使用glide加载图片(加载贼流畅)

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
      想法刷新("clear")
      Handler().postDelayed(Runnable({
        run=function()
          thinksr.setRefreshing(false);
        end,
      }),1000)

    end,
  });



  recy.addOnScrollListener(RecyclerView.OnScrollListener {
    function onScrollStateChanged( recyclerView, newState)

    end,

    function onScrolled(recyclerView,dx,dy)

      lastChildView = recyclerView.getLayoutManager().getChildAt(recyclerView.getLayoutManager().getChildCount()-1);

      lastChildBottom = lastChildView.getBottom();

      recyclerBottom = recyclerView.getBottom()-recyclerView.getPaddingBottom();

      lastPosition = recyclerView.getLayoutManager().getPosition(lastChildView);


      if lastChildBottom == recyclerBottom and lastPosition == recyclerView.getLayoutManager().getItemCount()-1
        想法刷新()
      end
    end

  });


  想法刷新()

  showD(pagetest)
  closeD(page1)
  closeD(page2)
  closeD(page3)
end

function homepage3()
  _title.setText("热榜")
  c3=x
  if q==3 then
   else
    q=3
    task(5,function()
      opentab={}
      hotdata=hot:new()
      --          for k,v in pairs({"全部","科学","数码","体育"}) do
      for k,v in pairs({"全部"}) do
        hotTab:addTab(v,function()
          热榜刷新()
        end)
      end
      hotTab:showTab(1)

      hotdata:getPartition(function()
        for k,v in pairs(hotdata.partition) do

          --              if k~="全部" and (not(table.find({"全部","科学","数码","体育"},k))) then
          if k~="全部" and (not(table.find({"全部"},k))) then
            hotTab:addTab(k,function()
              热榜刷新()
            end)
          end

        end
        task(1,function()热榜刷新(1) hotTab:showTab(1) end)
      end)
    end)
  end

  showD(page2)
  closeD(page1)
  closeD(page3)
  if qqq=="true" then
    closeD(pagetest)
  end
end

function homepage4 ()
  c4=x
  _title.setText("关注")
  if t==4 then
   else
    t=4
    关注刷新(1)

    isadd=true
    ppage=2

    gsr.setProgressBackgroundColorSchemeColor(转0x(backgroundc));
    gsr.setColorSchemeColors({转0x(primaryc)});
    gsr.setOnRefreshListener({
      onRefresh=function()
        关注刷新(1)
        isadd=true
        ppage=2
        Handler().postDelayed(Runnable({
          run=function()
            gsr.setRefreshing(false);
          end,
        }),1000)

      end,
    });



    list9.setOnScrollListener{
      onScroll=function(view,a,b,c)
        if a+b==list9.adapter.getCount() and moments_isend==false and isadd and list9.adapter.getCount()>0 then
          isadd=false
          gsr.setRefreshing(true)
          ppage=ppage+1
          关注刷新(ppage,moments_nextUrl)
          System.gc()
          Handler().postDelayed(Runnable({
            run=function()
              isadd=true
              gsr.setRefreshing(false)
            end,
          }),1000)
        end
      end
    }

    list9.setOnItemClickListener(AdapterView.OnItemClickListener{
      onItemClick=function(parent,v,pos,id)
        local open=activity.getSharedData("内部浏览器查看回答")
        if tostring(v.Tag.follow_id.text):find("文章分割") then
          activity.newActivity("column",{tostring(v.Tag.follow_id.Text):match("文章分割(.+)"),tostring(v.Tag.follow_id.Text):match("分割(.+)")})
         elseif tostring(v.Tag.follow_id.text):find("想法分割") then
          activity.newActivity("column",{tostring(v.Tag.follow_id.Text):match("想法分割(.+)"),tostring(v.Tag.follow_id.Text):match("分割(.+)"),"想法"})
         elseif tostring(v.Tag.follow_id.text):find("问题分割") then
          activity.newActivity("question",{tostring(v.Tag.follow_id.Text):match("问题分割(.+)"),true})
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



  end

  showD(page3)
  closeD(page1)
  closeD(page2)
  if qqq=="true" then
    closeD(pagetest)
  end

end


home_list={["推荐"]=0,["想法"]=1,["热榜"]=2,["关注"]=3}
local starthome=this.getSharedData("starthome")
if not starthome then
  this.setSharedData("starthome","推荐")
  starthome=this.getSharedData("starthome")
end

if qqq=="true" then
  tznum=home_list[starthome]
 else
  tznum=home_list[starthome]-1
end

page_home_p.setCurrentItem(tznum,false)
page_home_p.setOnPageChangeListener(PageView.OnPageChangeListener{
  onPageScrolled=function(a,b,c)
  end,
  onPageSelected=function(v)
    x=primaryc
    c=stextc
    c1=c
    c2=c
    c3=c
    c4=c
    if v==0 then
      homepage1()
    end

    if v==1 then
      if qqq=="true" then
        homepage2()
       else
        homepage3()
      end
    end
    if v==2 then
      if qqq=="true" then
        homepage3()
       else
        homepage4()
      end
    end
    if v==3 then
      if qqq=="true" then
        homepage4()
      end
    end
    page1.getChildAt(0).setColorFilter(转0x(c1))
    page2.getChildAt(0).setColorFilter(转0x(c3))
    page3.getChildAt(0).setColorFilter(转0x(c4))
    page1.getChildAt(1).setTextColor(转0x(c1))
    page2.getChildAt(1).setTextColor(转0x(c3))
    page3.getChildAt(1).setTextColor(转0x(c4))
    if qqq=="true" then
      pagetest.getChildAt(0).setColorFilter(转0x(c2))
      pagetest.getChildAt(1).setTextColor(转0x(c2))
    end
  end
})



function 切换页面(z)--切换主页Page函数
  if qqq~="true" and z>0 then
    page_home_p.showPage(z-1)
   else
    page_home_p.showPage(z)
  end
end


--设置波纹（部分机型不显示，因为不支持setColor）（19 6-6发现及修复因为不支持setColor而导致的报错问题)
波纹({_menu,_more,_search,_ask,page1,page2,page3,page5,page4,pagetest},"圆主题")
波纹({open_source},"方主题")
波纹({侧滑头},"方自适应")
波纹({注销},"圆自适应")

--主页布局
itemc2=
{
  LinearLayout;
  layout_width="-1";
  orientation="horizontal";
  BackgroundColor=cardedge;

  {
    CardView;
    layout_gravity="center";
    layout_height="-2";
    CardBackgroundColor=cardedge,
    Elevation="0";
    layout_width="-1";
    layout_margin="0dp";
    layout_marginTop="4dp";
    layout_marginBottom="0dp";
    radius="0dp";
    {
      CardView;
      CardElevation="0dp";
      CardBackgroundColor=backgroundc;
      Radius="0dp";
      layout_margin="0px";
      layout_marginTop="0px";
      layout_marginBottom="0px";
      layout_width="-1";
      layout_height="-1";
      {
        LinearLayout;
        ripple="圆自适应",

        layout_height="fill";
        id="background";
        padding="24dp";
        layout_width="fill";
        {
          TextView;
          id="链接2";
          textSize="0sp";
        };
        {
          LinearLayout;
          orientation="vertical";
          {
            TextView;
            textSize="14sp";
            id="标题2";
            letterSpacing="0.02";
            textColor=textc;
            Typeface=字体("product-Bold");
          };
          {
            TextView;
            textSize="12sp";
            MaxLines=3;--设置最大输入行数
            ellipsize="end",
            id="文章2";
            letterSpacing="0.02";
            textColor=stextc;
            layout_marginTop="10dp";
            Typeface=字体("product");
          };
          {
            LinearLayout;
            layout_marginTop="10dp";
            orientation="horizontal";
            {
              ImageView;
              layout_gravity="center",
              layout_height="16dp",
              layout_width="16dp",
              src=图标("vote_up"),
              ColorFilter=textc;
            };
            {
              TextView;
              id="点赞2";
              textSize="12sp",
              layout_marginLeft="6dp",
              textColor=textc;
              Typeface=字体("product");
            };
            {
              ImageView;
              layout_marginLeft="24dp",
              src=图标("message"),
              ColorFilter=textc;
              layout_height="16dp",
              layout_width="16dp",
              layout_gravity="center",
            };
            {
              TextView;
              layout_marginLeft="6dp",
              id="评论2";
              textColor=textc;
              textSize="12sp",
              Typeface=字体("product");
            };
          };
        };
      };
    };
  };
};

--[[itemc2=
{
  LinearLayout;
  layout_width="-1";
  orientation="horizontal";
  BackgroundColor=backgroundc;

  {
    CardView;
    layout_gravity="center";
    layout_height="-2";
    CardBackgroundColor=cardedge,
    Elevation="0";
    layout_width="-1";
    layout_margin="16dp";
    layout_marginTop="8dp";
    layout_marginBottom="8dp";
    radius="8dp";
    {
      CardView;
      CardEle3vation="0dp";
      CardBackgroundColor=backgroundc;
      Radius=dp2px(8)-2;
      layout_margin="2px";
      layout_width="-1";
      layout_height="-1";
      {
        LinearLayout;
        ripple="圆自适应",

        layout_height="fill";
        id="background";
        padding="16dp";
        layout_width="fill";
        {
          TextView;
          id="链接2";
          textSize="0sp";
        };
        {
          LinearLayout;
          orientation="vertical";
          {
            TextView;
            textSize="14sp";
            id="标题2";
            textColor=textc;
            Typeface=字体("product-Bold");
          };
          {
            TextView;
            textSize="12sp";
            MaxLines=3;--设置最大输入行数
            ellipsize="end",
            id="文章2";
            textColor=stextc;
            layout_marginTop="2dp";
            Typeface=字体("product-Medium");
          };
          {
            LinearLayout;
            layout_marginTop="4dp";
            orientation="horizontal";
            {
              ImageView;
              layout_gravity="center",
              layout_height="16dp",
              layout_width="16dp",
              src=图标("vote_up"),
              ColorFilter=textc;
            };
            {
              TextView;
              id="点赞2";
              textSize="12sp",
              layout_marginLeft="6dp",
              textColor=textc;
              Typeface=字体("product");
            };
            {
              ImageView;
              layout_marginLeft="24dp",
              src=图标("message"),
              ColorFilter=textc;
              layout_height="16dp",
              layout_width="16dp",
              layout_gravity="center",
            };
            {
              TextView;
              layout_marginLeft="6dp",
              id="评论2";
              textColor=textc;
              textSize="12sp",
              Typeface=字体("product");
            };
          };
        };
      };
    };
  };
};]]

--创建table
requrl={}
function 主页刷新(hometype)

  if activity.getSharedData("signdata")~=nil then
    local login_access_token="Bearer"..require "cjson".decode(activity.getSharedData("signdata")).access_token;
    access_token_head={
      ["authorization"] = login_access_token;
      ["cookie"] = 获取Cookie("https://www.zhihu.com/");
    }
   else
    --[[    提示("还没有获取登录参数 已清除数据")
                           清除所有cookie()
                        跳转页面("home")
                        activity.finish()]]
    access_token_head={
      ["cookie"] = 获取Cookie("https://www.zhihu.com/");
    }
  end

  function resolve_feed(v)
    local 点赞数=tointeger(v.target.voteup_count)
    local 评论数=tointeger(v.target.comment_count)
    local 标题,问题id等;
    local 作者=v.target.author.name
    --          local 预览内容=作者.." : "..v.target.excerpt_new
    local 预览内容=作者.." : "..v.target.excerpt
    --     print(dump(v))
    if v.target.type=="pin" then
      问题id等="想法分割"..v.target.url:match("(%d+)")--由于想法的id长达18位，而cJSON无法解析这么长的数字，所以暂时用截取url结尾的数字字符串来获取id
      标题=作者.."发表了想法"
     elseif v.target.type=="answer" then
      问题id等=tointeger(v.target.question.id or 1).."分割"..tointeger(v.target.id)
      标题=v.target.question.title
     elseif v.target.type=="article" then--????????没有测到这个推荐流
      问题id等="文章分割"..tointeger(v.target.id)
      标题=v.target.title
     else
      提示("未知类型"..v.target.type.." id"+v.target.id)
    end
    return {点赞2=点赞数,标题2=标题,文章2=预览内容,评论2=评论数,链接2=问题id等}
  end

  function 主页推荐刷新(result)

    local url= requrl[result] or "https://api.zhihu.com/feed-root/section/"..tointeger(result).."?channelStyle=0"
    Http.get(url,access_token_head,function(code,content)
      if code==200 then
        decoded_content = require "cjson".decode(content)
        if decoded_content.paging.is_end==false then
          requrl[result]=decoded_content.paging.next
          for k,v in ipairs(decoded_content.data) do
            table.insert(list2.adapter.getData(),resolve_feed(v))
          end
          task(1,function() list2.adapter.notifyDataSetChanged()end)
        end
      end
    end)
  end

  function 随机推荐 ()
    local posturl = requrl[-1] or "https://api.zhihu.com/topstory?action=down"--"https://api.zhihu.com/feeds"
    local head = {
      ["cookie"] = 获取Cookie("https://www.zhihu.com/")
    }
    Http.get(posturl,head,function(code,content)
      if code==200 then
        decoded_content = require "cjson".decode(content)
        for k,v in ipairs(decoded_content.data) do
          table.insert(list2.adapter.getData(),resolve_feed(v))
        end
        task(1,function() list2.adapter.notifyDataSetChanged()end)
        requrl[-1] = decoded_content.paging.next
       elseif code==401 then
        提示("请登录后访问推荐，http错误码401")
        状态="未登录"
        --[[      list2.Text="请先登录"
      list9.Text="请先登录"]]
        -- list2.setVisibility(8)
        -- empty2.setVisibility(0)
        -- list9.setVisibility(8)
        -- empty9.setVisibility(0)
       else
        提示("获取数据失败，请检查网络是否正常，http错误码"..code)
        状态="未登录"
        --[[      list2.text="获取数据失败"
      list9.text="获取数据失败"]]
        -- list2.setVisibility(8)
        -- empty2.setVisibility(0)
        -- list9.setVisibility(8)
        -- empty9.setVisibility(0)
      end

    end)
  end


  if not requrl[-1] or hometype=="refersh" then

    local yxuan_adpqy=LuaAdapter(activity,itemc2)
    list2.adapter=yxuan_adpqy







    --新建适配器
  end
  if choosebutton==nil then
    随机推荐()
   elseif choosebutton then
    主页推荐刷新(choosebutton)
  end
end
主页刷新()


sr.setProgressBackgroundColorSchemeColor(转0x(backgroundc));
sr.setColorSchemeColors({转0x(primaryc)});
sr.setOnRefreshListener({
  onRefresh=function()
    主页刷新("refersh")
    Handler().postDelayed(Runnable({
      run=function()
        sr.setRefreshing(false);
      end,
    }),1000)

  end,
});


isadd=true
list2.setOnScrollListener{
  onScroll=function(view,a,b,c)
    if a+b==list2.adapter.getCount() and isadd and list2.adapter.getCount()>0 then
      isadd=false
      sr.setRefreshing(true)
      主页刷新()
      System.gc()
      Handler().postDelayed(Runnable({
        run=function()
          sr.setRefreshing(false);
          isadd=true
        end,
      }),1000)
    end
  end
}
--热榜布局
itemc=
{
  LinearLayout,

  layout_width="-1",
  -- layout_height='56dp';
  --id="fpll",
  background=cardedge,
  {
    CardView;
    layout_margin="0dp";
    layout_marginTop="4dp";
    layout_marginBottom="0dp";
    layout_gravity='center';
    -- layout_marginLeft="0%w";
    Elevation='0';
    layout_width='fill';
    layout_height='-2';
    radius='0dp';
    id="_root",
    CardBackgroundColor=cardedge,
    {
      CardView;
      CardElevation="0dp";
      CardBackgroundColor=backgroundc;
      Radius="0dp";
      layout_margin="0px";
      layout_width="-1";
      layout_height="-1";
      {
        LinearLayout;
        layout_height="fill";
        ripple="圆自适应",

        layout_width="fill";

        {
          LinearLayout;
          orientation="horizontal",
          id="hot_background";
          layout_width="fill";
          {
            LinearLayout;
            padding="6dp";
            paddingTop="15dp";
            paddingBottom="15dp";

            {
              layout_marginLeft="10dp";
              TextView;
              textSize="16sp";
              Typeface=字体("product");
              id="排行";
              textColor=primaryc;
            };
            {
              TextView;
              textSize="0sp";
              id="导向链接",
              Typeface=字体("product");
            };
            {
              LinearLayout;
              layout_width="60%w",
              layout_marginLeft="10dp";
              orientation="vertical";
              {
                TextView;
                textColor=textc;
                textSize="14sp";
                letterSpacing="0.02";
                Typeface=字体("product-Medium");
                id="标题",
              };
              {
                TextView;
                textColor=stextc;
                textSize="13sp";
                layout_marginTop="8dp";
                id="热度",
                Typeface=字体("product");
              };
            };
          };
          {
            CardView;
            Elevation='0';
            radius='2dp';
            --  id="_root",
            layout_gravity="center_vertical",
            CardBackgroundColor=cardbackroundc,
            {
              ImageView;
              layout_width='102dp';
              layout_gravity="center",
              layout_height="63dp",
              id="热图片",
              ScaleType=ScaleType.CENTER_CROP,
            };
          };
        };
      };
    };
  };
};

--[[itemc=
{
  LinearLayout,

  layout_width="-1",
  -- layout_height='56dp';
  --id="fpll",
  background=backgroundc,
  {
    CardView;
    layout_margin="16dp";
    layout_marginTop="8dp";
    layout_marginBottom="8dp";
    layout_gravity='center';
    -- layout_marginLeft="0%w";
    Elevation='0';
    layout_width='fill';
    layout_height='-2';
    radius='8dp';
    id="_root",
    CardBackgroundColor=cardedge,
    {
      CardView;
      CardElevation="0dp";
      CardBackgroundColor=backgroundc;
      Radius=dp2px(8)-2;
      layout_margin="2px";
      layout_width="-1";
      layout_height="-1";
      {
        LinearLayout;
        layout_height="fill";
        ripple="圆自适应",

        layout_width="fill";

        {
          LinearLayout;
          orientation="horizontal",
          id="hot_background";
          layout_width="fill";
          {
            LinearLayout;
            padding="16dp";

            {
              TextView;
              textSize="16sp";
              Typeface=字体("product");
              id="排行";
              textColor=primaryc;
            };
            {
              TextView;
              textSize="0sp";
              id="导向链接",
              Typeface=字体("product");
            };
            {
              LinearLayout;
              layout_width="50%w",
              layout_marginLeft="10dp";
              orientation="vertical";
              {
                TextView;
                textColor=textc;
                textSize="14sp";
                Typeface=字体("product-Bold");
                id="标题",
              };
              {
                TextView;
                textColor=stextc;
                textSize="13sp";
                id="热度",
                Typeface=字体("product");
              };
            };
          };
          {
            CardView;
            Elevation='0';
            radius='4dp';
            --  id="_root",
            layout_gravity="center_vertical",
            CardBackgroundColor=cardbackroundc,
            {
              ImageView;
              layout_width='96dp';
              layout_gravity="center|right",
              layout_height="56dp",
              id="热图片",
              ScaleType=ScaleType.CENTER_CROP,
            };
          };
        };
      };
    };
  };
};]]


list3.addHeaderView(loadlayout( {
  MyTab
  {
    id="hotTab",
  },
  contentDescription="热榜标签集",

},nil,list3),nil,false)

import "com.kn.MyLuaAdapter"
import "com.bumptech.glide.Glide"
热榜adp=MyLuaAdapter(activity,itemc)

list3.adapter=热榜adp

function 热榜刷新(t)
  pcall(function()热榜adp.clear()end)
  Handler().postDelayed(Runnable({
    run=function()
      xpcall(function()

        Http.get(hotdata:getValue(tostring(hotTab:getShowItem(t).getChildAt(0).text),true),function(code,content)
          if code==200 then--判断网站状态
            local tab=require "cjson".decode(content).data
            for i=1,#tab do

              local 标题,热度,排行,导向链接=tab[i].target.title,tab[i].detail_text,i,tointeger(tab[i].target.id)..""
              local 热榜图片=tab[i].children[1].thumbnail
              --  print(热榜图片)
              if tab[i].target.type=="article" then
                导向链接="文章分割"..tointeger(tab[i].target.id)
              end

              table.insert(热榜adp.getData(),{标题=标题,热度=热度,排行=排行,导向链接=导向链接,热图片={src=String(热榜图片),Visibility=#热榜图片>0 and 0 or 8}})
              Glide.get(this).clearMemory();
            end
            Glide.get(this).clearMemory();
            task(1,function() 热榜adp.notifyDataSetChanged() end)
           else
            --        提示("获取回答失败 "..content)
          end
        end)

        end,function(e)

        hotdata:getPartition(function()
          for k,v in pairs(hotdata.partition) do
            --            if k~="全部" and (not(table.find({"全部","科学","数码","体育"},k))) then
            if k~="全部" and (not(table.find({"全部"},k))) then
              hotTab:addTab(k,function()
                热榜刷新()
              end)
            end
          end
          task(1,function()热榜刷新() hotTab:showTab(1) end)
        end)
      end)

    end,
  }),120)


end

function getuserinfo()


  local myurl= 'https://www.zhihu.com/api/v4/me'
  head = {
    ["cookie"] = 获取Cookie("https://www.zhihu.com/")
  }
  Http.get(myurl,head,function(code,content)

    if code==200 then--判断网站状态
      local data=require "cjson".decode(content)
      local 名字=data.name
      local 头像=data.avatar_url
      local 签名=data.headline
      local uid=data.id--用tointeger不行数值太大了会
      activity.setSharedData("idx",uid)
      ---      activity.setSharedData("name",名字)
      头像id.setImageBitmap(loadbitmap(头像))
      名字id.Text=名字
      if #签名:gsub(" ","")<1 then
        签名id.Text="你还没有签名呢"
       else
        签名id.Text=签名
      end
      侧滑头.onClick=function()
        activity.newActivity("people",{uid})
      end
    end
  end)

end

getuserinfo()

itemc3=
{
  LinearLayout,
  orientation="horizontal",
  layout_width="-1",
  BackgroundColor=backgroundc;
  {
    CardView;
    layout_margin="16dp";
    layout_marginTop="8dp";
    layout_marginBottom="8dp";
    layout_gravity='center';
    Elevation='0';
    layout_width='-1';
    layout_height='-2';
    radius='8dp';
    CardBackgroundColor=cardedge,
    {
      CardView;
      CardElevation="0dp";
      CardBackgroundColor=backgroundc;
      Radius=dp2px(8)-2;
      layout_margin="2px";
      layout_width="-1";
      layout_height="-1";
      {
        LinearLayout;
        layout_height="fill";
        id="background";
        layout_width="fill";
        ripple="圆自适应",

        {
          LinearLayout;
          orientation="horizontal";
          padding="16dp";
          {
            TextView;
            textSize="0sp";
            id="导向链接3",
            Typeface=字体("product");
          };
          {
            LinearLayout;
            orientation="vertical";
            {
              TextView;
              textColor=textc;
              textSize="14sp";
              Typeface=字体("product-Bold");
              id="标题3",
            };
          };
        };
      };
    };
  };
};

aabba=1

--
--创建适配器，将datas里面的数据匹配给itemc小项目
yuxun_adpqy=LuaAdapter(activity,itemc3)

--将小项目匹配给大list
list1.Adapter=yuxun_adpqy

news={}
function 日报刷新()
  --  链接= 'http://www.zhihudaily.me/'
  for i=1,2 do
    if i==2 then
      isaddd=true
      break
     else
      aabba=aabba-1
      import "android.icu.text.SimpleDateFormat"
      cal=Calendar.getInstance();
      cal.add(Calendar.DATE,tointeger(aabba));
      d=cal.getTime();
      sp= SimpleDateFormat("yyyyMMdd");
      ZUOTIAN=sp.format(d);
      链接 = 'https://kanzhihu.pro/api/news/'..tostring(ZUOTIAN)
      Http.get(链接,function(code,content)
        --  news[tostring(ZUOTIAN)]=content
        if aabba==0 then
          newnews=content
         elseif aabba==-1 then
          if content==newnews
            return
          end
        end

        --创建一个空的列表为datas(列表就是可以存放多个数据的意思)
        datas3={}
        --创建了三个有数据的列表
        aw3={}
        lj3={}

        --[[    doc = Jsoup.parse(content)--使用jsoup解析网页
    classification = doc.getElementsByClass('list-group-item')--查找到所有网页元素
    classification = luajava.astable(classification)--转换成table表
    for k,v in pairs(classification) do--循环添加
      table.insert(aw3,v.text())
      --   print(v.text())
    end
]]
        --    for t,c in content:gmatch([[<img name="image"(.-)alt="" />]]) do
        --      编码3=t:match([[id="(.-)" type]])
        --      table.insert(lj3,编码3)
        --    end


        --    for nj=1,#aw3 do
        for k,v in ipairs(require "cjson".decode(content).data.stories) do
          --给空的datas添加所有的数据
          --格式为  table.insert(空列表名称,{id=数据列表[nj]})
          --table.insert(datas3,{标题3=aw3[nj],导向链接3=lj3[nj]})
          table.insert(yuxun_adpqy.getData(),{标题3=v.title,导向链接3=v.url})
          task(1,function() yuxun_adpqy.notifyDataSetChanged()end)
        end
        --
        --创建适配器，将datas里面的数据匹配给itemc小项目
        --    yuxun_adpqy=LuaAdapter(activity,itemc3)

        --将小项目匹配给大list
        --    list1.Adapter=yuxun_adpqy
      end)
    end
  end
end


list1.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(parent,v,pos,id)
    --    activity.newActivity("huida",{"https://daily.zhihu.com/story/"..v.Tag.导向链接3.Text})
    activity.newActivity("huida",{v.Tag.导向链接3.Text})
  end

})

isaddd=true
list1.setOnScrollListener{
  onScroll=function(view,a,b,c)
    if a+b==yuxun_adpqy.getCount() and isaddd and yuxun_adpqy.getCount()>0 then
      isaddd=false
      日报刷新()
      System.gc()
    end
  end
}


itemc4=
{
  LinearLayout;
  layout_width="-1";
  BackgroundColor=backgroundc;
  orientation="horizontal";
  {
    CardView;
    Elevation="0";
    layout_gravity="center";
    CardBackgroundColor=cardedge,
    layout_margin="16dp";
    layout_marginTop="8dp";
    layout_marginBottom="8dp";
    layout_height="-2";
    layout_width="-1";
    radius="8dp";
    {
      CardView;
      CardElevation="0dp";
      CardBackgroundColor=backgroundc;
      Radius=dp2px(8)-2;
      layout_margin="2px";
      layout_width="-1";
      layout_height="-1";
      {
        LinearLayout;
        ripple="圆自适应",
        layout_height="fill";
        layout_width="fill";
        orientation="vertical";
        {
          LinearLayout;
          padding="10dp";
          orientation="horizontal";
          {
            TextView;
            textSize="14sp";
            Typeface=字体("product-Bold");
            textColor=textc;
            id="collections_title",
          };
          {
            ImageView;
            layout_height="16dp",
            layout_width="16dp",
            layout_marginLeft="2dp",
            id="is_lock",
            layout_gravity="center",
            ColorFilter=textc;
          };
        };
        {
          LinearLayout;
          padding="8dp";
          paddingTop="0dp";
          orientation="vertical";
          {
            TextView;
            textColor=stextc;
            textSize="12sp",
            Typeface=字体("product");
            id="collections_art",
          };
          {
            TextView;
            TextSize="0dp",
            id="collections_id",
          };
        };
        {
          LinearLayout;
          padding="8dp";
          paddingTop="0dp";
          orientation="horizontal";
          {
            ImageView;
            src=图标("chat_bubble"),
            layout_gravity="center",
            ColorFilter=textc;
            layout_height="16dp",
            layout_width="16dp",
          };
          {
            TextView;
            layout_marginLeft="6dp",
            textColor=textc;
            textSize="12sp",
            Typeface=字体("product");
            id="collections_item",
          };
          {
            ImageView;
            layout_marginLeft="18dp",
            src=图标("eye"),
            ColorFilter=textc;
            layout_gravity="center",
            layout_height="16dp",
            layout_width="16dp",
          };
          {
            TextView;
            layout_marginLeft="6dp",
            textColor=textc;
            Typeface=字体("product");
            textSize="12sp",
            id="collections_follower",
          };
        };
      };

    };
  };
};

itemc8=
{
  LinearLayout;
  layout_width="-1";
  orientation="horizontal";
  BackgroundColor=backgroundc;
  {
    CardView;
    Elevation="0";
    layout_gravity="center";
    CardBackgroundColor=cardedge,
    layout_margin="16dp";
    layout_marginTop="8dp";
    layout_marginBottom="8dp";
    layout_height="-2";
    layout_width="-1";
    radius="8dp";
    {
      CardView;
      CardElevation="0dp";
      CardBackgroundColor=backgroundc;
      Radius=dp2px(8)-2;
      layout_margin="2px";
      layout_width="-1";
      layout_height="-1";

      {
        LinearLayout;
        ripple="圆自适应",
        layout_height="fill";
        layout_width="fill";
        orientation="horizontal";
        {
          TextView;
          TextSize="0dp",
          layout_width="0",
          layout_hieght="0",
          Visibility=8,
          id="mc_id",
        };
        {
          CircleImageView;
          layout_gravity="left|center",
          id="mc_image",
          layout_width="60dp",--布局宽度
          layout_height="40dp",--布局高度
          layout_marginLeft="5dp",
        };
        {
          LinearLayout;
          layout_width="fill",
          padding="8dp";
          paddingLeft="5dp",
          paddingTop="10dp",
          paddingBottom="10dp",
          orientation="vertical";

          {
            TextView;
            textSize="14sp";
            id="mc_title",
            Typeface=字体("product-Bold");
            textColor=textc;

          };
          {
            TextView;
            Typeface=字体("product");
            textColor=stextc;
            SingleLine=true;
            textSize="12sp",
            layout_gravity="left|bottom",
            gravity="left|bottom",
            --      layout_marginBottom="-1dp",
            id="mc_name",
            y="17dp",
          };
          {
            TextView;
            layout_width="wrap",
            textSize="12sp",
            layout_gravity="right|bottom";
            layout_marginLeft="20dp";
            Typeface=字体("product");
            SingleLine=true;
            textColor=stextc;
            id="mc_follower",
          };
        };
      };
    };

  };
};


function 收藏刷新()
  xpcall(function()
    local yuxun_ay=LuaAdapter(activity,datas4,itemc4)

    list4.Adapter=yuxun_ay
    list4.adapter.add{
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

    }

    local yuxuuun_ay=MyLuaAdapter(activity,datas8,itemc8)
    list8.Adapter=yuxuuun_ay

    local collections_url= "https://api.zhihu.com/people/"..activity.getSharedData("idx").."/collections_v2?offset=0&limit=20"

    local head = {
      ["cookie"] = 获取Cookie("https://www.zhihu.com/")
    }


    Http.get(collections_url,head,function(code,content)
      if code==200 then


        for k,v in ipairs(require "cjson".decode(content).data) do

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
              text="https://api.zhihu.com/collections/"..tointeger(v.id).."/answers?offset=0"

            },
          }
        end

       else
        提示("获取收藏列表失败")
      end
    end)



    local mc_url= "https://api.zhihu.com/people/"..activity.getSharedData("idx").."/following_collections?offset=0"
    -- print(mc_url)
    head = {
      ["cookie"] = 获取Cookie("https://www.zhihu.com/")
    }

    Http.get(mc_url,head,function(c,ct)
      if c==200 then

        for k,v in ipairs(require "cjson".decode(ct).data) do

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
              text="https://api.zhihu.com/collections/"..tointeger(v.id).."/answers?offset=0",
            },
            background={foreground=Ripple(nil,转0x(ripplec),"方")},
          }
        end

       else
        提示("获取收藏列表失败")
      end
    end)
    end,function()
    提示("你可能需要登录哦")
  end)

end

list4.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(parent,v,pos,id)
    activity.newActivity("collections",{v.Tag.collections_id.Text,v.Tag.collections_title.Text})
  end
})
list8.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(parent,v,pos,id)
    activity.newActivity("collections",{v.Tag.mc_id.Text,v.Tag.mc_title.Text})
  end
})


page.setOnPageChangeListener(PageView.OnPageChangeListener{
  onPageScrolled=function(a,b,c)
    local w=activity.getWidth()/2
    local wd=c/2
    if a==0 then
      page_scroll.setX(wd)
    end
    if a==1 then
      page_scroll.setX(wd+w)
    end
  end,
  onPageSelected=function(v)
    local x=primaryc
    local c=stextc
    local c1=c
    local c2=c
    if v==0 then
      c1=x
    end
    if v==1 then
      c2=x
    end
    page4.getChildAt(0).setTextColor(转0x(c1))
    page5.getChildAt(0).setTextColor(转0x(c2))
  end
})


function changepage(z)
  page.showPage(z)
end

itemcc={
  LinearLayout,
  BackgroundColor=backgroundc;
  layout_width="-2",
  padding="20",
  id="it",
  {
    CardView;
    layout_margin="16dp";
    layout_marginTop="8dp";
    layout_marginBottom="8dp";
    layout_gravity='center';
    Elevation='0';
    layout_width='-1';
    radius='8dp';
    CardBackgroundColor=cardedge,
    {
      CardView;
      CardElevation="0dp";
      CardBackgroundColor=backgroundc;
      Radius=dp2px(8)-2;
      layout_margin="2px";
      layout_width="-1";
      {
        LinearLayout,
        layout_width="-1",
        orientation="vertical",
        Gravity="center",
        {
          ImageView;
          layout_width="-1",
          id="img",
        };
        {
          TextView,
          paddingTop="20",
          Gravity="center",
          textColor=textc;
          textSize="14sp";
          Typeface=字体("product-Bold");
          id="tv",
        },
      },
    },
  },
}


csr.setProgressBackgroundColorSchemeColor(转0x(backgroundc));
csr.setColorSchemeColors({转0x(primaryc)});
csr.setOnRefreshListener(SwipeRefreshLayout.OnRefreshListener{onRefresh=function()
    收藏刷新()
    Handler().postDelayed(Runnable({
      run=function()
      csr.setRefreshing(false); end,
    }),1000)
end})

list2.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(parent,v,pos,id)

    local open=activity.getSharedData("内部浏览器查看回答")
    if tostring(v.Tag.链接2.text):find("文章分割") then

      activity.newActivity("column",{tostring(v.Tag.链接2.Text):match("文章分割(.+)"),tostring(v.Tag.链接2.Text):match("分割(.+)")})

     elseif tostring(v.Tag.链接2.text):find("想法分割") then
      activity.newActivity("column",{tostring(v.Tag.链接2.Text):match("想法分割(.+)"),"想法"})

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

list3.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(parent,v,pos,id)

    local open=activity.getSharedData("内部浏览器查看回答")

    if tostring(v.Tag.导向链接.text):find("文章分割") then
      activity.newActivity("column",{tostring(v.Tag.导向链接.Text):match("文章分割(.+)"),tostring(v.Tag.导向链接.Text):match("分割(.+)")})

     elseif tostring(v.Tag.导向链接.text):find("想法分割") then
      activity.newActivity("column",{tostring(v.Tag.链接2.Text):match("想法分割(.+)"),"想法"})
     else
      保存历史记录(v.Tag.标题.Text,v.Tag.导向链接.Text,50)
      if open=="false" then

        activity.newActivity("question",{v.Tag.导向链接.Text,nil})
       else
        activity.newActivity("huida",{"https://www.zhihu.com/question/"..tostring(v.Tag.导向链接.Text)})
      end
    end
  end
})





--关注布局
follow_itemc=
{
  LinearLayout;
  layout_width="-1";
  orientation="horizontal";
  BackgroundColor=backgroundc;
  {
    CardView;
    layout_gravity="center";
    layout_height="-2";
    CardBackgroundColor=cardedge,
    Elevation="0";
    layout_width="-1";
    layout_margin="0dp";
    layout_marginTop="0dp";
    layout_marginBottom="0dp";
    radius="0dp";
    {
      CardView;
      CardElevation="0dp";
      CardBackgroundColor=backgroundc;
      Radius="0dp";
      layout_margin="4px";
      layout_width="-1";
      layout_height="-1";
      {
        LinearLayout;
        ripple="圆自适应",

        layout_height="fill";
        id="background";
        layout_width="fill";

        {
          LinearLayout;
          orientation="horizontal";
          padding="24dp";
          paddingTop="16dp";
          paddingBottom="16dp";
          {
            TextView;
            id="follow_id";
            textSize="0sp";
          };
          {
            LinearLayout;
            orientation="vertical";
            {
              LinearLayout;
              layout_marginTop="0dp";
              orientation="horizontal";
              {
                CircleImageView;
                padding="2dp",
                id="follow_image",
                layout_width="32dp",
                layout_height="32dp",
              };
              {
                LinearLayout;
                orientation="vertical";
                layout_marginLeft="8dp";
                {
                  TextView;
                  id="follow_name";
                  textColor=stextc;
                  Typeface=字体("product");
                  textSize="14dp";
                };
                {
                  TextView;
                  id="follow_time";
                  textColor=stextc;
                  Typeface=字体("product");
                  textSize="14dp";
                };
              };
            };
            {
              TextView;
              textSize="14sp";
              id="follow_title";
              textColor=textc;
              layout_marginTop="12dp";
              Typeface=字体("product-Bold");
              letterSpacing="0.02";
            };

            {
              TextView;
              textSize="12sp";
              id="follow_art";
              textColor=stextc;
              MaxLines=3,--设置最大输入行数
              ellipsize="end",--设置内容超出控件大小时显示...
              layout_marginTop="8dp";
              Typeface=字体("product");
              letterSpacing="0.02";
            };
            {
              LinearLayout;
              layout_marginTop="8dp";
              orientation="horizontal";
              {
                ImageView;
                layout_gravity="center",
                layout_height="16dp",
                layout_width="16dp",
                src=图标("vote_up"),
                ColorFilter=textc;
              };
              {
                TextView;
                id="follow_voteup";
                layout_marginLeft="6dp",
                textSize="12sp";
                textColor=textc;
                Typeface=字体("product");
              };
              {
                ImageView;
                layout_marginLeft="24dp",
                src=图标("message"),
                ColorFilter=textc;
                layout_height="16dp",
                layout_width="16dp",
                layout_gravity="center",
              };
              {
                TextView;
                layout_marginLeft="6dp",
                id="follow_comment";
                textColor=textc;
                textSize="12sp";
                Typeface=字体("product");
              };
            };
          };
        };
      };
    };
  };
};


moments_nextUrl=""

moments_isend=false

function 关注刷新(ppage,url)
  -- origin15.19 更改
  local posturl = url or "https://www.zhihu.com/api/v3/moments?limit=10"
  local head = {
    ["cookie"] = 获取Cookie("https://www.zhihu.com/")
  }

  if ppage<2 then
    local qqadpqy=LuaAdapter(activity,datas9,follow_itemc)
    list9.Adapter=qqadpqy
  end

  if 状态=="未登录" then
    提示("请登录后使用关注功能")
   else
    提示("加载中")
    local json=require "cjson"
    Http.get(posturl,head,function(code,content)
      if code==200 then
        local data=json.decode(content)
        moments_isend=data.paging.is_end
        moments_nextUrl=data.paging.next
        for k,v in ipairs(data.data) do
          if v.type=="feed_group"
            --         for i=1, #require "cjson".decode(v.list) do
            for d,e in ipairs(v.list) do


              local 关注作者头像=e.actors[1].avatar_url
              --        local 点赞数=tointeger(v.target.voteup_count)
              local 点赞数=tointeger(e.target.voteup_count)
              local 评论数=tointeger(e.target.comment_count)
              local 标题=e.target.title or e.target.question.title
              local 关注名字=e.action_text
              local 时间=时间戳(e.created_time)
              --            local 预览内容=e.target.excerpt_new
              local 预览内容=e.target.excerpt
              if e.target.type=="answer" then
                问题id等=tointeger(e.target.question.id or 1).."分割"..tointeger(e.target.id)
                标题=e.target.question.title
               elseif e.target.type=="question" then
                问题id等="问题分割"..tointeger(e.target.id)
                标题=e.target.title
               elseif e.target.type=="article"
                问题id等="文章分割"..tointeger(e.target.id)
                标题=e.target.title
               elseif e.target.type=="pin"
                问题id等="想法分割"..tointeger(e.target.id)
                标题=e.target.title
              end
              list9.Adapter.add{follow_voteup=点赞数,follow_title=标题,follow_art=预览内容,follow_comment=评论数,follow_id=问题id等,follow_name=关注名字,follow_time=时间,follow_image=关注作者头像}

            end
           elseif v.type=="feed" then
            local 关注作者头像=v.actors[1].avatar_url
            --        local 点赞数=tointeger(v.target.voteup_count)
            local 点赞数=tointeger(v.target.voteup_count)
            local 评论数=tointeger(v.target.comment_count)
            local 标题=v.target.title
            local 关注名字=v.action_text
            local 时间=时间戳(v.created_time)
            --          local 预览内容=v.target.excerpt_new
            local 预览内容=v.target.excerpt
            if v.target.type=="answer" then
              问题id等=tointeger(v.target.question.id or 1).."分割"..tointeger(v.target.id)
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
            end
            list9.Adapter.add{follow_voteup=点赞数,follow_title=标题,follow_art=预览内容,follow_comment=评论数,follow_id=问题id等,follow_name=关注名字,follow_time=时间,follow_image=关注作者头像}
          end
        end
       elseif require "cjson".decode(content).error.message and code==401 then
        authorerror=AlertDialog.Builder(this)
        .setTitle("提示")
        .setMessage("账号存在风险 请更改密码 由于风险问题 不更改密码会无法使用该功能")
        .setCancelable(false)
        .setPositiveButton("立即更改密码",nil)
        .show()
        authorerror.create()
        authorerror.getButton(authorerror.BUTTON_POSITIVE).onClick=function()
          activity.newActivity("huida",{"https://www.zhihu.com/account/password_reset?utm_id=0"})
        end
      end

    end)
  end
end

function onActivityResult(a,b,c)
  if b==100 then
    getuserinfo()
    主页刷新()
    关注刷新(1)
   elseif b==1200 then --夜间模式开启
    activity.newActivity("home",android.R.anim.fade_in,android.R.anim.fade_out)
    activity.finish()
   elseif b==200 then
    activity.finish()
   elseif b==1500 then
    初始化历史记录数据(true)
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

appinfo=this.getPackageManager().getApplicationInfo(this.getPackageName(),(0))
--versionCode=tointeger(appinfo.versionCode)

local update_api= "https://huajicloud.gitee.io/hydrogen.html"

--Http.get(update_api,function(code,ctt)
Http.get(update_api,function(code,content)
  if code==200 then
    --  content=table2string(require "cjson".decode(ctt))
    -- updateversioncode=tointeger(content:match[[updateversioncode=(.+),]])
    updateversioncode=tonumber(content:match("updateversioncode%=(.+),updateversioncode"))
    if updateversioncode > versionCode and activity.getSharedData("version")~=updateversioncode then
      updateversionname=content:match("updateversionname%=(.+),updateversionname")
      updateinfo=content:match("updateinfo%=(.+),updateinfo")
      updateurl=tostring(content:match("updateurl%=(.+),updateurl"))
      myupdatedialog=AlertDialog.Builder(this)
      .setTitle("检测到最新版本")
      .setMessage("最新版本："..updateversionname.."("..updateversioncode..")\n"..updateinfo)
      .setCancelable(false)
      .setPositiveButton("立即更新",nil)
      .setNeutralButton("暂不更新",{onClick=function() activity.setSharedData("version",updateversioncode) end})
      .show()
      myupdatedialog.create()
      myupdatedialog.getButton(myupdatedialog.BUTTON_POSITIVE).onClick=function()
        下载文件对话框("下载安装包中",updateurl,"Hydrogen.apk",false)
      end
      --  updateversionname=content:match[[updateversionname=(.+),]]
      -- updateversionname=content:match("updateversionname%=(.+),updateversionname")
    end
   else
    提示("检查更新失败，请检查网络连接后再试")
  end
end)

if activity.getSharedData("自动清理缓存")=="true" then
  import "androidx.core.content.ContextCompat"
  task(function(dar)
    --   dar=File(activity.getLuaDir()).parent.."/cache/webviewCache"
    require "import"
    import "java.io.File"
    local tmp={[1]=0}

    local function getDirSize(tab,path)
      if File(path).exists() then
        local a=luajava.astable(File(path).listFiles() or {})

        for k,v in pairs(a) do
          if v.isDirectory() then
            getDirSize(tab,tostring(v))
           else

            tab[1]=tab[1]+v.length()
          end
        end
      end
    end
    dar=tostring(ContextCompat.getDataDir(activity)).."/cache"
    getDirSize(tmp,dar)
    --    getDirSize(tmp,"/sdcard/Android/data/"..activity.getPackageName().."/cache/")

    local a1,a2=File("/data/data/"..activity.getPackageName().."/database/webview.db"),File("/data/data/"..activity.getPackageName().."/database/webviewCache.db")
    pcall(function()
      tmp[1]=tmp[1]+(a1.length() or 0)+(a2.length() or 0)
      a1.delete()
      a2.delete()
    end)
    LuaUtil.rmDir(File(dar))

    return tmp[1]
    end,APP_CACHEDIR,function(m)

    提示("清理成功,共清理 "..tokb(m))
  end)
end

function 想法刷新(isclear)
  if isclear=="clear" or #mytab<2 then
    mytab={}
    recy.setAdapter(adapter)
    recy.setLayoutManager(StaggeredGridLayoutManager(2,StaggeredGridLayoutManager.VERTICAL))
    thisurl=nil
  end
  local geturl=thisurl or "https://api.zhihu.com/prague/feed?offset=0&limit=10"
  Http.get(geturl,head,function(code,content)
    if code==200 then--判断网站状态
      thisurl=require "cjson".decode(content).paging.next
      for i,v in ipairs(require "cjson".decode(content).data) do
        local url=v.target.images[1].url
        local title=v.target.excerpt
        local tzurl=v.target.url:match("pin/(.-)?")
        table.insert(mytab,{url=url,title=title,tzurl=tzurl})
        adapter.notifyDataSetChanged()
      end



     else
      --        提示("获取回答失败 "..content)
    end
  end)

end


data=...
function onCreate()
  if data then
    local intent=tostring(data.getData())
    检查意图(inent)
  end
end