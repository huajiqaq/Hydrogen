--import "android.os.Environment"
local AppPath={}
local context=Jesse205.context
local packageName=context.getPackageName()

--软件名
local appName
appName=application.get("appName")
if appName==nil then
  appName=context.getApplicationInfo().loadLabel(context.getPackageManager())
  application.set("appName",appName)
end

AppPath.Sdcard=Environment.getExternalStorageDirectory().getPath()--SD卡的目录

--将默认目录设为“/sdcard/Android/data/Package Name/files”
local dataDirPath1="/data/data/"..packageName
local dataDirPath2="Android/data/"..packageName
local mediaDirPath=AppPath.Sdcard.."/Android/media/"..packageName--共享文件夹
context.setLuaExtDir(dataDirPath2.."/files")
dataDirPath2=AppPath.Sdcard.."/"..dataDirPath2

local function getSelfPublicPath(value)--获取自身公共路径
  return Environment.getExternalStoragePublicDirectory(value).getPath().."/Edde software/"..appName
end

AppPath.Temp=context.getLuaExtDir("temp")--临时目录

AppPath.Downloads=getSelfPublicPath(Environment.DIRECTORY_DOWNLOADS)
AppPath.Movies=getSelfPublicPath(Environment.DIRECTORY_MOVIES)
AppPath.Pictures=getSelfPublicPath(Environment.DIRECTORY_PICTURES)
AppPath.Music=getSelfPublicPath(Environment.DIRECTORY_MUSIC)
getSelfPublicPath=nil

AppPath.LuaDir=context.getLuaDir()
--AppPath.LuaExtDir=extDir
AppPath.AppShareDir=mediaDirPath.."/files"
AppPath.AppDataDir=dataDirPath1.."/files"
AppPath.AppSdcardDataDir=dataDirPath2.."/files"

AppPath.AppShareCacheDir=mediaDirPath.."/cache"
AppPath.AppDataCacheDir=dataDirPath1.."/cache"
AppPath.AppSdcardCacheDataDir=dataDirPath2.."/cache"

return AppPath