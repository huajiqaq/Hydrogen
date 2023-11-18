local MyTipLayout={}
local insertTable=require "com.jesse205.layout.insertTable"

MyTipLayout.layout={
  CardView;
  layout_width="fill";
  cardBackgroundColor=theme.color.rippleColorAccent;
  {
    LinearLayoutCompat;
    layout_width="fill";
    layout_height="fill";
    gravity="left|center";
    layout_margin="8dp";
    {
      AppCompatImageView;
      layout_width="24dp";
      layout_height="24dp";
      layout_marginLeft="8dp";
      layout_marginRight="16dp";
      colorFilter=theme.color.colorAccent;
    };
    {
      AppCompatTextView;
      layout_marginRight="8dp";
      textColor=theme.color.colorAccent;
    };
  };
}

function MyTipLayout.Builder(config)--返回布局表
  local layout=table.clone(MyTipLayout.layout)
  if config then
    insertTable(layout,config)
  end
  return layout
end

function MyTipLayout.load(config,...)--返回视图
  return loadlayout2(MyTextInputLayout.Builder(config),...)
end
return MyTipLayout