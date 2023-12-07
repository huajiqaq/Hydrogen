require "import"
import "mods.muk"

import "com.google.android.material.tabs.TabLayout"

波纹({fh,_more},"圆主题")

初始化历史记录数据(true)


id,mtype,title,tz,issub=...

mtype=mtype:gsub("更多","")

canclick_followed={true,true}

if not mtype:find("的")
  mtype="的"..mtype
end

if mtype:find("收藏") then

  activity.setContentView(loadlayout("layout/followed_collections"))

  if title then
    if mtype:find("他") or mtype:find("她") then
      _title.text=title.."的收藏夹"
     else
      _title.text=title..mtype
    end
   else
    _title.text=mtype
  end

  initpage(page,"collection",2)

  if tz then
    page.setCurrentItem(2)
  end

  可以加载收藏={}
  collection_isend={}
  collection_nexturl={}

  function 收藏刷新(isclear,pos)

    if pos==nil then
      pos=1
      if tz then
        pos=2
      end
    end

    local thispage,thissr=getpage(page,"collection",pos,2)

    local alldo={
      function(v)
        return
        {
          collections_title={
            text=v.title,
          },
          is_lock=v.is_public==false and 图标("https") or nil,

          collections_art={
            text=""..(v.item_count).."个内容"
          },
          collections_item={
            text=math.floor(v.comment_count)..""
          },
          collections_follower={
            text=(v.follower_count)..""
          },
          collections_id={
            text=tostring(v.id)

          },
        }
      end,
      function(v)
        return
        {
          mc_image=v.creator.avatar_url,
          mc_name={
            text="由 "..v.creator.name.." 创建"
          },
          mc_title={
            text=v.title
          },
          mc_follower={
            text=math.floor(v.follower_count).."人关注"
          },
          mc_id={
            text=tostring(v.id),
          },
          background={foreground=Ripple(nil,转0x(ripplec),"方")},
        }
      end,
    }

    local oriurl={
      "https://api.zhihu.com/people/"..id.."/collections_v2?with_update=1&with_deleted=1&offset=0&limit=20",
      "https://api.zhihu.com/people/"..id.."/following_collections?with_update=1&offset=0"
    }

    if CollectiontabLayout.getTabCount()==0 then
      CollectiontabLayout.setupWithViewPager(page)
      local CollectionTable={"我的","关注"}
      --setupWithViewPager设置的必须手动设置text
      for i=1, #CollectionTable do
        local itemnum=i-1
        local tab=CollectiontabLayout.getTabAt(itemnum)
        tab.setText(CollectionTable[i]);
      end
      CollectiontabLayout.addOnTabSelectedListener(TabLayout.OnTabSelectedListener {
        onTabSelected=function(tab)
          --选择时触发
          local pos=tab.getPosition()+1
          if canclick_followed[pos] then
            canclick_followed[pos]=false
            Handler().postDelayed(Runnable({
              run=function()
                canclick_followed[pos]=true
              end,
            }),1050)
           else
            return false
          end
          收藏刷新(false,pos)
        end,

        onTabUnselected=function(tab)
          --未选择时触发
        end,

        onTabReselected=function(tab)
          --选中之后再次点击即复选时触发
          local pos=tab.getPosition()+1
          if canclick_followed[pos]then
            canclick_followed[pos]=false
            Handler().postDelayed(Runnable({
              run=function()
                canclick_followed[pos]=true
              end,
            }),1050)
           else
            return false
          end
          收藏刷新(true,pos)
        end,
      });

    end

    if thispage.adapter and isclear==false then
      return
    end
    if not(thispage.adapter) or isclear then

      if thispage.adapter then
        thispage.setOnScrollListener(nil)
        luajava.clear(thispage.adapter)
        thispage.adapter=nil
      end

      local allitemc={获取适配器项目布局("home/home_collections"),获取适配器项目布局("home/home_shared_collections")}
      local allonclick={
        AdapterView.OnItemClickListener{
          onItemClick=function(parent,v,pos,id)
            activity.newActivity("collections",{v.Tag.collections_id.Text})
          end
        },
        AdapterView.OnItemClickListener{
          onItemClick=function(parent,v,pos,id)
            if v.Tag.mc_id.text=="local" then
              activity.newActivity("collections_tj")
              return
            end
            activity.newActivity("collections",{v.Tag.mc_id.Text,true})
          end
        },
      }

      local allonlongclick={
        AdapterView.OnItemLongClickListener{
          onItemLongClick=function(id,v,zero,one)
            local collections_id=v.Tag.collections_id.text
            if collections_id=="local" then
              提示("不支持删除本地收藏夹")
              return true
            end
            双按钮对话框("删除收藏夹","删除收藏夹？该操作不可撤消！","是的","点错了",function(an)
              zHttp.delete("https://api.zhihu.com/collections/"..collections_id,head,function(code,json)
                if code==200 then
                  提示("已删除")
                  id.adapter.remove(zero)
                 else
                  提示("删除失败")
                end
              end)
              an.dismiss()
            end,function(an)an.dismiss()end)
            return true
        end},
        AdapterView.OnItemLongClickListener{
          onItemLongClick=function(id,v,zero,one)
            local collections_id=v.Tag.mc_id.text
            if collections_id=="local" then
              提示("不支持操作此收藏夹")
              return true
            end
            双按钮对话框("取关该收藏夹","取消关注该收藏夹？该操作不可撤消！","是的","点错了",function(an)
              zHttp.delete("https://api.zhihu.com/collections/"..collections_id.."/followers/"..activity.getSharedData("idx"),head,function(code,json)
                if code==200 then
                  提示("已取关")
                  id.adapter.remove(zero)
                 else
                  提示("删除失败")
                end
              end)
              an.dismiss()
            end,function(an)an.dismiss()end)
            return true
          end
        },
      }


      local alladd={
        "null",
        {
          mc_image="https://picx.zhimg.com/50/v2-abed1a8c04700ba7d72b45195223e0ff_xl.jpg",
          mc_name={
            text="为你推荐"
          },
          mc_title={
            text="推荐关注收藏夹"
          },
          mc_follower={
            text=""
          },
          mc_id={
            text="local",
          },
          background={foreground=Ripple(nil,转0x(ripplec),"方")},
        },
      }


      thispage.setOnItemClickListener(allonclick[pos])
      thispage.setOnItemLongClickListener(allonlongclick[pos])
      thissr.setProgressBackgroundColorSchemeColor(转0x(backgroundc));
      thissr.setColorSchemeColors({转0x(primaryc)});
      thissr.setOnRefreshListener({
        onRefresh=function()
          收藏刷新(true,pos)
          Handler().postDelayed(Runnable({
            run=function()
              thissr.setRefreshing(false);
            end,
          }),1000)

        end,
      });

      thispage.adapter=MyLuaAdapter(activity,allitemc[pos])
      local madapter=thispage.Adapter

      if alladd[pos]~="null"
        table.insert(madapter.getData(),alladd[pos])
      end

      可以加载收藏[pos]=true
      collection_isend[pos]=false
      collection_nexturl[pos]=false

      thispage.setOnScrollListener{
        onScroll=function(view,a,b,c)
          if a+b==c and 可以加载收藏[pos] then
            可以加载收藏[pos]=false
            收藏刷新(nil,pos)
            thissr.setRefreshing(true)
            System.gc()
            Handler().postDelayed(Runnable({
              run=function()
                thissr.setRefreshing(false);
              end,
            }),1000)
          end
        end
      }

      return
    end
    local dofun=alldo[pos]

    local madapter=thispage.Adapter

    local collections_url= collection_nexturl[pos] or oriurl[pos]
    zHttp.get(collections_url,head,function(code,content)
      if code==200 then
        local data=luajson.decode(content)
        collection_isend[pos]=data.paging.is_end
        collection_nexturl[pos]=data.paging.next
        if collection_isend[pos]==false then
          可以加载收藏[pos]=true
         elseif collection_isend[pos] then
          提示("没有新内容了")
        end
        for k,v in ipairs(data.data) do
          madapter.add(dofun(v))
        end

       else
        提示("获取收藏列表失败")
      end
    end)
    return

  end

  收藏刷新(false)

 else
  activity.setContentView(loadlayout("layout/history"))
  if title then
    if mtype:find("他") or mtype:find("她") then
      _title.text=mtype
     else
      _title.text=title..mtype
    end
   else
    _title.text=mtype
  end
  history_list.setDividerHeight(0)
  tabv.setVisibility(8)
  itemc=获取适配器项目布局("simple/card")
  if mtype:find("视频") then

    if issub then
      murl="https://api.zhihu.com/zvideo-collections/collections/"..id.."/include?offset=0&limit=10&include=answer"
      function reslove(v)
        local 标题=v.title
        local 预览内容=v.description
        local 底部内容=v.play_count.."个播放"
        xpcall(function()
          videourl=v.video.playlist.sd.url
          end,function()
          videourl=v.video.playlist.ld.url
          end,function()
          videourl=v.video.playlist.hd.url
        end)
        xpcall(function()
          videourl=v.video.playlist.sd.url
          end,function()
          videourl=v.video.playlist.ld.url
          end,function()
          videourl=v.video.playlist.hd.url
        end)
        链接="视频分割"..videourl
        if 预览内容==false or 预览内容=="" then
          预览内容="无介绍"
        end
        return {标题=标题,文章=预览内容,底部内容=底部内容,链接=链接,mc_title=标题}
      end
     else
      murl="https://api.zhihu.com/zvideo-collections/members/"..id.."/collections?offset=0&limit=10"
      function reslove(v)
        local 标题=v.name
        local 预览内容=v.description
        local 链接="视频合集分割"..v.id
        local 底部内容=v.zvideo_count.."个视频 · "..v.voteup_count.."个赞同"
        if 预览内容==false or 预览内容=="" then
          预览内容="无介绍"
        end
        return {标题=标题,文章=预览内容,底部内容=底部内容,链接=链接,mc_title=标题}
      end
    end
   else
    if mtype:find("专栏") then
      mmtype="columns"
      function reslove(v)
        local 标题=v.title
        local 预览内容=v.description
        local 链接="专栏分割"..v.id
        local 底部内容=v.items_count.."篇内容 · "..v.voteup_count.."个赞同"
        if 预览内容==false or 预览内容=="" then
          预览内容="无介绍"
        end
        return {标题=标题,文章=预览内容,底部内容=底部内容,链接=链接,mc_title=标题}
      end
     elseif mtype:find("话题") then
      mmtype="topics"
      --底部内容删除
      itemc[2][2][3][4]=nil
      function reslove(v)
        local 标题=v.name
        local 预览内容=v.excerpt
        local 链接="话题分割"..v.id
        local 底部内容="无"
        if 预览内容==false or 预览内容=="" then
          预览内容="无介绍"
        end
        return {标题=标题,文章=预览内容,链接=链接,mc_title=标题}
      end
     elseif mtype:find("问题") then
      mmtype="questions"
      --预览内容删除
      itemc[2][2][3][3]=nil
      function reslove(v)
        local 标题=v.title
        local 链接="问题分割"..v.id
        local 底部内容=v.answer_count.."个回答 · "..v.follower_count.."个关注"
        if 预览内容==false or 预览内容=="" then
          预览内容="无介绍"
        end
        return {标题=标题,底部内容=底部内容,链接=链接,mc_title=标题}
      end
    end
    murl="https://api.zhihu.com/people/"..id.."/following_"..mmtype.."?offset=0&limit=20"

  end

  adp=LuaAdapter(activity,itemc)
  history_list.Adapter=adp

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
          history_list.Adapter.add(reslove(v))
        end
      end
    end)
  end

  history_list.onItemClick=function(l,v,c,b)
    if tostring(v.Tag.链接.Text):find("视频合集分割") then
      activity.newActivity("followed",{tostring(v.Tag.链接.Text):match("视频合集分割(.+)"),mtype,title,tz,true})
     elseif tostring(v.Tag.链接.Text):find("视频分割") then
      activity.newActivity("huida",{tostring(v.Tag.链接.Text):match("视频分割(.+)"),"视频",true})
     elseif tostring(v.Tag.链接.Text):find("专栏分割") then
      activity.newActivity("people_column",{tostring(v.Tag.链接.Text):match("专栏分割(.+)")})
     elseif tostring(v.Tag.链接.Text):find("话题分割") then
      activity.newActivity("topic",{tostring(v.Tag.链接.Text):match("话题分割(.+)")})
     elseif tostring(v.Tag.链接.Text):find("问题分割") then
      activity.newActivity("question",{tostring(v.Tag.链接.Text):match("问题分割(.+)")})

    end
  end

  add=true

  history_list.setOnScrollListener{
    onScroll=function(view,a,b,c)
      if a+b==c and add then
        add=false
        刷新()
        System.gc()
      end
    end
  }

end

task(1,function()
  a=MUKPopu({
    tittle=_title.Text,
    list={
    },
  })
end)