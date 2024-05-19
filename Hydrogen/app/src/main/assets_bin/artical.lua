require "import"
import "mods.muk"
import "android.view.animation.ScaleAnimation"
import "androidx.swiperefreshlayout.widget.*"

activity.setContentView(loadlayout("layout/artical"))

设置toolbar(toolbar)

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

back.onClick=function()
  动画消失(back_root)
  if is_star==true then
    _star.setColorFilter(PorterDuffColorFilter(转0x(primaryc),PorterDuff.Mode.SRC_ATOP));
   else
    _star.setColorFilter(PorterDuffColorFilter(转0x(textc),PorterDuff.Mode.SRC_ATOP));
  end
  atitle.Text=backtitle
  atext.Text=backtext
  aauthor.text=backauthor
end

function 获取随机一文()
  local api="http://htwinkle.cn/article"
  Http.get(api, function(code, content)
    if code == 200 and content then
      local title,author,art
      title = content:match("<h2 class=\"title\">(.-)</h2>")
      author = content:match("<h3 class=\"author\">作者&nbsp;&nbsp;(.-)</h3>")
      art = content:match("1.0rem\">(.-)</p></div>")
      art = art:gsub("<p>", "   ")
      art = art:gsub("</p>", "")
      atitle.text=title
      aauthor.text=author
      atext.text=art
      backtitle=atitle.text
      backtext=atext.text
      backauthor=aauthor.text
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
    local addstr
    if aauthor.text and aauthor.text~="未知" then
      addstr=" (作者:"..aauthor.text..")"
     else
      addstr=""
    end
    创建文件(内置存储文件("Note/"..atitle.text..addstr))
    写入文件(内置存储文件("Note/"..atitle.text..addstr),atext.text)
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
  if back_root.Visibility==0 then
    back_root.Visibility=8
    _star.setColorFilter(PorterDuffColorFilter(转0x(textc),PorterDuff.Mode.SRC_ATOP));
  end
  获取随机一文()
end

noteitem=获取适配器项目布局("note/note")
notedata={}
noteadp=LuaAdapter(activity,notedata,noteitem)
notelist.setAdapter(noteadp)

function 加载笔记()
  local result=get_write_permissions()
  if result~=true then
    return false
  end
  notedata={}
  for i,v in ipairs(luajava.astable(File(内置存储文件("Note")).listFiles())) do
    local v=tostring(v)
    local _,name=v:match("(.+)/(.+)")
    local content=读取文件(v)
    local first_line=content:sub(1, content:find("\n") - 1)
    local author=first_line:match("文章作者:(.+)")
    local preview
    if author then
      preview=content:match("\n(.+)")
      name=name.." (作者:"..author..")"
     else
      preview=content
    end
    notedata[#notedata+1]={title=name,text=(v),preview=preview}
  end
  noteadp=LuaAdapter(activity,notedata,noteitem)
  notelist.setAdapter(noteadp)
end

加载笔记()

notelist.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(id,v,zero,one)
    local mtext=v.Tag.title.Text
    local author
    if mtext:find("作者:") then
      author=mtext:match("作者:(.-)%)")
      mtext=mtext:match("(.+) %(")
     else
      author="未知"
    end
    atitle.Text=mtext
    atext.Text=v.Tag.preview.Text
    aauthor.text=author
    artical_page.setCurrentItem(0,false)
    动画出现(back_root)
    _star.setColorFilter(PorterDuffColorFilter(转0x(primaryc),PorterDuff.Mode.SRC_ATOP));
end})


notelist.setOnItemLongClickListener(AdapterView.OnItemLongClickListener{
  onItemLongClick=function(id,v,zero,one)
    local _,name=v.Tag.text.Text:match("(.+)/(.+)")
    双按钮对话框("确认要删除 "..name.." 吗？","此操作不可撤销","确认删除","取消",function(an)
      删除文件(v.Tag.text.Text)
      加载笔记()
      关闭对话框(an)
    end,function(an)关闭对话框(an)end)
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

function checktitle(str)
  local oridata=notelist.adapter.getData()
  for b=1,2 do
    if b==2 then
      提示("搜索完毕 共搜索到"..#notelist.adapter.getData().."条数据\n提示：上拉可刷新列表")
      if #notelist.adapter.getData()==0 then
        加载笔记()
        notelist.adapter.notifyDataSetChanged()
      end
    end
    for i=#oridata,1,-1 do
      if not oridata[i].title:find(str) then
        table.remove(oridata, i)
      end
      notelist.adapter.notifyDataSetChanged()
    end
  end
end


task(1,function()
  a=MUKPopu({
    tittle="一文",
    list={
      {src=图标("share"),text="随机一文",onClick=function()
          _title.Text="随机一文"
          atitle.text="加载中.."
          atext.text=""
          获取随机一文()
          click=0
          _star.setColorFilter(PorterDuffColorFilter(转0x(textc),PorterDuff.Mode.SRC_ATOP));
      end},
      {src=图标("search"),text="搜索保存内容",onClick=function()
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
    }
  })
end)

if activity.getSharedData("一文提示0.01")==nil
  AlertDialog.Builder(this)
  .setTitle("小提示")
  .setCancelable(false)
  .setMessage("你可点击标题来切换刷新一文类型")
  .setPositiveButton("我知道了",{onClick=function() activity.setSharedData("一文提示0.01","true") end})
  .show()
end