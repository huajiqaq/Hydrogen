local MyTextInputLayout={}
import "com.google.android.material.textfield.*"
import "com.Jesse205.layout.insertTable"
local insertTable=insertTable

MyTextInputLayout.layout={
  TextInputLayout;
  {
    TextInputEditText;
    layout_width="fill";
    layout_height="fill";
  };
}

--MyTextInputLayout.insertTable=insertTable

function MyTextInputLayout.Builder(config)
  local layout=table.clone(MyTextInputLayout.layout)
  if config then
    insertTable(layout,config)
  end
  return layout
end

function MyTextInputLayout.load(config,...)
  return loadlayout2(MyTextInputLayout.Builder(config),...)
end
return MyTextInputLayout