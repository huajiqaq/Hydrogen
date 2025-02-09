# Hydrogen

[![License](https://img.shields.io/github/license/huajiqaq/Hydrogen)](LICENSE)
[![Gitee 仓库](https://img.shields.io/badge/Gitee-仓库-C71D23?logo=gitee)](https://gitee.com/huajicloud/Hydrogen)
[![Github 仓库](https://img.shields.io/badge/Github-仓库-0969DA?logo=github)](https://github.com/huajiqaq/Hydrogen)

## 介绍

Hydrogen 是一个基于 Androlua+ 的项目，推荐使用 [Aide Lua](https://gitee.com/AideLua/AideLua) 进行打包。当然，你也可以首先通过 Gradle 打包，然后将文件添加到安装包中。

本项目是原 Hydrogen 项目的继续维护版本。由于时间限制，我可能无法及时进行维护。因此决定开源此工程，供有兴趣和动手能力的人继续为 Hydrogen 添加或维护功能。

[Hydrogen项目维护被延缓](https://github.com/huajiqaq/Hydrogen/issues/159)

## 特别鸣谢

- [ZL114514 ](https://gitee.com/ZL114514)：现致力于仓库的维护工作
- [orz12 ](https://gitee.com/orz12)：在早期重新设计了部分布局
- [1582421598 ](https://github.com/1582421598)：提交pr修复bug

## 下载

要获取最新版的 App，请访问 [这个页面](https://huajiqaq.github.io/myhydrogen)。若需历史版本，可通过 [这里](https://workdrive.zoho.com.cn/folder/8ix3h3e8828db660e4e63acd5dd9e70bf591a) 获取。

- **hydrogen-master.zip**：这是 Hydrogen 最后一个版本 final 7 的源代码。请注意，在预览或打包时可能会遇到错误。如需解决这些问题，请下载本项目中的 **要插入的 dex** 文件，并将其添加至打包的 APK 安装包中。
- **hydrogen 目录内**：包含 Hydrogen 后续维护版本的源码。在这个版本无需下载**要插入的 dex** 文件。

对于在 Android 10 及以上设备上使用 AideLua 打包可能导致的安装问题，建议使用 MT 管理器进行优化。二次打包的 APK 可以在项目路径 `/app/build/bin` 中找到。

### 签名说明

`hydrogen.jks` 是软件的签名文件，你可以使用 apksigner 或其他签名程序进行签名。别名为 `hydrogen`，密钥库密码为 `zhihu`，私钥密码为 `android`。

apksigner 示例命令如下：

```shell
.\apksigner sign --ks hydrogen.jks --ks-key-alias hydrogen --ks-pass pass:zhihu --key-pass pass:android --v1-signing-enabled true --v2-signing-enabled true --v3-signing-enabled true --v4-signing-enabled true -v --out 签名后apk 签名前apk