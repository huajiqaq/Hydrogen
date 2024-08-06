require "import"
import "android.widget.*"
import "android.view.*"
import "mods.muk"
import "android.text.method.LinkMovementMethod"
activity.setContentView(loadlayout("layout/comment"))

comment_id,comment_type,answer_title,answer_author,comment_count,oricomment_id,oricomment_type=...
波纹({fh,_more},"圆主题")

if answer_title and answer_author then
  保存路径=内置存储文件("Download/"..answer_title:gsub("/","or").."/"..answer_author)
end

if comment_type=="answers" then
  savetype="回答"
 elseif comment_type=="articles" then
  savetype="文章"
 elseif comment_type=="pins" then
  savetype="想法"
 elseif comment_type=="zvideos" then
  savetype="视频"
 elseif comment_type then
  savetype=""
end

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

function 发送评论(send_text,当前回复人)

  if not(getLogin()) then
    return 提示("请登录后使用本功能")
  end

  local mytext
  local postdata
  local 请求链接
  local 评论类型
  local 评论id
  local 回复id

  local 回复id=当前回复人 or ""

  local unicode=require "unicode"

  --测试不通过unicode编码也可以 暂时这么解决
  local mytext=send_text

  if _title.text=="对话列表" then
    --防止在对话列表内回复id为空
    if 回复id=="" then
      回复id=comment_id
    end
    --将类型和id改为原来的 防止报404
    评论类型 = oricomment_type
    评论id = oricomment_id
   else
    评论类型 = comment_type
    评论id = comment_id
  end

  postdata='{"comment_id":"","content":"'..mytext..'","extra_params":"","has_img":false,"reply_comment_id":"'..回复id..'","score":0,"selected_settings":[],"sticker_type":null,"unfriendly_check":"strict"}'
  请求链接="https://api.zhihu.com/comment_v5/"..评论类型.."/"..评论id.."/comment"


  search_base=require "model.dohttp"
  :new(请求链接)
  :setresultfunc(function(data)
    commentid=nil
    提示("发送成功 如若想看到自己发言请刷新数据")
    edit.Text=""
  end)
  :getData("post",postdata)
end

function 多选菜单(v)
  local rootview=获取listview顶部布局(v)
  if 踩tab[rootview.Tag.id内容.text]==true then
    ctext="取消踩"
   else
    ctext="踩评论"
  end

  local mtab={

    {"分享",function()
        分享文本(v.Text)
    end},
    {"复制",function()
        import "android.content.*"
        activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(v.Text)
        提示("复制文本成功")
    end},
    {ctext,function()
        if not(getLogin()) then
          return 提示("请登录后使用本功能")
        end
        if 踩tab[rootview.Tag.id内容.text]==false
          zHttp.put("https://api.zhihu.com/comment_v5/comment/"..rootview.Tag.id内容.Text.."/reaction/dislike",'',postapphead,function(code,content)
            if code==200 then
              提示("踩成功")
              踩tab[rootview.Tag.id内容.text]=true
            end
          end)
         else
          zHttp.delete("https://api.zhihu.com/comment_v5/comment/"..rootview.Tag.id内容.Text.."/reaction/dislike",postapphead,function(code,content)
            if code==200 then
              提示("取消踩成功")
              踩tab[rootview.Tag.id内容.text]=false
            end
          end)
        end
    end},
    {"举报",function()
        local url="https://www.zhihu.com/report?id="..rootview.Tag.id内容.Text.."&type=comment"
        activity.newActivity("huida",{url.."&source=android&ab_signature=",nil,nil,nil,"举报"})
    end},
    {"屏蔽",function()
        if not(getLogin()) then
          return 提示("请登录后使用本功能")
        end
        AlertDialog.Builder(this)
        .setTitle("提示")
        .setMessage("屏蔽过后如果想查看屏蔽的所有用户 可以在软件内主页右划 点击消息 选择设置 之后打开屏蔽即可管理屏蔽 你也可以选择管理屏蔽用户 但是这样没有选择设置可设置的多 如果只想查看屏蔽的用户 推荐选择屏蔽用户管理")
        .setPositiveButton("我知道了", {onClick=function()
            zHttp.post("https://api.zhihu.com/settings/blocked_users","people_id="..people_id,apphead,function(code,json)
              if code==200 or code==201 then
                提示("已拉黑")
              end
            end)
        end})
        .setNegativeButton("取消",nil)
        .show();
    end},
    {"查看主页",function()
        activity.newActivity("people",{rootview.Tag.作者id.text})
    end}
  }

  if isstart then
    local comment_view=rootview.Tag.id内容
    local authortext=rootview.Tag.标题.Text
    local addtab={"回复评论",function()
        local editDialog=AlertDialog.Builder(this)
        .setTitle("回复"..authortext.."发送的评论")
        .setView(loadlayout({
          LinearLayout;
          layout_height="fill";
          layout_width="fill";
          orientation="vertical";
          {
            TextView;
            TextIsSelectable=true;
            layout_marginTop="10dp";
            layout_marginLeft="10dp",
            layout_marginRight="10dp",
            Text='请输入回复内容';
            Typeface=字体("product-Medium");
          },
          {
            EditText;
            layout_width="match";
            layout_height="match";
            layout_marginTop="5dp";
            layout_marginLeft="10dp",
            layout_marginRight="10dp",
            id="edit";
            Typeface=字体("product");
          }
        }))
        .setPositiveButton("确定", {onClick=function()
            local commentid=comment_view.Text
            local sendtext=edit.Text
            发送评论(sendtext,commentid)
        end})
        .setNegativeButton("取消", nil)
        .show()
    end}
    table.insert(mtab,addtab)
  end

  local pop=showPopMenu(mtab)
  pop.showAtLocation(rootview, Gravity.NO_GRAVITY, downx, downy);

  return true
end

踩tab={}

function 刷新()

  comment_itemc=获取适配器项目布局("comment/comment")

  comment_adp=MyLuaAdapter(activity,comment_itemc)
  comment_list.Adapter=comment_adp

  comment_base=require "model.comment"
  :new(comment_id,comment_type)
  :setresultfunc(function(v)
    local 头像=v.author.avatar_url
    local 内容=v.content
    local 点赞数=(v.vote_count)
    local 时间=时间戳(v.created_time)
    local 名字,id=v.author.name,"没有id"
    local function isauthor(v)
      local a=""
      if v.role=="author" then
        a=" (作者) "
      end
      return v.name..a
    end
    local myspan
    pcall(function()
      名字=isauthor(v.author).. "  →  "..isauthor(v.reply_to_author)
      if _title.text~="对话列表" then id=(v.id) end
    end)
    if 内容:find("https?://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]") then
      myspan=setstyle(Html.fromHtml(内容))
     else
      myspan=Html.fromHtml(内容)
    end
    踩tab[tostring((tostring(v.id)))]=v.disliked
    if 无图模式 then
      头像=logopng
    end
    comment_list.Adapter.add{提示内容={Visibility=(v.child_comment_count==0 and 8 or 0)},
      id内容=(tostring(v.id)),
      作者id=v.author.id,
      预览内容={
        text=myspan,
        MovementMethod=LinkMovementMethod.getInstance(),
        onClick=function(v,event) 多选菜单(v) end,
        Focusable=false,
        onTouch=function(v,event)
          downx=event.getRawX()
          downy=event.getRawY()
        end
      },
      author_lay={
        onClick=function(v)
          activity.newActivity("people",{获取listview顶部布局(v).Tag.作者id.text})
        end
      },
      标题=名字,
      图像=头像,
      时间=时间,
      isme=(v.is_author==true and "true" or "false")
    }

  end)

  if comment_type=="comments" then
    comment_base:setSortBy("ts")
  end

  add=true

  comment_list.setOnScrollListener{
    onScroll=function(view,a,b,c)
      if a+b==c and add then
        add=false
        评论刷新()
        System.gc()
      end
    end
  }

end


function 评论刷新()
  comment_base:next(function(r,a)
    if r==false and comment_base.is_end==false then
      提示("获取评论列表出错 "..a or "")
     else
      if comment_base.is_end==false
        add=true
      end
      if _title.text=="评论" then
        _title.text=string.format("共%s条评论",comment_base.common_counts)
      end
    end
  end)
end

comment_list.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(id,v,zero,one)
    if not(v.Tag) then
      return true
    end
    if v.Tag.提示内容.getVisibility()==0 then
      if _title.text=="对话列表" then
        return 提示("当前已在该对话列表内")
      end
      activity.newActivity("comment",{v.Tag.id内容.text,"comments",answer_title,answer_author,nil,comment_id,comment_type})
     else
      当前回复人=v.Tag.id内容.Text
    end
end})

comment_list.setOnItemLongClickListener(AdapterView.OnItemLongClickListener{
  onItemLongClick=function(id,v,zero,one)
    if not(v.Tag) then
      多选菜单(v)
      return true
    end

    local commenttype
    local 对话id=v.Tag.id内容.text
    local 对话用户=v.Tag.标题.text
    local 对话内容=v.Tag.预览内容.text
    if v.Tag.isme.text=="true" then
      local 请求链接="https://api.zhihu.com/comment_v5/comment/"..对话id

      双按钮对话框("删除","删除该回复？该操作不可撤消！","是的","点错了",function(an)
        search_base=require "model.dohttp"
        :new(请求链接)
        :setresultfunc(function(data)
          提示("删除成功！")
          an.dismiss()
        end)
        :getData("delete")
      end,function(an)an.dismiss()end)
      return true
    end

    if type(answer_title)~="string" then
      return true
    end

    local result=get_write_permissions()
    if result~=true then
      return true
    end

    if not(文件是否存在(保存路径.."/mht.mht"))then
      return 提示("先保存"..savetype.."才可以收藏评论")
    end

    if _title.text~="对话列表" then

      local 写入文件路径=保存路径.."/".."fold/"..对话id
      local 写入内容='author="'..对话用户..'"'
      local 写入内容=写入内容.."\n"
      local 写入内容=写入内容..'content="'..对话内容..'"'

      双按钮对话框("收藏","收藏这条评论？","是的","点错了",function(an)
        写入文件(写入文件路径,写入内容)
        提示("收藏成功")
        an.dismiss()
      end,
      function(an)an.dismiss()end)
     else
      --如果是在对话列表里
      local 写入文件路径=保存路径.."/".."fold/"..comment_id
      local 写入内容=''

      双按钮对话框("收藏","收藏整条列表？","是的","点错了",function(an)
        local alldata=comment_list.adapter.getData()
        for i=1,#alldata do
          local 对话用户= alldata[i].标题
          local 对话内容= tostring(alldata[i].预览内容.text)
          写入内容=写入内容..'author="'..对话用户..'"'
          写入内容=写入内容.."\n"
          写入内容=写入内容..'content="'..对话内容..'"'
          写入内容=写入内容..'\n'
        end
        写入文件(写入文件路径,写入内容)
        提示("收藏成功")
        an.dismiss()
      end,
      function(an)an.dismiss()end)
    end
    return true
end})


if comment_type=="comments" then
  _title.text="对话列表"
  刷新()

 elseif comment_type=="local_chat" then
  _title.text="对话列表"
  Internetnet.setVisibility(8)
  Localcomment.setVisibility(0)

  comment_itemc=获取适配器项目布局("comment/comments_reply")

  sadapter=LuaAdapter(activity,comment_itemc)
  local_comment_list.setAdapter(sadapter)

  function getCommentData(filename, func)
    local file = io.open(filename, "r")
    local currentAuthor = nil
    local currentContentBuffer = ""

    for line in file:lines() do
      -- 检查是否开始一个新的author行
      if line:find('author="') then
        currentAuthor = line:match('author="([^"]+)"')
        currentContentBuffer = "" -- 重置content缓冲区
       else
        -- 累积content，直到找到结束引号
        currentContentBuffer = currentContentBuffer .. line
        local contentEndIndex = currentContentBuffer:find('"', 10) -- content从第10个字符开始
        if contentEndIndex then
          local currentContent = currentContentBuffer:sub(9, contentEndIndex - 1)
          func(currentAuthor, currentContent)
          currentAuthor = nil
          currentContentBuffer = "" -- 处理完一对后重置缓冲区
        end
      end
    end

    file:close()
  end


  getCommentData(comment_id,function(用户名,内容)
    local myspan
    if 内容:find("https?://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]") then
      myspan=setstyle(Html.fromHtml(内容))
     else
      myspan=Html.fromHtml(内容)
    end


    sadapter.add{
      标题=用户名,
      预览内容={
        text=myspan,
        MovementMethod=LinkMovementMethod.getInstance(),
        Focusable=false,
        onLongClick=function(v)
          复制文本=v.Text
          import "android.content.*"
          activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(复制文本)
          提示("复制文本成功")
        end
      },
      提示内容={Visibility=8}
    }

  end)


  --对话列表 显示第一个的提示内容
  local_comment_list.adapter.getData()[1].提示内容.Visibility=0
  local_comment_list.adapter.notifyDataSetChanged()

  local_comment_list.setOnItemClickListener(AdapterView.OnItemClickListener{
    onItemClick=function(id,v,zero,one)
      if v.Tag.提示内容.getVisibility()==0 then
        提示("当前已在该对话列表内")
      end
  end})

 elseif comment_type=="local" then
  _title.text="保存的评论"
  Internetnet.setVisibility(8)
  local_comment_list.setVisibility(0)

  comment_itemc=获取适配器项目布局("comment/comments_reply")

  sadapter=LuaAdapter(activity,comment_itemc)
  local_comment_list.setAdapter(sadapter)

  function isAuthorMentionedMoreThanOnce(s)
    local count = 0
    local pos = 1

    while true do
      local findPos = string.find(s, "author", pos)
      if findPos then
        count = count + 1
        pos = findPos + 1
        if count > 1 then -- 当计数超过1时，直接返回true
          return "true"
        end
       else
        break
      end
    end

    return "false" -- 如果循环结束还没有返回，说明计数不超过1，返回false
  end

  for v,s in pairs(luajava.astable(File(保存路径.."/".."fold/").listFiles())) do
    xxx=读取文件(tostring(s))
    name=xxx:match('author="([^"]*)"')
    content=xxx:match('content="(.-)"')
    iscomments=isAuthorMentionedMoreThanOnce(xxx)
    id=s.Name
    sadapter.add{标题=name,
      预览内容={
        text=content,
        onLongClick=function(v)
          复制文本=v.Text
          import "android.content.*"
          activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(复制文本)
          提示("复制文本成功")
        end
      },
      提示内容={
        Visibility=(type(iscomments)=="false" and 8 or 0)
      },
      id内容=id
    }

  end


  local_comment_list.setOnItemClickListener(AdapterView.OnItemClickListener{
    onItemClick=function(id,v,zero,one)
      if v.Tag.提示内容.getVisibility()==0 then
        activity.newActivity("comment",{保存路径.."/fold/"..v.Tag.id内容.text,"local_chat",answer_title,answer_author})
      end
  end})


 else
  刷新()
end

if not(comment_type:find("local")) then
  if isstart=="true" then
    send.setVisibility(0)
  end
end


task(1,function()
  a=MUKPopu({
    tittle="评论",
    list={
      {src=图标("format_align_left"),text="按时间顺序",onClick=function()
          comment_base:setSortBy("ts")
          comment_base:clear()
          comment_adp.clear()
          踩tab={}
          add=true
      end},
      {src=图标("notes"),text="按默认顺序",onClick=function()
          comment_base:setSortBy("score")
          comment_base:clear()
          comment_adp.clear()
          踩tab={}
          add=true
      end},
    }
  })
end)

if comment_type:find("local") then
  task(1,function()
    a=MUKPopu({
      tittle=_title.text,
      list={

      }
    })
  end)
end

function onActivityResult(a,b,c)
  if b==100 then
    if comment_type~="local" then
      comment_base:clear()
      comment_list.Adapter.clear()
    end
  end
end

send.onClick=function()
  local sendtext=edit.Text
  发送评论(sendtext)
end