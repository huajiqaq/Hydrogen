return function(title,icon,name,date)
  return {
    title=title;
    icon=icon;
    layout={
      LinearLayoutCompat;
      layout_width="fill";
      layout_height="fill";
      orientation="vertical";
      --buildTitlebar(icon,title);
      {
        ScrollView;
        layout_height="fill";
        layout_width="fill";
        layout_weight=1;
        id="scrollView";
        
        {
          LinearLayoutCompat;
          layout_height="fill";
          layout_width="fill";
          orientation="vertical";
          {
            AppCompatTextView;
            padding="16dp";
            id="textView";
            layout_height="fill";
            layout_width="fill";
            textIsSelectable=true;
            textColor=theme.color.textColorPrimary;
            --movementMethod=LinkMovementMethod.getInstance();
          };
        };
      };
      {
        AppCompatCheckBox;
        text=formatResStr(R.string.Jesse205_agreement_checkBox,{string.lower(activity.getString(title))});
        id="checkBox";
        layout_width="fill";
        layout_height="48dp";
        layout_marginRight="16dp";
        layout_marginLeft="16dp";
      };
    },
    onInitLayout=function(self)
      self.textView.setText(Html.fromHtml(io.open(activity.getLuaPath(("../../agreements/%s.html"):format(name)),"r"):read("*a")))
      local contrast="LastActionBarElevation_"..name
      _G[contrast]=0
      self.elevationKey=contrast
      self.scrollView.onScrollChange=function(view,l,t,oldl,oldt)
        MyAnimationUtil.ScrollView.onScrollChange(view,l,t,oldl,oldt,nil,contrast)
      end
      local agree=toboolean(getSharedData(name)==date)
      self.allowNext=agree
      self.checkBox.setChecked(agree)
      self.checkBox.setOnCheckedChangeListener({onCheckedChanged=function()
          self:refresh()
      end})
    end,
    refresh=function(self)
      local checkBox=self.checkBox
      local checked=checkBox.checked
      self.allowNext=checked
      if checked then
        nextButton.setEnabled(true)
        setSharedData(name,date)
       else
        nextButton.setEnabled(false)
        setSharedData(name,nil)
      end
    end,
  }
end