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

function 刷新()
  comment_itemc=获取适配器项目布局("comment/comment")

  comment_adp=MyLuaAdapter(activity,comment_itemc)
  comment_list.Adapter=comment_adp

  comment_base=require "model.comment"
  :new(comment_id,comment_type)
  :setresultfunc(function(v)
    local 头像=v.author.avatar_url
    local 内容=v.content
    local 点赞数=tointeger(v.vote_count)
    local 时间=时间戳(v.created_time)
    local 名字,id=v.author.name,"没有id"
    local function isauthor(v)
      local a=""
      if v.role=="author" then
        a=" (作者) "
      end
      return v.name..a
      --      return v.member.name..a
    end
    local myspan
    pcall(function()
      名字=isauthor(v.author).. "  →  "..isauthor(v.reply_to_author)
      if _title.text~="对话列表" then id=tointeger(v.id) end
    end)
    if 内容:find("https?://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]") then
      评论链接=内容:match("https?://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]")
      myspan=setstyle(Html.fromHtml(内容))
     else
      myspan=Html.fromHtml(内容)
    end
    comment_list.Adapter.add{comment_toast={Visibility=(v.child_comment_count==0 and 8 or 0)},
      comment_id=tointeger(tostring(v.id)),
      comment_art={
        text=myspan,
        MovementMethod=LinkMovementMethod.getInstance(),
        onClick= function(view)
          提示("点击文字不可以触发相关事件哦 你可长按文字复制 点击其余地方去打开楼中楼(如果有的话)")
        end,
        Focusable=false,
      },

      comment_author=名字,
      comment_image=头像,
      comment_time=时间,
      comment_vote=点赞数,
      isme=(v.is_author==true and "true" or "false")
    }

  end)

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
      --      评论刷新()
     else
      if comment_base.is_end==false
        add=true
      end
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


comment_list.setOnItemClickListener(AdapterView.OnItemClickListener{
  onItemClick=function(id,v,zero,one)
    if _title.text~="对话列表" and v.Tag.comment_toast.getVisibility()==0 then
      activity.newActivity("comment",{v.Tag.comment_id.text,"comments",answer_title,answer_author,nil,comment_id,comment_type})
     else
      当前回复人=v.Tag.comment_id.Text
    end
end})


comment_list.setOnItemLongClickListener(AdapterView.OnItemLongClickListener{
  onItemLongClick=function(id,v,zero,one)
    if not(v.Tag) then
      import "android.content.*"
      activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(v.Text)
      提示("复制文本成功")
      return true
    end

    if type(answer_title)~="string" then
      return
    end

    local result=get_write_permissions()
    if result~=true then
      return true
    end

    local commenttype
    local 对话id=v.Tag.comment_id.text
    local 对话用户=v.Tag.comment_author.text
    local 对话内容=v.Tag.comment_art.text
    local 写入文件路径=保存路径.."/".."fold/"..对话用户.."+"..对话id
    if v.Tag.isme.text=="true" then
      local 请求链接="https://api.zhihu.com/comment_v5/comment/"..对话id

      双按钮对话框("删除","删除该回复？该操作不可撤消！","是的","点错了",function()
        search_base=require "model.dohttp"
        :new(请求链接)
        :setresultfunc(function(data)
          提示("删除成功！")
          an.dismiss()
        end)
        :getData("delete")
      end,function()an.dismiss()end)
      return
    end

    local 写入内容='author="'..对话用户..'"'
    local 写入内容=写入内容.."\n"
    local 写入内容=写入内容..'content="'..对话内容..'"'
    local 写入内容=写入内容..'\n'

    if not(文件是否存在(保存路径.."/mht.mht"))then
      return 提示("先保存"..savetype.."才可以收藏评论")
    end

    if _title.text~="对话列表" then
      --如果评论下没有对话列表
      if v.Tag.comment_toast.Visibility==8 then
        if 文件是否存在(保存路径.."/mht.mht")then
          双按钮对话框("收藏","收藏这条评论？","是的","点错了",function()
            写入文件(写入文件路径,写入内容)
            提示("收藏成功")
            an.dismiss()
          end,
          function()an.dismiss()end)
        end
        --如果评论下有对话列表
       elseif v.Tag.comment_toast.Visibility==0 then
        三按钮对话框("收藏","收藏这该条评论还是整个对话列表？","该评论","整个对话列表","点错了",
        --点击第一个按钮的事件
        function()
          写入文件(写入文件路径,写入内容)
          提示("收藏成功")
          an.dismiss()
        end,
        --点击第二个按钮事件
        function()
          zHttp.get("https://api.zhihu.com/comment_v5/comment/"..对话id.."/child_comment",head,function(code,content)
            if code==200
              写入内容=写入内容..'jsbody='..content..'jsbodyend'
              写入文件(写入文件路径,写入内容)
              提示("收藏成功")
             else
              提示("保存失败 可能是网络原因")
            end
            an.dismiss()
          end)
        end,
        --点击第三个按钮事件
        function()
          an.dismiss()
        end)
      end
      --如果是在对话列表里
     else
      写入内容='author="'..对话用户..'"'
      写入内容=写入内容.."\n"
      写入内容=写入内容..'content="'..对话内容..'"'
      双按钮对话框("收藏","收藏这条评论？","是的","点错了",function()
        写入文件(写入文件路径,写入内容)
        提示("收藏成功")
        an.dismiss()
      end,
      function()an.dismiss()end)
    end
    return true
end})


if comment_type=="comments" then
  if isstart=="true" then
    send.setVisibility(0)
  end
  _title.text="对话列表"
  刷新()

 elseif comment_type=="local_chat" then
  _title.text="对话列表"
  Internetnet.setVisibility(8)
  Localcomment.setVisibility(0)

  comment_itemc=获取适配器项目布局("comment/comments_reply")

  sadapter=LuaAdapter(activity,comment_itemc)
  local_comment_list.setAdapter(sadapter)

  local data=luajson.decode(comment_id)

  for k,v in ipairs(data.data) do

    local 内容=v.content
    local myspan

    if 内容:find("https?://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]") then
      评论链接=内容:match("https?://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]")
      myspan=setstyle(Html.fromHtml(内容))
     else
      myspan=Html.fromHtml(内容)
    end

    task(50,function()sadapter.add{
        comment_author=v.author.name,
        comment_art={
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
        comment_toast={Visibility=8}
      }
    end)
  end


 elseif comment_type=="local" then
  _title.text="保存的评论"
  Internetnet.setVisibility(8)
  Localcomment.setVisibility(0)

  comment_itemc=获取适配器项目布局("comment/comments_reply")

  sadapter=LuaAdapter(activity,comment_itemc)
  local_comment_list.setAdapter(sadapter)
  for v,s in pairs(luajava.astable(File(保存路径.."/".."fold/").listFiles())) do
    xxx=读取文件(tostring(s))
    name=s.Name:match('(.+)+')
    content=xxx:match('content="(.-)"')
    jsbody=xxx:match("jsbody%=(.+)jsbodyend")
    id=s.Name:match('+(.+)')
    sadapter.add{comment_author=name,
      comment_art={
        text=content,
        onLongClick=function(v)
          复制文本=v.Text
          import "android.content.*"
          activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(复制文本)
          提示("复制文本成功")
        end
      },
      comment_toast={
        Visibility=(type(jsbody)~="string" and 8 or 0)
      },
      comment_id=id
    }

  end


  local_comment_list.setOnItemClickListener(AdapterView.OnItemClickListener{
    onItemClick=function(id,v,zero,one)
      if v.Tag.comment_toast.getVisibility()==0 then
        activity.newActivity("comment",{读取文件(保存路径.."/fold/"..v.Tag.comment_author.text.."+"..v.Tag.comment_id.text):match("jsbody%=(.+)jsbodyend"),"local_chat",answer_title,answer_author})
      end
  end})


 else
  if isstart=="true" then
    send.setVisibility(0)
  end

  刷新()

end

if _title.text=="对话列表" then
  task(1,function()
    a=MUKPopu({
      tittle=_title.text,
      list={

      }
    })
  end)

 elseif _title.text=="保存的评论" then
  task(1,function()
    a=MUKPopu({
      tittle=_title.text,
      list={

      }
    })
  end)

 else
  task(1,function()
    a=MUKPopu({
      tittle="评论",
      list={
        {src=图标("format_align_left"),text="按时间顺序",onClick=function()
            comment_base:setSortBy("ts")
            --          comment_base:setSortBy("created")
            comment_base:clear()
            comment_adp.clear()
            评论刷新()
        end},
        {src=图标("notes"),text="按默认顺序",onClick=function()
            comment_base:setSortBy("score")
            --          comment_base:setSortBy("default")
            comment_base:clear()
            comment_adp.clear()
            评论刷新()
        end},
      }
    })
  end)
end

function onActivityResult(a,b,c)
  if b==100 then
    comment_base:clear()
    评论刷新()
  end
end

send.onClick=function()
  local send_text=edit.Text
  local mytext
  local commentid
  local postdata
  local 请求链接
  local replyid

  if oricomment_id then
    commentid=oricomment_id
   else
    commentid=comment_id
  end

  local replyid=当前回复人 or ""

  local unicode=require "unicode"

  local mytext=unicode.encode(send_text)

  if oricomment_id then
    postdata='{"comment_id":"'..oricomment_id..'","content":"'..mytext..';","extra_params":"","has_img":false,"reply_comment_id":"'.. replyid ..'","score":0,"selected_settings":[],"sticker_type":null,"unfriendly_check":"strict"}'

    请求链接="https://api.zhihu.com/comment_v5/"..oricomment_type.."/"..oricomment_id.."/comment"

   else
    postdata='{"comment_id":"","content":"'..mytext..'","extra_params":"","has_img":false,"reply_comment_id":"'..replyid..'","score":0,"selected_settings":[],"sticker_type":null,"unfriendly_check":"strict"}'

    请求链接="https://api.zhihu.com/comment_v5/"..comment_type.."/"..comment_id.."/comment"

  end

  search_base=require "model.dohttp"
  :new(请求链接)
  :setresultfunc(function(data)
    commentid=nil
    提示("发送成功 如若想看到自己发言请刷新数据")
    edit.Text=""
  end)
  :getData("post",postdata)
end

send.onLongClick=function()
  当前回复人 =nil
  提示("清除选中成功")
end


if activity.getSharedData("评论提示0.01") ==nil and isstart=="true" then
  AlertDialog.Builder(this)
  .setTitle("小提示")
  .setCancelable(false)
  .setMessage("以下的提示非常重要！ 选中后 如果想取消选定回复 请长按发送按钮 如不取消选定回复 将会一直回复当前选定人哦 不过选定的人当回复发送成功一次 将会清除选中")
  .setPositiveButton("我知道了",{onClick=function() activity.setSharedData("评论提示0.01","true") end})
  .show()
end