# Hydrogen
[![License](https://img.shields.io/github/license/Jesse205/AideLua)](LICENSE.md)
[![发行版](https://img.shields.io/github/v/tag/Jesse205/AideLua?color=C71D23&label=发行版&logo=gitee)](https://gitee.com/Jesse205/AideLua/releases)

[![QQ 群: 628045718](https://img.shields.io/badge/QQ_群-628045718-0099FF?logo=tencentqq)](https://jq.qq.com/?_wv=1027&k=41q8mp8y)
[![QQ 频道: t37c1u1nmw](https://img.shields.io/badge/QQ_频道-t37c1u1nmw-0099FF?logo=tencentqq)](https://pd.qq.com/s/ncghvc)

[![Gitee 仓库](https://img.shields.io/badge/Gitee-仓库-C71D23?logo=gitee)](https://gitee.com/Jesse205/AideLua/)
[![Github 仓库](https://img.shields.io/badge/Github-仓库-0969DA?logo=github)](https://github.com/Jesse205/AideLua)
[![使用文档](https://img.shields.io/badge/使用文档--3F51B5)](https://jesse205.github.io/AideLua/)

![cover](images/ic_cover-aidelua.png)

## 注意 Alert
如需使用源代码，请进入 [发行版](/Jesse205/AideLua/releases) 页面下载。<br>
If you need to use the source code, please go to the [releases](/Jesse205/AideLua/releases) page to download.

尽量不要在 Github 内直接更改此仓库，因为 Github 的仓库是由 Gitee 镜像过去的。<br>
Try not to change the repository directly in Github, because Github's repository is mirrored by Gitee。

## 简介
Aide Lua 是一款依赖 Aide 的 Lua 编辑器<br>
Aide Lua 可以让您在移动设备上也能享受高级的、快速的软件开发<br>
Aide Lua 可以帮您从 Androlua+ 转移到 AIDE，再转移到 Android Studio

## 下载
### Gradle for AIDE Pro
### AIDE 高级设置版
[![蓝奏云](https://img.shields.io/badge/蓝奏云-38.5_M-FF6600?logo=icloud&logoColor=white)](https://www.lanzouy.com/b00zdhbeb)
[![Github Releases)](https://img.shields.io/github/v/tag/AndroIDE-Pro/AidePro?color=0969DA&label=Github+Releases&logo=github)](https://github.com/AndroIDE-Pro/AidePro/releases)

### Aide Lua Pro
[![Gitee 发行版)](https://img.shields.io/github/v/tag/Jesse205/AideLua?color=C71D23&label=Gitee+发行版&logo=gitee)](https://gitee.com/Jesse205/AideLua/releases)

#### 其他渠道 (可能更新不及时)
[![天翼云盘](https://img.shields.io/badge/天翼云盘--DF9C1F)](https://cloud.189.cn/t/ZZ7RzijyqiUv)
[![腾讯微云](https://img.shields.io/badge/腾讯微云--2980ff)](https://share.weiyun.com/oLiNtxMR)
[![百度网盘](https://img.shields.io/badge/百度网盘-jxnb-06a7ff)](https://pan.baidu.com/s/1j1RwisPR8iq1fPS3O_fl7Q?pwd=jxnb)
[![123云盘](https://img.shields.io/badge/123云盘--597dfc)](https://www.123pan.com/s/G7a9-Yzck)

## 构建项目
1. 克隆本项目到本地：`git clone https://gitee.com/Jesse205/AideLua.git`
2. 使用 Gradle 构建：`gradle build`
3. 复制到 Android 设备的`内部存储/AppProjects/<你的项目>`
4. 下载 Aide Lua 的发行版，进入 Aide Lua 后选择刚才复制的工程，然后依次点击 `菜单-项目...-二次打包并安装`


## 使用须知
1. 本软件默认开启自动保存代码且无法关闭（自动保存触发条件：切换到其他应用、点击二次打包以及打包运行、打开文件、关闭文件）
2. 此软件不能用来开发大型项目
3. 此软件必须搭配编译器，不管你用的是真正的Gradle还是仿Gradle（AIDE属于仿Gradle）
4. 要实现直接运行项目，必须导出 `LuaActivity`（默认是导出的），并成功安装项目软件（先用 AIDE 打包，然后用 Aide Lua 打包，最后安装）

## 如何接收更新推送
1. 首先进入 `设置`-`通知设置` ，打开 `有新的 Release`<br>
![步骤1](images/releases/step1.jpg)
2. 然后点击仓库右上角 `Watch`，然后点击 `关注所有动态`<br>
![步骤2](images/releases/step2.jpg)

## 使用教程
[视频教程](https://space.bilibili.com/1229937144)
[使用文档](https://jesse205.github.io/AideLua/)

由于 AIDE 的特殊性，请下载 [__AIDE高级设置版__](https://aidepro.top/) 进行操作

### 快速入门
#### 一、配置AIDE
1. 进入 `设置-高级设置-工程相关`
2. 关闭 `启用alert调试文件` ，打开 `重定义Apk构建路径`
3. 重启 AIDE

#### 二、初次打包
1. 在 AideLua 点击新建项目，在填写与选择完成后点击 `新建`
2. 用 AIDE 打开项目，点击 `构建刷新`
3. 点击 AideLua 的 `二次打包并安装` 按钮（或 `二次打包` ，但需手动签名）并安装，测试是否可以正常打包并运行
4. 点击 AideLua 的 `运行` 按钮，测试是否正常通过已安装的应用调试

## 注意事项
1. AIDE 必须使用 `AIDE高级设置版本` ，否则无法打开 `重定义Apk路径`
2. AIDE 必须打开 `重定义Apk路径` ，否则会导致 APK 错误
3. AIDE 最好关闭 `adrt调试文件`
4. 不是必须用 AIDE 编译，也可以使用 Android Studio 编译

## 开放源代码许可
[https://gitee.com/Jesse205/AideLua/blob/master/app/src/main/assets_bin/licences](https://gitee.com/Jesse205/AideLua/blob/master/app/src/main/assets_bin/licences)