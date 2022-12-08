require "import"
import "mods.muk"
activity.setContentView(loadlayout("layout/history"))

波纹({fh,_more},"圆主题")

初始化历史记录数据(true)

local recordtt={}
local recordii={}
if (退出时保存历史记录==true)then
  for d in each(this.getSharedPreferences("Historyrecordtitle",0).getAll().entrySet()) do
    recordtt[tonumber(d.getKey())]=d.getValue()
  end
  for d in each(this.getSharedPreferences("Historyrecordid",0).getAll().entrySet()) do
    recordii[tonumber(d.getKey())]=d.getValue()
  end
 else
  local k=0
  for i=#recordtitle,1,-1 do
    k=k+1
    recordtt[k]=recordtitle[i]
    recordii[k]=recordid[i]
  end
end

history_list.setDividerHeight(0)
if (#recordtt==0)then
  history_list.setVisibility(8)
  empty.setVisibility(0)
end


itemc=
{
  LinearLayout,
  orientation="horizontal",
  layout_width="-1",
  BackgroundColor=backgroundc;
  {
    CardView;
    layout_margin="16dp";
    layout_marginTop="8dp";
    layout_marginBottom="8dp";
    layout_gravity='center';
    Elevation='0';
    layout_width='-1';
    layout_height='-2';
    radius='8dp';
    CardBackgroundColor=cardedge,
    {
      CardView;
      CardElevation="0dp";
      CardBackgroundColor=backgroundc;
      Radius=dp2px(8)-2;
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
          orientation="horizontal";
          padding="16dp";
          {
            TextView;
            textSize="0sp";
            id="history_id",
            Typeface=字体("product");
          };
          {
            LinearLayout;
            orientation="vertical";
            {
              TextView;
              textColor=textc;
              textSize="14sp";
              Typeface=字体("product-Bold");
              id="history_title",
            };
          };
        };
      };
    };
  };
};




adp=LuaAdapter(activity,itemc)

history_list.Adapter=adp

for n=1,#recordtt do
  adp.add{history_title={Text=recordtt[n],}}
end


history_list.onItemClick=function(l,v,c,b)
  return true
end
history_list.onItemClick=function(l,v,c,b)
  local open=activity.getSharedData("内部浏览器查看回答")
  if (recordii[b]):find("文章分割") then
    activity.newActivity("column",{(recordii[b]):match("文章分割(.+)"),(recordii[b]):match("分割(.+)")})
   elseif (recordii[b]):find("想法分割") then
    activity.newActivity("column",{(recordii[b]):match("想法分割(.+)"),"想法"})
    --TOOD 对于回答记录的点击
   elseif (recordii[b]):find("分割") then
    if open=="false" then
      activity.newActivity("answer",{(recordii[b]):match("(.+)分割"),(recordii[b]):match("分割(.+)")})
     else
      activity.newActivity("huida",{"https://www.zhihu.com/question/"..(recordii[b]):match("(.+)分割").."/answer/"..(recordii[b]):match("分割(.+)")})
    end
   else
    if open=="false" then
      activity.newActivity("question",{(recordii[b])})
     else
      activity.newActivity("huida",{"https://www.zhihu.com/question/"..(recordii[b])})
    end
  end
end
a=MUKPopu({
  tittle="历史记录",
  list={
    {
      src=图标("list_alt"),text="清理历史记录",onClick=function()
        双按钮对话框("提示","确定要清理历史记录吗 清除将会重启应用","我知道了","暂不清理",function()
          关闭对话框(an)
          清除历史记录()
          提示("已清除,即将重启")
          task(200,function()
            import "android.os.Process"
            local intent =activity.getBaseContext().getPackageManager().getLaunchIntentForPackage(activity.getBaseContext().getPackageName());
            intent.addFlags(Intent.FLAG_ACTIVITY_CLEAR_TOP);
            activity.startActivity(intent);
            Process.killProcess(Process.myPid());
          end)
          end,function()
          关闭对话框(an)
        end)

    end},
  }
})



