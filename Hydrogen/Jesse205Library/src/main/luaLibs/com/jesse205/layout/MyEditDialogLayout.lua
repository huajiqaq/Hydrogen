local MyEditDialogLayout={}
local insertTable=require "com.jesse205.layout.insertTable"

MyEditDialogLayout.layout=MyTextInputLayout.Builder{
  layout_margin="8dp";
  layout_width="fill";
  layout_marginLeft="22dp";
  layout_marginRight="22dp";
  id="editLay";
  {
    inputType="text";
    lines=1;
    id="edit";
    focusable=true;
    showSoftInputOnFocus=true;
    selectAllOnFocus=true;
  };
}

--MyEditDialogLayout.insertTable=insertTable

function MyEditDialogLayout.Builder(config)--返回布局表
  local layout=table.clone(MyEditDialogLayout.layout)
  if config then
    insertTable(layout,config)
  end
  return layout
end

function MyEditDialogLayout.load(config,...)--返回视图
  return loadlayout2({
    LinearLayoutCompat;
    layout_width="fill";
    layout_height="fill";
    MyEditDialogLayout.Builder(config);
  },...)
end
return MyEditDialogLayout