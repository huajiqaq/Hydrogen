require "import"
import "android.widget.*"
import "android.view.*"
import "android.graphics.PorterDuffColorFilter"
import "android.graphics.PorterDuff"
import "mods.muk"
--import "mods.loadlayout"
import "android.widget.NumberPicker$OnValueChangeListener"
import "mods.muk"
import "com.lua.custrecycleradapter.*"
import "com.google.android.flexbox.*"
import "androidx.recyclerview.widget.*"

设置视图("layout/xgtj")

波纹({fh},"圆主题")
波纹({moren,xiugai},"方自适应")


local list_item=获取适配器项目布局("xgtj/xgtj")

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


local function 页面设置()
  local 其他位置=recycler_view.getChildLayoutPosition(lay["其他"])
  --lua中table下标从1开始 java中下标从0开始 java写法为从2开始循环到其他前一个数据 在lua中化简就是这样写
  id数据表={}
  for i=1,2 do
    if i==2 then
      local 最终处理数据=luajson.encode({["section_ids"]=id数据表})
      --转为json中会生成\"转义 替换掉
      local 最终处理数据=string.gsub(最终处理数据,[[\"]],"")
      zHttp.post("https://api.zhihu.com/feed-root/sections/submit/v2",最终处理数据,posthead,function(code,content)
        if code==200 then
          activity.setResult(100,nil)
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
  zHttp.get("https://api.zhihu.com/feed-root/sections/query/v2",head,function(code,content)
    if code==200 then
      for i=1, 3 do
        if i==1 then
          alldata=#luajson.decode(content).selected_sections+#luajson.decode(content).guess_like_sections+#luajson.decode(content).more_sections-1

          table.insert(data,{myt="提示：你可点击标签来添加/删除 可长按拖动排序 可拖动其他来快速添加".."\n"})
          table.insert(data,{myt="我的"})
          for i=1, #luajson.decode(content).selected_sections do
            adapter.notifyDataSetChanged()
            if i<#luajson.decode(content).selected_sections+1 and luajson.decode(content).selected_sections[i].section_name~="圈子" then
              table.insert(data,{title=luajson.decode(content).selected_sections[i].section_name,text=tostring(tointeger(luajson.decode(content).selected_sections[i].section_id))})

            end
          end
        end
        if i==2 then
          table.insert(data,{myt="其他"})
          for i=1, #luajson.decode(content).guess_like_sections do
            --提示(tostring(i))
            if luajson.decode(content).guess_like_sections[i].section_name~="圈子" then
              table.insert(data,{title=luajson.decode(content).guess_like_sections[i].section_name,text=tostring(tointeger(luajson.decode(content).guess_like_sections[i].section_id))})

            end
          end
          for i=1, #luajson.decode(content).more_sections do
            if luajson.decode(content).more_sections[i].section_name~="圈子" then

              table.insert(data,{title=luajson.decode(content).more_sections[i].section_name,text=tostring(tointeger(luajson.decode(content).more_sections[i].section_id))})

            end
          end
        end
        if i==3 then
          xiugai.onClick=function()
            页面设置()
          end
          adapter.notifyDataSetChanged()
        end
      end
    end
  end)
end
开始加载推荐()

function 修改地点()
  zHttp.get("https://api.zhihu.com/feed-root/sections/cityList",head,function(code,content)
    if code==200 then
      local mstr=""
      tab=luajson.decode(content).result_info
      for k,v pairs(tab)
        local mtab=v.city_info_list
        local mkey=v.city_key
        for key,value pairs(mtab)
          if key==1 then
            if k>1 then
              mstr=mstr..'\n'..mkey..'\n'
             else
              mstr=mstr..mkey..'\n'
            end
            mstr=mstr..value.city_name
           else
            mstr=mstr.." "..value.city_name
          end
          --    print(mstr)
        end
        --  print(mstr)
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
              text=mstr;
            };
          };
        };
      }))
      .setPositiveButton("确定",nil)
      .setNegativeButton("取消",nil)
      .show()

      dialog.getButton(dialog.BUTTON_POSITIVE).onClick=function()
        local checkstr=string.gsub(edit.Text, "%s", "")
        if mstr:find(checkstr) and checkstr~="" then
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
xgdd.onClick=function() 修改地点() end