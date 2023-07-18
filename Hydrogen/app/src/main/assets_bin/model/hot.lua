require "import"
import "android.widget.*"
import "android.view.*"

local hotdata={
  partition={},
  cjson=require "cjson"
}

function hotdata:new()
  return table.clone(self)
end

function hotdata:putPartition(name,t)
  if table.find(self.partition,t) then
   else
    self.partition[name]=t
  end
end

function hotdata.getValue(self,key,isreturnurl)


  local result=self.partition[key]
  if #self.partition==0 then  
  for key, value in pairs(self.partition) do
    result=value
  end
  end

  if result==nil then error("hotdata:Not find key") end
  if isreturnurl then
    result="https://www.zhihu.com/api/v3/feed/topstory/hot-lists/"..result.."?limit=50&mobile=true"
  end
  return result


end

function hotdata:getPartitionFromApi(func)


  zHttp.get("https://www.zhihu.com/api/v3/feed/topstory/hot-lists",head,function(code,body)
    if code==200 then
      local tab=self.cjson.decode(body)
      if #tab.data>0 then
        for k,v in pairs(tab.data) do
          local z=v.name
          if z=="全站" then z="全部" end
          self:putPartition(z,v.identifier)
        end
       elseif tab.data.name=="全站" then
        z="全部"
        self:putPartition(z,tab.data.identifier)
      end
      self.partition.视频=nil

      pcall(func)
    end
  end)

end


function hotdata:getPartition(func)
  if #self.partition<1 then
    self:getPartitionFromApi(func)
   else
    return self.partition
  end
end

return hotdata