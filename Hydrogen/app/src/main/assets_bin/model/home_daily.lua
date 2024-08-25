local base={
  日报data={},
  可以加载日报=true,
  thisdata=1,
  news={},
  ZUOTIAN=nil
}

function base:new(id)--类的new方法
  local child=table.clone(self)
  return child
end

function base:getData(isclear,isinit)

  if isclear then
    self.可以加载日报=true
    self.thisdata=1
    self.news={}
    self.ZUOTIAN=nil

    table.clear(self.日报data)
    self.view.removeAllViews();
    self.view.getRecycledViewPool().clear();
    self.view.adapter.notifyDataSetChanged()
  end

  if isinit and self.view.adapter.getItemCount()>0 then
    return self
  end

  local ZUOTIAN=self.ZUOTIAN
  local thisdata=self.thisdata
  local 日报adp=self.view.adapter

  if ZUOTIAN==nil then
    self.链接 = "https://news-at.zhihu.com/api/4/stories/latest"
    self.ZUOTIAN = true
   else
    self.thisdata=self.thisdata-1
    import "android.icu.text.SimpleDateFormat"
    local cal=Calendar.getInstance();
    cal.add(Calendar.DATE,thisdata);
    local d=cal.getTime();
    local sp= SimpleDateFormat("yyyyMMdd");
    local ZUOTIAN=sp.format(d);
    self.链接 = 'https://news-at.zhihu.com/api/4/stories/before/'..tostring(ZUOTIAN)
  end
  self.可以加载日报=false
  zHttp.get(self.链接,head,function(code,content)
    if code==200 then
      self.可以加载日报=true
     else
      return
    end
    if self.thisdata==0 then
      self.newnews=content
     elseif self.thisdata==-1 then
      if content==self.newnews
        return
      end
    end

    for k,v in ipairs(luajson.decode(content).stories) do
      local add={}
      add.标题=v.title
      add.id内容=v.url
      table.insert(self.日报data,add)   
    end
    日报adp.notifyDataSetChanged()
  end)

  self.sr.setRefreshing(true);
  Handler().postDelayed(Runnable({
    run=function()
      self.sr.setRefreshing(false);
    end,
  }),1000)

end

function base:getAdapter(home_pagetool,pos)
  local 日报adp=LuaRecyclerAdapter(activity,self.日报data,获取适配器项目布局("home/home_daily"))
  日报adp.setAdapterInterface(LuaRecyclerAdapter.AdapterInterface{
    onBindViewHolder=function(holder,position)
      local views=holder.getTag()
      local data=self.日报data[position+1]

      local 标题=data.标题
      local id内容=data.id内容

      views.标题.text=标题
      views.card.onClick=function()
        activity.newActivity("huida",{data.id内容})
      end
    end,
  })

  return 日报adp
end

function base:initpage(view,sr)
  self.view=view
  self.sr=sr
  view.setAdapter(self:getAdapter())
  local manager=LinearLayoutManager(this,RecyclerView.VERTICAL,false)
  view.setLayoutManager(manager)

  sr.setProgressBackgroundColorSchemeColor(转0x(backgroundc));
  sr.setColorSchemeColors({转0x(primaryc)});
  sr.setOnRefreshListener({
    onRefresh=function()
      self:getData(true)
      Handler().postDelayed(Runnable({
        run=function()
          sr.setRefreshing(false);
        end,
      }),1000)

    end,
  });

  self.view.addOnScrollListener(RecyclerView.OnScrollListener{
    onScrollStateChanged=function(recyclerView,newState)
      if newState == RecyclerView.SCROLL_STATE_IDLE then
        local lastVisiblePosition = manager.findLastVisibleItemPosition();
        if lastVisiblePosition >= manager.getItemCount() - 1 and self.可以加载日报 then
          self:getData(false)
          System.gc()
        end
      end
  end});


  return self
end

return base