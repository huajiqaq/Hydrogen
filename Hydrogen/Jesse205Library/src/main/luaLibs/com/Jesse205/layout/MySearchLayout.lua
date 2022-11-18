local MySearchLayout={}
import "com.Jesse205.layout.insertTable"
local insertTable=insertTable

MySearchLayout.layout={
  CardView;
  layout_width="fill";
  id="topCard";
  elevation=0;
  background=GradientDrawable()
  .setShape(GradientDrawable.RECTANGLE)
  .setColor(theme.color.windowBackground)
  .setCornerRadii({0,0,0,0,math.dp2int(8),math.dp2int(8),math.dp2int(8),math.dp2int(8)});
  {
    LinearLayoutCompat;
    orientation="horizontal";
    layout_width="fill";
    gravity="center";
    MyTextInputLayout.Builder{
      layout_margin="8dp";
      layout_weight=1;
      layout_marginLeft="16dp";
      hint=getString(R.string.abc_search_hint);
      id="searchLay";
      {
        inputType="text";
        lines=1;
        id="searchEdit";
        imeOptions="actionSearch";
      };
    };
    {
      MaterialButton_OutlinedButton;
      layout_margin="8dp";
      layout_marginRight="16dp";
      id="searchButton";
      minimumWidth="48dp";
      minWidth=0;
      text=R.string.search_menu_title;
    };
  };
}

function MySearchLayout.Builder(config)--返回布局表
  --ids=ids or {}
  local layout=table.clone(MySearchLayout.layout)
  if config then
    insertTable(layout,config)
  end
  --local mainLayout=loadlayout2(layout,ids)
  return layout
end

function MySearchLayout.load(config,...)--返回视图
  return loadlayout2(MySearchLayout.Builder(config),...)
end
return MySearchLayout