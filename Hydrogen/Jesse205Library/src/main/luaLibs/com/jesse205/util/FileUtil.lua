import "java.io.File"
import "java.io.FileInputStream"
import "java.io.FileOutputStream"


local FileUtil={}

---@param sourceChannel FileChannel 来源FileChannel
---@param destChannel FileChannel 目标FileChannel
---@throws IllegalArgumentException | NonReadableChannelException | NonWritableChannelException | ClosedChannelException | AsynchronousCloseException | ClosedByInterruptException | IOException
function FileUtil.channelCopy(sourceChannel, destChannel)
  local size=sourceChannel.size()
  local transferSize
  local left=size
  while left>0 do
    transferSize = sourceChannel.transferTo((size - left), left, destChannel)
    left=left-transferSize
  end
  --sourceChannel.close()
  --destChannel.close()
end

--@param sourceStream FileInputStream 来源FileInputStream
--@param destStream FileOutputStream 目标FileOutputStream
function FileUtil.copyFileStream(sourceStream,destStream)
  local sourceChannel=sourceStream.getChannel()
  local destChannel=destStream.getChannel()
  FileUtil.channelCopy(sourceChannel, destChannel)
  sourceChannel.close()
  destChannel.close()
  --sourceStream.close()
  --destStream.close()
end


local function copyFile(fromFile,toFile,rewrite)
  local exists=toFile.exists()
  if exists and not rewrite then
    return
  end
  if exists then
    toFile.delete()
  end
  local toFileParent=toFile.getParentFile()
  if not toFileParent.isDirectory() then
    toFileParent.mkdirs()
  end
  local fosfrom = FileInputStream(fromFile)
  local fosto = FileOutputStream(toFile)
  FileUtil.copyFileStream(fosfrom,fosto)
  --[[
  local bt = byte[1024]
  local c = fosfrom.read(bt)
  while c>=0 do
    fosto.write(bt, 0, c) --将内容写到新文件当中
    c = fosfrom.read(bt)
  end]]
  fosfrom.close()
  fosto.close()
  luajava.clear(fosfrom)
  luajava.clear(fosto)
end
FileUtil.copyFile=copyFile

local function copyDir(fromFile,toFile,rewrite)
  if toFile.isFile() and rewrite then
    toFile.delete()
  end
  toFile.mkdirs()
  local toFilePath=toFile.getPath()
  local filesList=fromFile.listFiles()
  for index=0,#filesList-1 do
    local nowFile=filesList[index]
    local newFile=File(toFilePath.."/"..nowFile.getName())
    if nowFile.isFile() then
      copyFile(nowFile,newFile,rewrite)
     else
      copyDir(nowFile,newFile,rewrite)
    end
  end
  luajava.clear(filesList)
end
FileUtil.copyDir=copyDir

return FileUtil