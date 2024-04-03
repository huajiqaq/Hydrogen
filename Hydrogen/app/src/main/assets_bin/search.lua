require "import"
import "android.app.*"
import "andoid.os.*"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
import "com.google.android.material.textfield.TextInputLayout"
import "com.google.android.material.textfield.TextInputEditText"

MDC_R=luajava.bindClass"com.google.android.material.R"

设置视图("layout/search")



button.onClick=function()
  if #(tostring(t2.text):gsub("\n",""):gsub(" ",""))<1 then
    提示("请输入您要搜索的内容")
   else
    activity.newActivity("huida",{"https://www.zhihu.com/search?type=content&q="..t2.text})
  end
end

local corii={dp2px(24),dp2px(24),dp2px(24),dp2px(24)}
t1.setBoxCornerRadii(table.unpack(corii))


import "com.google.android.material.card.MaterialCardView"


波纹({_back},"圆主题")
波纹({button},"方主题")

itemc=获取适配器项目布局("search/search")

yuxuan_adpqy=LuaAdapter(activity,itemc)

search_list.Adapter=yuxuan_adpqy

local url = "https://api.zhihu.com/search/top_search"
zHttp.get(url,head,function(code,content)
  if code==200 then
    local data=luajson.decode(content)
    for k,v in ipairs(data.top_search.words) do
      task(50,function()yuxuan_adpqy.add{hotsearch_key=v.query,hotsearch_title=v.display_query}end)
    end
   else
    提示("获取热门搜索失败 "..content)
  end

end)

search_list.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(parent,v,pos,id)
    if activity.getSharedData("内部搜索(beta)")=="true" then
      activity.newActivity("search_result",{v.Tag.hotsearch_key.Text})
     else
      activity.newActivity("huida",{"https://www.zhihu.com/search?type=content&q="..v.Tag.hotsearch_key.Text})
    end
  end
})

import "android.widget.TextView$OnEditorActionListener"
import "android.view.inputmethod.EditorInfo"

t2.setOnEditorActionListener(OnEditorActionListener({
  onEditorAction=function( v, actionId, event)
    if (actionId == EditorInfo.IME_ACTION_SEARCH) then
      if #(tostring(t2.text):gsub("\n",""):gsub(" ",""))<1 then
        提示("请输入您要搜索的内容")
       else
        activity.newActivity("huida",{"https://www.zhihu.com/search?type=content&q="..t2.text})
      end
    end
    return true;
  end
}))