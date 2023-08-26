local base={
  data={},
  is_end=false,
  nextUrl=nil,

}

function base:new(id,type)
  local child=table.clone(self)
  child.id=id
  child.type=type
  return child
end


function base:setSortBy(tab)
  self.sortby=tab
  return self
end

function base:getcommon_counts(cb)
  return (self.common_counts)

end


function base:getUrlByType(id,type)

  if type~="comments" then
    return "https://api.zhihu.com/comment_v5/"..type.."/"..id.."/root_comment?order_by="..(self.sortby or "score").."&type="
--    return "https://api.zhihu.com/"..type.."/"..id.."/comments?include=badge%5B%2A%5D.topics%2Ccomment_count%2Cexcerpt%2Cvoteup_count%2Ccreated_time%2Cupdated_time%2Cupvoted_followees%2Cvoteup_count&limit=20&sort_by="..(self.sortby or "default")
   else
    return ("https://api.zhihu.com/comment_v5/comment/"..id.."/child_comment")
    --    return ("https://api.zhihu.com/comments/"..id.."/conversation")--.."?include=badge%5B%2A%5D.topics%2Ccomment_count%2Cexcerpt%2Cvoteup_count%2Ccreated_time%2Cupdated_time%2Cupvoted_followees%2Cvoteup_count&limit=20")
  end
end


function base:clear()
  self.nextUrl=nil
  self.is_end=false
  self.data={}
  return self
end




function base:setresultfunc(tab)
  self.resultfunc=tab
  return self
end

function base:next(callback)

  if self.is_end~=true then

    zHttp.get(self.nextUrl or self:getUrlByType(self.id,self.type),head ,function(code,body)

      if code==200 then
        decoded_content=luajson.decode(body)
        self.nextUrl=decoded_content.paging.next
        self.is_end=decoded_content.paging.is_end
        self.common_counts=tointeger(decoded_content.counts.total_counts)
--        self.common_counts=tointeger(decoded_content.common_counts)
        for k,v in ipairs(decoded_content.data) do
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