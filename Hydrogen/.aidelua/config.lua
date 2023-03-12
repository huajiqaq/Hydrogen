tool={
  version="1.1",
}
appName="Hydrogen"--应用名称
packageName="com.zhihu.hydrogen"--应用包名
debugActivity="com.androlua.LuaActivity"--调试Activity

include={"project:app","project:androlua"}--导入，第一个为主程序
main="app"--老版本
compileLua=true--编译Lua

--相对路径位于工程根目录下
icon={
  day="app/src/main/ic_launcher-playstore.png",--图标
  night="app/src/main/ic_launcher_night-playstore.png",--暗色模式图标
}