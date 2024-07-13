--MyPgae Tool
--author huaji
--time 2024-2-1
--self:对象本身
local Page_Tool={
  canclick={},
  ids={},
  pagedata={},
  allcount=1,
  defpage=1,
}--父类

function Page_Tool:new(mtab)
  for key, value in pairs(mtab) do
    self[key] = value
  end
  if self.view.adapter==nil then
    self.view.adapter=SWKLuaPagerAdapter()
  end
  local child=table.clone(self)
  _G[self.bindstr.."_pageTool"]=child
  return child
end

function Page_Tool:addPage(mtype,mydata,mynum)--新建Page
  local adapter=self.view.adapter
  local allcount=self.allcount

  local data_type=type(mydata)

  local mtype=mtype or 1

  local pagadp=adapter
  local list="list".."_"..tostring(allcount)
  local sr="sr".."_"..tostring(allcount)
  local addview

  if data_type=="number" then
    for i=allcount,mydata do
      self:addPage(mtype,nil)
    end
    return
   elseif data_type=="table" then
    for i=allcount,mynum or #mydata do
      self:addPage(mtype,nil)
    end
    self.tabview.setupWithViewPager(self.view)
    --setupWithViewPager设置的必须手动设置text
    for i=1, #mydata do
      local itemnum=i-1
      local tab=self.tabview.getTabAt(itemnum)
      tab.setText(mydata[i]);
    end

    return
  end

  if mtype==1 then
    addview=
    {
      ListView;
      DividerHeight="0",
      layout_width="fill";
      id=list,
      layout_height="fill";
      nestedScrollingEnabled=true,
    };
   elseif mtype==2 then
    addview={
      SwipeRefreshLayout;
      id=sr;
      layout_height="fill";
      layout_width="fill";
      {
        ListView;
        DividerHeight="0",
        layout_width="fill";
        id=list,
        layout_height="fill";
        nestedScrollingEnabled=true,
      };
    }
  end

  pagadp.add(loadlayout(addview,self.ids))
  pagadp.notifyDataSetChanged()
  self.allcount=allcount+1

  table.insert(self.pagedata,{
    prev=false,
    nexturl=false,
    isend=false,
    canload=true,
  })

  if self.addcanclick then
    local mtab=self.canclick
    table.insert(mtab,true)
  end

  return self
end


function Page_Tool:setOnTabListener()
  local needlogin=self.needlogin
  local view=self.tabview
  local mtab=self.canclick

  local func=self.referfunc
  if func==nil then
    error("你必须首先调用createfunc来创建一个刷新的函数")
  end

  view.addOnTabSelectedListener(TabLayout.OnTabSelectedListener {
    onTabSelected=function(tab)
      if needlogin and not(getLogin()) then
        return 提示("请登录后使用本功能")
      end
      --选择时触发
      local pos=tab.getPosition()+1-(self.defpage-1)

      if pos>0 and mtab[pos] then
        mtab[pos]=false
        Handler().postDelayed(Runnable({
          run=function()
            mtab[pos]=true
          end,
        }),1050)
      end
      func(nil,pos,false)
    end,

    onTabUnselected=function(tab)
      --未选择时触发
    end,

    onTabReselected=function(tab)
      --选中之后再次点击即复选时触发
      local pos=tab.getPosition()+1-(self.defpage-1)
      if needlogin and not(getLogin()) then
        return 提示("请登录后使用本功能")
      end
      if pos>0 and mtab[pos] then
        mtab[pos]=false
        Handler().postDelayed(Runnable({
          run=function()
            mtab[pos]=true
          end,
        }),1050)
      end
      func(true,pos,true)
    end,
  });
end

function Page_Tool:createfunc(mtab)
  local bindstr=self.bindstr
  local needlogin=self.needlogin

  local itemc=mtab.itemc
  local onclick=mtab.onclick
  local onlongclick=mtab.onlongclick
  local defurl=mtab.defurl
  local head=mtab.head
  local func=mtab.func
  local funcstr=mtab.funcstr
  local addtab=mtab.addtab

  local dofunc=mtab.dofunc

  self.defurl=defurl

  self.referfunc=function (isclear,pos,isprev)
    local pagedata=self.pagedata
    if pos==nil then
      pos=1
    end

    local func_data
    if dofunc then
      func_data=dofunc(pos)
    end
    if func_data==false then
      return false
    end

    if isprev then
      pagedata[pos]["isprev"]=true
    end
    local isprev=pagedata[pos]["isprev"]
    local thispage,thissr=self:getItem(pos)

    if isclear or not(thispage.adapter) then

      if thispage.adapter then
        thispage.setOnScrollListener(nil)
        luajava.clear(thispage.adapter)
        thispage.adapter=nil
      end

      --布局
      local itemc=itemc
      if itemc and type(itemc)=="table" and itemc["multiple"]==true then
        itemc=itemc[pos]
      end

      local onclick=onclick
      if onclick then
        if type(onclick)=="table" then
          onclick=onclick[pos]
        end
        if onclick then
          thispage.setOnItemClickListener(AdapterView.OnItemClickListener{
            onItemClick=function(parent,v,pos,id)
              return onclick(parent,v,pos,id)
            end
          })
        end
      end

      local onlongclick=onlongclick
      if onlongclick then
        if type(onlongclick)=="table" then
          onlongclick=onlongclick[pos]
        end
        if onlongclick then
          thispage.setOnItemLongClickListener(AdapterView.OnItemLongClickListener{
            onItemLongClick=function(parent,v,pos,id)
              return onlongclick(parent,v,pos,id)
            end
          })
        end
      end

      if isprev~=true then
        pagedata[pos]={
          prev=false,
          nexturl=false,
        }
      end

      thissr.setProgressBackgroundColorSchemeColor(转0x(backgroundc));
      thissr.setColorSchemeColors({转0x(primaryc)});
      thissr.setOnRefreshListener({
        onRefresh=function()
          self.referfunc(true,pos,true)
          Handler().postDelayed(Runnable({
            run=function()
              thissr.setRefreshing(false);
            end,
          }),1000)
        end,
      });

      pagedata[pos]["canload"]=true
      pagedata[pos]["isend"]=false


      local adapter=MyLuaAdapter(activity,itemc)

      local addtab=addtab
      if addtab then
        if type(addtab)=="table" then
          addtab=addtab[pos]
        end
        if addtab then
          table.insert(adapter.getData(),addtab)
        end
      end

      thispage.adapter=adapter

      thispage.setOnScrollListener{
        onScroll=function(view,a,b,c)
          if a+b==c and pagedata[pos]["canload"] then
            self.referfunc(false,pos,false)
            System.gc()
            thissr.setRefreshing(true)
            pagedata[pos]["canload"]=false
            Handler().postDelayed(Runnable({
              run=function()
                thissr.setRefreshing(false);
              end,
            }),1000)
          end
        end
      }

      return
     elseif isclear==nil and thispage.adapter then
      if pagedata[pos].isend then
        return 提示("没有新内容了")
      end
      return false

    end

    if pagedata[pos].isend then
      return 提示("已经到底了")
    end

    local posturl
    if isprev then
      posturl = pagedata[pos].prev
     else
      posturl = pagedata[pos].nexturl
    end

    local posturl= posturl or self.defurl[pos]

    if needlogin and not(getLogin()) then
      return 提示("请登录后使用本功能")
    end

    local madapter=thispage.adapter

    zHttp.get(posturl,_G[head],function(code,content)
      if code==200 then
        pagedata[pos]["isprev"]=false
        local data=luajson.decode(content)

        pagedata[pos].isend=data.paging.is_end
        pagedata[pos].prev=data.paging.previous
        pagedata[pos].nexturl=data.paging.next

        if pagedata[pos].isend==false then
          pagedata[pos]["canload"]=true
         elseif pagedata[pos].isend then
          提示("没有新内容了")
        end

        if data.data then
          for _,v in ipairs(data.data) do
            func(v,pos,madapter)
          end
        end

      end
    end)
  end

  if type(mtab)=="function" then
    self.referfunc=mtab
  end

  _G[funcstr]=function(isclear,pos,isprev)
    return self.referfunc(isclear,pos,isprev)
  end

  return self.referfunc

end

function Page_Tool:clearItem(index)
  self.pagedata[index]={
    prev=false,
    nexturl=false,
    isend=false,
    canload=true,
  }
  local list=self:getItem(index)
  list.adapter.clear()
end

function Page_Tool:setUrlItem(index,url)
  self.defurl[index]=url
end

function Page_Tool:getItem(index)
  local ids=self.ids
  local list="list".."_"..tostring(index)
  local sr="sr".."_"..tostring(index)

  local thislist=ids[list]
  local thissr=ids[sr]

  if thissr==nil then
    thissr = {}
    --防止尝试访问一些没有的方法报错
    setmetatable(thissr, {
      __index = function(table, key)
        return true
      end
    })
  end

  return thislist,thissr
end

return Page_Tool