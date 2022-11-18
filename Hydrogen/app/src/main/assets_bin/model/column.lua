--文章实体类
--author dingyi
--time 2020-6-14
--self:对象本身

basecolumn={}

function basecolumn:new(id)--新建对象
  local child=table.clone(self)
  child.id=tostring(id)

  return child
end

function basecolumn:getId()--获取本身id(需要先getData)
  return self.id
end



function basecolumn:getUsername()--获取文章作者名(需要先getData)
  return self.data.author.name
end

function basecolumn:getDataAsyc(callback)--异步获取数据

  Http.get("https://api.zhihu.com/articles/"..self.id,function(code,body)--拼接并get Data
    if code==200 then
      self.data=require "cjson".decode(body)
      callback(self.data)--直接回答data
     else
      callback(false)--不成功
    end

  end)


  return self
end

return basecolumn

