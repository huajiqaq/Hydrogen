local MySearchBar={}
local insertTable=require "com.jesse205.layout.insertTable"

MySearchBar.layout={
  CardView;
  layout_width="fill";
  layout_height="48dp";
  layout_marginTop="8dp";
  layout_marginBottom="8dp";
  layout_margin="16dp";
  elevation="3dp";
  id="searchBar";
  cardBackgroundColor=res.color.attr.colorBackgroundFloating;
  {
    FrameLayout;
    layout_width="fill";
    layout_height="fill";
    {
      AppCompatEditText;
      layout_width="fill";
      layout_height="fill";
      id="searchEdit";
      hint=activity.getString(R.string.abc_search_hint);
      padding=0;
      backgroundColor=0;
      lines=1;
      inputType="text";
      textSize="18sp";
      imeOptions="actionSearch";
      paddingLeft="56dp";
      paddingRight="48dp";
      hintTextColor=theme.color.textColorSecondary;
    };
    {
      ImageView;
      layout_width="48dp";
      layout_height="48dp";
      padding="12dp";
      layout_gravity="center|left";
      layout_margin="4dp";
      imageResource=R.drawable.ic_magnify;
      colorFilter=theme.color.colorAccent;
      id="searchButton";
    };
    {
      ImageView;
      layout_width="48dp";
      layout_height="48dp";
      padding="12dp";
      imageResource=R.drawable.ic_close_circle_outline;
      id="clearSearchBtn";
      layout_gravity="center|right";
      colorFilter=theme.color.textColorPrimary;
      tooltip=getString(R.string.jesse205_clear);
    };
  };
}

function MySearchBar.Builder(config)--返回布局表
  --ids=ids or {}
  local layout=table.clone(MySearchBar.layout)
  if config then
    insertTable(layout,config)
  end
  return layout
end

function MySearchBar.load(config,...)--返回视图
  return loadlayout2(MySearchBar.Builder(config),...)
end
return MySearchBar