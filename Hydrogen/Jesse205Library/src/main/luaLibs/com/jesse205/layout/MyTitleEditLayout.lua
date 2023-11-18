local MyTitleEditLayout={}
local insertTable=require "com.jesse205.layout.insertTable"

MyTitleEditLayout.layout={
  LinearLayout;
  layout_width="fill";
  layout_height="fill";
  {
    AppCompatEditText;
    layout_width="fill";
    layout_height="fill";
    layout_weight=1;
    padding=0;
    id="searchEdit";
    imeOptions="actionSearch";
    backgroundColor=0;
    lines=1;
    inputType="text";
    textSize="18sp";
    textColor=theme.color.ActionBar.colorControlNormal;
    hintTextColor=theme.color.ActionBar.textColorSecondary;
    gravity="center|left";
  };
  {
    ImageView;
    layout_width="48dp";
    layout_height="48dp";
    padding="12dp";
    imageResource=R.drawable.ic_close_circle_outline;
    id="clearSearchBtn";
    layout_gravity="center|right";
    colorFilter=theme.color.ActionBar.colorControlNormal;
    tooltip=getString(R.string.jesse205_clear);
  };
}

function MyTitleEditLayout.Builder(config)--返回布局表
  local layout=table.clone(MyTitleEditLayout.layout)
  if config then
    insertTable(layout,config)
  end
  return layout
end

function MyTitleEditLayout.load(config,...)--返回视图
  return loadlayout2(MyTitleEditLayout.Builder(config),...)
end
return MyTitleEditLayout