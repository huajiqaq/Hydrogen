import "java.io.File"
import "java.io.FileInputStream"
import "java.io.FileOutputStream"
local FileUtil={}
local function copyFile(fromFile,toFile,rewrite)
  local exists=toFile.exists()
  if exists and not(rewrite) then
    return
  end
  if exists then
    toFile.delete()
  end
  local toFileParent=toFile.getParentFile()
  if not(toFileParent.isDirectory()) then
    toFileParent.mkdirs()
  end
  local fosfrom = FileInputStream(fromFile)
  local fosto = FileOutputStream(toFile)
  local bt = byte[1024]
  local c = fosfrom.read(bt)
  while c>=0 do
    fosto.write(bt, 0, c) --将内容写到新文件当中
    c = fosfrom.read(bt)
  end
  fosfrom.close()
  fosto.close()
end
FileUtil.copyFile=copyFile

local function copyDir(fromFile,toFile,rewrite)
  if toFile.isFile() and rewrite then
    toFile.delete()
  end
  toFile.mkdirs()
  local toFilePath=toFile.getPath()
  for index,content in ipairs(luajava.astable(fromFile.listFiles())) do
    local newFile=File(toFilePath.."/"..content.getName())
    if content.isFile() then
      copyFile(content,newFile,rewrite)
     else
      copyDir(content,newFile,rewrite)
    end
  end
end
FileUtil.copyDir=copyDir

return FileUtil