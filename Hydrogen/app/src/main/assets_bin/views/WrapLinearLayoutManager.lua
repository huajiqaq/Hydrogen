--adpTool
--author huaji
--time 2024-8-21
--self:对象本身
--支持了addHeader 和addFooter 只支持一种Recyclerview的布局
local adpTool={
  headers={},
  footers={},
}--父类

function adpTool:new(adp)
  local child=table.clone(self)
  if not adp then
    error("adp必须绑定")
  end
  child.adp=adp
  return child
end

--需要确保这两个没有被使用
local HEADER_TYPE=1000000
local FOOTER_TYPE=2000000

function adpTool:getHeaders(index)
  if index then
    return self:getHeaders()[index]
  end
  return self.headers
end

function adpTool:getFooters(index)
  if index then
    return self:getFooters()[index]
  end
  return self.footers
end

function adpTool:getHeader(index)
  if not index then
    error("getHeader的index是必须的")
  end
  return self:getHeaders()[index]
end

function adpTool:getFooter(index)
  if not index then
    error("getFooter的index是必须的")
  end
  return self:getFooters()[index]
end


function adpTool:getHeadersCount()
  return #self:getHeaders()
end


function adpTool:getFootersCount()
  return #self:getFooters()
end

function adpTool:addHeader(header)
  local count=self:getHeadersCount()
  table.insert(self:getHeaders(),{
    type=HEADER_TYPE+count,
    layout=header
  })
  return self
end

function adpTool:addFooter(footer)
  local count=self:getFootersCount()
  table.insert(self:getFooters(),{
    type=FOOTER_TYPE+count,
    layout=footer
  })
  return self
end

function adpTool:getAdp()
  local adp=self.adp
  return LuaCustRecyclerAdapter(AdapterCreator({
    getItemCount=function()
      return self:getHeadersCount()+self:getFootersCount()+adp.getItemCount()
    end,
    getItemViewType=function(position)
      local numHeaders=self:getHeadersCount()
      if position < numHeaders then
        return self:getHeader(position+1).type;
      end
      local adjPosition = position - numHeaders;
      local adapterCount = adp.getItemCount();
      if adjPosition < adapterCount then
        return adp.getItemViewType(adjPosition);
      end
      return self:getFooter(position+1-adapterCount-self:getHeadersCount()).type;
    end,
    onCreateViewHolder=function(parent,viewType)
      if viewType >= HEADER_TYPE and viewType < HEADER_TYPE + self:getHeadersCount() then
        local position=viewType - HEADER_TYPE
        local item = self:getHeader(position+1).layout;
        local views={}
        local holder=LuaCustRecyclerHolder(loadlayout(item,views))
        holder.view.setTag(views)
        return holder
       elseif viewType >= FOOTER_TYPE and viewType < FOOTER_TYPE + self:getFootersCount() then
        local position=viewType - FOOTER_TYPE
        local item = self:getFooter(position+1).layout;
        local views={}
        local holder=LuaCustRecyclerHolder(loadlayout(item,views))
        holder.view.setTag(views)
        return holder
      end
      return adp.onCreateViewHolder(parent, viewType);
    end,
    onBindViewHolder=function(holder,position)
      local numHeaders=self:getHeadersCount()
      if position < numHeaders then
        return;
      end
      local adjPosition = position - numHeaders;
      local adapterCount = adp.getItemCount();
      if adjPosition < adapterCount then
        adp.onBindViewHolder(holder, adjPosition);
        return;
      end

      --footer的内容 因为header和footer不需要onBindViewHolder 上面已排除header 所以直接不用renturn

    end,
  }))
end


return adpTool