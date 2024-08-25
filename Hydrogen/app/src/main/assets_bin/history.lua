require "import"

custom_onstart=true

import "mods.muk"
activity.setContentView(loadlayout("layout/history"))

设置toolbar(toolbar)

波纹({fh,_more},"圆主题")

初始化历史记录数据(true)

history_list.setDividerHeight(0)
if (#recordtitle==0)then
  history_list.setVisibility(8)
  histab.ids.load.parent.setVisibility(8)
  empty.setVisibility(0)
end


itemc=获取适配器项目布局("history/history")


adp=LuaAdapter(activity,itemc)

history_list.adapter=adp


mytab={"全部","回答","想法","文章","提问","用户","视频","专栏"}


function 加载历史记录()
  if find_type=="全部" or find_type==nil then
    for i=#recordid,1,-1 do
      local id=recordid[i]
      local title=recordtitle[i]
      adp.add{标题=Html.fromHtml(title),id内容=id}
    end
   elseif find_type=="回答" then
    for i=#recordid,1,-1 do
      local id=recordid[i]
      if not id:find("想法") and not id:find("文章") and not id:find("视频") and not id:find("用户") and not id:find("专栏") and id:find("分割") then
        local title=recordtitle[i]
        adp.add{标题=Html.fromHtml(title),id内容=id}
      end
    end
   elseif find_type=="提问" then
    for i=#recordtitle,1,-1 do
      local id=recordid[i]
      if not id:find("分割") then
        local title=recordtitle[i]
        adp.add{标题=Html.fromHtml(title),id内容=id}
      end
    end
   else
    for i=#recordtitle,1,-1 do
      local id=recordid[i]
      if id:find(find_type) then
        local title=recordtitle[i]
        adp.add{标题=Html.fromHtml(title),id内容=id}
      end
    end
  end
end

for i,v in ipairs(mytab) do
  histab:addTab(v,function()
    adp.clear()
    find_type=v
    加载历史记录()
    adp.notifyDataSetChanged()
  end,3)
end
histab:showTab(1)

加载历史记录()

function checktitle(str)
  local oridata=adp.getData()
  for i=#oridata,1,-1 do
    if not tostring(oridata[i].标题):find(str) then
      table.remove(oridata, i)
      adp.notifyDataSetChanged()
    end
  end
  提示("搜索完毕 共搜索到"..#adp.getData().."条数据")
  if #adp.getData()==0 then
    加载历史记录()
  end
end

function 获取位置(find_id)
  for k,v ipairs(recordid) do
    if v==find_id then
      return k
    end
  end
end

history_list.onItemLongClick=function(l,v,c,b)
  双按钮对话框("删除","删除该历史记录？该操作不可撤消！","是的","点错了",function(an)
    local pos=获取位置(v.Tag.id内容.text)
    table.remove(recordtitle,pos)
    table.remove(recordid,pos)
    adp.remove(c)
    adp.notifyDataSetChanged()
    an.dismiss()
    提示("已删除")
  end
  ,function(an)an.dismiss()end)
  return true
end

history_list.onItemClick=function(l,v,c,b)
  local 标题=v.Tag.标题.text
  local id内容=v.Tag.id内容.text
  点击事件判断(id内容)
  table.remove(recordtitle,#recordtitle)
  table.remove(recordid,#recordid)
  table.insert(recordtitle,1,标题)
  table.insert(recordtitle,1,id内容)
end


task(1,function()
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
          双按钮对话框("提示","确定要清理历史记录吗 清除将会重启应用","我知道了","暂不清理",function(an)
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
            end,function(an)
            关闭对话框(an)
          end)

      end},
    }
  })
end)

function onDestroy()
  清空并保存历史记录("Historyrecordtitle", recordtitle)
  清空并保存历史记录("Historyrecordid", recordid)
end