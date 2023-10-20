require "import"
import "mods.muk"
import "com.lua.*"

collections_id,isfollow=...

activity.setContentView(loadlayout("layout/collections"))

if collections_id=="local" then
  collections_url=collections_id
  collections_id=nil
  _title.Text="本地收藏"
 else
  collections_url="https://api.zhihu.com/collections/"..collections_id.."/contents?with_deleted=1&offset=0"

  zHttp.get("https://api.zhihu.com/collections/"..collections_id.."?with_deleted=1&censor=1",head,function(code,content)
    if code==200 then--判断网站状态
      data=luajson.decode(content).collection
      _title.Text=data.title
      if isfollow then
        local mview=mpop.list[3]
        mview.onClick=function(text)
          if text=="关注" then
            zHttp.post("https://api.zhihu.com/collections/"..collections_id.."/followers","",posthead,function(code,json)
              if code==200 then
                mview.src=图标("close")
                mview.text="取关"
                提示("已关注")
                a=MUKPopu(mpop)
                activity.setResult(1600,nil)
              end
            end)
           else
            zHttp.delete("https://api.zhihu.com/collections/"..collections_id.."/followers/"..activity.getSharedData("idx"),head,function(code,json)
              if code==200 then
                提示("已取关")
                mview.src=图标("add")
                mview.text="关注"
                a=MUKPopu(mpop)
                activity.setResult(1600,nil)
              end
            end)
          end
        end
        if data.is_following then
          mview.src=图标("close")
          mview.text="取关"
         else
          mview.src=图标("add")
          mview.text="关注"
        end
        a=MUKPopu(mpop)

      end
     else
      --错误时的操作
    end
  end)

end

初始化历史记录数据(true)

波纹({fh,_more},"圆主题")

itemc5=获取适配器项目布局("collections/collections")

local_item=获取适配器项目布局("collections/local")

--判断收藏为本地
if collections_url=="local" then

  if not 文件是否存在(内置存储文件()) then
    xpcall(function()
      创建文件夹(内置存储文件())
      end,function()
    end)
  end
  if not 文件夹是否存在(内置存储文件("Collection/")) then
    xpcall(function()
      创建文件夹(内置存储文件("Collection/"))
      end,function()
    end)
  end


  function 加载笔记()
    notedata={}
    if #luajava.astable(File(内置存储文件("Collection/")))==0 then
      提示("你没有在本地收藏任何内容")
      activity.finish()
    end
    for i,v in ipairs(luajava.astable(File(内置存储文件("Collection/")).listFiles())) do
      local v=tostring(v)
      local _,name=v:match("(.+)/(.+)")
      notedata[#notedata+1]={
        catitle=name,
        file=(v),
      }
    end

    noteadp=LuaAdapter(activity,notedata,local_item)
    list5.setAdapter(noteadp)

  end

  加载笔记()

  function 本地列表(path)

    import "com.google.android.material.bottomsheet.*"

    if 全局主题值=="Day" then
      bwz=0x3f000000
     else
      bwz=0x3fffffff
    end

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
        id="ztbj";
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
          Text="选择回答者";
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
            CardView;
            layout_width="-2";
            layout_height="-2";
            radius="2dp";
            background="#00000000";
            layout_marginTop="8dp";
            layout_marginLeft="8dp";
            layout_marginBottom="24dp";
            Elevation="0";
            onClick=qxnr;
            {
              TextView;
              layout_width="-1";
              layout_height="-2";
              textSize="16sp";
              Typeface=字体("product-Bold");
              paddingRight="16dp";
              paddingLeft="16dp";
              paddingTop="8dp";
              paddingBottom="8dp";
              Text=qx;
              textColor=stextc;
              BackgroundDrawable=activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{bwz}));
            };
          };
          {
            CardView;
            layout_width="-2";
            layout_height="-2";
            radius="4dp";
            CardBackgroundColor=primaryc;
            layout_marginTop="8dp";
            layout_marginLeft="8dp";
            layout_marginRight="24dp";
            layout_marginBottom="24dp";
            Elevation="1dp";
            onClick=qdnr;
            {
              TextView;
              layout_width="-1";
              layout_height="-2";
              textSize="16sp";
              paddingRight="16dp";
              paddingLeft="16dp";
              Typeface=字体("product-Bold");
              paddingTop="8dp";
              paddingBottom="8dp";
              Text="关闭";
              onClick=function()
                an.dismiss()
              end,

              textColor=backgroundc;
              BackgroundDrawable=activity.Resources.getDrawable(ripples).setColor(ColorStateList(int[0].class{int{}},int{bwz}));
            };
          };
        };
      };
    };


    local bottomSheetDialog = BottomSheetDialog(this)
    bottomSheetDialog.setContentView(loadlayout(dann))
    an=bottomSheetDialog.show()
    datas={}
    for v,s in pairs(luajava.astable(File(内置存储文件("Collection/"..path.."/")).listFiles())) do
      table.insert(datas,s.Name)
    end
    array_adp=ArrayAdapter(activity,android.R.layout.simple_list_item_1,String(datas))
    --设置适配器
    listview.setAdapter(array_adp)

    listview.setOnItemClickListener(AdapterView.OnItemClickListener{
      onItemClick=function(id,v,zero,one)
        local open=activity.getSharedData("内部浏览器查看回答")
        local filestr=io.open(内置存储文件("Collection/"..path.."/"..v.Text.."/".."detail.txt"))
        local id=tostring(filestr:read("*a"):match[[question_id="(.-)"]]).."分割"..tostring(io.open(内置存储文件("Collection/"..path.."/"..v.Text.."/".."detail.txt")):read("*a"):match[[answer_id="(.-)"]])
        if open=="false" then
          activity.newActivity("answer",{tostring(id):match("(.+)分割"),tostring(id):match("分割(.+)")})
         else
          activity.newActivity("huida",{"https://www.zhihu.com/question/"..tostring(id):match("(.+)分割").."/answer/"..tostring(id):match("分割(.+)")})
        end
        an.dismiss()
    end})

  end


  list5.setOnItemClickListener(AdapterView.OnItemClickListener{
    onItemClick=function(parent,v,pos,id)
      本地列表(v.Tag.catitle.Text)

    end
  })
  list5.setOnItemLongClickListener(AdapterView.OnItemLongClickListener{
    onItemLongClick=function(id,v,zero,one)
      双按钮对话框("删除","删除该问题？该操作不可撤消！","是的","点错了",function(an)删除文件(内置存储文件("Collection/"..v.Tag.catitle.Text))
        an.dismiss()
        加载笔记()
        提示("已删除")end,function(an)an.dismiss()end)
      return true
  end})

  --判断收藏不为本地
 else

  local yuxunnn_ay=LuaAdapter(activity,datas5,itemc5)
  list5.Adapter=yuxunnn_ay

  function 初始化()
    collections_base=require "model.collections":new(collections_url)
    :setresultfunc(function(tab)

      if tab.type=="answer" then
        点赞数=tointeger(tab.voteup_count)..""
        评论数=tointeger(tab.comment_count)..""
        内容=tab.excerpt
        标题=tab.question.title
        id分割=tointeger(tab.question.id).."回答分割"..tointeger(tab.id)
       elseif tab.type=="article" then
        点赞数=tointeger(tab.voteup_count)..""
        评论数=tointeger(tab.comment_count)..""
        内容=tab.excerpt
        标题=tab.title
        id分割="文章分割"..tointeger(tab.id)
        yuxunnn_ay.add{
          cavoteup=点赞数,
          cacomment=评论数,
          cid=id分割,
          caart=内容,
          catitle=标题,
          background={foreground=Ripple(nil,转0x(ripplec),"方")},
        }
        return
       elseif tab.type=="pin" then

        内容=tab.excerpt_title
        点赞数=tointeger(tab.collection_count)..""
        评论数=tointeger(tab.comment_count)..""
        标题="一个想法"
        id分割="想法分割"..tab.id
       elseif tab.type=="zvideo" then

        内容=tab.excerpt_title
        点赞数=tointeger(tab.collection_count)..""
        评论数=tointeger(tab.comment_count)..""
        标题=tab.title
        id分割="视频分割"..tab.id
       else
        id分割="其他分割"..tointeger(v.target.id)
        标题=tab.title
      end
      yuxunnn_ay.add{
        cavoteup=点赞数,
        cacomment=评论数,
        cid=id分割,
        caart=内容,
        catitle=标题,
        background={foreground=Ripple(nil,转0x(ripplec),"方")},
      }
    end)
  end

  初始化()

  function 刷新()
    collections_base:next(function(r,a)
      if not(r) and collections_base.is_end==false then
        提示("获取收藏列表出错 "..a or "")
       else
        --刷新
        isadd=true
      end
    end)
  end

  isadd=true
  list5.setOnScrollListener{
    onScroll=function(view,a,b,c)
      if a+b==c and isadd then
        isadd=false
        刷新()
        System.gc()
      end
    end
  }

  list5.setOnItemClickListener(AdapterView.OnItemClickListener{
    onItemClick=function(parent,v,pos,id)

      local open=activity.getSharedData("内部浏览器查看回答")


      if tostring(v.Tag.cid.text):find("文章分割") then
        activity.newActivity("column",{tostring(v.Tag.cid.Text):match("文章分割(.+)")})
       elseif tostring(v.Tag.cid.text):find("想法分割") then
        activity.newActivity("column",{tostring(v.Tag.cid.Text):match("想法分割(.+)"),"想法"})
       elseif tostring(v.Tag.cid.text):find("视频分割") then
        activity.newActivity("column",{tostring(v.Tag.cid.Text):match("视频分割(.+)"),"视频"})
       else
        保存历史记录(v.Tag.catitle.Text,v.Tag.cid.Text,50)
        if open=="false" then
          activity.newActivity("answer",{tostring(v.Tag.cid.Text):match("(.+)回答分割"),tostring(v.Tag.cid.Text):match("回答分割(.+)")})
         else
          activity.newActivity("huida",{"https://www.zhihu.com/question/"..tostring(v.Tag.cid.Text):match("(.+)分割").."/answer/"..tostring(v.Tag.cid.Text):match("分割(.+)")})
        end
      end
    end
  })

  list5.setOnItemLongClickListener(AdapterView.OnItemLongClickListener{
    onItemLongClick=function(id,v,zero,one)
      if isfollow then
        return true
      end
      双按钮对话框("取消收藏","取消收藏该问题？该操作不可撤消！","是的","点错了",function(an)
        an.dismiss()
        if tostring(v.Tag.cid.text):find("回答分割") then
          删除类型="answer"
         elseif tostring(v.Tag.cid.text):find("文章分割") then
          删除类型="article"
         elseif tostring(v.Tag.cid.text):find("想法分割") then
          删除类型="pin"
         elseif tostring(v.Tag.cid.text):find("视频分割") then
          删除类型="zvideo"
        end
        zHttp.delete(collections_url:match("(.+)/answer").."/contents/"..v.Tag.cid.Text:match("分割(.+)").."?content_type="..删除类型,head,function(code,json)
          if code==200 then
            提示("已删除")
            activity.setResult(1600,nil)
            list5.adapter.remove(zero)
            list5.adapter.notifyDataSetChanged()
          end
        end)
      end,function(an)an.dismiss()end)
      return true
  end})


end


--有时间再补充 api接口请求头需要一些参数被加密 k实现同种功能可无限zHttp.get获取内容 后直到is_end 再执行搜索
function checktitle(str)
  local oridata=list5.adapter.getData()

  for b=1,2 do
    if b==2 then
      提示("搜索完毕 共搜索到"..#list5.adapter.getData().."条数据")
      if #list5.adapter.getData()==0 then
        if collections_url=="local" then
          加载笔记()
        end
        list5.adapter.notifyDataSetChanged()
      end
    end
    for i=#oridata,1,-1 do
      if not oridata[i].catitle:find(str) then
        table.remove(oridata, i)
      end
      list5.adapter.notifyDataSetChanged()
    end
  end
end

task(1,function()
  mpop={
    tittle="收藏",
    list={
      {
        src=图标("search"),text="在当前内容中搜索",onClick=function()
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

      {src=图标("close"),text="删除收藏夹",onClick=function()
          if not(collections_id) then
            return 提示("本地收藏不支持此功能")
          end
          双按钮对话框("删除收藏夹","删除收藏夹？该操作不可撤消！","是的","点错了",function(an)
            an.dismiss()
            zHttp.delete("https://api.zhihu.com/collections/"..collections_id,head,function(code,json)
              if code==200 then
                提示("已删除")
                activity.setResult(1600,nil)
              end
            end)
          end,function(an)an.dismiss()end)
      end},
      {
        src=图标("close"),text="举报",onClick=function()
          if not(collections_id) then
            return 提示("本地收藏不支持此功能")
          end
          local url="https://www.zhihu.com/report?id="..collections_id.."&type=favlist"
          activity.newActivity("huida",{url.."&source=android&ab_signature=",nil,nil,nil,"举报"})
        end
      },
    }
  }
  a=MUKPopu(mpop)
end)

function onActivityResult(a,b,c)
  if b==100 then
    if collections_url~="local" then
      collections_base:clear()
      初始化()
      list5.adapter.clear()
    end
  end
end