require "import"
import "android.widget.*"
import "android.view.*"
import "android.graphics.PorterDuffColorFilter"
import "android.graphics.PorterDuff"
import "mods.muk"
import "android.widget.NumberPicker$OnValueChangeListener"
import "mods.muk"
import "com.lua.custrecycleradapter.*"
import "com.google.android.flexbox.*"
import "androidx.recyclerview.widget.*"

设置视图("layout/homesort")
edgeToedge(topbar)

波纹({fh},"圆主题")
波纹({moren},"方自适应")


local item={
  LinearLayout;
  Orientation="vertical";
  id="root";
  {
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
      id="cardv";
      layout_height="-1";
      {
        TextView;
        layout_width="0";
        layout_height="0";
        id="text";
      };
      {
        CardView;
        CardBackgroundColor=转0x(primaryc)-0xdf000000,
        elevation="0";
        id="cardt";
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
            id="title";
            textSize="13sp",
            textColor=primaryc,
            gravity="center";
          };
        };
      };
    }
  }
};

local item2={
  LinearLayout;
  layout_width="fill";
  layout_height="wrap";
  id="root";
  {
    TextView,
    id="myt",
    textColor=primaryc;
  };
};

data={}


--设置线性列表布局
recycler_view.LayoutManager=ExetendFlexboxLayoutManager(this);

import "android.widget.LinearLayout$LayoutParams"

lay={}

local adapter=LuaCustRecyclerAdapter(AdapterCreator({

  getItemCount=function()
    return #data
  end,

  getItemViewType=function(pos)
    local newdata=data[pos+1]
    if newdata.myt then return 1 end
    return 0
  end,
  onCreateViewHolder=function(parent,type)
    local views={}
    if type==0 then
      holder=LuaCustRecyclerHolder(loadlayout(item,views))
     else
      holder=LuaCustRecyclerHolder(loadlayout(item2,views))
    end
    holder.view.setTag(views)
    return holder
  end,
  areContentsTheSame=function(old,new)
    return old.title==new.title
  end,
  areItemsTheSame=function(old,new)
    return old.title==new.title
  end,
  onBindViewHolder=function(holder,position)
    local newdata=data[position+1]
    local tag=holder.itemView.tag
    if not(newdata.myt) then
      tag.title.text=newdata.title
      tag.text.text=newdata.text
      tag.cardv.onClick=function(v)
        local 其他位置=recycler_view.getChildLayoutPosition(lay["其他"])
        local 自身位置=recycler_view.getChildLayoutPosition(tag.root)
        recycler_view.adapter.notifyItemMoved(自身位置, 其他位置)
        table.swap(data, 自身位置, 其他位置, true)
      end
     else

      lay[newdata.myt]=tag.root
      tag.myt.text=newdata.myt
      local hhh=LinearLayout.LayoutParams(LayoutParams.MATCH_PARENT,LayoutParams.WRAP_CONTENT);
      tag.root.setLayoutParams(hhh)
    end
  end
}))

recycler_view.adapter=adapter

luajava.new(luajava.bindClass("androidx.recyclerview.widget.ItemTouchHelper"), luajava.override(luajava.bindClass("androidx.recyclerview.widget.ItemTouchHelper").Callback,{
  getMovementFlags=function(b,c,d)
    local itemclass = luajava.bindClass "androidx.recyclerview.widget.ItemTouchHelper$Callback"
    dragFlags = ItemTouchHelper.UP
    swipeFlags = ItemTouchHelper.LEFT
    return int(itemclass.makeMovementFlags(ItemTouchHelper.RIGHT | ItemTouchHelper.LEFT | ItemTouchHelper.DOWN | ItemTouchHelper.UP, 0));

  end,
  isLongPressDragEnabled=function(a)
    return true
  end,
  isItemViewSwipeEnabled=function()
    return false
  end,

  canDropOver=function(a,recyclerView, current, target)
    local fromPosition, toPosition = current.getAdapterPosition(), target.getAdapterPosition();
    if toPosition==0 or fromPosition==0 or toPosition==1 or fromPosition==1 then
      return false
    end
    return true
  end,
  onMove=function(a,recyclerView, viewHolder, target)
    fromPosition, toPosition = viewHolder.getAdapterPosition(), target.getAdapterPosition();
    if toPosition==0 then
      return false
     else
      table.swap(data, fromPosition, toPosition, true)
      adapter.notifyItemMoved(fromPosition, toPosition)
      return true;
    end
  end,
  onSelectedChanged=function( viewHolder, actionState)
  end
})).attachToRecyclerView(recycler_view);


local function 页面设置()
  local 其他位置=recycler_view.getChildLayoutPosition(lay["其他"])
  --lua中table下标从1开始 java中下标从0开始 java写法为从2开始循环到其他前一个数据 在lua中化简就是这样写
  local id数据表={}
  for i=3,其他位置 do
    local id数据='"'..data[i].text..'"'
    table.insert(id数据表,id数据)
  end
  local 最终处理数据=luajson.encode({["section_ids"]=id数据表})
  --转为json中会生成\"转义 替换掉
  local 最终处理数据=最终处理数据:gsub([[\"]],"")
  zHttp.post("https://api.zhihu.com/feed-root/sections/submit/v2",最终处理数据,posthead,function(code,content)
    if code==200 then
      activity.setResult(1300,nil)
      提示("修改成功 返回主页生效")
    end
  end)
end

function resolve_data(v)
  local add={}
  add.title=v.section_name
  add.text=tostring(v.section_id)
  return add
end

function 开始加载推荐()
  zHttp.get("https://api.zhihu.com/feed-root/sections/query/v2",head,function(code,content)
    if code==200 then
      local json=luajson.decode(content)

      table.insert(data,{myt="提示：你可点击标签来添加/删除 可长按拖动排序 可拖动其他来快速添加".."\n"})
      table.insert(data,{myt="我的"})
      for _,v ipairs(json.selected_sections)
        table.insert(data,resolve_data(v))
      end

      table.insert(data,{myt="其他"})
      for _,v ipairs(json.guess_like_sections)
        table.insert(data,resolve_data(v))
      end
      for _,v ipairs(json.more_sections)
        table.insert(data,resolve_data(v))
      end

      xiugai.onClick=function()
        页面设置()
      end

      adapter.notifyDataSetChanged()
    end
  end)
end
开始加载推荐()

function 修改地点()
  zHttp.get("https://api.zhihu.com/feed-root/sections/cityList",head,function(code,content)
    if code==200 then
      local show_content=""
      local infos=luajson.decode(content).result_info
      for k,v pairs(infos)
        local city_info_list=v.city_info_list
        local city_key=v.city_key
        for key,value pairs(city_info_list)
          if key==1 then
            if k>1 then
              show_content=show_content..'\n'..city_key..'\n'
             else
              show_content=show_content..city_key..'\n'
            end
            show_content=show_content..value.city_name
           else
            show_content=show_content.." "..value.city_name
          end
        end
      end

      local dialog=AlertDialog.Builder(this)
      .setTitle("修改城市")
      .setView(loadlayout({
        LinearLayout;
        orientation="vertical";
        Focusable=true,
        FocusableInTouchMode=true,
        {
          EditText;
          hint="输入";
          layout_marginTop="5dp";
          layout_marginLeft="10dp",
          layout_marginRight="10dp",
          layout_width="match_parent";
          layout_gravity="center",
          Typeface=字体("product");
          id="edit";
        };
        {
          ScrollView;
          layout_height="fill";
          fillViewport="true";
          {
            LinearLayout;
            orientation="vertical";
            {
              TextView;
              id="Prompt",
              textSize="15sp",
              layout_marginTop="10dp";
              layout_marginLeft="10dp",
              layout_marginRight="10dp",
              layout_width="match_parent";
              layout_height="match_parent";
              TextIsSelectable=true,
              Typeface=字体("product");
              text=show_content;
            };
          };
        };
      }))
      .setPositiveButton("确定",nil)
      .setNegativeButton("取消",nil)
      .show()

      dialog.getButton(dialog.BUTTON_POSITIVE).onClick=function()
        local checkstr=string.gsub(edit.Text, "%s", "")
        if show_content:find(checkstr) and checkstr~="" then
          zHttp.post("https://api.zhihu.com/feed-root/sections/saveUserCity",'{"city":"'..checkstr..'"}',posthead,function(code,content)
            if code==200 then
              activity.setResult(100,nil)
              提示("修改成功 你可能需要刷新页面才能看到更改")
             else
              提示("失败 请检查输入内容或联系作者修复")
            end
          end)
         else
          提示("你输入了一个不支持的城市")
        end
      end

    end
  end)
end

xgdd.onClick=function()
  修改地点()
end

qzkg.onClick=function(view)
  if view.text=="开启全站" then
    this.setSharedData("关闭全站","false")
    view.Text="关闭全站"
   else
    this.setSharedData("关闭全站","true")
    view.Text="开启全站"
  end
  提示("重启软件生效")
end