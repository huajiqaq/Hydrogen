require "import"
import "jesse205"
local normalkeys=jesse205.normalkeys
normalkeys.appInfo=true
normalkeys.openSourceLicenses=true
normalkeys.developers=true
normalkeys.moreItem=true
normalkeys.copyright=true
normalkeys.onUpdate=true

import "android.graphics.Typeface"
import "android.text.Spannable"
import "android.text.SpannableString"
import "android.text.style.ForegroundColorSpan"
import "android.text.style.StyleSpan"

import "com.jesse205.layout.util.SettingsLayUtil"
import "com.jesse205.app.dialog.ImageDialogBuilder"
import "appAboutInfo"
import "agreements"

activity.setTitle(R.string.jesse205_about)
activity.setContentView(loadlayout2("layout"))
actionBar.setDisplayHomeAsUpEnabled(true)

loadlayout2("iconLayout")
loadlayout2("portraitCardParentView")
portraitCardParent.addView(iconLayout)

adapterEvents=SettingsLayUtil.adapterEvents
packageInfo=activity.getPackageManager().getPackageInfo(getPackageName(),0)
landscapeState=false--是否是横屏。此Activity按竖屏做的，因此默认为false
LastCard2Elevation=0
topCardItems={}

function onOptionsItemSelected(item)
  local id=item.getItemId()
  if id==android.R.id.home then
    activity.finish()
  end
end

--获取QQ头像链接
function getUserAvatarUrl(qq,size)
  if qq then
    return ("http://q.qlogo.cn/headimg_dl?spec=%s&img_type=jpg&dst_uin=%s"):format(size or 640,qq)
  end
end

--QQ交流
function chatOnQQ(qqNumber)
  local uri=Uri.parse("mqqwpa://im/chat?chat_type=wpa&uin="..qqNumber)
  if not(pcall(activity.startActivity,Intent(Intent.ACTION_VIEW,uri))) then
    MyToast(R.string.jesse205_noQQ)
  end
end

--加入QQ交流群
function joinQQGroup(groupNumber)
  local uri=Uri.parse(("mqqapi://card/show_pslcard?src_type=internal&version=1&uin=%s&card_type=group&source=qrcode"):format(groupNumber))
  if not(pcall(activity.startActivity,Intent(Intent.ACTION_VIEW,uri))) then
    MyToast(R.string.jesse205_noQQ)
  end
end

function callItem(parent,view,data)
  if data.url then
    openUrl(data.url)
   elseif data.browserUrl then
    openInBrowser(data.browserUrl)
   elseif data.qqGroup then--QQ群
    joinQQGroup(data.qqGroup)
   elseif data.qq then
    chatOnQQ(data.qq)
   elseif data.click then
    data.click()
   elseif data.contextMenuEnabled then
    if parent and view then
      parent.showContextMenuForChild(view)
    end
  end
end

function onItemClick(view,views,key,data)
  if callItem(recyclerView,view,data) then
   elseif key=="version" then
    if onUpdate then
      onUpdate()
    end
   elseif key=="html" then
    newSubActivity("HtmlFileViewer",{{title=data.title,path=data.path}})
   elseif key=="openSourceLicenses" then
    newSubActivity("OpenSourceLicenses")
   elseif key=="thanks" then
    local items={}
    for index,content in pairs(data.thanks) do
      local text=SpannableString(index..": "..table.concat(content,"、"))
      local indexLength=utf8.len(index)
      text.setSpan(ForegroundColorSpan(theme.color.colorAccent),0,indexLength,Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
      text.setSpan(StyleSpan(Typeface.BOLD),0,indexLength,Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
      table.insert(items,text)
    end
    AlertDialog.Builder(this)
    .setTitle(R.string.jesse205_thanksList)
    .setItems(items,nil)
    .setPositiveButton(android.R.string.ok,nil)
    .show()
  end
end

function onConfigurationChanged(config)
  screenConfigDecoder:decodeConfiguration(config)
  local newLandscapeState=config.orientation==Configuration.ORIENTATION_LANDSCAPE--新的横屏状态
  if landscapeState~=newLandscapeState then--因为有时候的调节可能不是屏幕方向改变，所以要判断一下
    landscapeState=newLandscapeState
    local screenWidthDp=config.screenWidthDp
    if newLandscapeState then--横屏时
      --将工具栏阴影设置为0，启用虚拟阴影区域
      LastActionBarElevation=0
      actionBar.setElevation(0)
      appBarElevationCard.setVisibility(View.VISIBLE)
      local linearParams=iconLayout.getLayoutParams()
      if screenWidthDp>theme.number.width_dp_pc then--根据窗口宽度调整卡片宽度，保证在小屏手机显示效果良好
        linearParams.width=math.dp2int(200+16*2)
       else
        linearParams.width=math.dp2int(152+16*2)
      end
      iconLayout.setLayoutParams(linearParams)
      portraitCardParent.removeView(iconLayout)
      mainLayChild.addView(iconLayout,0)
     else
      --将虚拟阴影设置为0，启用工具栏阴影
      appBarElevationCard.setVisibility(View.GONE)
      local linearParams=iconLayout.getLayoutParams()
      linearParams.width=-1
      iconLayout.setLayoutParams(linearParams)
      mainLayChild.removeView(iconLayout)
      portraitCardParent.addView(iconLayout)
    end
  end
end

--插入大软件图标
if appInfo then
  for index,content in ipairs(appInfo) do
    local ids={}
    appIconGroup.addView(loadlayout2("iconItem",ids,LinearLayoutCompat))
    local mainIconLay=ids.mainIconLay--主布局
    local iconView,nameView,messageView=ids.icon,ids.name,ids.message
    table.insert(topCardItems,mainIconLay)
    local iconResource=content.iconResource
    iconView.setBackgroundResource(iconResource)
    nameView.setText(content.name)
    messageView.setText(content.message)
    if content.clickable then
      mainIconLay.setBackground(ThemeUtil.getRippleDrawable(theme.color.rippleColorPrimary))
      mainIconLay.onClick=lambda view: callItem(appIconGroup,view,content)
    end
    local pain=ids.name.getPaint()
    pain.setTypeface(content.typeface or Typeface.defaultFromStyle(Typeface.BOLD))
    if content.nameColor then
      nameView.setTextColor(content.nameColor)
    end
  end
end

data={
  {--软件图标
    -1;
  };
  {--关于软件
    SettingsLayUtil.TITLE;
    title=R.string.jesse205_about_full;
  };
  {--软件版本
    SettingsLayUtil.ITEM;
    title=R.string.jesse205_nowVersion_app;
    summary=("%s (%s)"):format(BuildConfig.VERSION_NAME,BuildConfig.VERSION_CODE);
    icon=R.drawable.ic_information_outline;
    key="version";
  };
  {--Jesse205Library版本
    SettingsLayUtil.ITEM;
    title=R.string.jesse205_nowVersion_jesse205Library;
    summary=("%s (%s)"):format(jesse205._VERSION,jesse205._VERSIONCODE);
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
if developers or openSourceLicenses or thanks then
  table.insert(data,{
    SettingsLayUtil.TITLE;
    title=R.string.jesse205_developerInfo;
  })

  --插入开发者
  if developers then
    for index,content in ipairs(developers) do
      table.insert(data,{
        SettingsLayUtil.ITEM_AVATAR;
        title="@"..content.name;
        summary=content.message;
        icon=content.avatar or getUserAvatarUrl(content.qq,content.imageSize);
        url=content.url,
        qq=content.qq;
        key="developer";
        newPage="newApp";
      })
    end
  end

  --插入开源许可
  if openSourceLicenses then
    table.insert(data,{
      SettingsLayUtil.ITEM_NOSUMMARY;
      title=R.string.jesse205_openSourceLicense;
      icon=R.drawable.ic_github;
      key="openSourceLicenses";
      newPage=true;
    })
  end
  --插入感谢名单
  if thanks then
    table.insert(data,{
      SettingsLayUtil.ITEM;
      title=R.string.jesse205_thanksList;
      summary=R.string.jesse205_ranking_random;
      icon=R.drawable.ic_emoticon_happy_outline;
      key="thanks";
      thanks=thanks;
    })
  end
end



if moreItem or copyright then
  --更多内容
  table.insert(data,{
    SettingsLayUtil.TITLE;
    title=R.string.jesse205_moreContent;
  })
  if moreItem then
    for index=1,#moreItem do
      local content=moreItem[index]
      content.key="more"
      table.insert(data,content)
    end
  end
  if copyright then--版权信息
    table.insert(data,{
      SettingsLayUtil.ITEM;
      title=R.string.jesse205_copyright;
      summary=copyright;
      icon=R.drawable.ic_copyright;
      key="copyright";
    })
  end
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

recyclerView.setAdapter(adapter)
layoutManager=LinearLayoutManager()
recyclerView.setLayoutManager(layoutManager)
activity.registerForContextMenu(recyclerView)
recyclerView.onCreateContextMenu=function(menu,view,menuInfo)
  local data=data[menuInfo.position+1]
  if data and data.contextMenuEnabled then
    local key=data.key
    if data.contextMenuEnabled then--多个QQ群
      menu.setHeaderTitle(data.title)
      local menusList=data.menus
      for index,content in ipairs(menusList) do
        menu.add(0,index,0,content.title)
      end
      menu.setCallback({
        onMenuItemSelected=function(menu,item)
          local id=item.getItemId()
          local menuData=menusList[id]
          callItem(nil,nil,menuData)
        end
      })
    end
  end
end

recyclerView.addOnScrollListener(RecyclerView.OnScrollListener{
  onScrolled=function(view,dx,dy)
    if landscapeState then
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