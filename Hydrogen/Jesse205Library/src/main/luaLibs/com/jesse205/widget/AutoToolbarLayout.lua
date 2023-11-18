local AutoToolbarLayout={
  _baseClass=AppBarLayout,
  __call=function(self,context)
    return LayoutInflater.from(context).inflate(R.layout.layout_jesse205_autotoolbarlayout,nil)
  end,
}
setmetatable(AutoToolbarLayout,AutoToolbarLayout)

return AutoToolbarLayout