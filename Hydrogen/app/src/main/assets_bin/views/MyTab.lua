--简单的MyTab view
--author dingyi
--time 2020-6-14
--self:对象本身
local tab={}--父类


tab.layout={--根布局
  HorizontalScrollView;
  horizontalScrollBarEnabled=false;
  background=backroundc,
  {
    FrameLayout;
    layout_width="-1";
    layout_height="wrap";
    background=backroundc,
    id="load",
    {
      LinearLayout;
      layout_height="-1";
      layout_width="-1";
      background=backroundc,
      id="add",
    };

  };
}

function tab:addTab(text,onClick,type)--新建tab text:显示文字 onClick 点击事件 type 类型
  local index=#(self.indexTab)+1

  self.ids.type=type --记录类型


  if self.ids.type==2 then
    local layout2= {
      LinearLayout;
      layout_width="-2";
      layout_height="-2";
      onClick=function(v)
        onClick(v)
      end,
      {
        LinearLayout;
        layout_width="-1";
        orientation="vertical";
        padding="9dp";
        layout_height="-1";
        {
          CardView;
          CardBackgroundColor=转0x(primaryc)-0xdf000000,
          elevation="0";
          radius="4%w";
          {
            LinearLayout;
            layout_width="-2";
            layout_height="-2";
            padding="6dp",
            paddingLeft="10dp",
            paddingRight="10dp",
            orientation="vertical";
            {
              TextView;
              layout_width="-1";
              layout_height="-1";
              textSize="13sp",
              Typeface=字体("product");
              textColor=primaryc,
              gravity="center";
              text=text;
            };
          };
        };
      }
    }
    self.ids.add.addView(loadlayout(layout2,self.ids))
    波纹({self.ids.add.getChildAt(self.ids.add.getChildCount()-1).getChildAt(0).getChildAt(0).getChildAt(0)},"圆主题")
  end
  if self.ids.type==3 then
    local layout2= {
      LinearLayout;
      layout_width="-2";
      layout_height="-2";
      onClick=function(v)
        self:showTab(index)
        onClick(v)
      end,
      {
        LinearLayout;
        layout_width="-1";
        orientation="vertical";
        padding="9dp";
        layout_height="-1";
        {
          CardView;
          elevation="0";
          radius="4%w";
          {
            LinearLayout;
            layout_width="-2";
            layout_height="-2";
            padding="6dp",
            paddingLeft="10dp",
            paddingRight="10dp",
            orientation="vertical";
            {
              TextView;
              layout_width="-1";
              layout_height="-1";
              textSize="13sp",
              Typeface=字体("product");
              gravity="center";
              text=text;
            };
          };
        };
      }
    }
    self.ids.add.addView(loadlayout(layout2,self.ids))
    self.ids.showindex=#self.indexTab+1--更新指示table位置
    self.indexTab[#self.indexTab+1]=#self.indexTab+1--更新 ？(cao 我忘了)
    波纹({self.ids.add.getChildAt(self.ids.add.getChildCount()-1).getChildAt(0).getChildAt(0).getChildAt(0)},"圆主题")
  end
  return self
end

function tab:showTab(index)--显示table参数 仅当type==1生效
  if self.ids.type==3 then
    pcall(function()
      for i=0, self.ids.add.getChildCount()-1 do--遍历全部控件
        local view= self.ids.add.getChildAt(i)--取得控件
        local cardv=view.getChildAt(0).getChildAt(0)
        local textv=view.getChildAt(0).getChildAt(0).getChildAt(0).getChildAt(0)
        if i+1==index then
          cardv.CardBackgroundColor=转0x(primaryc)-0xdf000000
         else
          cardv.CardBackgroundColor=转0x(cardbackc)
        end
      end
    end)
    return self
  end
  return self
end

function tab:getItem(index)
  return self.ids.add.getChildAt(index-1)--获取Item
end

function tab:getShowItem(index)
  return self:getItem(index~=nil and index or self.ids.showindex )--明显
end

function tab:getCount()--总数
  return #self.indexTab
end

function tab:removeTab(index)--删除tab
  self.ids.add.removeView(self:getItem(index))
  if self.ids.showindex==index then
    self:showTab(1)
  end
  return self
end

function MyTab(mtab)
  local parent={--构建子类
    addTab=tab.addTab,
    showTab=tab.showTab,
    getItem=tab.getItem,
    getCount=tab.getCount,
    removeTab=tab.removeTag,
    getShowItem=tab.getShowItem,
    ids={},
    indexTab={},
    type=mtab.type or 1,
  }

  return function()
    local view=loadlayout(tab.layout,parent.ids)--加载布局
    _G[mtab.id]=parent --设置id
    return view
  end
end

return MyTab