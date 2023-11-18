function string.split(self,str)
  local idx=1
  local length=#self
  local strLen=#str
  return function()
    local i=self:find(str,idx)
    if idx>length then
      return nil
    end
    if i==nil then
      i=length+1
    end
    local sub=self:sub(idx,i-1)
    idx=i+strLen
    return sub
  end
end

function string.toCharArray(self)
  local s={}
  for i=1,string.len(self) do
    table.insert(s,string.sub(self,i,i))
  end
  return s
end

function utf8.toCharArray(self)
  local s={}
  for i=1,utf8.len(self) do
    table.insert(s,utf8.sub(self,i,i))
  end
  return s
end

function string.trim(s)
  return string.gsub(s, "^%s*(.-)%s*$","")
end