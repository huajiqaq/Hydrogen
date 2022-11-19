local SettingsLayUtil={}
import "com.bumptech.glide.load.resource.drawable.DrawableTransitionOptions"

SettingsLayUtil.TITLE=1
SettingsLayUtil.ITEM=2
SettingsLayUtil.ITEM_NOSUMMARY=3
SettingsLayUtil.ITEM_SWITCH=4
SettingsLayUtil.ITEM_SWITCH_NOSUMMARY=5
SettingsLayUtil.ITEM_AVATAR=6
SettingsLayUtil.ITEM_ONLYSUMMARY=7

local colorAccent=theme.color.colorAccent
local textColorPrimary=theme.color.textColorPrimary
local textColorSecondary=theme.color.textColorSecondary


local leftIconLay={
  AppCompatImageView,
  id="icon",
  layout_margin="16dp",
  layout_marginRight="32dp",
  layout_width="24dp",
  layout_height="24dp",
  colorFilter=colorAccent,
}

local leftCoverLay={
  MaterialCardView;
  layout_height="40dp";
  layout_width="40dp";
  layout_margin="16dp";
  radius="20dp";
  {
    CardView;
    layout_height="fill";
    layout_width="fill";
    radius="18dp";
    {
      AppCompatImageView;
      layout_height="fill";
      layout_width="fill";
      id="icon";
    };
  };
}

local leftCoverIconLay={
  MaterialCardView;
  layout_height="40dp";
  layout_width="40dp";
  layout_margin="16dp";
  radius="20dp";
  {
    CardView;
    layout_height="fill";
    layout_width="fill";
    radius="18dp";
    {
      AppCompatImageView;
      layout_height="24dp";
      layout_width="24dp";
      layout_gravity="center";
      id="icon";
    };
  };
}

local oneLineLay={
  AppCompatTextView;
  id="title";
  textSize="16sp";
  textColor=textColorPrimary;
  layout_weight=1;
  layout_marginTop="16dp";
  layout_marginBottom="16dp";
}

local twoLineLay={
  LinearLayoutCompat;
  orientation="vertical";
  gravity="center";
  layout_weight=1;
  layout_marginTop="16dp";
  layout_marginBottom="16dp";
  {
    AppCompatTextView;
    id="title";
    textSize="16sp";
    layout_width="fill";
    textColor=textColorPrimary;
  };
  {
    AppCompatTextView;
    textSize="14sp";
    id="summary";
    layout_width="fill";
  };
}

local rightSwitchLay={
  SwitchCompat;
  id="switchView";
  layout_marginRight="16dp";
}

local rightNewPageIconLay={
  AppCompatImageView;
  id="rightIcon";
  layout_margin="16dp";
  --layout_marginLeft=0;
  layout_width="24dp";
  layout_height="24dp";
  colorFilter=textColorSecondary;
}

SettingsLayUtil.leftIconLay=leftIconLay
SettingsLayUtil.leftCoverLay=leftCoverLay
SettingsLayUtil.leftCoverIconLay=leftCoverIconLay
SettingsLayUtil.oneLineLay=oneLineLay
SettingsLayUtil.twoLineLay=twoLineLay
SettingsLayUtil.rightSwitchLay=rightSwitchLay
SettingsLayUtil.rightNewPageIconLay=rightNewPageIconLay


local itemsLay={
  {--标题
    LinearLayoutCompat;
    layout_width="fill";
    focusable=false;
    {
      AppCompatTextView;
      id="title";
      textSize="14sp";
      textColor=colorAccent;
      layout_margin="16dp";
      layout_marginBottom=0;
    };
  };

  {--设置项(图片,标题,简介)
    LinearLayoutCompat;
    layout_width="fill";
    gravity="center";
    focusable=true;
    leftIconLay;
    twoLineLay;
    rightNewPageIconLay;
  };

  {--设置项(图片,标题)
    LinearLayoutCompat;
    layout_width="fill";
    gravity="center";
    focusable=true;
    leftIconLay;
    oneLineLay;
    rightNewPageIconLay;
  };


  {--设置项(图片,标题,简介,开关)
    LinearLayoutCompat;
    gravity="center";
    layout_width="fill";
    focusable=true;
    leftIconLay;
    twoLineLay;
    rightSwitchLay;
  };


  {--设置项(图片,标题,开关)
    LinearLayoutCompat;
    gravity="center";
    layout_width="fill";
    focusable=true;
    leftIconLay;
    oneLineLay;
    rightSwitchLay;
  };

  {--设置项(头像,标题,简介)
    LinearLayoutCompat;
    layout_width="fill";
    gravity="center";
    focusable=true;
    leftCoverLay;
    twoLineLay;
    rightNewPageIconLay;
  };

  {--设置项(简介)
    LinearLayoutCompat;
    gravity="center";
    layout_width="fill";
    focusable=false;
    {
      AppCompatTextView;
      layout_weight=1;
      layout_marginLeft="72dp",
      layout_margin="16dp";
      layout_width="fill";
      textSize="14sp";
      id="summary";
    };
  };

}
SettingsLayUtil.itemsLay=itemsLay
SettingsLayUtil.itemsNumber=#itemsLay

local function setAlpha(views,alpha)
  for index,content in pairs(views) do
    if content then
      content.setAlpha(alpha)
    end
  end
end
SettingsLayUtil.setAlpha=setAlpha

local function applySwitchData()
end
local function onItemViewClick(view)
  local ids=view.tag
  local viewConfig=ids._config
  local data=ids._data
  local key=data.key
  local onItemClick=viewConfig.onItemClick
  viewConfig.allowedChange=false

  local switchView=ids.switchView
  if switchView and viewConfig.switchEnabled then
    local checked=not(switchView.checked)
    switchView.setChecked(checked)
    if data.checked~=nil then
      data.checked=checked
     elseif data.key then
      setSharedData(data.key,checked)
    end
  end

  if onItemClick then
    onItemClick(view,ids,key,data)
  end
  viewConfig.allowedChange=true
  return true
end
local function onItemViewLongClick(view)
  local ids=view.tag
  local viewConfig=ids._config
  local data=ids._data
  local key=data.key
  local onItemLongClick=viewConfig.onItemLongClick
  if onItemLongClick then
    return onItemLongClick(view,ids,key,data)
  end
end
local function onSwitchCheckedChanged(view,checked)
  local viewConfig=view.tag
  local allowedChange=viewConfig.allowedChange
  if allowedChange then
    local key=viewConfig.key
    local data=viewConfig.data
    local onItemClick=viewConfig.onItemClick
    if data.checked~=nil then
      data.checked=checked
     elseif data.key then
      setSharedData(data.key,checked)
    end
    if onItemClick then
      onItemClick(viewConfig.itemView,viewConfig.ids,key,data)
    end
  end
end

local adapterEvents={
  getItemCount=function(data)
    return #data
  end,
  getItemViewType=function(data,position)
    return data[position+1][1]
  end,
  onCreateViewHolder=function(onItemClick,onItemLongClick,parent,viewType)
    local ids={}
    local view=loadlayout2(itemsLay[viewType],ids)
    local holder=LuaCustRecyclerHolder(view)
    view.setTag(ids)
    local viewConfig={enabled=true,
      switchEnabled=true,
      onItemClick=onItemClick,
      onItemLongClick=onItemLongClick,
      itemView=view,
      ids=ids}
    ids._config=viewConfig

    if viewType==1 then
      ids.title.getPaint().setFakeBoldText(true)
     else
      local switchView=ids.switchView
      view.setFocusable(true)
      view.setBackground(ThemeUtil.getRippleDrawable(theme.color.rippleColorPrimary,true))
      view.onClick=onItemViewClick
      view.onLongClick=onItemViewLongClick
      if switchView then
        switchView.tag=viewConfig
        switchView.setOnCheckedChangeListener({
          onCheckedChanged=onSwitchCheckedChanged})
      end
    end
    return holder
  end,

  onBindViewHolder=function(data,holder,position)
    local data=data[position+1]
    local layoutView=holder.view
    local tag=layoutView.getTag()
    local viewConfig=tag._config
    tag._data=data
    local title=data.title
    local icon=data.icon
    local summary=data.summary
    local enabled=data.enabled
    local switchEnabled=data.switchEnabled
    local key=data.key
    viewConfig.key=key
    viewConfig.data=data
    viewConfig.allowedChange=false

    --Views
    local titleView=tag.title
    local summaryView=tag.summary
    local switchView=tag.switchView
    local rightIconView=tag.rightIcon
    local iconView=tag.icon

    if title and titleView then
      titleView.text=title
    end
    if summary and summaryView then
      summaryView.text=summary
    end
    if icon and iconView then
      if type(icon)=="number" then
        iconView.setImageResource(icon)
       else
        Glide.with(activity)
        .load(icon)
        .transition(DrawableTransitionOptions.withCrossFade())
        .into(iconView)
      end
    end

    --设置启用状态透明
    local enabledNotFalse=not(enabled==false)
    local switchEnabledNotFalse=not(switchEnabled==false)
    if viewConfig.enabled~=enabledNotFalse then
      viewConfig.enabled=enabledNotFalse
      layoutView.setEnabled(enabledNotFalse)
      local viewsList={titleView,summaryView,iconView,rightIconView}
      if enabledNotFalse then
        setAlpha(viewsList,1)
       else
        setAlpha(viewsList,0.5)
      end
    end
    if viewConfig.switchEnabled~=switchEnabledNotFalse then
      viewConfig.switchEnabled=switchEnabledNotFalse
      if switchView then
        switchView.setEnabled(switchEnabledNotFalse)
      end
    end



    if switchView then
      if data.checked~=nil then
        switchView.setChecked(data.checked)
       elseif data.key then
        switchView.setChecked(getSharedData(key) or false)
       else
        switchView.setChecked(false)
      end
    end
    if rightIconView then
      local newPage=data.newPage
      local visibility=rightIconView.getVisibility()
      if newPage then
        if newPage=="newApp" then
          rightIconView.setImageResource(R.drawable.ic_launch)
         else
          rightIconView.setImageResource(R.drawable.ic_chevron_right)
        end
        if visibility~=View.VISIBLE then
          rightIconView.setVisibility(View.VISIBLE)
        end
       else
        if visibility~=View.GONE then
          rightIconView.setVisibility(View.GONE)
        end
      end
    end
    viewConfig.allowedChange=true
  end,
}
SettingsLayUtil.adapterEvents=adapterEvents

function SettingsLayUtil.newAdapter(data,onItemClick,onItemLongClick)
  return LuaCustRecyclerAdapter(AdapterCreator({
    getItemCount=function()
      return adapterEvents.getItemCount(data)
    end,
    getItemViewType=function(position)
      return adapterEvents.getItemViewType(data,position)
    end,
    onCreateViewHolder=function(parent,viewType)
      return adapterEvents.onCreateViewHolder(onItemClick,onItemLongClick,parent,viewType)
    end,
    onBindViewHolder=function(holder,position)
      adapterEvents.onBindViewHolder(data,holder,position)
    end,
  }))
end

return SettingsLayUtil