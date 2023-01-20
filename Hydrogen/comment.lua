require "import"
import "android.widget.*"
import "android.view.*"
import "com.michael.NoScrollListView"
import "mods.muk"
import "android.text.method.LinkMovementMethod"
activity.setContentView(loadlayout("layout/comment"))

comment_id,comment_type,answer_title,answer_author,comment_count=...
波纹({fh,_more},"圆主题")

local function setstyle(styleee)
  stylee = SpannableStringBuilder(styleee);
  local len= stylee.length()
  local urltab=luajava.astable(stylee.getSpans(0, len,URLSpan))
  local function Myspan(b)
    local myspan=ClickableSpan{
      onClick=function(v)
        检查链接(urltab[b].getURL())
      end,
      updateDrawState=function(v)
        v.setColor(v.linkColor);
        v.setUnderlineText(true);
      end
    }
    return myspan
  end
  if #urltab>0 then
    stylee.clearSpans()
    for i=1,#urltab do
      stylee.setSpan(Myspan(i), styleee.getSpanStart(urltab[i]), styleee.getSpanEnd(urltab[i]), Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
    end
    return stylee
  end
end

local function savecommentfile()
  if id~="没有id" and _title.text~="对话列表" then
    if 文件是否存在(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/mht.mht"))then
      三按钮对话框("收藏","收藏这该条评论还是整个对话列表？","该评论","整个对话列表","点错了",function()
        if 文件是否存在(内置存储文件("Download/"..answer_title:gsub("/","or")..":"..answer_author.."/comment.txt"))then
          写入文件(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/comment.txt"),[[
author="]]..名字..[["=}"
]]..[[
content="]]..setstyle(Html.fromHtml(内容))..[["=}"]])
          an.dismiss()
          提示("已收藏")
         else
          创建文件(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/comment.txt"))
          追加更新文件(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/comment.txt"),[[
]]..[[
author="]]..名字..[["=}"
]]..[[
content="]]..setstyle(Html.fromHtml(内容))..[["=}"]])
          an.dismiss()
          提示("已收藏")
        end
      end,
      function()
        Http.get("https://api.zhihu.com/comments/"..id.."/conversation",
        获取Cookie("https://www.zhihu.com/"),
        function(code,content)
          if code=="-1" then
            an.dismiss()
            提示("保存失败 可能是网络原因")
           else
            if 文件夹是否存在(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/".."fold/"))then
              if 文件是否存在(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/".."fold/"..名字.."+"..id))then
                提示("您已收藏过该对话列表")
               else
                创建文件(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/".."fold/"..名字.."+"..id))
                写入文件(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/".."fold/"..名字.."+"..id),content)
                an.dismiss()
                提示("收藏成功")
              end
             else
              创建文件夹(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/".."fold/"))
              创建文件(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/".."fold/"..名字.."+"..id))
              写入文件(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/".."fold/"..名字.."+"..id),content)
              提示("收藏成功")
              an.dismiss()

            end
          end
        end)
      end,
      function()
        an.dismiss()
      end)
     else
      提示("先保存回答 才可以收藏评论")
    end
   else
    if 文件是否存在(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/mht.mht"))then
      双按钮对话框("收藏","收藏这条评论？","是的","点错了",function()
        if 文件是否存在(内置存储文件("Download/"..answer_title:gsub("/","or")..":"..answer_author.."/comment.txt"))then
          写入文件(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/comment.txt"),[[
author="]]..名字..[["=}"
]]..[[
content="]]..setstyle(Html.fromHtml(内容))..[["=}"]])
          an.dismiss()
          提示("已收藏")
         else
          创建文件(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/comment.txt"))
          追加更新文件(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/comment.txt"),[[
]]..[[
author="]]..名字..[["=}"
]]..[[
content="]]..setstyle(Html.fromHtml(内容))..[["=}"]])
          an.dismiss()
          提示("已收藏")
      end end,
      function()an.dismiss()end)
     else
      提示("先保存回答 才可以收藏评论")
    end
  end
  return true
end


function 刷新()
  comment_itemc=
  {
    LinearLayout;
    layout_width="-1";
    id="commentrootview";
    BackgroundColor=backgroundc;
    {
      CardView;
      Elevation="0";
      layout_gravity="center";
      CardBackgroundColor=cardedge,
      layout_margin="0dp";
      layout_height="-2";
      layout_width="-1";
      radius="0dp";
      {
        CardView;
        CardElevation="0dp";
        CardBackgroundColor=backgroundc;
        Radius="0dp";
        --       layout_margin="4px";
        layout_margin=cardmargin;
        layout_width="-1";
        layout_height="-1";

        {
          TextView;
          textSize="0sp";
          id="comment_id",
        };
        {
          LinearLayout;
          layout_height="fill";
          id="background";
          layout_width="fill";
          ripple="圆自适应",
          {
            LinearLayout;
            padding="24dp";
            paddingTop="16dp";
            paddingBottom="16dp";
            layout_height="fill";
            layout_width="fill";
            orientation="vertical";
            {
              LinearLayout;
              orientation="horizontal";
              gravity="left|center",
              {
                CircleImageView;
                id="comment_image",
                layout_width="24dp",
                layout_height="24dp",
              };
              {
                TextView;
                layout_marginLeft="8dp",
                textSize="14sp";
                id="comment_author",
                Typeface=字体("product-Bold");
                textColor=textc;
              };
            };
            {
              LinearLayout;
              layout_marginTop="10dp",
              layout_width="-1",
              orientation="vertical";
              {
                TextView;
                Typeface=字体("product");
                textColor=stextc;
                id="comment_art",

                textSize="12sp";
              };
              {
                LinearLayout;
                orientation="horizontal";
                layout_marginTop="8dp",
                layout_marginBottom="0dp",
                gravity="bottom";
                layout_gravity="bottom";
                layout_width="fill",
                {
                  TextView;
                  layout_weight="1",
                  gravity="left";
                  Typeface=字体("product");
                  textColor=stextc;
                  textSize="12sp";
                  id="comment_time",
                };
                {
                  TextView;
                  Typeface=字体("product");
                  textColor=textc;
                  id="comment_toast",
                  textSize="12sp";
                  textColor="#FF767676",
                  gravity="right";
                  text="查看对话列表",
                };
                {
                  layout_marginLeft="10dp",
                  ImageView;
                  layout_gravity="right",
                  layout_height="16dp",
                  layout_width="16dp",
                  src=图标("vote_up"),
                  ColorFilter=textc;
                };
                {
                  layout_marginLeft="3dp",
                  TextView;
                  Typeface=字体("product");
                  textColor=stextc;
                  id="comment_vote",
                  textSize="12sp";
                  gravity="right";
                  text="",
                };
              };
            }
          };
        };
      };
    };
  };

  comment_adp=LuaAdapter(activity,comment_datas,comment_itemc)
  comment_list.Adapter=comment_adp

  comment_base=require "model.comment"
  :new(comment_id,comment_type)
  :setresultfunc(function(v)
    local 头像=v.author.member.avatar_url
    local 内容=v.content
    local 点赞数=tointeger(v.vote_count)
    --[[    if 点赞数==0 then
      comment_vote.setVisibility(8)
    end
    ]]
    local 时间=时间戳(v.created_time)
    local 名字,id=v.author.member.name,"没有id"
    local function isauthor(v)
      local a=""
      if v.role=="author" then
        a=" (作者) "
      end
      return v.member.name..a
    end
    pcall(function()
      名字=isauthor(v.author).. "  →  "..isauthor(v.reply_to_author)
      if _title.text~="对话列表" then id=tointeger(v.id) end
    end)
    if 内容:find("https?://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]") then
      评论链接=内容:match("https?://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]")
      comment_list.Adapter.add{comment_toast={Visibility=(id=="没有id" and 8 or 0)},comment_id=id,comment_art={Text=setstyle(Html.fromHtml(内容)),MovementMethod=LinkMovementMethod.getInstance()},comment_author=名字,comment_image=头像,comment_time=时间,comment_vote=点赞数,commentrootview={onLongClick=function() savecommentfile() 提示(comment_id.Text) end,onClick=function() if id~="没有id" and _title.text~="对话列表" then activity.newActivity("comment",{id,"comments",answer_title,answer_author}) end end}}
     else
      comment_list.Adapter.add{comment_toast={Visibility=(id=="没有id" and 8 or 0)},comment_id=id,comment_art=Html.fromHtml(内容),comment_author=名字,comment_image=头像,comment_time=时间,comment_vote=点赞数}
    end
  end)


  function 评论刷新()
    comment_base:next(function(r,a)
      if r==false and comment_base.is_end==false then
        if a then
          decoded_content = require "cjson".decode(a)
          if decoded_content.error and decoded_content.error.message and decoded_content.error.redirect then
            AlertDialog.Builder(this)
            .setTitle("提示")
            .setMessage(decoded_content.error.message)
            .setCancelable(false)
            .setPositiveButton("立即跳转",{onClick=function() activity.newActivity("huida",{decoded_content.error.redirect}) 提示("已跳转 成功后请自行退出") end})
            .show()
           else
            提示("获取评论列表出错 "..a)
          end
        end
        --      评论刷新()
       else
        if _title.text=="评论" then
          if comment_type~="pins" then
            _title.text=string.format("共%s条评论",comment_base.common_counts )
           else
            _title.text=string.format("共%s条评论",comment_count)
          end
        end
      end
    end)
  end



  评论刷新()

  comment_list.setOnItemClickListener(AdapterView.OnItemClickListener{
    onItemClick=function(id,v,zero,one)

      if v.Tag.comment_id.text~="没有id" and _title.text~="对话列表" then
        activity.newActivity("comment",{ v.Tag.comment_id.text,"comments",answer_title,answer_author})
      end
  end})


  comment_list.setOnItemLongClickListener(AdapterView.OnItemLongClickListener{
    onItemLongClick=function(id,v,zero,one)
      if v.Tag.comment_id.text~="没有id" and _title.text~="对话列表" then
        if 文件是否存在(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/mht.mht"))then
          三按钮对话框("收藏","收藏这该条评论还是整个对话列表？","该评论","整个对话列表","点错了",function()
            if 文件是否存在(内置存储文件("Download/"..answer_title:gsub("/","or")..":"..answer_author.."/comment.txt"))then
              写入文件(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/comment.txt"),[[
author="]]..v.Tag.comment_author.text..[["=}"
]]..[[
content="]]..v.Tag.comment_art.text..[["=}"]])
              an.dismiss()
              提示("已收藏")
             else
              创建文件(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/comment.txt"))
              追加更新文件(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/comment.txt"),[[
]]..[[
author="]]..v.Tag.comment_author.text..[["=}"
]]..[[
content="]]..v.Tag.comment_art.text..[["=}"]])
              an.dismiss()
              提示("已收藏")
            end
          end,
          function()
            Http.get("https://api.zhihu.com/comments/"..v.Tag.comment_id.text.."/conversation",
            获取Cookie("https://www.zhihu.com/"),
            function(code,content)
              if code=="-1" then
                an.dismiss()
                提示("保存失败 可能是网络原因")
               else
                if 文件夹是否存在(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/".."fold/"))then
                  if 文件是否存在(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/".."fold/"..v.Tag.comment_author.text.."+"..v.Tag.comment_id.text))then
                    提示("您已收藏过该对话列表")
                   else
                    创建文件(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/".."fold/"..v.Tag.comment_author.text.."+"..v.Tag.comment_id.text))
                    写入文件(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/".."fold/"..v.Tag.comment_author.text.."+"..v.Tag.comment_id.text),content)
                    an.dismiss()
                    提示("收藏成功")
                  end
                 else
                  创建文件夹(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/".."fold/"))
                  创建文件(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/".."fold/"..v.Tag.comment_author.text.."+"..v.Tag.comment_id.text))
                  写入文件(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/".."fold/"..v.Tag.comment_author.text.."+"..v.Tag.comment_id.text),content)
                  提示("收藏成功")
                  an.dismiss()

                end
              end
            end)
          end,
          function()
            an.dismiss()
          end)
         else
          提示("先保存回答 才可以收藏评论")
        end
       else
        if 文件是否存在(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/mht.mht"))then
          双按钮对话框("收藏","收藏这条评论？","是的","点错了",function()
            if 文件是否存在(内置存储文件("Download/"..answer_title:gsub("/","or")..":"..answer_author.."/comment.txt"))then
              写入文件(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/comment.txt"),[[
author="]]..v.Tag.comment_author.text..[["=}"
]]..[[
content="]]..v.Tag.comment_art.text..[["=}"]])
              an.dismiss()
              提示("已收藏")
             else
              创建文件(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/comment.txt"))
              追加更新文件(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/comment.txt"),[[
]]..[[
author="]]..v.Tag.comment_author.text..[["=}"
]]..[[
content="]]..v.Tag.comment_art.text..[["=}"]])
              an.dismiss()
              提示("已收藏")
          end end,
          function()an.dismiss()end)
         else
          提示("先保存回答 才可以收藏评论")
        end
      end
      return true
  end})

  isadd=true
  comment_list.setOnScrollListener{
    onScroll=function(view,a,b,c)
      if a+b==comment_list.adapter.getCount() and isadd and comment_list.adapter.getCount()>0 then
        isadd=false
        评论刷新()
        System.gc()
        Handler().postDelayed(Runnable({
          run=function()
            isadd=true
          end,
        }),1000)
      end
  end }
end


if comment_type=="comments" then
  _title.text="对话列表"
  刷新()
 elseif comment_type=="answers" then
  刷新()

 elseif comment_type=="local_chat" then
  _title.text="对话列表"

  itemc=
  {
    LinearLayout;
    layout_width="-1";
    BackgroundColor=backgroundc;
    {
      CardView;
      Elevation="0";
      layout_gravity="center";
      CardBackgroundColor=cardedge,
      layout_margin="16dp";
      layout_marginTop="8dp";
      layout_marginBottom="8dp";
      layout_height="-2";
      layout_width="-1";
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
          TextView;
          textSize="0sp";
          id="comment_id",
        };
        {
          LinearLayout;
          layout_height="fill";
          id="background";
          layout_width="fill";
          ripple="圆自适应",
          {
            LinearLayout;
            padding="8dp",
            layout_height="fill";
            layout_width="fill";
            orientation="vertical";
            {
              LinearLayout;
              orientation="horizontal";
              gravity="left|center",
              {
                TextView;
                layout_marginLeft="8dp",
                textSize="14sp";
                id="comment_author",
                Typeface=字体("product-Bold");
                textColor=textc;
              };
            };
            {
              LinearLayout;
              layout_marginTop="10dp",
              layout_width="-1",
              orientation="vertical";
              {
                TextView;
                Typeface=字体("product");
                textColor=stextc;
                id="comment_art",
                textSize="12sp";
              };
            }
          };
        };
      };
    };
  };



  yuxuan_adpqy=LuaAdapter(activity,itemc)

  comment_list.Adapter=yuxuan_adpqy

  local data=require "cjson".decode(comment_id)
  for k,v in ipairs(data.data) do
    task(50,function()yuxuan_adpqy.add{comment_author=v.author.member.name,comment_art=v.content}end)
  end




 elseif comment_type=="local" then
  _title.text="保存的评论"
  Internetnet.setVisibility(8)
  Localcomment.setVisibility(0)


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
              id="local_comment_id",
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
                id="local_comment_title",
              };
            };
          };
        };
      };
    };
  };


  comment_itemc=
  {
    LinearLayout;
    layout_width="-1";
    BackgroundColor=backgroundc;
    {
      CardView;
      Elevation="0";
      layout_gravity="center";
      CardBackgroundColor=cardedge,
      layout_margin="16dp";
      layout_marginTop="8dp";
      layout_marginBottom="8dp";
      layout_height="-2";
      layout_width="-1";
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
          TextView;
          textSize="0sp";
          id="comment_id",
        };
        {
          LinearLayout;
          layout_height="fill";
          id="background";
          layout_width="fill";
          ripple="圆自适应",
          {
            LinearLayout;
            padding="8dp",
            layout_height="fill";
            layout_width="fill";
            orientation="vertical";
            {
              LinearLayout;
              orientation="horizontal";
              gravity="left|center",
              {
                TextView;
                layout_marginLeft="8dp",
                textSize="14sp";
                id="comment_author",
                Typeface=字体("product-Bold");
                textColor=textc;
              };
            };
            {
              LinearLayout;
              layout_marginTop="10dp",
              layout_width="-1",
              orientation="vertical";
              {
                TextView;
                Typeface=字体("product");
                textColor=stextc;
                id="comment_art",
                textSize="12sp";
              };
            }
          };
        };
      };
    };
  };

  data={}
  title={}
  art={}
  --创建适配器
  comment_adp=LuaAdapter(activity,data,comment_itemc)
  --添加数据
  xxx=读取文件(内置存储文件("Download/"..answer_title:gsub("/","\\").."/"..answer_author.."/comment.txt"))
  name=xxx:gmatch([[author="(.-)"]])

  for l,q in xxx:gmatch([[author="(.-)"=}"]])do
    table.insert(title,l)
  end

  for l,q in xxx:gmatch([[content="(.-)"=}"]])do
    table.insert(art,l)
  end

  for n=1,#title do
    table.insert(data,{comment_author=title[n],comment_art=art[n]})
  end
  --设置适配器
  comment_local_list.Adapter=comment_adp



  sadapter=LuaAdapter(activity,itemc)
  local_comment_list.setAdapter(sadapter)
  for v,s in pairs(luajava.astable(File(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/".."fold/")).listFiles())) do
    names=s.Name:match[[(.+)+]]
    ids=s.Name:match[[+(.+)]]
    sadapter.add{local_comment_title=names,local_comment_id=ids}
  end


  local_comment_list.setOnItemClickListener(AdapterView.OnItemClickListener{
    onItemClick=function(id,v,zero,one)
      activity.newActivity("comment",{读取文件(内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author.."/fold/"..v.Tag.local_comment_title.text.."+"..v.Tag.local_comment_id.text)),"local_chat",answer_title,answer_author})
  end})

 else
  刷新()

end

if _title.text=="对话列表" then

  a=MUKPopu({
    tittle=_title.text,
    list={

    }
  })

 elseif _title.text=="保存的评论" then
  a=MUKPopu({
    tittle=_title.text,
    list={

    }
  })

 else
  a=MUKPopu({
    tittle="评论",
    list={
      {src=图标("format_align_left"),text="按时间顺序",onClick=function()
          comment_base:setSortBy("created")
          comment_base:clear()
          comment_adp.clear()
          评论刷新()
      end},
      {src=图标("notes"),text="按默认顺序",onClick=function()
          comment_base:setSortBy("default")
          comment_base:clear()
          comment_adp.clear()
          评论刷新()
      end},
    }
  })

end

