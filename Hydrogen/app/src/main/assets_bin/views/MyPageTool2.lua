--MyPgae Tool
--author huaji
--time 2024-2-1
--self:对象本身
local Page_Tool={
  canclick={},
  ids={},
  pagedata={},
  datas={},
  urls={},
  adapters={},
  funcs={},
  allcount=0,
  addpos=0,
}--父类

local function contains_any(test_string)
  for word in string.gmatch(this.getSharedData("屏蔽词"), "%S+") do
    if string.find(test_string, word, 1, true) then
      return true
    end
  end
  return false
end

local function 加载屏蔽词(tab)
  if this.getSharedData("屏蔽词") and this.getSharedData("屏蔽词"):gsub(" ","")~="" then
    local mt = {
      __newindex = function(t, k, v)
        local 匹配内容=tostring(v.标题)..tostring(v.预览内容)
        if contains_any(匹配内容) then
          return
        end
        rawset(t, k, v)
      end
    }
    setmetatable(tab, mt)
  end
end

function Page_Tool:new(conf)
  if not conf then
    error("至少要绑定一个view")
  end
  local child=table.clone(self)
  for key, value in pairs(conf) do
    child[key] = value
  end
  if not luajava.instanceof(child.view,RecyclerView) and child.view.adapter==nil then
    child.view.adapter=SWKLuaPagerAdapter()
  end
  return child
end

function Page_Tool:initPage()

  table.insert(self.datas,{})

  加载屏蔽词(self.datas[#self.datas])

  table.insert(self.pagedata,{
    prev=false,
    nexturl=false,
    isend=false,
    canload=true,
  })
  --添加用于限制点击的标识
  if self.addcanclick then
    local canclick=self.canclick
    table.insert(canclick,true)
  end

  local pagedata=self.pagedata
  --allcount从0计数 下标是1符合我的预期 所以先加1
  local pos=self.allcount+1
  local thispage,thissr=self:getItem(pos)


  if self.adapters_func then
    local adapters_func=self.adapters_func
    self.adapters[pos]=adapters_func(self,pos)
  end

  if self.adapter then
    local adapter=self.adapter
    self.adapters[pos]=adapter
  end

  if self.func then
    local func=self.func
    self.funcs[pos]=func
  end

  if not thispage.adapter then
    if thissr then
      thissr.setProgressBackgroundColorSchemeColor(转0x(backgroundc));
      thissr.setColorSchemeColors({转0x(primaryc)});
      thissr.setOnRefreshListener({
        onRefresh=function()
          self:clearItem(pos)
          self:refer(pos,true)
          Handler().postDelayed(Runnable({
            run=function()
              thissr.setRefreshing(false);
            end,
          }),1000)
        end,
      });
    end

    local manager=LinearLayoutManager(this,RecyclerView.VERTICAL,false)
    thispage.setLayoutManager(manager)

    local adp=self.adapters[pos]
    if adp then
      thispage.adapter=adp
     else
      error("必须先设置当前页的adp")
    end

    thispage.addOnScrollListener(RecyclerView.OnScrollListener{
      onScrollStateChanged=function(recyclerView,newState)
        if newState == RecyclerView.SCROLL_STATE_IDLE then
          local lastVisiblePosition = manager.findLastVisibleItemPosition();
          if lastVisiblePosition >= manager.getItemCount() - 1 and pagedata[pos]["canload"] then
            local pos=self:getCurrentItem()
            self.referfunc(pos,false)
            System.gc()
          end
        end
    end});
  end

  --变量添加
  self.allcount=self.allcount+1

  return self
end

function Page_Tool:addPage(addtype,mydata)--新建Page
  if luajava.instanceof(self.view,RecyclerView) then
    error("RecyclerView单页不支持addPage")
  end

  local data_type=type(mydata)

  if data_type=="number" then
    for i=1,mydata do
      self:addPage(addtype)
    end
    return self
   elseif data_type=="table" then
    for i=1,#mydata-self.addpos do
      self:addPage(addtype)
    end

    self.tabview.setupWithViewPager(self.view)
    --setupWithViewPager设置的必须手动设置text
    for i=1, #mydata do
      local itemnum=i-1
      local tab=self.tabview.getTabAt(itemnum)
      tab.setText(mydata[i]);
    end

    return self
  end

  --获取adapter
  local adapter=self.view.adapter
  --已经添加页的总数
  --allcount从0计数 下标是1符合我的预期 所以先加1
  local allcount=self.allcount+1
  --要添加页的类型
  local addtype=addtype or 1

  local pagadp=adapter
  local list="list".."_"..tostring(allcount)
  local sr="sr".."_"..tostring(allcount)
  local addview

  if addtype==1 then
    addview=
    {
      RecyclerView;
      layout_width="fill";
      id=list,
      layout_height="fill";
      nestedScrollingEnabled=true,
    };
   elseif addtype==2 then
    addview={
      SwipeRefreshLayout;
      id=sr;
      layout_height="fill";
      layout_width="fill";
      {
        RecyclerView;
        layout_width="fill";
        id=list,
        layout_height="fill";
        nestedScrollingEnabled=true,
      };
    }
  end

  pagadp.add(loadlayout(addview,self.ids))
  pagadp.notifyDataSetChanged()

  --初始化页数据
  self:initPage()

  return self
end


function Page_Tool:setOnTabListener(callback)
  local view=self.tabview
  local canclick=self.canclick

  local referfunc=self.referfunc
  if referfunc==nil then
    error("你必须首先调用createfunc来创建一个刷新的函数")
  end


  local callback=callback or function() end

  view.addOnTabSelectedListener(TabLayout.OnTabSelectedListener {
    onTabSelected=function(tab)
      --选择时触发
      local pos=tab.getPosition()+1-self.addpos

      callback(self,pos)

      if pos>0 and canclick[pos] then
        canclick[pos]=false
        Handler().postDelayed(Runnable({
          run=function()
            canclick[pos]=true
          end,
        }),1050)
      end
      self:refer(pos,false,true)
    end,

    onTabUnselected=function(tab)
      --未选择时触发
    end,

    onTabReselected=function(tab)
      --选中之后再次点击即复选时触发
      local pos=tab.getPosition()+1-self.addpos

      callback(self,pos)

      if pos>0 and canclick[pos] then
        canclick[pos]=false
        Handler().postDelayed(Runnable({
          run=function()
            canclick[pos]=true
          end,
        }),1050)
      end
      self:clearItem(pos)
      referfunc(pos,true)
    end,
  });
  return self
end

function Page_Tool:createfunc()

  if self.referfunc then
    error("referfunc已创建 只能存在一个referfunc")
  end

  if not self.funcs then
    error("创建referfunc时必须拥有自身funcs属性")
  end

  if not self.adapters then
    error("创建referfunc时必须拥有自身adapters属性")
  end

  local needlogin=self.needlogin

  self.referfunc=function (pos,isprev)
    local pagedata=self.pagedata

    if pos==nil then
      pos=1
    end

    if isprev then
      pagedata[pos]["isprev"]=true
    end

    local isprev=pagedata[pos]["isprev"]
    local thispage,thissr=self:getItem(pos)

    if pagedata[pos].isend then
      return 提示("已经到底了")
    end

    local posturl
    if isprev then
      posturl = pagedata[pos].prev
     else
      posturl = pagedata[pos].nexturl
    end

    local posturl= posturl or self.urls[pos]

    if needlogin and not(getLogin()) then
      return 提示("请登录后使用本功能")
    end

    local adapter=thispage.adapter

    local head
    if self.head then
      head=_G[self.head]
    end
    if self.urlfunc then
      posturl,head=self.urlfunc(posturl,head)
    end

    zHttp.get(posturl,head,function(code,content)
      if code==200 then
        pagedata[pos]["isprev"]=false
        local data=luajson.decode(content)

        if data.paging then
          pagedata[pos].isend=data.paging.is_end
          pagedata[pos].prev=data.paging.previous
          pagedata[pos].nexturl=data.paging.next

          if pagedata[pos].isend==false then
            pagedata[pos]["canload"]=true
           elseif pagedata[pos].isend then
            提示("没有新内容了")
          end

        end

        local adpdata=self:getItemData(pos)
        local func=self.funcs[pos]
        if data.data then
          for _,v in ipairs(data.data) do
            func(v,adpdata)
          end
         else
          func(data,adpdata,pos)
        end
        thispage.adapter.notifyDataSetChanged()

        local manager=thispage.getLayoutManager()
        local listener=thispage.getViewTreeObserver().addOnGlobalLayoutListener(
        ViewTreeObserver.OnGlobalLayoutListener{
          onGlobalLayout=function()
            local lastVisiblePosition = manager.findLastVisibleItemPosition();
            if lastVisiblePosition >= manager.getItemCount() - 1 and pagedata[pos]["canload"] then
              local pos=self:getCurrentItem()
              self.referfunc(pos,isprev)
              System.gc()
             else
              thispage.getViewTreeObserver().removeGlobalOnLayoutListener(listener);
            end
          end
        })

      end
    end)

    thissr.setRefreshing(true)
    pagedata[pos]["canload"]=false

    Handler().postDelayed(Runnable({
      run=function()
        thissr.setRefreshing(false);
      end,
    }),1000)

  end

  return self
end

function Page_Tool:getCurrentItem()
  --针对只有一个RecyclerView的适配
  if luajava.instanceof(self.view,RecyclerView) then
    return 1
  end
  local viewpager=self.view
  return viewpager.getCurrentItem()+1-self.addpos
end

function Page_Tool:refer(index,isprev,isinit)
  local index=index or self:getCurrentItem()
  local thispage,thissr=self:getItem(index)
  if index==0 or (isinit and self:getItem(index).adapter.getItemCount()>1) then
    return self
  end
  self.referfunc(index,isprev)
  return self
end

function Page_Tool:getData()
  return self.datas
end

function Page_Tool:getItemData(index)
  local index=index or self:getCurrentItem()
  local datas=self:getData()
  return datas[index]
end

function Page_Tool:clearItem(index)
  local index=index or self:getCurrentItem()
  self.pagedata[index]={
    prev=false,
    nexturl=false,
    isend=false,
    canload=true,
  }
  local list=self:getItem(index)
  if list.adapter then
    table.clear(self:getItemData(index))
    list.removeAllViews();
    list.getRecycledViewPool().clear();
    list.adapter.notifyDataSetChanged()
  end
  return self
end

function Page_Tool:setUrls(urls)
  self.urls=urls
  return self
end

function Page_Tool:setUrlItem(url,index)
  local index=index or self:getCurrentItem()
  self.urls[index]=url
  return self
end

function Page_Tool:getItem(index)

  --针对只有一个RecyclerView的适配
  if luajava.instanceof(self.view,RecyclerView) then
    return self.view,self.sr
  end

  local index=index or self:getCurrentItem()

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