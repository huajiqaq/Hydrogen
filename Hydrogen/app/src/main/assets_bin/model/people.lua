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



function base:clear()
  self.nextUrl=nil
  self.is_end=false
  self.adp=nil
  self.data={}
  return self
end




function base:setresultfunc(tab)
  self.resultfunc=tab
  return self
end

function base:getData(callback)
  zHttp.get("https://api.zhihu.com/people/"..self.id.."/profile?profile_new_version=1",head,function(code,content)
    if code==200 then
      local data=luajson.decode(content)
      callback(data)
     elseif luajson.decode(content).error then
      提示(luajson.decode(content).error.message)
    end
  end)
  return self
end

function base:next(callback)
  if self.is_end~=true then
    if self.nextUrl==nil then
      nextoffset=""
     else
      nextoffset=self.nextUrl:match("?offset=(.-)&page_num")
    end

    --zHttp.get(self.nextUrl or "https://api.zhihu.com/people/"..self.id.."/activities?limit=20",head,function(code,body)
    zHttp.get(self.nextUrl or "https://api.zhihu.com/moments/"..self.id.."/origin?limit=20",apphead,function(code,body)

      if code==200 then
        self.nextUrl=luajson.decode(body).paging.next
        self.is_end=luajson.decode(body).paging.is_end
        for k,v in pairs(luajson.decode(body).data) do
          if self.data[v.id] then
           else
            self.data[v.id]=v --(概率需要(如果以后需要扩张功能的话))
            self.resultfunc(v)
          end
        end
        callback(true)
       else
        callback(false,body)
      end

    end)
   else
    callback(false,body)
  end
  return self
end

return base