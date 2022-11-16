require "import"
import "android.app.*"
import "andoid.os.*"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
import "com.michael.NoScrollGridView"
import "mods.MyEditText"


设置视图("layout/search")



button.onClick=function()
  if #(tostring(search_editor.EditText.text):gsub("\n",""):gsub(" ",""))<1 then
    提示("请输入您要搜索的内容")
   else
--[[    if activity.getSharedData("内部搜索(beta)")=="true" then
      activity.newActivity("search_result",{search_editor.EditText.text})
     else]]
      activity.newActivity("huida",{"https://www.zhihu.com/search?type=content&q="..search_editor.EditText.text})
--    end
  end
end

--EditText文本被改变事件
search_editor.EditText.addTextChangedListener{
  onTextChanged=function(s)
    if search_editor.EditText.text:find"\n"then
      if #(tostring(search_editor.EditText.text):gsub("\n",""):gsub(" ",""))<1 then
        提示("请输入您要搜索的内容")
       else
        button.performClick()
      end
      search_editor.EditText.text=search_editor.EditText.text:gsub("\n","")
    end
  end
}




波纹({_back},"圆主题")
波纹({button},"方主题")

itemc=
{
  LinearLayout;
  layout_width="-1";
  layout_height="-2";
  BackgroundColor=backgroundc;
  {
    CardView;
    CardElevation="0dp";
    CardBackgroundColor=cardedge;
    radius="8dp";
    layout_width="-1";
    layout_height="48dp";
    layout_margin="8dp";
    {
      CardView;
      CardElevation="0dp";
      CardBackgroundColor=backgroundc;
      radius=dp2px(8)-2;
      layout_margin="2px";
      layout_width="-1";
      layout_height="-1";
      {
        LinearLayout;
        layout_height="fill";
        id="background";
        layout_width="fill";

        ripple="圆自适应",

        {
          LinearLayout;
          layout_width="-1";
          layout_height="-1";
          gravity="center";
          {
            TextView;
            id="hotsearch_title";
            singleLine=true;
            textColor=textc;
            textSize="14sp";
            gravity="center";
            SingleLine=true;
            ellipsize='marquee',
            Selected=true,
            Typeface=字体("product-Bold");
          };
          {
            TextView;
            id="hotsearch_key";
            layout_width="0";
            layout_height="0";
          };
        };
      };
    };
  };
};

yuxuan_adpqy=LuaAdapter(activity,itemc)

search_list.Adapter=yuxuan_adpqy

local url = "https://api.zhihu.com/search/top_search"
Http.get(url,function(code,content)
  if code==200 then
    local data=require "cjson".decode(content)
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

