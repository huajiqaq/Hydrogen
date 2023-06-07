require "import"
import "mods.muk"
import "android.view.animation.ScaleAnimation"

activity.setContentView(loadlayout("layout/artical"))

波纹({fh,_star,_refre,_folder},"圆主题")
波纹({title_root,back},"方主题")

控件隐藏(back_root)

if not 文件是否存在(内置存储文件()) then
  xpcall(function()
    创建文件夹(内置存储文件())
    end,function()
  end)
end
if not 文件是否存在(内置存储文件("Note")) then
  xpcall(function()
    创建文件夹(内置存储文件("Note"))
    end,function()
  end)
end

function 动画消失(back)
  back.startAnimation(ScaleAnimation(1.0, 0.0, 1.0, 0.0,1, 0.5, 1, 0.5).setDuration(200))
  back.setVisibility(View.INVISIBLE)
end
function 动画出现(back)
  back.setVisibility(View.VISIBLE)
  back.startAnimation(ScaleAnimation(0.0, 1.0, 0.0, 1.0,1, 0.5, 1, 0.5).setDuration(300))
end
function 申请权限()
  import "android.content.pm.PackageManager"
  local mAppPermissions = ArrayList();

  权限="android.permission.WRITE_EXTERNAL_STORAGE"
  mAppPermissions.add(权限);

  local size = mAppPermissions.size();
  local mArray = mAppPermissions.toArray(String[size])
  activity.requestPermissions(mArray,0);
end


back.onClick=function()
  动画消失(back_root)
  if is_star==true then
    _star.setColorFilter(PorterDuffColorFilter(转0x(primaryc),PorterDuff.Mode.SRC_ATOP));
   else
    _star.setColorFilter(PorterDuffColorFilter(转0x(textc),PorterDuff.Mode.SRC_ATOP));
  end
  atitle.Text=backtitle
  atext.Text=backtext
end


function 获取每日一文()
  local api="https://interface.meiriyiwen.com/article/today?dev=1"
  Http.get(api,head,function(code,content)
    if code==200 then
      一文模式="每日"
      data=require "cjson".decode(content)
      atitle.text=data.data.title
      atext.text=Html.fromHtml(data.data.content)
      backtitle=atitle.text
      backtext=atext.text
    end
  end)
end




function 获取随机一文()
  local api="https://interface.meiriyiwen.com/article/random?dev=1"
  Http.get(api,head,function(code,content)
    if code==200 then
      一文模式="随机"
      data=require "cjson".decode(content)
      atitle.text=data.data.title
      atext.text=Html.fromHtml(data.data.content)
      backtitle=atitle.text
      backtext=atext.text
    end
  end)
end
获取随机一文()

local click=0
_star.onClick=function()
  if click==0 then
    click=1
   elseif click==1 then
    click=0
  end
  if click==1 then
    _star.setColorFilter(PorterDuffColorFilter(转0x(primaryc),PorterDuff.Mode.SRC_ATOP));
    创建文件(内置存储文件("Note/"..atitle.text))
    写入文件(内置存储文件("Note/"..atitle.text),atext.text)
    if _title.Text=="每日一文"then
      is_star=true
    end
    加载笔记()
   elseif click==0 then
    if _title.Text=="每日一文"then
      is_star=false
    end
    _star.setColorFilter(PorterDuffColorFilter(转0x(textc),PorterDuff.Mode.SRC_ATOP));
    删除文件(内置存储文件("Note/"..atitle.text))
    加载笔记()
  end
end

_refre.onClick=function()
  if 一文模式=="每日" then
    获取每日一文()
   else
    获取随机一文()
  end
end


noteitem={
  LinearLayout;
  layout_width="-1";
  layout_height="-2";
  orientation="vertical";
  BackgroundColor=backgroundc;
  {
    CardView;
    layout_gravity="center";
    layout_height="-2";
    CardBackgroundColor=cardedge,
    Elevation="0";
    layout_width="fill";
    layout_margin="16dp";
    layout_marginTop="8dp";
    layout_marginBottom="8dp";
    radius="8dp";
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
        ripple="圆自适应",

        layout_width="fill";
        {
          LinearLayout;
          layout_width="-1";
          layout_height="-1";
          orientation="vertical";
          padding="16dp";
          {
            TextView;
            textColor=textc;
            textSize="14sp";
            gravity="center|left";
            Typeface=字体("product-Bold");
            id="title";
          };
          {
            TextView;
            textColor=stextc;
            textSize="12sp";
            gravity="center|left";
            Typeface=字体("product");
            layout_marginTop="12dp";
            MaxLines=2;
            ellipsize="end";
            id="preview";
          };
          {
            TextView;
            id="text";
            --maxLines=3;
            layout_width="0";
            layout_height="0";
          };
        };
      };
    };
  };
};


notedata={}
noteadp=LuaAdapter(activity,notedata,noteitem)
notelist.setAdapter(noteadp)

function 加载笔记()
  xpcall(function()
    notedata={}
    for i,v in ipairs(luajava.astable(File(内置存储文件("Note")).listFiles())) do
      local v=tostring(v)
      local _,name=v:match("(.+)/(.+)")
      notedata[#notedata+1]={title=name,text=(v),preview=读取文件(v)}
    end
    noteadp=LuaAdapter(activity,notedata,noteitem)
    notelist.setAdapter(noteadp)
    end,function()
    双按钮对话框("权限","需要存储权限才可以收藏文章 即使卸载文章也会保存在本地","给","不给",function()关闭对话框(an)申请权限() end,function()关闭对话框(an)end)
  end)
end

加载笔记()

notelist.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(id,v,zero,one)
    atitle.Text=v.Tag.title.Text
    atext.Text=v.Tag.preview.Text
    artical_page.showPage(0)
    动画出现(back_root)
    _star.setColorFilter(PorterDuffColorFilter(转0x(primaryc),PorterDuff.Mode.SRC_ATOP));
end})


notelist.setOnItemLongClickListener(AdapterView.OnItemLongClickListener{
  onItemLongClick=function(id,v,zero,one)
    local _,name=v.Tag.text.Text:match("(.+)/(.+)")
    双按钮对话框("确认要删除 "..name.." 吗？","此操作不可撤销","确认删除","取消",function()
      删除文件(v.Tag.text.Text)
      加载笔记()
      关闭对话框(an)
    end,function()关闭对话框(an)end)
    return true
end})




artical_list_sr.setProgressBackgroundColorSchemeColor(转0x(backgroundc));
artical_list_sr.setColorSchemeColors({转0x(primaryc)});
artical_list_sr.setOnRefreshListener(SwipeRefreshLayout.OnRefreshListener{onRefresh=function()
    加载笔记()
    Handler().postDelayed(Runnable({
      run=function()
        artical_list_sr.setRefreshing(false); end,
    }),300)
end})

a=MUKPopu({
  tittle="一文",
  list={
    {src=图标("share"),text="每日一文",onClick=function()
        _title.Text="每日一文"
        atitle.text="加载中.."
        atext.text=""
        获取每日一文()
        if is_star==true then
          _star.setColorFilter(PorterDuffColorFilter(转0x(primaryc),PorterDuff.Mode.SRC_ATOP));
         else
          _star.setColorFilter(PorterDuffColorFilter(转0x(textc),PorterDuff.Mode.SRC_ATOP));
        end
    end},
    {src=图标("share"),text="随机一文",onClick=function()
        _title.Text="随机一文"
        atitle.text="加载中.."
        atext.text=""
        获取随机一文()
        click=0
        _star.setColorFilter(PorterDuffColorFilter(转0x(textc),PorterDuff.Mode.SRC_ATOP));
    end},
  }
})

if activity.getSharedData("一文提示0.01")==nil
  AlertDialog.Builder(this)
  .setTitle("小提示")
  .setCancelable(false)
  .setMessage("你可点击标题来切换刷新一文类型")
  .setPositiveButton("我知道了",{onClick=function() activity.setSharedData("一文提示0.01","true") end})
  .show()
end