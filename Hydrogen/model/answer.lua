--回答也相关数据类
--author dingyi
--time 2020-6-21
--self:对象本身
--TODO 重写逻辑，没想好


local base={--表初始化
  nextUrl=nil,
  is_end=false,
  isleft=false,
  is_add=false,
  now=0,--当前数据
  data={},
}

function base:new(id)--类的new方法
  local child=table.clone(self)
  child.id=id --这里的id是回答页id
  return child
end

function base:addAII(t) --data是数据
  self.data=t.data
  self.sortby=t.sortby
  self.now=t.now
  self.one=true
  self.is_add=true
  self.is_end=t.is_end
  self.nextUrl=t.nextUrl
  return self
end


function base:getAnswer(id,cb)
  --[[  local include=[[?&include=collections_count,thanks_count,comment_count,voteup_count,created_time,updated_time,collections_count,thanks_count,upvoted_followees;voteup_count,badge[?(type=best_answerer)].topics
  
  Http.get("https://api.zhihu.com/answers/"..id..include,head,function(a,b)
    if a==200 then
      cb(require "cjson".decode(b))
    end
  end)]]

  Http.get("https://api.zhihu.com/answers/"..id,{
    ["x-app-za"] = "OS=Android";
    ["cookie"] = 获取Cookie("https://www.zhihu.com/")
  }
  ,function(a,b)
    if a==200 then
      cb(require "cjson".decode(b))
    end
  end)

end



function base:getOneData(cb,z) --获取一条数据
  local index=z==false and self.now+1 or self.now-1

  if self.now==1 and self.is_add==true then --判断是否添加数据时是否到左顶
    self.isleft=true
  end

  if self.one==true then
    index=self.now
  end


  if self.data[index] then --如果数据存在
    self:getAnswer(tointeger(self.data[index].id).."",function(z)

      self.now=index

      self.one=nil

      cb(z)

    end)

   else--否则
    self:next(function(b,e)--调用下一页函数
      if b==true then--成功

        self.one=nil

        self:getOneData(cb,z)

       else
        cb(false,e)--返回false
      end
    end)
  end

  return self
end


function base:next(callback)--获取下一页数据 callback:回调 Boolean error_info

  if self.is_end~=true then--是否到底，否则刷新
    local head = {
      ["cookie"] = 获取Cookie("https://www.zhihu.com/")
    }

    Http.get(self.nextUrl or "https://api.zhihu.com/questions/"..self.id.."/answers?&include=badge%5B*%5D.topics,follower_count,follower_count,comment_count,collect_count,voteup_count,upvoted_followees,collections_count,thanks_count,voteup_count&limit=20".."&sort_by="..(self.sortby or "default"),head,function(code,body)
      if code==200 then--判断刷新码是否为200
        self.nextUrl=require "cjson".decode(body).paging.next
        self.is_end=require "cjson".decode(body).paging.is_end
        --解析下一页链接和是否结束flag

        for k,v in pairs(require "cjson".decode(body).data) do--遍历数据
          self.data[#self.data+1]=v --(概率需要(如果以后需要扩张功能的话))

        end
        callback(true)--回调提示刷新成功
       else
        callback(false,body)--不然就返回false和访问错误信息
      end

    end)
   else
    callback(false,body)--同上
  end
  return self
end

return base