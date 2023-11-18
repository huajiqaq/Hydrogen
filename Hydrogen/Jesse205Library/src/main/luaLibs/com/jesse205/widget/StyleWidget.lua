local widgets={
  MaterialButton={"TextButton","OutlinedButton","TextButton_Normal","TextButton_Icon"},
}

local types={}
for mainWidget,content in pairs(widgets) do
  for index,content in ipairs(content) do
    local widgetName=mainWidget.."_"..content
    table.insert(types,widgetName)
    local myWidget={
      _baseClass=_G[mainWidget],
      __call=function(self,context)
        return LayoutInflater.from(context).inflate(R.layout["layout_jesse205_"..string.lower(widgetName)],nil)
      end,
    }
    setmetatable(myWidget,myWidget)
    _G[widgetName]=myWidget
  end
end

return {types=types,widgets=widgets}