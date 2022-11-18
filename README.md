# Hydrogen 一个由Lua编写的知乎第三方客户端

## 提示：尽量不要在 Github 内直接更改此仓库，因为 Github 的仓库是由 Gitee 镜像过去的。

# 关于本项目
Hydrogen为androlua项目 
Hydrogenn为AideLua项目 AideLua与AndroLua打包略不同 如想查看具体打包教程 请点击[这里](https://gitee.com/Jesse205/AideLua)
Hydrogenn是由原Hydrogen的继续维护版 由于时间因素 本人可能不会及时维护 现将工程开源 供一些动手能力较强的人继续为Hydrogen添加/维护 功能

# 下载注意事项
在本开源地址内 还有原版Hydrogen的源码供下载 **hydrogenn-master.zip** 为Hydrogen最后一个版本final 7 的源码  **hydrogen目录内容**为Hydrogen的后续维护版本的源码
预览或打包可能会报错 如若想解决 请下载本项目中的**classess2.dex**添加进打包的apk 安装

## 构建项目
1. 克隆本项目到本地：点击右上角下载或使用`git clone https://gitee.com/huajicloud/Hydrogen.git`下载
2. 使用Aide或使用 Gradle 构建：`gradle build`
3. 复制到 Android 设备的`内部存储/AppProjects/<你的项目>`
4. 查找编译的Apk 从下载的文件内搜索 `要插入的dex.dex/` 查找完成后将dex加入编译apk内的dex内 如若dex内容重复 请点击覆盖
4. 进入Aide Lua 后选择刚才复制的工程，然后依次点击 `菜单-项目...-二次打包并安装`