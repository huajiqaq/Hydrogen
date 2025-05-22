local base={}



function base:new(id)--类的new方法
  local child=table.clone(self)
  child.id=id
  return child
end

--全局变量
recommend_data={}
homeapphead=table.clone(apphead)
homeapphead["x-close-recommend"]="0"

local function getBottomContent(v)
  local 底部内容 = "未知"

  if v.common_card and v.common_card.footline and v.common_card.footline.elements then
    local elements = v.common_card.footline.elements
    local count = #elements

    if count == 1 then
      local element = elements[1]
      if element and element.text and element.text.panel_text then
        底部内容 = element.text.panel_text
      end
    end
  end

  return 底部内容:gsub("等 ", "")
end

function base.resolvedata(v,data)

  v.extra.type=string.lower(v.extra.type)
  if v.type~="common_card" then
    return false
  end

  --对于推广的一些屏蔽
  if v.deliver_type=="ZPlus" or v.promotion_extra then
    return
  end

  local 底部内容=getBottomContent(v)
  local 标题=v.common_card.feed_content.title.panel_text
  local 作者=v.common_card.feed_content.source_line.elements[2].text.panel_text
  local 预览内容=作者.." : "..v.common_card.feed_content.content.panel_text

  local id =v.extra.id
  local 分割字符串;
  local datatype
  local content_type=v.extra.type
  switch content_type
   case "answer"
    datatype=0
    分割字符串="回答分割"
   case "pin"
    datatype=1
    标题=作者.."发表了想法"
    分割字符串="想法分割"
   case "article"
    datatype=2
    分割字符串="文章分割"
   case "zvideo"
    datatype=3
    分割字符串="视频分割"
   case "drama"
    datatype=4
    分割字符串="直播分割"
    预览内容="正在直播中"
    --知乎图书 例如https://www.zhihu.com/pub/book/120202629
    --不考虑适配
   case v.extra.type=="ebook" then
    return
    --知乎训练 例如 https://www.zhihu.com/education/training/sku-detail/1699846867112804354
    --不考虑适配
   case v.extra.type=="training" then
    return
    --vip推荐
    --不考虑适配
   case v.extra.type:find("vip") then
    return
    --需要购买的专栏/小说
    --不考虑适配
   case v.extra.type:find("paid") then
    return
   default
    --[[
    提示("未知类型"..v.extra.type or "无法获取type".." id"..v.extra.id or "无法获取id")
    AlertDialog.Builder(this)
    .setTitle("小提示")
    .setMessage("检测到未知类型的内容 为了方便软件的适配 建议提交问卷 如想提交 请点击下方立即跳转 点击立即跳转后会复制未知数据 请放心 数据内并没有账号信息和隐私数据")
    .setCancelable(false)
    .setPositiveButton("立即跳转",{onClick=function()
        import "android.content.*"
        activity.getSystemService(Context.CLIPBOARD_SERVICE).setText(luajson.encode(v))
        提示("已将未知内容复制到剪贴板内")
        浏览器打开("https://wj.qq.com/s2/13337862/c006/")
    end})
    .setNegativeButton("取消",nil)
    .show()
    ]]
    return
  end

  if v.common_card.feed_content.content then
    预览内容=作者.." : "..v.common_card.feed_content.content.panel_text
   elseif v.common_card.feed_content.video
    预览内容=作者.." : ".."[视频]"
  end

  local id内容=分割字符串..id

  local isread='"t"'
  local readdata=v.brief

  if activity.getSharedData("feed_cache")==nil
    activity.setSharedData("feed_cache",100)
  end
  if tointeger(activity.getSharedData("feed_cache"))>1
    if File(tostring(activity.getExternalCacheDir()).."/rc.json").exists()
      pcall(function()recommend_history=luajson.decode(io.open(tostring(activity.getExternalCacheDir()).."/rc.json"):read("*a"))end)
     else
      recommend_history={}
    end
    if table.find(recommend_history,预览内容)
      提示("找到重复内容")
      local postdata=luajson.encode(readdata)
      postdata=urlEncode('[["r",'..postdata..']]')
      postdata="targets="..postdata
      zHttp.post("https://api.zhihu.com/lastread/touch/v2",postdata,apphead,function(code,content)
        if code==200 then
        end
      end)
      return
     else
      if #recommend_history>tointeger(activity.getSharedData("feed_cache") or 100)
        table.remove(recommend_history,1)
      end
      table.insert(recommend_history,预览内容)
      io.open(tostring(tostring(activity.getExternalCacheDir()).."/rc.json"),"w"):write(tostring(luajson.encode(recommend_history))):close()
    end
  end


  local add={}
  add.标题=标题
  add.预览内容=预览内容
  add.底部内容=底部内容
  add.id内容=id内容

  local extradata= {
    isread=isread,
    readdata=readdata
  }
  table.insert(recommend_data,extradata)
  add.extradata=extradata

  table.insert(data,add)
end


function base.getAdapter(home_pagetool,pos)
  local data=home_pagetool:getItemData(pos)
  return LuaCustRecyclerAdapter(AdapterCreator({

    getItemCount=function()
      return #data
    end,

    getItemViewType=function(position)
      return 0
    end,

    onCreateViewHolder=function(parent,viewType)
      local views={}
      loaditemc=获取适配器项目布局("home/home_layout")
      holder=LuaCustRecyclerHolder(loadlayout(loaditemc,views))
      holder.view.setTag(views)
      return holder
    end,

    onBindViewHolder=function(holder,position)
      local views=holder.view.getTag()
      local data=data[position+1]
      local type=data.datatype

      local 标题=data.标题
      local 预览内容=data.预览内容
      local 底部内容=data.底部内容
      local id内容=data.id内容
      local extradata=data.extradata
      local isread=extradata.isread
      local readdata=extradata.readdata

      views.标题.text=标题
      views.预览内容.text=预览内容
      views.底部内容.text=底部内容

      views.card.onTouch=function(v,event)
        downx=event.getRawX()
        downy=event.getRawY()
      end

      views.card.onClick=function()
        if getLogin() then
          home_pagetool:getItemData()[position+1].extradata.isread='"r"'

          local postdata=luajson.encode(readdata)
          postdata=urlEncode('[["r",'..postdata..']]')
          postdata="targets="..postdata

          zHttp.post("https://api.zhihu.com/lastread/touch/v2",postdata,apphead,function(code,content)
            if code==200 then
            end
          end)
        end

        nTView=views.card
        点击事件判断(data.id内容,data.标题)
      end

      views.card.onLongClick=function(view)
        if tostring(data.id内容):find("文章分割") then
          mytype="article"
          myid=tostring(data.id内容):match("文章分割(.+)")
         elseif tostring(data.id内容):find("想法分割") then
          mytype="pin"
          myid=tostring(data.id内容):match("想法分割(.+)")
         elseif tostring(data.id内容):find("视频分割") then
          mytype="zvideo"
          myid=tostring(data.id内容):match("视频分割(.+)")
         elseif tostring(data.id内容):find("直播分割") then
          mytype="drama"
          myid=tostring(data.id内容):match("直播分割(.+)")
         else
          mytype="answer"
          myid=tostring(data.id内容):match("分割(.+)")
        end
        zHttp.get("https://api.zhihu.com/negative-feedback/panel?scene_code=RECOMMEND&content_type="..mytype.."&content_token="..myid,apphead,function(code,content)
          if code==200 then
            local menu={}
            local data=luajson.decode(content).data.items
            for k,v in ipairs(data) do
              local raw_button=v.raw_button
              local method=string.lower(raw_button.action.method)
              local panel_text=raw_button.text.panel_text
              table.insert(menu,{
                panel_text,
                function()
                  if raw_button.action.backend_url then
                    zHttp.request(raw_button.action.backend_url,method,"",apphead,function(code,content)
                      if code==200 then
                        提示(raw_button.text.toast_text)
                      end
                    end)
                   elseif raw_button.action.intent_url then
                    newActivity("browser",{raw_button.action.intent_url.."&source=android&ab_signature=","举报"})
                  end
                end
              })
            end
            local pop=showPopMenu(menu)
            pop.showAtLocation(v, Gravity.NO_GRAVITY, downx, downy);
          end
        end)
      end

    end,
  }))

end

function base:initpage(view,sr)
  return MyPageTool2:new({
    view=view,
    sr=sr,
    head="homeapphead",
    adapters_func=self.getAdapter,
    func=self.resolvedata,
    allow_prev=true
  })
  :initPage()
  :createfunc()
  :setUrlItem("https://api.zhihu.com/topstory/recommend")
end

return base