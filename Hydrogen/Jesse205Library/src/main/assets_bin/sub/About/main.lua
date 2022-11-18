require "import"
import "Jesse205"

import "com.Jesse205.layout.util.SettingsLayUtil"
import "com.Jesse205.app.dialog.ImageDialogBuilder"
import "appAboutInfo"
import "agreements"

--local screenConfigDecoder,actionBar,Landscape,data,PackInfo,adp,layoutManager,Glide,topCardItems,appIconGroup,topCard,recyclerView,appBarElevationCard
--Glide,activity,actionBar=_G.Glide,_G.activity,_G.actionBar
activity.setTitle(R.string.Jesse205_about)
activity.setContentView(loadlayout2("layout",_ENV))
actionBar.setDisplayHomeAsUpEnabled(true)

loadlayout2("iconLayout")
loadlayout2("portraitCardParentView")
portraitCardParent.addView(iconLayout)

adapterEvents=SettingsLayUtil.adapterEvents
packageInfo=activity.getPackageManager().getPackageInfo(getPackageName(),0)
landscape=false
LastCard2Elevation=0

function onOptionsItemSelected(item)
  local id=item.getItemId()
  if id==android.R.id.home then
    activity.finish()
  end
end

--获取QQ头像链接
function getUserAvatarUrl(qq,size)
  return ("http://q.qlogo.cn/headimg_dl?spec=%s&img_type=jpg&dst_uin=%s"):format(size or 640,qq)
end

--加入QQ交流群
function joinQQGroup(groupNumber)
  local uri=Uri.parse(("mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%s&card_type=group&source=qrcode"):format(groupNumber))
  if not(pcall(activity.startActivity,Intent(Intent.ACTION_VIEW,uri))) then
    MyToast(R.string.Jesse205_noQQ)
  end
end

function onItemClick(view,views,key,data)
  if key=="qq" then
    pcall(activity.startActivity,Intent(Intent.ACTION_VIEW,Uri.parse("mqqwpa://im/chat?chat_type=wpa&uin="..data.qq)))
   elseif key=="qq_group" then--单个QQ群
    joinQQGroup(data.groupId)
   elseif key=="qq_groups" then--多个QQ群
    local pop=PopupMenu(activity,view)
    local menu=pop.Menu
    for index,content in ipairs(data.groups) do
      menu.add(content.name).onMenuItemClick=function()
        joinQQGroup(content.id)
      end
    end
    pop.show()
   elseif key=="html" then
    newSubActivity("HtmlFileViewer",{{title=data.title,path=data.path}})
   elseif key=="openSourceLicenses" then
    newSubActivity("OpenSourceLicenses")
   elseif key=="support" then
    local supportUrl=data.supportUrl
    local supportList=data.supportList
    if supportList then
      local pop=PopupMenu(activity,view)
      local menu=pop.Menu
      for index,content in ipairs(supportList) do
        menu.add(content.name).onMenuItemClick=function()
          local url=content.url
          local func=content.func
          if func then
            func(view)
           elseif url then
            openUrl(url)
          end
        end
      end
      pop.show()
     elseif supportUrl then
      openUrl(supportUrl)
    end
  end
end

function onConfigurationChanged(config)
  screenConfigDecoder:decodeConfiguration(config)
  local newLandscape=config.orientation==Configuration.ORIENTATION_LANDSCAPE
  if landscape~=newLandscape then
    landscape=newLandscape
    local screenWidthDp=config.screenWidthDp
    if newLandscape then--横屏时
      LastActionBarElevation=0
      actionBar.setElevation(0)
      appBarElevationCard.setVisibility(View.VISIBLE)
      local linearParams=iconLayout.getLayoutParams()
      if screenWidthDp>theme.number.padWidthDp then
        linearParams.width=math.dp2int(200+16*2)
       else
        linearParams.width=math.dp2int(152+16*2)
      end
      iconLayout.setLayoutParams(linearParams)
      portraitCardParent.removeView(iconLayout)
      mainLayChild.addView(iconLayout,0)
     else
      appBarElevationCard.setVisibility(View.GONE)
      local linearParams=iconLayout.getLayoutParams()
      linearParams.width=-1
      iconLayout.setLayoutParams(linearParams)
      mainLayChild.removeView(iconLayout)
      portraitCardParent.addView(iconLayout)
    end
  end
end

topCardItems={}
--插入大软件图标
for index,content in ipairs(appInfo) do
  local ids={}
  appIconGroup.addView(loadlayout2("iconItem",ids,LinearLayoutCompat))
  table.insert(topCardItems,ids.mainIconLay)
  local icon,iconView,nameView=content.icon,ids.icon,ids.name
  iconView.setBackgroundResource(icon)
  nameView.setText(content.name)
  ids.message.setText(content.message)
  if content.click then
    ids.mainIconLay.setBackground(ThemeUtil.getRippleDrawable(theme.color.rippleColorPrimary))
    ids.mainIconLay.onClick=content.click
  end
  local pain=ids.name.getPaint()
  if content.typeface then
    pain.setTypeface(content.typeface)
   else
    pain.setTypeface(Typeface.defaultFromStyle(Typeface.BOLD))
  end
  if content.nameColor then
    nameView.setTextColor(content.nameColor)
  end
  ids=nil
end

data={
  {--软件图标
    -1;
  };

  {--关于软件
    SettingsLayUtil.TITLE;
    title=R.string.Jesse205_about_full;
  };
  {--软件版本
    SettingsLayUtil.ITEM;
    title=R.string.Jesse205_nowVersion_app;
    summary=("%s (%s)"):format(packageInfo.versionName,packageInfo.versionCode);
    icon=R.drawable.ic_information_outline;
    key="update";
  };
  {--Jesse205Library版本
    SettingsLayUtil.ITEM;
    title=R.string.Jesse205_nowVersion_jesse205Library;
    summary=("%s (%s)"):format(Jesse205._VERSION,Jesse205._VERSIONCODE);
    icon=R.drawable.ic_information_outline;
  };
}

--插入协议
if agreements then
  local fileBasePath=activity.getLuaPath("../../agreements/%s.html")
  for index,content in ipairs(agreements) do
    content[1]=SettingsLayUtil.ITEM_NOSUMMARY
    content.path=fileBasePath:format(content.name)
    content.key="html"
    content.newPage=true
    table.insert(data,content)
  end
end


--开发信息
if developers or openSourceLicenses then
  table.insert(data,{
    SettingsLayUtil.TITLE;
    title=R.string.Jesse205_developerInfo;
  })
end

--插入开发者
if developers then
  for index,content in ipairs(developers) do
    table.insert(data,{
      SettingsLayUtil.ITEM_AVATAR;
      title="@"..content.name;
      summary=content.message;
      icon=getUserAvatarUrl(content.qq,content.imageSize);
      qq=content.qq;
      key="qq";
      newPage="newApp";
    })
  end
end

--插入开源许可
if openSourceLicenses then
  table.insert(data,{
    SettingsLayUtil.ITEM_NOSUMMARY;
    title=R.string.Jesse205_openSourceLicense;
    icon=R.drawable.ic_github;
    key="openSourceLicenses";
    newPage=true;
  })
end

--更多内容
table.insert(data,{
  SettingsLayUtil.TITLE;
  title=R.string.Jesse205_moreContent;
})

--插入交流群
if qqGroup then--单个交流群
  table.insert(data,{
    SettingsLayUtil.ITEM_NOSUMMARY;
    title=R.string.Jesse205_qqGroup;
    icon=R.drawable.ic_account_group_outline;
    groupId=qqGroup;
    key="qq_group";
    newPage="newApp";
  })
end

if qqGroups then--多个交流群
  table.insert(data,{
    SettingsLayUtil.ITEM_NOSUMMARY;
    title=R.string.Jesse205_qqGroups;
    icon=R.drawable.ic_account_group_outline;
    groups=qqGroups;
    key="qq_groups";
  })
end

if supportUrl or supportList then--支持项目
  table.insert(data,{
    SettingsLayUtil.ITEM_NOSUMMARY;
    title=R.string.Jesse205_supportProject;
    icon=R.drawable.ic_wallet_giftcard;
    supportUrl=supportUrl;
    supportList=supportList;
    key="support";
    newPage=supportNewPage;
  })
end

if copyright then--版权信息
  table.insert(data,{
    SettingsLayUtil.ITEM;
    title=R.string.Jesse205_copyright;
    summary=copyright;
    icon=R.drawable.ic_copyright;
    key="copyright";
  })
end


adapter=LuaCustRecyclerAdapter(AdapterCreator({
  getItemCount=function()
    return adapterEvents.getItemCount(data)
  end,
  getItemViewType=function(position)
    return adapterEvents.getItemViewType(data,position)
  end,
  onCreateViewHolder=function(parent,viewType)
    if viewType==-1 then
      local holder=LuaCustRecyclerHolder(portraitCardParent)
      return holder
     else
      return adapterEvents.onCreateViewHolder(onItemClick,nil,parent,viewType)
    end
  end,
  onBindViewHolder=function(holder,position)
    if position~=0 then
      adapterEvents.onBindViewHolder(data,holder,position)
    end
  end,
}))

layoutManager=LinearLayoutManager()
recyclerView.setAdapter(adapter)
recyclerView.setLayoutManager(layoutManager)

recyclerView.addOnScrollListener(RecyclerView.OnScrollListener{
  onScrolled=function(view,dx,dy)
    if landscape then
      MyAnimationUtil.RecyclerView.onScroll(view,dx,dy,appBarElevationCard,"LastCard2Elevation")
     else
      MyAnimationUtil.RecyclerView.onScroll(view,dx,dy)
    end
  end
})


screenConfigDecoder=ScreenFixUtil.ScreenConfigDecoder({
  orientation={
    different={appIconGroup},
  },
  fillParentViews={topCard},
  onDeviceChanged = function(device, oldDevice)
    if device=="pc" then
      local linearParams=iconCard.getLayoutParams()
      linearParams.height=-2
      linearParams.width=-2
      iconCard.setLayoutParams(linearParams)
     elseif oldDevice=="pc" then
      local linearParams=iconCard.getLayoutParams()
      linearParams.height=-1
      linearParams.width=-1
      iconCard.setLayoutParams(linearParams)
    end
  end
})

onConfigurationChanged(activity.getResources().getConfiguration())