local base={}

function base:new(id,type)
  local child=table.clone(self)
  child.id=id
  child.type=type
  return child
end

function base:getUrlByType(sortby)
  local type=self.type
  if type~="comments" then
    return "https://api.zhihu.com/comment_v5/"..type.."/"..self.id.."/root_comment?order_by="..(sortby or "score")
   else
    return "https://api.zhihu.com/comment_v5/comment/"..self.id.."/child_comment?order_by="..(sortby or "ts")
  end
end

local function setstyle(text)
  local style = SpannableStringBuilder(text);
  local len= style.length()
  local urltab=luajava.astable(style.getSpans(0, len,URLSpan))
  local function MyClickableSpan(url)
    local myspan=ClickableSpan{
      onClick=function(v)
        if v.Text:find("图片") or v.Text:find("动图") then
          local data={["0"]=url,["1"]=1}
          this.setSharedData("imagedata",luajson.encode(data))
          activity.newActivity("image")
          return
        end
        检查链接(url)
      end,
      updateDrawState=function(v)
        v.setColor(v.linkColor);
        v.setUnderlineText(true);
      end
    }
    return myspan
  end
  if #urltab>0 then
    style.clearSpans()
    for i=1,#urltab do
      local urlspan=urltab[i]
      local url=urlspan.getURL()
      local Span=MyClickableSpan(url)
      local startindex= text.getSpanStart(urlspan)
      local endindex=text.getSpanEnd(urlspan)
      style.setSpan(Span, startindex, endindex, Spannable.SPAN_EXCLUSIVE_INCLUSIVE)
    end
    return style
  end
end

function base.resolvedata(v,data)
  local 头像=v.author.avatar_url
  local 内容=v.content
  local 点赞数=v.vote_count
  local 时间=时间戳(v.created_time)
  local 名字=v.author.name
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
  end)
  local 包含url
  if 内容:find("https?://[-A-Za-z0-9+&@#/%?=~_|!:,.;]+[-A-Za-z0-9+&@#/%=~_|]") then
    myspan=setstyle(Html.fromHtml(内容))
    包含url=true
   else
    myspan=Html.fromHtml(内容)
  end
  踩tab[tostring((tostring(v.id)))]=v.disliked
  if 无图模式 then
    头像=logopng
  end
  local 提示内容=v.child_comment_count>0
  local id内容=tostring(v.id)
  local 作者id=v.author.id
  local 预览内容=myspan
  local 标题=名字
  local 图像=头像
  local 时间=v.like_count.." 喜欢 · "..时间
  local isme=(v.is_author==true and "true" or "false")
  pcall(function()
    local comment_tag=v.comment_tag[1]
    if comment_tag.type=="ip_info" then
      时间=comment_tag.text.." · "..时间
    end
  end)


  local add={}
  add.提示内容=提示内容
  add.id内容=id内容
  add.作者id=作者id
  add.预览内容=预览内容
  add.标题=标题
  add.图像=图像
  add.时间=时间
  add.isme=isme
  add.包含url=包含url
  table.insert(data,add)
end

local function 多选菜单(data,v)
  local id内容=data.id内容
  if 踩tab[id内容]==true then
    ctext="取消踩"
   else
    ctext="踩评论"
  end

  local menu={

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
        if 踩tab[id内容]==false
          zHttp.put("https://api.zhihu.com/comment_v5/comment/"..id内容.."/reaction/dislike",'',postapphead,function(code,content)
            if code==200 then
              提示("踩成功")
              踩tab[id内容]=true
            end
          end)
         else
          zHttp.delete("https://api.zhihu.com/comment_v5/comment/"..id内容.."/reaction/dislike",postapphead,function(code,content)
            if code==200 then
              提示("取消踩成功")
              踩tab[id内容]=false
            end
          end)
        end
    end},
    {"举报",function()
        local url="https://www.zhihu.com/report?id="..id内容.."&type=comment"
        activity.newActivity("browser",{url.."&source=android&ab_signature=","举报"})
    end},
    {"屏蔽",function()
        if not(getLogin()) then
          return 提示("请登录后使用本功能")
        end
        AlertDialog.Builder(this)
        .setTitle("提示")
        .setMessage("屏蔽过后如果想查看屏蔽的所有用户 可以在软件内主页右划 点击消息 选择设置 之后打开屏蔽即可管理屏蔽 你也可以选择管理屏蔽用户 但是这样没有选择设置可设置的多 如果只想查看屏蔽的用户 推荐选择屏蔽用户管理")
        .setPositiveButton("我知道了", {onClick=function()
            zHttp.post("https://api.zhihu.com/settings/blocked_users","people_id="..data.作者id,apphead,function(code,json)
              if code==200 or code==201 then
                提示("已拉黑")
              end
            end)
        end})
        .setNegativeButton("取消",nil)
        .show();
    end},
    {"查看主页",function()
        activity.newActivity("people",{data.作者id})
    end}
  }

  if isstart then
    local authortext=data.标题
    local addmenu={"回复评论",function()
        local editDialog=AlertDialog.Builder(this)
        .setTitle("回复"..authortext.."发送的评论")
        .setView(loadlayout({
          LinearLayout;
          layout_height="fill";
          layout_width="fill";
          orientation="vertical";
          {
            EditText;
            layout_width="match";
            layout_height="match";
            layout_marginTop="5dp";
            layout_marginLeft="10dp",
            layout_marginRight="10dp",
            id="edit";
            hint="输入回复内容";
            Typeface=字体("product");
          }
        }))
        .setPositiveButton("确定", {onClick=function()
            local commentid=id内容
            local sendtext=edit.Text
            发送评论(sendtext,commentid)
        end})
        .setNegativeButton("取消", nil)
        .show()
    end}
    table.insert(menu,addmenu)
  end

  local pop=showPopMenu(menu)
  pop.showAtLocation(v, Gravity.NO_GRAVITY, downx, downy);

  return true
end

function base.getAdapter(comment_pagetool,pos)
  local data=comment_pagetool:getItemData(pos)
  return LuaCustRecyclerAdapter(AdapterCreator({

    getItemCount=function()
      if 卡片信息 and #data==0 then
        table.insert(data,卡片信息)
      end
      return #data
    end,

    getItemViewType=function(position)
      return 0
    end,

    onCreateViewHolder=function(parent,viewType)
      local views={}
      holder=LuaCustRecyclerHolder(loadlayout(comment_item,views))
      holder.view.setTag(views)
      return holder
    end,

    onBindViewHolder=function(holder,position)
      local views=holder.view.getTag()
      local data=data[position+1]
      local type=data.datatype

      local 标题=data.标题
      local 预览内容=data.预览内容
      local id内容=data.id内容
      local 提示内容=data.提示内容
      local 作者id=data.作者id
      local 图像=data.图像
      local 时间=data.时间
      local isme=data.isme

      if 提示内容 then
        views.提示内容.Visibility=0
       else
        views.提示内容.Visibility=8
      end


      views.标题.text=标题
      views.预览内容.text=预览内容
      views.时间.text=时间

      loadglide(views.图像,图像)

      views.card.onClick=function()
        if views.提示内容.getVisibility()==0 then
          if comment_type=="comments" then
            return 提示("当前已在该对话列表内")
          end
          activity.newActivity("comment",{data.id内容,"comments",comment_id,comment_type,保存路径})
        end
      end

      views.card.onLongClick=function()
        local commenttype
        local 对话id=data.id内容
        local 对话用户=views.标题.text
        local 对话内容=views.预览内容.text
        if isme=="true" then
          local 请求链接="https://api.zhihu.com/comment_v5/comment/"..对话id

          双按钮对话框("删除","删除该回复？该操作不可撤消！","是的","点错了",function(an)
            local url,head=require "model.zse96_encrypt"(请求链接)
            zHttp.delete(url,head,function(code)
              if code==200 then
                提示("删除成功！")
                an.dismiss()
              end
            end)
          end,function(an)an.dismiss()end)
          return true
        end

        local result=get_write_permissions()
        if result~=true then
          return true
        end

        if not 保存路径 then
          return 提示("该内容下评论不支持保存")
        end

        if not(文件夹是否存在(保存路径))then
          return 提示("先保存 才可以收藏评论")
        end

        if comment_type~="comments" then

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
            local alldata=comment_pagetool:getItemData(1)
            for i=1,#alldata do
              local 对话用户= alldata[i].标题
              local 对话内容= tostring(alldata[i].预览内容)
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
      end

      views.author_lay.onClick=function()
        activity.newActivity("people",{data.作者id})
      end

      views.预览内容.onTouch=function(v,event)
        downx=event.getRawX()
        downy=event.getRawY()
      end

      views.预览内容.onClick=function(view)
        多选菜单(data,view)
      end

      views.预览内容.onLongClick=function(view)
        多选菜单(data,view)
      end

      if data.包含url then
        views.预览内容.MovementMethod=LinkMovementMethod.getInstance()
      end

    end,
  }))

end

function base:initpage(view,sr)
  self.view=view
  self.sr=sr
  orititle=_title.text
  return MyPageTool2:new({
    view=view,
    sr=sr,
    head="head",
    adapters_func=self.getAdapter,
    func=self.resolvedata,
    firstfunc=function(data,adpdata)
      --针对对话列表 添加父评论
      if self.type=="comments" then
        self.resolvedata(data.root,adpdata)
      end
      if data.counts then
        _title.text=orititle.." "..tostring(data.counts.total_counts).."条"
       else
        local tip="当前页无评论"
        if data.comment_status and data.comment_status.text then
          tip=data.comment_status.text
        end
        AlertDialog.Builder(this)
        .setTitle("提示")
        .setCancelable(false)
        .setMessage(tip)
        .setPositiveButton("我知道了",{onClick=function()
            this.finish()
        end})
        .show()
      end
    end
  })
  :initPage()
  :createfunc()
  :setUrlItem(self:getUrlByType())
  :refer()
end


return base