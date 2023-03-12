require "import"
import "android.widget.*"
import "android.view.*"
import "android.graphics.PorterDuffColorFilter"
import "android.graphics.PorterDuff"
import "mods.muk"
import "mods.loadlayout"
import "com.michael.NoScrollListView"
import "android.widget.NumberPicker$OnValueChangeListener"
import "mods.muk"
import "com.lua.custrecycleradapter.*"
import "com.google.android.flexbox.*"
import "androidx.recyclerview.widget.*"

设置视图("layout/xgtj")

波纹({fh},"圆主题")
波纹({moren,xiugai},"方自适应")

--dl=ProgressDialog.show(activity,nil,'加载中 请耐心等待')
--dl.show()

local list_item={
  LinearLayout;
  Orientation="vertical";
  id="root";
  {
    TextView,
    id="myt",
    Typeface=字体("product-Bold");
    Visibility=8;
  };
  {
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
      id="cardv";
      layout_height="-1";
      {
        TextView;
        layout_width="0";
        layout_height="0";
        id="text";
      };
      --       background=backroundc,
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
          --         background=backroundc,
          paddingLeft="10dp",
          paddingRight="10dp",

          orientation="vertical";
          {
            TextView;
            layout_width="-1";
            layout_height="-1";
            id="title";
            textSize="13sp",
            --            Typeface=字体("product");
            textColor=primaryc,
            gravity="center";
          };
        };
      };



    }
  }
};


data={}
--myview = LayoutInflater.from(this).inflate(R.layout.recycler_view, null);

--设置布局管理器

--设置线性列表布局
recycler_view.layoutManager=ExetendFlexboxLayoutManager(this)


import "android.widget.LinearLayout$LayoutParams"

lay={}

local adapter=LuaCustRecyclerAdapter(AdapterCreator({

  getItemCount=function()
    return #data
  end,

  getItemViewType=function(pos)
    return int(0)
  end,
  onCreateViewHolder=function(parent,type)

    local views={}
    if type==0 then
      holder=LuaCustRecyclerHolder(loadlayout(list_item,views))
     else
      holder=LuaCustRecyclerHolder(loadlayout(tips,views))
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

      tag.cardv.setVisibility(View.GONE)
      tag.myt.setVisibility(View.VISIBLE)
      tag.myt.text=newdata.myt


      local hhh=LinearLayout.LayoutParams(LayoutParams.MATCH_PARENT,LayoutParams.WRAP_CONTENT);

      tag.root.setLayoutParams(hhh)
    end
  end
}))


recycler_view.adapter=adapter



function table.swap(数据, 查找位置, 替换位置, ismode)
  if ismode then
    替换位置 = 替换位置 + 1
    查找位置 = 查找位置 + 1
  end
  xpcall(function()
    删除数据=table.remove(数据, 查找位置)
    end,function()
    return false
  end)
  table.insert(数据, 替换位置, 删除数据)
end

luajava.new(luajava.bindClass("androidx.recyclerview.widget.ItemTouchHelper"), luajava.override(luajava.bindClass("androidx.recyclerview.widget.ItemTouchHelper").Callback,{
  getMovementFlags=function(b,c,d)
    local itemclass = luajava.bindClass "androidx.recyclerview.widget.ItemTouchHelper$Callback"
    dragFlags = ItemTouchHelper.UP
    swipeFlags = ItemTouchHelper.LEFT
    -- return int(itemclass.makeMovementFlags(dragFlags, swipeFlags))
    return int(itemclass.makeMovementFlags(ItemTouchHelper.RIGHT | ItemTouchHelper.LEFT | ItemTouchHelper.DOWN | ItemTouchHelper.UP, 0));

  end,
  isLongPressDragEnabled=function(a)
    return true
  end,
  isItemViewSwipeEnabled=function()
    return false
  end,

  canDropOver=function(a,recyclerView, current, target)
    fromPosition, toPosition = current.getAdapterPosition(), target.getAdapterPosition();
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

if activity.getSharedData("signdata")~=nil then
  local login_access_token="Bearer"..require "cjson".decode(activity.getSharedData("signdata")).access_token;
  access_token_head={
    ["Content-Type"] = "application/json; charset=UTF-8";
    ["authorization"] = login_access_token;
    ["cookie"] = 获取Cookie("https://www.zhihu.com/");
  }
 else
  access_token_head={
    ["Content-Type"] = "application/json; charset=UTF-8";
    ["cookie"] = 获取Cookie("https://www.zhihu.com/");
  }

end

local function 页面设置()
  local 其他位置=recycler_view.getChildLayoutPosition(lay["其他"])
  --lua中table下标从1开始 java中下标从0开始 java写法为从2开始循环到其他前一个数据 在lua中化简就是这样写
  id数据表={}
  for i=1,2 do
    if i==2 then
      local 最终处理数据=require "cjson".encode({["section_ids"]=id数据表})
      --转为json中会生成\"转义 替换掉
      local 最终处理数据=string.gsub(最终处理数据,[[\"]],"")
      Http.post("https://api.zhihu.com/feed-root/sections/submit/v2",最终处理数据,access_token_head,function(code,content)
        if code==200 then
          activity.setResult(1200,nil)
          提示("修改成功 返回主页生效")
        end
      end)
    end
    for i=3,其他位置 do
      id数据='"'..data[i].text..'"'
      table.insert(id数据表,id数据)
    end
  end
end

function 开始加载推荐()
  Http.get("https://api.zhihu.com/feed-root/sections/query/v2",access_token_head,function(code,content)
    if code==200 then
      --    提示(require "cjson".decode(content).selected_sections[1].section_name)
      for i=1, 3 do
        if i==1 then
          alldata=#require "cjson".decode(content).selected_sections+#require "cjson".decode(content).guess_like_sections+#require "cjson".decode(content).more_sections-1

          table.insert(data,{myt=[[提示：你可点击标签来添加/删除 可长按拖动排序 可拖动其他来快速添加  
 ]]})
          table.insert(data,{myt="我的"})
          --提示(tostring(i))

          for i=1, #require "cjson".decode(content).selected_sections do
            adapter.notifyDataSetChanged()
            if i<#require "cjson".decode(content).selected_sections+1 and require "cjson".decode(content).selected_sections[i].section_name~="圈子" then
              table.insert(data,{title=require "cjson".decode(content).selected_sections[i].section_name,text=tostring(tointeger(require "cjson".decode(content).selected_sections[i].section_id))})

            end
          end
        end
        if i==2 then
          table.insert(data,{myt="其他"})
          for i=1, #require "cjson".decode(content).guess_like_sections do
            --提示(tostring(i))
            if require "cjson".decode(content).guess_like_sections[i].section_name~="圈子" then
              table.insert(data,{title=require "cjson".decode(content).guess_like_sections[i].section_name,text=tostring(tointeger(require "cjson".decode(content).guess_like_sections[i].section_id))})

            end
          end
          for i=1, #require "cjson".decode(content).more_sections do
            if require "cjson".decode(content).more_sections[i].section_name~="圈子" then

              table.insert(data,{title=require "cjson".decode(content).more_sections[i].section_name,text=tostring(tointeger(require "cjson".decode(content).more_sections[i].section_id))})

            end
          end
        end
        if i==3 then
          xiugai.onClick=function()
            页面设置()
          end
          adapter.notifyDataSetChanged()
          --        dl.dismiss()
        end
      end
    end
  end)
end
开始加载推荐()

function onDestroy()
  System.gc()
  LuaUtil.rmDir(File(tostring(ContextCompat.getDataDir(activity)).."/cache"))
  collectgarbage("collect")
end