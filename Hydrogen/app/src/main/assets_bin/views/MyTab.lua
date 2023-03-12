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
    RelativeLayout;
    layout_width="-1";
    layout_height="48dp";
    background=backroundc,
    id="load",
    {
      LinearLayout;
      layout_height="-1";
      layout_width="-1";
      background=backroundc,
      id="add",
    };
    {
      LinearLayout;
      layout_height="8dp";
      layout_width=activity.getWidth()/5;
      id="page_scroll";
      Visibility=8,
      layout_alignParentBottom="true";
      gravity="center";
      --background=textc;
      {
        CardView;
        background=primaryc,
        id="card",
        elevation="0";
        radius="4dp";
        layout_height="8dp";
        layout_marginTop="4dp";
        layout_width="32dp";
      };
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
      --     background=backroundc,
      onClick=function(v)
        onClick(v)
      end,
      {
        LinearLayout;
        layout_width="-1";
        orientation="vertical";
        padding="9dp";
        layout_height="-1";
        --       background=backroundc,
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
            --         background=backroundc,
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
      --     background=backroundc,
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
        --       background=backroundc,
        {
          CardView;
          elevation="0";
          radius="4%w";
          {
            LinearLayout;
            layout_width="-2";
            layout_height="-2";
            padding="6dp",
            --         background=backroundc,
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
  if self.ids.type==nil then--如果type是1
    local layout=

    {
      LinearLayout;
      layout_height="-1";
      layout_width="20%w";
      gravity="center";
      onClick=function(v)

        self:showTab(index)
        onClick(v)
      end,
      {

        TextView;
        layout_width="-2";
        layout_height="-2";
        Text=text;
        Typeface=字体("product-Bold");
        textSize="16sp";
        --        textColor=stextc;
        textColor=textc;
      };
    };
    self.ids.add.addView(loadlayout(layout,self.ids))
    self.ids.page_scroll.visibility=0 --显示指示块
    self.ids.showindex=#self.indexTab+1--更新指示table位置
    self.indexTab[#self.indexTab+1]=#self.indexTab+1--更新 ？(cao 我忘了)

  end
  return self
end

--[[
function tab:addTab(text,onClick,type)--新建tab text:显示文字 onClick 点击事件 type 类型
  local index=#(self.indexTab)+1
  local layout=

  {
    LinearLayout;
    layout_height="-1";
    layout_width="20%w";
    gravity="center";
    onClick=function(v)

      self:showTab(index)
      onClick(v)
    end,
    {

      TextView;
      layout_width="-2";
      layout_height="-2";
      Text=text;
      Typeface=字体("product-Bold");
      textSize="16sp";
      textColor=stextc;
    };
  };

  local layout2= {
    LinearLayout;
    layout_width="-2";
    layout_height="-2";
    background=backroundc,
    onClick=function(v)
      onClick(v)
    end,
    {
      LinearLayout;
      layout_width="-1";
      orientation="vertical";
      padding="9dp";
      layout_height="-1";
      background=backroundc,
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
          background=backroundc,
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
  self.ids.type=type --记录类型

  self.ids.add.addView(loadlayout(type==2 and layout2 or layout,self.ids))--三目运算加载layout (比if好多了)

  if self.ids.type==2 then 波纹({self.ids.add.getChildAt(self.ids.add.getChildCount()-1).getChildAt(0).getChildAt(0).getChildAt(0)},"圆主题") end

  if self.ids.type==nil then--如果type是1
    self.ids.page_scroll.visibility=0 --显示指示块
    self.ids.showindex=#self.indexTab+1--更新指示table位置
    self.indexTab[#self.indexTab+1]=#self.indexTab+1--更新 ？(cao 我忘了)

  end
  return self
end
]]

function tab:showTab(index)--显示table参数 仅当type==1生效
  if self.ids.type==2 then
    return
  end
  if self.ids.type==3 then

    pcall(function()
      for i=0, self.ids.add.getChildCount()-1 do--遍历全部控件
        local view= self.ids.add.getChildAt(i)--取得控件
        local cardv=view.getChildAt(0).getChildAt(0)
        local textv=view.getChildAt(0).getChildAt(0).getChildAt(0).getChildAt(0)
        if i+1==index then--是否位指示table
          cardv.CardBackgroundColor=转0x(primaryc)-0xdf000000
          textv.textColor=转0x(primaryc)
          --指示器动画 和显示 索引更新
         else

          cardv.CardBackgroundColor=转0x(cardbackc)
          textv.textColor=Color.GRAY
        end
      end
    end)
    return self
  end
  --TODO 后期可以改良
  pcall(function()
    for i=0, self.ids.add.getChildCount()-1 do--遍历全部控件
      local view= self.ids.add.getChildAt(i)--取得控件
      if i+1==index then--是否位指示table
        view.getChildAt(0).setTextColor(转0x(primaryc))--文本高亮
        local newx=view.getX()
        --     self.ids.page_scroll.x=newx
        ObjectAnimator.ofFloat((self or n).ids.page_scroll,"x",{(self or n).ids.page_scroll.x,newx}).setDuration(200).start()
        ObjectAnimator.ofFloat((self or n).ids.card,"y",{0+dp2px(4),0+dp2px(8),0+dp2px(4)}).setDuration(400).start()
        self.ids.showindex=index
        --指示器动画 和显示 索引更新
       else
        view.getChildAt(0).setTextColor(转0x(stextc))--取消高亮
      end
    end
  end)
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

  local view=loadlayout(tab.layout,parent.ids)--加载布局
  if mtab.type==2 then
    parent.ids.load.removeView(parent.ids.page_scroll)
    parent.ids.page_scroll.Visibility=8
    --移除指示器
   else
    parent.ids.card.setBackgroundColor(转0x(primaryc)) --指示器颜色
  end
  _G[mtab.id]=parent --设置id
  return function() return view end --返回table
end

return MyTab