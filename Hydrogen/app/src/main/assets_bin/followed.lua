require "import"
import "mods.muk"

import "com.google.android.material.tabs.TabLayout"

波纹({fh,_more},"圆主题")

初始化历史记录数据(true)


id,mtype,title,tz,issub=...

task(1,function()
  a=MUKPopu({
    tittle=_title.Text,
    list={
    },
  })
end)

mtype=mtype:gsub("更多","")

if not mtype:find("的")
  mtype="的"..mtype
end

--判断是否为收藏夹
if mtype:find("收藏") then

  activity.setContentView(loadlayout("layout/followed_collections"))
  设置toolbar(toolbar)

  if title then
    if mtype:find("他") or mtype:find("她") then
      _title.text=title.."的收藏夹"
     else
      _title.text=title..mtype
    end
   else
    _title.text=mtype
  end

  resolve_home_collection={
    function(v)
      return
      {
        标题={
          text=v.title,
        },
        is_lock=v.is_public==false and 图标("https") or nil,

        预览内容={
          text=""..(v.item_count).."个内容"
        },
        评论数={
          text=math.floor(v.comment_count)..""
        },
        关注数={
          text=(v.follower_count)..""
        },
        id内容={
          text=tostring(v.id)

        },
      }
    end,
    function(v)
      return
      {
        图像=v.creator.avatar_url,
        预览内容={
          text="由 "..v.creator.name.." 创建"
        },
        标题={
          text=v.title
        },
        关注数={
          text=math.floor(v.follower_count).."人关注"
        },
        id内容={
          text=tostring(v.id),
        },
        background={foreground=Ripple(nil,转0x(ripplec),"方")},
      }
    end,
  }

  local conf={
    view=page,
    tabview=CollectiontabLayout,
    bindstr="collection",
    addcanclick=true,
  }

  MyPageTool:new(conf)
  local CollectionTable={"我的","关注"}
  collection_pageTool:addPage(2,CollectionTable)

  local mconf={
    itemc={
      multiple=true,
      [1]=获取适配器项目布局("home/home_collections"),
      [2]=获取适配器项目布局("home/home_shared_collections")
    },
    onclick={
      function(parent,v,pos,id)
        activity.newActivity("collections",{v.Tag.id内容.Text})
      end,
      function(parent,v,pos,id)
        activity.newActivity("collections",{v.Tag.mc_id.Text,true})
      end,
    },
    defurl={
      "https://api.zhihu.com/people/"..id.."/collections_v2?offset=0&limit=20",
      "https://api.zhihu.com/people/"..id.."/following_collections?offset=0"
    },
    head="head",

    func=function(v,pos,adapter)
      local data= resolve_home_collection[pos](v)
      if data then
        adapter.add(data)
      end
    end,
    funcstr="收藏刷新"
  }

  local loadpage=1

  if tz then
    page.setCurrentItem(2)
    loadpage=2
  end

  collection_pageTool:createfunc(mconf)
  collection_pageTool:setOnTabListener()

  收藏刷新(false,loadpage)
  return
end

--不是就使用通用的布局
activity.setContentView(loadlayout("layout/simple"))
if title then
  if mtype:find("他") or mtype:find("她") then
    _title.text=mtype
   else
    _title.text=title..mtype
  end
 else
  _title.text=mtype
end

simple_list.setDividerHeight(0)
itemc=获取适配器项目布局("simple/card")
if mtype:find("视频") then

  if issub then
    murl="https://api.zhihu.com/zvideo-collections/collections/"..id.."/include?offset=0&limit=10&include=answer"

    function resolve(v)
      local 标题=v.title
      local 预览内容=v.description
      local 底部内容=v.play_count.."个播放"
      链接="视频分割"..v.id
      if 预览内容==false or 预览内容=="" then
        预览内容="无介绍"
      end
      return {标题=标题,预览内容=预览内容,底部内容=底部内容,id内容=链接,标题=标题}
    end

   else
    murl="https://api.zhihu.com/zvideo-collections/members/"..id.."/collections?offset=0&limit=10"

    function resolve(v)
      local 标题=v.name
      local 预览内容=v.description
      local 链接="视频合集分割"..v.id
      local 底部内容=v.zvideo_count.."个视频 · "..v.voteup_count.."个赞同"
      if 预览内容==false or 预览内容=="" then
        预览内容="无介绍"
      end
      return {标题=标题,预览内容=预览内容,底部内容=底部内容,id内容=链接,标题=标题}
    end

  end
 else
  if mtype:find("专栏") then
    mmtype="columns"

    function resolve(v)
      local 标题=v.title
      local 预览内容=v.description
      local 链接="专栏分割"..v.id
      local 底部内容=v.items_count.."篇内容 · "..v.voteup_count.."个赞同"
      if 预览内容==false or 预览内容=="" then
        预览内容="无介绍"
      end
      return {标题=标题,预览内容=预览内容,底部内容=底部内容,id内容=链接,标题=标题}
    end

   elseif mtype:find("话题") then
    mmtype="topics"
    --底部内容删除
    itemc[2][2][3][4]=nil

    function resolve(v)
      local 标题=v.name
      local 预览内容=v.excerpt
      local 链接="话题分割"..v.id
      local 底部内容="无"
      if 预览内容==false or 预览内容=="" then
        预览内容="无介绍"
      end
      return {标题=标题,预览内容=预览内容,id内容=链接}
    end

   elseif mtype:find("问题") then
    mmtype="questions"
    --预览内容删除
    itemc[2][2][3][3]=nil

    function resolve(v)
      local 标题=v.title
      local 链接="问题分割"..v.id
      local 底部内容=v.answer_count.."个回答 · "..v.follower_count.."个关注"
      if 预览内容==false or 预览内容=="" then
        预览内容="无介绍"
      end
      return {标题=标题,底部内容=底部内容,id内容=链接,标题=标题}
    end

  end
  murl="https://api.zhihu.com/people/"..id.."/following_"..mmtype.."?offset=0&limit=20"

end

adp=LuaAdapter(activity,itemc)
simple_list.Adapter=adp

function 刷新()
  geturl=myurl or murl
  zHttp.get(geturl,apphead,function(code,content)
    if code==200 then
      if luajson.decode(content).paging.next then
        testurl=luajson.decode(content).paging.next
        if testurl:find("http://") then
          testurl=string.gsub(testurl,"http://","https://",1)
        end
        myurl=testurl
      end
      if luajson.decode(content).paging.is_end and isclear~="clear" then
        提示("已经没有更多内容了")
       else
        add=true
      end
      for i,v in ipairs(luajson.decode(content).data) do
        simple_list.Adapter.add(resolve(v))
      end
    end
  end)
end

simple_list.onItemClick=function(l,v,c,b)
  点击事件判断(v.Tag.id内容.Text)
end

add=true

simple_list.setOnScrollListener{
  onScroll=function(view,a,b,c)
    if a+b==c and add then
      add=false
      刷新()
      System.gc()
    end
  end
}
