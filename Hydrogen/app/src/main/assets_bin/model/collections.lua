--收藏事体类
--author dingyi
--time 2020-6-14
--self:对象本身
local base_collections={--表初始化
  nextUrl=nil,
  is_end=false,
  data={},
}

function base_collections:new(id)--类的new方法
  local child=table.clone(self)
  child.nextUrl=id
  return child
end


function base_collections:clear()--清空所有收藏
  self.nextUrl=nil
  self.is_end=false

  return self
end



function base_collections:setresultfunc(tab)--设置回调函数
  self.resultfunc=tab
  return self
end


function base_collections:next(callback)--获取下一页数据 callback:回调 Boolean error_info

  if self.is_end~=true then--是否到底，否则刷新
    local head = {
      ["cookie"] = 获取Cookie("https://www.zhihu.com/")
    }

    Http.get(self.nextUrl,head,function(code,body)--http.get
      if code==200 then--判断刷新码是否为200
        self.nextUrl=require "cjson".decode(body).paging.next
        self.is_end=require "cjson".decode(body).paging.is_end
        --解析下一页链接和是否结束flag
        callback(true)--回调提示刷新成功

        for k,v in pairs(require "cjson".decode(body).data) do--遍历数据
          -- self.data[#self.data+1]=v (概率需要(如果以后需要扩张功能的话))
          self.resultfunc(v)--回调数据
        end
       else
        callback(false,body)--不然就返回false和访问错误信息
      end

    end)
   else
    callback(false,body)--同上
  end
  return self
end

return base_collections