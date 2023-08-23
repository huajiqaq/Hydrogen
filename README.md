# Hydrogen

[![license](https://img.shields.io/github/license/huajiqaq/Hydrogen)](LICENSE)
[![Gitee 仓库](https://img.shields.io/badge/Gitee-仓库-C71D23?logo=gitee)](https://gitee.com/huajicloud/Hydrogen)
[![Github 仓库](https://img.shields.io/badge/Github-仓库-0969DA?logo=github)](https://github.com/huajiqaq/Hydrogen)

## 介绍

本项目为基于androlua+ 推荐使用[Aide Lua](https://gitee.com/AideLua/AideLua)  打包 当然 你也可以首先使用gradle打包 再将文件添加进安装包内

本项目是由原Hydrogen项目的继续维护版 由于时间因素 本人可能不会及时维护 现将工程开源 供一些动手能力较强的人继续为Hydrogen添加/维护 功能

## 下载

如果你想要下载最新版的App 可前往[这个页面](https://myhydrogen.gitee.io)获取最新版 可通过[这个页面](https://workdrive.zoho.com.cn/folder/8ix3h3e8828db660e4e63acd5dd9e70bf591a)获取历史版本

原版Hydrogen的源码供下载 **hydrogen-master.zip** 为Hydrogen最后一个版本final 7 的源码 **hydrogen目录内**为Hydrogen的后续维护版本的源码 预览或打包可能会报错 如若想解决 请下载本项目中的**要插入的dex**添加进打包的apk 安装

由于在AideLua打包可能会在安卓10以上设备无法安装 所以推荐将输出的apk使用mt管理器优化一下 使用AideLua二次打包的apk在 项目路径/app/build/bin

**hydrogen.jks**为软件的签名文件 你可使用apksigner或其他签名程序签名  别名 hydrogen 密钥库密码 zhihu 私钥密码 android

apksigner签名示例

```shell
.\apksigner sign --ks hydrogen.jks --ks-key-alias hydrogen --ks-pass pass:zhihu --key-pass pass:android --v1-signing-enabled true --v2-signing-enabled true --v3-signing-enabled true --v4-signing-enabled true -v --out 签名后apk 签名前apk
```