local base_question={
  nextUrl=nil,
  is_end=false,
  mdata={},
  data={}
}


function base_question:new(id)
  local child=table.clone(self)
  child.id=id
  return child
end

function base_question:getTag(callback)
  zHttp.get( "https://api.zhihu.com/questions/"..self.id.."/topics?&limit=20&platform=android",head,function(code,body)

    if code==200 then
      for k,v in pairs(require "cjson".decode(body).data) do
        callback(v.name,v.url)
      end
    end

  end)
  return self
end

function base_question:clear()
  self.nextUrl=nil
  self.is_end=false
  self.data={}
  self.mdata={}
  return self
end


function base_question:setSortBy(tab)
  self.sortby=tab
  return self
end

function base_question:getChild(id) --获取传输类
  local child={ --子对象属性
    nextUrl=self.nextUrl,
    is_end=self.is_end,
    sortby=self.sortby or "default",
  }
  if id==nil then --如果不指定id
    child.data=self.data

   else --不然的话把id之前的删除了
    local index
    for k,v in pairs(self.data) do
      if v.id==id then
        index=k
        break
      end
    end
    child.data=table.clone(self.data)
    child.now=index
  end
  --  print(dump(require "cjson".encode(child)))
  return require "cjson".encode(child)
end

function base_question:setresultfunc(tab)
  self.resultfunc=tab
  return self
end

function base_question:getData(callback)
  --[[  zHttp.get("https://www.zhihu.com/api/v4/questions/"..self.id.."?include=data%5B*%5D.answer_count,comment_count,follower_count,detail,excerpt",head,function(code,content)
    if code==200 then
      local data=require "cjson".decode(content)
      callback(data)
    end
  end)
  return self]]

  zHttp.get("https://api.zhihu.com/questions/"..self.id.."?include=read_count,answer_count,comment_count,follower_count,excerpt",{
    ["x-app-za"] = "OS=Android"
  }
  ,function(code,content)
    if code==200 then
      local data=require "cjson".decode(content)
      callback(data)
    end
  end)
  return self

end

function base_question:next(callback)

  if self.is_end~=true then
    local head = {
      ["cookie"] = 获取Cookie("https://www.zhihu.com/")
    }

    zHttp.get(self.nextUrl or "https://api.zhihu.com/questions/"..self.id.."/answers?&include=badge%5B*%5D.topics,comment_count,excerpt,voteup_count,created_time,updated_time,upvoted_followees,voteup_count&limit=20".."&sort_by="..(self.sortby or "default"),head,function(code,body)

      if code==200 then
        self.nextUrl=require "cjson".decode(body).paging.next
        self.is_end=require "cjson".decode(body).paging.is_end
        for k,v in pairs(require "cjson".decode(body).data) do
          if self.mdata[v.id] then
           else
            self.mdata[v.id]=v --(概率需要(如果以后需要扩张功能的话))
            self.data[#self.data+1]=v
            self.data[#self.data].id=tointeger(self.data[#self.data].id)
            if self.resultfunc then self.resultfunc(v) end
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

return base_question