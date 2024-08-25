local base={
  nextUrl=nil,
  is_end=false,
  data={},
}

function base:new(id)
  local child=table.clone(self)
  child.id=id
  return child
end

function base:getData(callback)
  zHttp.get("https://api.zhihu.com/people/"..self.id.."/profile?profile_new_version=1",head,function(code,content)
    if code==200 then
      local data=luajson.decode(content)
      self.id=data.id
      callback(data)
     elseif luajson.decode(content).error then
      提示(luajson.decode(content).error.message)
      callback(false)
    end
  end)
  return self
end

function base.getAdapter(people_pagetool,pos)

  return LuaCustRecyclerAdapter(AdapterCreator({

    getItemCount=function()
      return #people_pagetool:getItemData(pos)
    end,

    getItemViewType=function(position)
      return people_pagetool:getItemData(pos)[position+1].type or 0
    end,

    onCreateViewHolder=function(parent,viewType)
      local views={}
      local holder=LuaCustRecyclerHolder(loadlayout(people_itemc,views))
      switch viewType
       case 1
        views.点赞图标.getParent().removeView(views.点赞图标)
        views.点赞数.getParent().removeView(views.点赞数)
        local 评论图标=views.评论图标
        local layoutParams = 评论图标.getLayoutParams();
        layoutParams.setMargins(0, 0, 0, 0);
        评论图标.setLayoutParams(layoutParams);
       case 2
        views.评论图标.getParent().removeView(views.点赞图标)
        views.评论数.getParent().removeView(views.点赞数)
       case 3
        views.底部内容.getParent().removeView(views.底部内容)
      end
      holder.view.setTag(views)
      return holder
    end,

    onBindViewHolder=function(holder,position)
      local views=holder.view.getTag()
      local data=people_pagetool:getItemData(pos)[position+1]

      views.活动.Text=data.活动
      views.预览内容.Text=data.预览内容
      if data.点赞数 then
        views.点赞数.Text=data.点赞数
      end
      if data.评论数 then
        views.评论数.Text=data.评论数
      end
      views.标题.Text=data.标题

      loadglide(views.图像,data.图像)

      views.card.onClick=function()
        if tostring(data.id内容):find("更多") then
          local id内容=data.id内容:gsub("更多","")
          activity.newActivity("people_more",{用户id,id内容})
         else
          点击事件判断(data.id内容,data.标题)
        end
      end
    end,
  }))
end

function base.resolvedata(v,data)
  --针对more的支持
  if v.more_tabs then
    for i,v in ipairs(v.more_tabs) do
      local 头像=大头像
      local 活动="的更多"
      local 标题=v.title
      local id内容="更多"..v.title
      local 添加字符串
      if 无图模式 then
        头像=logopng
      end
      if v.sub_title then
        添加字符串="共有"..v.sub_title.."个内容 "
        if v.sub_title=="" then
          添加字符串=""
        end
       else
        添加字符串=""
      end
      local 预览内容=添加字符串.."点击查看"
      local 点赞数="0"
      local 评论数="0"
      local add={}
      add.活动=活动
      add.预览内容=预览内容
      add.点赞数=点赞数
      add.评论数=评论数
      add.id内容=id内容
      add.标题=标题
      add.图像=头像
      table.insert(data,add)
    end
    return
  end

  local 活动=v.action_text
  local 头像
  xpcall(function()
    头像=v.actor.avatar_url
    end,function()
    头像=v.author.avatar_url
  end)

  if v.source then
    头像=v.source.actor.avatar_url
    活动=v.source.action_text
  end

  local v=v.target or v
  头像=头像 or v.author.avatar_url
  local 预览内容=v.excerpt
  local 点赞数=v.voteup_count
  local 评论数=v.comment_count
  local id内容,标题
  if 无图模式 then
    头像=logopng
  end

  local add={}
  if v.type=="answer" then
    id内容=(v.question.id) or "null"
    id内容=id内容.."分割"..(v.id)
    标题=v.question.title
    活动=活动 or "发布了回答"
   elseif v.type=="topic" then
    预览内容="无预览内容"
    id内容="话题分割"..v.id
    标题=v.name
    活动=活动 or "发布了话题"
   elseif v.type=="question" then
    id内容="问题分割"..(v.id)
    标题=v.title
    预览内容="无预览内容"
    活动=活动 or "发布了问题"
   elseif v.type=="column" then
    id内容="专栏分割"..v.id
    评论数=v.items_count
    标题=v.title
    预览内容=v.intro
    活动=活动 or "发布了专栏"
   elseif v.type=="collection" then
    return
   elseif v.type=="pin" or v.type=="moments_pin" then
    id内容="想法分割"..tostring(v.id)
    local title=v.content[1].title
    if #v.content>0 and title and title~="" then
      标题=v.content[1].title
     else
      标题="一个想法"
    end
    预览内容=v.content_html
    点赞数=v.like_count
    活动=活动 or "发布了想法"
   elseif v.type=="article" then
    id内容="文章分割"..(v.id)
    标题=v.title
    活动=活动 or "发布了文章"
   elseif v.type=="zvideo" then
    id内容="视频分割"..v.id
    标题=v.title
    活动=活动 or "发布了视频"
   elseif v.type=="roundtable" then
    id内容="圆桌分割"..v.id
    标题=v.name
    活动=活动 or "关注了圆桌"
    预览内容=v.description
   elseif v.type=="special" then
    id内容="专题分割"..v.id
    标题=v.title
    活动=活动 or "关注了专题"
    预览内容=v.description
   else
    标题="未知"
    活动="未知"
  end
  if not 预览内容 or 预览内容=="" then
    预览内容="无预览内容"
   else
    预览内容=Html.fromHtml(预览内容)
  end

  if 点赞数 then
    点赞数=tostring(点赞数)
   else
    add.type=1
  end

  if 评论数 then
    评论数=tostring(评论数)
   else
    add.type=2
  end

  if not 点赞数 and not 评论数 then
    add.type=3
  end

  add.活动=活动
  add.预览内容=预览内容
  add.点赞数=点赞数
  add.评论数=评论数
  add.id内容=id内容
  add.标题=标题
  add.图像=头像
  table.insert(data,add)
end


function base:putTabData(tabname,tabinfo)
  local people_id=self.id
  local taburl = {}
  local newTabname = {}
  local answerIndex
  local activitiesIndex

  local urls = {
    activities = "https://api.zhihu.com/people/" .. people_id .. "/activities?limit=20",
    zvideo = "https://api.zhihu.com/members/" .. people_id .. "/zvideos?offset=0&limit=20",
    answer = "https://api.zhihu.com/members/" .. people_id .. "/answers?order_by=created&offset=0&limit=20",
    vote = "https://api.zhihu.com/moments/" .. people_id .. "/vote?limit=20",
    more = "https://api.zhihu.com/people/" .. people_id .. "/profile/tab/more?tab_type=1",
    article = "https://api.zhihu.com/people/" .. people_id .. "/articles?offset=0&limit=20",
    column="https://api.zhihu.com/people/"..people_id.."/columns?offset=0&limit=20",
    pin="https://api.zhihu.com/v2/pins/"..people_id.."/moments"
  }

  for i, v in ipairs(tabinfo) do
    local key=v.key
    local url = urls[key] or v.url
    if url then
      table.insert(taburl, url)
      table.insert(newTabname, tabname[i])
      if key == "activities" then
        activitiesIndex = #taburl
       elseif key == "answer" then
        answerIndex = #taburl
      end
    end
  end

  if activitiesIndex and activitiesIndex > 1 then
    local activitiesUrl = table.remove(taburl, activitiesIndex)
    local activitiesName = table.remove(newTabname, activitiesIndex)
    table.insert(taburl, 1, activitiesUrl)
    table.insert(newTabname, 1, activitiesName)
    if answerIndex then
      if activitiesIndex < answerIndex then
        answerIndex = answerIndex - 1
       elseif activitiesIndex > answerIndex then
        answerIndex = answerIndex + 1
      end
    end
  end

  if #taburl == 0 then
    taburl = {urls["activities"]}
    newTabname = {"动态"}
    answerIndex = nil
  end

  return newTabname , taburl, answerIndex
end


local function getdata(v,tabname,tabinfo)
  if v.name=="全部" or v.key=="all" then
    return
  end
  local name=v.name
  local key=v.key
  local url=v.url
  if v.number>0 then
    name=name.." "..tostring(v.number)
  end
  table.insert(tabname,name)
  local info={}
  info.key=key
  info.url=url
  table.insert(tabinfo,info)
end

function base:getTab(func)
  if getLogin()~=true then
    func(self,{"动态"},self:putTabUrl({{type="activities"}}))
    return self
  end
  local tabname={}
  local tabinfo={}
  zHttp.get("https://api.zhihu.com/people/"..people_id.."/profile/tab",apphead,function(code,content)
    if code==200 then
      for _,v in ipairs(luajson.decode(content).tabs_v3) do
        if v.sub_tab then
          for _,v2 in ipairs(v.sub_tab) do
            getdata(v2,tabname,tabinfo)
          end
         else
          getdata(v,tabname,tabinfo)
        end
      end

      local tabname,taburl,answerIndex=self:putTabData(tabname,tabinfo)
      func(self,tabname,taburl,answerIndex)
    end
  end)
  return self
end

function base:initpage(view,tabview)
  return MyPageTool2:new({
    view=view,
    tabview=tabview,
    addcanclick=true,
    needlogin=true,
    head="apphead",
    adapters_func=self.getAdapter,
    func=self.resolvedata,
    urlfunc=function(geturl,head)
      local pos = geturl:find("activities?")
      if pos then
        local data=geturl:sub(pos)
        geturl="https://api.zhihu.com/people/"..self.id.."/"..data
      end
      return geturl,head
    end
  })

end

return base