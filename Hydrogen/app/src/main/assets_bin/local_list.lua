require "import"
import "mods.muk"
import "com.lua.*"

activity.setContentView(loadlayout("layout/local_list"))

初始化历史记录数据(true)


波纹({fh,_more},"圆主题")
_title.Text="已保存的内容"

local_item=获取适配器项目布局("local_item/local_item")


if not 文件是否存在(内置存储文件()) then
  xpcall(function()
    创建文件夹(内置存储文件())
    end,function()
  end)
end
if not 文件是否存在(内置存储文件("Download")) then
  xpcall(function()
    创建文件夹(内置存储文件("Download"))
    end,function()
  end)
end

notedata={}
noteadp=LuaAdapter(activity,notedata,local_item)
local_listview.setAdapter(noteadp)

mytab={"全部","回答","想法","文章","视频"}
for i,v in ipairs(mytab) do
  localtab:addTab(v,function() pcall(function()noteadp.clear()end) 加载笔记(v) mystr=v noteadp.notifyDataSetChanged() end,3)
end
localtab:showTab(1)

function 加载笔记(str)
  if #luajava.astable(File(内置存储文件("Download")).listFiles())==0 then
    localtab.ids.load.parent.setVisibility(8)
    empty.setVisibility(0)
    return false
  end

  if str =="全部" or str==nil then
    str="all"
   elseif str =="回答" then
    str="answer_id"
   elseif str=="想法" then
    str="pin"
   elseif str=="文章" then
    str="article"
   elseif str=="视频" then
    str="video"
  end

  notedata={}
  if str == "all" then
    for i,v in ipairs(luajava.astable(File(内置存储文件("Download")).listFiles())) do
      local vv=v
      local v=tostring(v)
      local _,name=v:match("(.+)/(.+)")
      notedata[#notedata+1]={
        timestamp=vv.lastModified(),
        catitle=name,
        file=(v),
      }
    end

    table.sort(notedata,function(a, b)
      return a.timestamp > b.timestamp
    end)
   else

    for i,v in ipairs(luajava.astable(File(内置存储文件("Download")).listFiles())) do
      local vv=v
      local v=tostring(v)
      local a=luajava.astable(File(v).listFiles())
      local bbb=tostring(a[1]).."/detail.txt"
      local filestr=读取文件(bbb)
      local _,name=v:match("(.+)/(.+)")
      if filestr:find(str) then
        notedata[#notedata+1]={
          timestamp=vv.lastModified(),
          catitle=name,
          file=(v),
        }
      end
    end
  end

  table.sort(notedata,function(a, b)
    return a.timestamp > b.timestamp
  end)

  noteadp=LuaAdapter(activity,notedata,local_item)
  local_listview.setAdapter(noteadp)
end

加载笔记()

function checktitle(str)
  local oridata=noteadp.getData()

  for b=1,2 do
    if b==2 then
      提示("搜索完毕 共搜索到"..#noteadp.getData().."条数据")
      if #noteadp.getData()==0 then
        加载笔记(mystr)
      end
    end
    for i=#oridata,1,-1 do
      if not oridata[i].catitle:find(str) then
        table.remove(oridata, i)
        noteadp.notifyDataSetChanged()
      end
    end
  end
end

local_listview.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(id,v,zero,one)
    本地列表(v.Tag.catitle.Text)
end})

local_listview.setOnItemLongClickListener(AdapterView.OnItemLongClickListener{
  onItemLongClick=function(id,v,zero,one)
    双按钮对话框("删除","删除该内容？该操作不可撤消！","是的","点错了",function(an)删除文件(内置存储文件("Download/"..v.Tag.catitle.Text))
      an.dismiss()
      加载笔记(mystr)
      提示("已删除")end,function(an)an.dismiss()end)
    return true
end})

local item={
  LinearLayout,
  orientation="vertical",
  layout_width="fill",
  {
    TextView,
    id="mytext",
    layout_width="match_parent",
    layout_height="wrap_content",
    textSize="16sp",
    gravity="center_vertical",
    Typeface=字体("product-Bold");
    paddingStart=64,
    paddingEnd=64,
    minHeight=192,
  },
}

function 本地列表(path)
  local gd2 = GradientDrawable()
  gd2.setColor(转0x(backgroundc))--填充
  local radius=dp2px(16)
  gd2.setCornerRadii({radius,radius,radius,radius,0,0,0,0})--圆角
  gd2.setShape(0)--形状，0矩形，1圆形，2线，3环形
  local dann={
    LinearLayout;
    layout_width="-1";
    layout_height="-1";
    {
      LinearLayout;
      orientation="vertical";
      layout_width="-1";
      layout_height="-2";
      Elevation="4dp";
      BackgroundDrawable=gd2;
      {
        CardView;
        layout_gravity="center",
        background=cardedge,
        radius="3dp",
        Elevation="0dp";
        layout_height="6dp",
        layout_width="56dp",
        layout_marginTop="12dp";
      };
      {
        TextView;
        layout_width="-1";
        layout_height="-2";
        textSize="20sp";
        layout_marginTop="24dp";
        layout_marginLeft="24dp";
        layout_marginRight="24dp";
        Text="选择作者";
        Typeface=字体("product-Bold");
        textColor=primaryc;
      };
      {
        ListView;
        padding="8dp",
        layout_width="-1";
        layout_height="-1";
        id="listview",
      };
      {
        LinearLayout;
        orientation="horizontal";
        layout_width="-1";
        layout_height="-2";
        gravity="right|center";
        {
          MaterialButton;
          layout_marginTop="16dp";
          layout_marginLeft="16dp";
          layout_marginRight="16dp";
          layout_marginBottom="16dp";
          textColor=backgroundc;
          text="关闭";
          Typeface=字体("product-Bold");
          onClick=function()an.dismiss()end;
        };
      };
    };
  };
  local bottomSheetDialog = BottomSheetDialog(this)
  bottomSheetDialog.setContentView(loadlayout(dann))
  an=bottomSheetDialog.show()

  adp=LuaAdapter(activity,item)

  for v,s in pairs(luajava.astable(File(内置存储文件("Download/"..path.."/")).listFiles())) do
    adp.add({
      mytext=s.Name,
    })
  end

  listview.setAdapter(adp)

  listview.setOnItemClickListener(AdapterView.OnItemClickListener{
    onItemClick=function(id,v,zero,one)
      activity.newActivity("local",{path,v.Tag.mytext.Text})
      an.dismiss()
  end})

  listview.setOnItemLongClickListener(AdapterView.OnItemLongClickListener{
    onItemLongClick=function(id,v,zero,one)
      双按钮对话框("删除","删除该内容？该操作不可撤消！","是的","点错了",function(an)删除文件(内置存储文件("Download/"..path.."/"..v.Tag.mytext.Text))
        an.dismiss()
        --当内容为1个时 删除后该保存内容就没有了意义 所以当删除时连同清理该保存内容
        if id.adapter.getCount()==1 then
          提示("已删除 由于删除后无内容保存 所以已自动关闭")
          删除文件(内置存储文件("Download/"..path))
          --访问全局变量的an
          _G["an"].dismiss()
          加载笔记(mystr)
         else
          id.adapter.remove(zero)
          提示("已删除")
        end
      end,function(an)an.dismiss()end)
      return true
  end})

end

task(1,function()
  a=MUKPopu({
    tittle="已保存的回答",
    list={
      {
        src=图标("search"),text="搜索已保存的回答",onClick=function()
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
      {src=图标("email"),text="反馈",onClick=function()
          activity.newActivity("feedback")
      end},
      {src=图标("info"),text="自定义目录",onClick=function()
          if Build.VERSION.SDK_INT <30 then
            return 提示("该功能只提供安卓10以上版本使用")
          end

          local result=get_write_permissions(true)
          if result~=true then
            return false
          end

          AlertDialog.Builder(this)
          .setTitle("提示")
          .setMessage("修改本目录是修改导入/导出时的默认目录 目前不支持修改保存文件的默认目录")
          .setPositiveButton("我知道了",{onClick=function()

              local sdcarddir=Environment.getExternalStorageDirectory().toString()
              local filesdir=activity.getExternalFilesDir(nil).toString()
              local path=activity.getSharedData("savepath") or sdcarddir
              local path=path.."/Hydrogen.zip"

              ChoicePath(activity.getSharedData("savepath") or sdcarddir,
              function(path)
                local savepath
                local last_char = string.sub(path, -1)
                -- 判断最后一部分是否为斜杠
                if last_char == '/' then
                  savepath = string.sub(path, 1, -2)
                 else
                  savepath=path
                end
                activity.setSharedData("savepath",savepath)
                提示("自定义路径成功")
              end)

          end})
          .setNegativeButton("取消", nil)
          .show()

      end},
      {src=图标("info"),text="导入",onClick=function()
          if Build.VERSION.SDK_INT <30 then
            return 提示("该功能只提供安卓10以上版本使用")
          end

          local result=get_write_permissions(true)
          if result~=true then
            return false
          end

          local sdcarddir=Environment.getExternalStorageDirectory().toString()
          local filesdir=activity.getExternalFilesDir(nil).toString()
          local path=activity.getSharedData("savepath") or sdcarddir
          local path=path.."/Hydrogen.zip"
          if 文件是否存在(path) then
            task(function()
              local path=activity.getSharedData("savepath") or sdcarddir
              local path=path.."/Hydrogen.zip"
              local filesdir=activity.getExternalFilesDir(nil).toString()
              ZipUtil.unzip(path,filesdir.."/Hydrogen")
            end)
            删除文件(path)
            提示("导入成功")
           else
            return 提示("导入失败 请检查是否导出或误删文件")
          end

      end},
      {src=图标("info"),text="导出",onClick=function()
          if Build.VERSION.SDK_INT <30 then
            return 提示("该功能只提供安卓10以上版本使用")
          end

          local result=get_write_permissions(true)
          if result~=true then
            return false
          end

          local path=activity.getSharedData("savepath") or sdcarddir

          if 文件夹是否存在(path)~=true then
            创建文件夹(path)
          end

          task(function()
            local sdcarddir=Environment.getExternalStorageDirectory().toString()
            local filesdir=activity.getExternalFilesDir(nil).toString()
            local path=activity.getSharedData("savepath") or sdcarddir
            ZipUtil.zip(filesdir.."/Hydrogen",path)
          end)
          提示("导出成功,导出文件在"..path.."/Hydrogen.zip")
      end},
      {src=图标("info"),text="问题",onClick=function()
          Snakebar("文件保存在"..内置存储("Hydrogen/download"))
      end},
    }
  })
end)