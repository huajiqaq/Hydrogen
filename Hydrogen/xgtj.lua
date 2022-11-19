require "import"
import "android.widget.*"
import "android.view.*"
import "android.graphics.PorterDuffColorFilter"
import "android.graphics.PorterDuff"
import "mods.muk"
import "mods.loadlayout"
import "com.michael.NoScrollListView"
import "android.widget.NumberPicker$OnValueChangeListener"
设置视图("layout/xgtj")

波纹({fh},"圆主题")
波纹({moren,xiugai},"方自适应")

dl=ProgressDialog.show(activity,nil,'加载中 请耐心等待')
dl.show()

about_item={
  {--标题
    LinearLayout;

    layout_width="fill";
    layout_height="-2";
    {
      TextView;
      Focusable=true;
      layout_marginTop="12dp";
      layout_marginBottom="0dp";
      gravity="center_vertical";
      Typeface=字体("product");
      id="title";
      textSize="13sp";
      textColor=primaryc;
      layout_marginLeft="16dp";
    };
  };

  {--标题
    LinearLayout;

    layout_width="fill";
    layout_height="-2";
    {
      TextView;
      Focusable=true;
      layout_marginTop="12dp";
      layout_marginBottom="0dp";
      gravity="center_vertical";
      Typeface=字体("product");
      id="subtitle";
      textSize="15sp";
      textColor=textc;
      layout_marginLeft="16dp";
    };
  };

  {--文字
    LinearLayout;
    layout_width="-1";
    layout_height="-2";
    gravity="center_vertical";
    {

      TextView;
      id="content";
      Typeface=字体("product");
      textSize="14sp";
      textColor=stextc;
      layout_marginRight="16dp",
      layout_marginLeft="16dp",
      layout_margin="8dp";
    };
  };


};
--activity.setTheme(Theme_Material_Light)

data = {}
adp=LuaMultiAdapter(this,data,about_item)

adp.add{__type=3,content="    提示： 请对照下方id列表修改id 请自行删除多余的"}

settings_list.setAdapter(adp)



settab={
  ["夜间模式"]="Setting_Night_Mode",
  ["夜间模式追随系统"]="Setting_Auto_Night_Mode",
}--设置数据

settings_list.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(id,v,zero,one)
    if v.Tag.status ~= nil then

      if v.Tag.status.Checked then
        this.setSharedData(settab[tostring(v.Tag.subtitle.Text)] or v.Tag.subtitle.Text,"false")
        data[one].status["Checked"]=false
       else
        this.setSharedData(settab[tostring(v.Tag.subtitle.Text)] or v.Tag.subtitle.Text,"true")
        data[one].status["Checked"]=true
      end

    end



    adp.notifyDataSetChanged()--更新列表
end})

function matchtext(str,regex)
  local t={}
  for i,v in string.gfind(str,regex) do
    table.insert(t,string.sub(str,i,v))
  end
  return t
end --返回table

function 修改页面()
  akkak=nil
  pcall(function()
    kaks=matchtext(Editt.Text,[[[1-9]%d*]])
    idtable=matchtext(Editt.Text,"id")
    if #idtable>id数量 or #idtable==id数量 then
      提示("异常 已恢复")
      Editt.Text=endtextz;
     else
      if akkak==nil then
        akkak=""
      end
      for i=1, #kaks do
        if kaks[i*2+2]-kaks[i*2]==2 then
         else
          akkak=akkak..'"'..kaks[i*2]..'",'
        end
      end
    end
  end)
  if akkak~=nil then
    local s = [[{"section_ids":[]]..akkak:gsub("(.*),", "%1")..[[]}]]
    Http.post("https://api.zhihu.com/feed-root/sections/submit/v2",s,access_token_head,function(code,content)
      if code==200 then
        activity.setResult(100,nil)
        提示("修改成功 返回主页生效")
      end
    end)
  end
end

function 添加项(a)
  if theadditem==nil then
    theadditem=0
  end
  if endtextz==nil then
    origintextt=""
   else
    origintextt=endtextz
  end
  theadditem=theadditem+1
  endtextz=origintextt.."【"..theadditem.."】".." "..a
end

if activity.getSharedData("signdata")~=nil then
  local login_access_token="Bearer"..require "cjson".decode(activity.getSharedData("signdata")).access_token;
  access_token_head={
    ["Content-Type"] = "application/json; charset=UTF-8";
    ["authorization"] = login_access_token;
    ["cookie"] = 获取Cookie("https://www.zhihu.com/");
  }
 else
  --[[    提示("还没有获取登录参数 已清除数据")
                           清除所有cookie()
                        跳转页面("home")
                        activity.finish()]]
  access_token_head={
    ["Content-Type"] = "application/json; charset=UTF-8";
    ["cookie"] = 获取Cookie("https://www.zhihu.com/");
  }

end

Http.get("https://api.zhihu.com/feed-root/sections/query/v2",access_token_head,function(code,content)
  if code==200 then
    --    提示(require "cjson".decode(content).selected_sections[1].section_name)
    for i=1, #require "cjson".decode(content).selected_sections+#require "cjson".decode(content).guess_like_sections+#require "cjson".decode(content).more_sections-1 do
      if i==#require "cjson".decode(content).selected_sections+#require "cjson".decode(content).guess_like_sections+#require "cjson".decode(content).more_sections-1 then
        id数量=#require "cjson".decode(content).selected_sections+#require "cjson".decode(content).guess_like_sections+#require "cjson".decode(content).more_sections-1
        Edittt.Text="id列表\n"..akk
        Edittt.setKeyListener(null);
        kk=endtextz
        Editt.Text=endtextz;
        Editt.addTextChangedListener{
          afterTextChanged=function(s)
            if tostring(s):match("【】") then
              print("请不要修改【】中的数值")
              Editt.Text=kk;
              --事件
            end
          end
        }
        dl.dismiss()
      end
      --提示(tostring(i))
      if i<#require "cjson".decode(content).selected_sections+1 and require "cjson".decode(content).selected_sections[i].section_name~="圈子" then
        if akk==nil then
          akk=""
        end
        akk=akk.." "..require "cjson".decode(content).selected_sections[i].section_name..tointeger(require "cjson".decode(content).selected_sections[i].section_id)
        添加项(tointeger(require "cjson".decode(content).selected_sections[i].section_id))

       else
        添加项("id")
      end
    end
    if endtextz==nil then
      endtextz=""
    end

    for i=1, #require "cjson".decode(content).guess_like_sections do
      --提示(tostring(i))
      if require "cjson".decode(content).guess_like_sections[i].section_name~="圈子" then
        if akk==nil then
          akk=""
        end


        akk=akk.." "..require "cjson".decode(content).guess_like_sections[i].section_name..tointeger(require "cjson".decode(content).guess_like_sections[i].section_id)
      end
    end
    for i=1, #require "cjson".decode(content).more_sections do
      --提示(tostring(i))
      if require "cjson".decode(content).more_sections[i].section_name~="圈子" then
        if akk==nil then
          akk=""
        end

        akk=akk.." "..require "cjson".decode(content).more_sections[i].section_name..tointeger(require "cjson".decode(content).more_sections[i].section_id)
      end
    end
  end
end)

