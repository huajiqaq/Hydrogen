require "import"
import "mods.muk"
activity.setContentView(loadlayout("layout/history"))

波纹({fh,_more},"圆主题")

初始化历史记录数据(true)

isxg=...

if isxg then
  activity.setResult(1500,nil)
end

function 初始化()
  recordtt={}
  recordii={}
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
end

初始化()

history_list.setDividerHeight(0)
if (#recordtt==0)then
  history_list.setVisibility(8)
  histab.ids.load.parent.setVisibility(8)
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
            {
              TextView;
              layout_width='0dp';
              layout_height='0dp';
              id="history_num",
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
  adp.add{history_title=recordtt[n],history_num=tostring(n)}
end

--mytab={"全部","回答","视频","想法","文章","提问","专栏"}
mytab={"全部","回答","想法","文章","提问","用户","视频","专栏"}


function check(str)
  if str=="全部"

    for n=1,#recordtt do
      adp.add{history_title=recordtt[n],history_num=tostring(n)}
    end
   elseif str=="回答" then
    for n=1,#recordii do
      if not recordii[n]:find("想法") and not recordii[n]:find("文章") and not recordii[n]:find("视频") and not recordii[n]:find("用户") and not recordii[n]:find("专栏") and recordii[n]:find("分割") then
        adp.add{history_title=recordtt[n],history_num=tostring(n)}
      end
    end
   elseif str=="提问" then
    for n=1,#recordii do
      if not recordii[n]:find("分割") then
        adp.add{history_title=recordtt[n],history_num=tostring(n)}
      end
    end
   else
    for n=1,#recordii do
      if recordii[n]:find(str) then
        adp.add{history_title=recordtt[n],history_num=tostring(n)}
      end
    end
  end
end

for i,v in ipairs(mytab) do
  histab:addTab(v,function() pcall(function()adp.clear()end) check(v) adp.notifyDataSetChanged() end,3)
end
histab:showTab(1)

function checktitle(str)
  local oridata=adp.getData()

  for b=1,2 do
    if b==2 then
      提示("搜索完毕 共搜索到"..#adp.getData().."条数据")
      if #adp.getData()==0 then
        task(200,function()
          activity.newActivity("history",{true}).overridePendingTransition(0, 0)
          activity.finish()
        end)
      end
    end
    for i=#oridata,1,-1 do
      if not oridata[i].history_title:find(str) then
        table.remove(oridata, i)
        adp.notifyDataSetChanged()
      end
    end
  end
end

history_list.onItemLongClick=function(l,v,c,b)
  双按钮对话框("删除","删除该历史记录？该操作不可撤消！ 确认后将会重启页面","是的","点错了",function()

    adp.clear()
    清除历史记录()
    allnum=#recordtt
    recordtt[tointeger(v.Tag.history_num.text)]=nil
    recordii[tointeger(v.Tag.history_num.text)]=nil

    kkk=0
    for n=1,allnum do
      if recordtt[n] then
        kkk=kkk+1
        this.getSharedPreferences("Historyrecordtitle",0).edit().putString(tostring(kkk),recordtt[n]).commit()
        this.getSharedPreferences("Historyrecordid",0).edit().putString(tostring(kkk),recordii[n]).commit()
      end
    end


    --     初始化历史记录数据(true)
    --           print(recordtitle[#recordtitle])
    初始化()
    for n=1,#recordtt do
      adp.add{history_title=recordtt[n],history_num=tostring(n)}
    end


    adp.notifyDataSetChanged()
    an.dismiss()
    activity.setResult(1500,nil)
    提示("已删除")

  end
  ,function()an.dismiss()end)
  return true
end
history_list.onItemClick=function(l,v,c,b)
  local clicknum=tointeger(v.Tag.history_num.text)
  local open=activity.getSharedData("内部浏览器查看回答")
  初始化历史记录数据(true)
  保存历史记录(recordtt[clicknum],recordii[clicknum],50)
  if (recordii[clicknum]):find("文章分割") then
    activity.newActivity("column",{(recordii[clicknum]):match("文章分割(.+)"),(recordii[clicknum]):match("分割(.+)")})
   elseif (recordii[clicknum]):find("想法分割") then
    activity.newActivity("column",{(recordii[clicknum]):match("想法分割(.+)"),"想法"})
   elseif (recordii[clicknum]):find("视频分割") then
    activity.newActivity("column",{(recordii[clicknum]):match("视频分割(.+)"),"视频"})
   elseif (recordii[clicknum]):find("用户分割") then
    activity.newActivity("people",{(recordii[clicknum]):match("用户分割(.+)")})
   elseif (recordii[clicknum]):find("专栏分割") then
    activity.newActivity("people_column",{(recordii[clicknum]):match("专栏分割(.+)"),recordtt[clicknum]})
    --TOOD 对于回答记录的点击
   elseif (recordii[clicknum]):find("分割") then
    if open=="false" then
      activity.newActivity("answer",{(recordii[clicknum]):match("(.+)分割"),(recordii[clicknum]):match("分割(.+)")})
     else
      activity.newActivity("huida",{"https://www.zhihu.com/question/"..(recordii[clicknum]):match("(.+)分割").."/answer/"..(recordii[clicknum]):match("分割(.+)")})
    end
   else
    if open=="false" then
      activity.newActivity("question",{(recordii[clicknum])})
     else
      activity.newActivity("huida",{"https://www.zhihu.com/question/"..(recordii[clicknum])})
    end
  end
  --     初始化历史记录数据(true)
  activity.setResult(1500,nil)
  task(300,function()
    初始化()
--[[    adp.clear()
    for n=1,#recordtt do
      adp.add{history_title=recordtt[n],history_num=tostring(n)}
    end
    adp.notifyDataSetChanged()
    ]]
  end)
end



a=MUKPopu({
  tittle="历史记录",
  list={
    {
      src=图标("search"),text="搜索历史记录",onClick=function()
        InputLayout={
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
            id="edit";
          };
        };

        AlertDialog.Builder(this)
        .setTitle("请输入")
        .setView(loadlayout(InputLayout))
        .setPositiveButton("确定", {onClick=function() checktitle(edit.text) end})
        .setNegativeButton("取消", nil)
        .show();

    end},
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

function onPause()
  if ishava then
    activity.overridePendingTransition(0,0);
  end
end