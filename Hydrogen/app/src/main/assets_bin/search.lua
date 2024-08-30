require "import"
import "android.app.*"
import "andoid.os.*"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
import "com.google.android.material.textfield.TextInputLayout"
import "com.google.android.material.textfield.TextInputEditText"


import "com.google.android.material.chip.ChipGroup"
import "com.google.android.material.chip.Chip"
MDC_R=luajava.bindClass"com.google.android.material.R"


设置视图("layout/search")

function 搜索(text)
  local search_text=text or search_view.getQuery().toString();
  if #(tostring(search_text):gsub(" ",""))<1 then
    提示("请输入您要搜索的内容")
   else

    for i, text in ipairs(search_history) do
      if search_text == text then
        -- 如果记录已存在，先删除再添加
        table.remove(search_history, i)
        break
      end
    end

    table.insert(search_history, search_text)
    清空并保存历史记录("search_history", search_history)
    activity.newActivity("browser",{"https://www.zhihu.com/search?type=content&q="..search_text})
  end
end


import "com.google.android.material.card.MaterialCardView"

波纹({_back,search,_delete},"圆主题")

if this.getSharedData("关闭热门搜索")=="true" then
  热门搜索布局.Visibility=8
 else
  itemc=获取适配器项目布局("search/search")
  adp=LuaAdapter(activity,itemc)
  search_list.adapter=adp
  local url = "https://api.zhihu.com/search/top_search"
  zHttp.get(url,head,function(code,content)
    if code==200 then
      local data=luajson.decode(content)
      for k,v in ipairs(data.top_search.words) do
        task(50,function()adp.add{id内容=v.query,标题=v.display_query}end)
      end
     else
      提示("获取热门搜索失败 "..content)
    end
  end)
  search_list.setOnItemClickListener(AdapterView.OnItemClickListener{
    onItemClick=function(parent,v,pos,id)
      搜索(v.Tag.id内容.Text)
    end
  })
end

search_view.setOnQueryTextListener(SearchView.OnQueryTextListener{
  onQueryTextSubmit=function(str)
    搜索()
  end,
  onQueryTextChange=function(str)
  end
})

search.onClick=function()
  搜索()
end

_delete.onClick=function()
  search_history={}
  清空并保存历史记录("search_history", search_history)
  chipgroup.removeAllViews()
end

function getCheckedPos(str)
  for i = 1,chipgroup.childCount do
    if chipgroup.getChildAt(i-1).text==str then
      return i-1
    end
  end
end

local function createchip(text)
  return loadlayout2({
    Chip_Input;
    layout_width="wrap_content";
    layout_height="wrap_content";
    text=text;
    checkable=false;
    EnsureMinTouchTargetSize=false,
    OnCloseIconClickListener=function(view)
      local pos=getCheckedPos(view.text)+1
      table.remove(search_history, pos)
      清空并保存历史记录("search_history", search_history)
      view.getParent().removeView(view)
    end,
    onClick=function()
      搜索(text)
    end
  })
end

search_history=loadSharedPreferences("search_history")

search_view.requestFocus()
search_view.postDelayed(Runnable{
  run=function()
    imm= this.getSystemService(Context.INPUT_METHOD_SERVICE);
    imm.showSoftInput(search_view, InputMethodManager.SHOW_IMPLICIT);
  end
}, 100);

function onStart()
  chipgroup.removeAllViews()
  for i=#search_history,1,-1 do
    local text=search_history[i]
    chipgroup.addView(createchip(text,itemnum))
  end
end