--将table2合并到table1中
local function insertTable(table1,table2)
  for index,content in pairs(table2) do
    if type(content)=="table" and type(index)=="number" then
      insertTable(table1[index+1],content)
     else
      table1[index]=content
    end
  end
end
return insertTable