---
title: OS X中使用brew管理多个node版本
date: 2017-04-18 21:58:16
tags: [node,osx]
---
<img src="http://o93mwnwp7.bkt.clouddn.com/thisjs/nodejs_header-03e90275ca.svg" width = "1050" alt="node list" align=center />

在使用Node进行开发的时候，有时候需要在不同的Node版本中进行切换。首先，跨平台的[**NVM**(Node Version Manager)](https://github.com/creationix/nvm)可以帮助我们很好的进行版本管理。

在OS X系统中，**HomeBrew**也是一个很方便的Node版本切换工具。

以下是使用HomeBrew管理Node的一些操作

<!--more-->

## 查看可用版本

```bash
$ brew search node
```
即可看到当前可用的版本

 <img src="http://o93mwnwp7.bkt.clouddn.com/thisjs/brew%20list.png" width = "680"  alt="node list" align=center />


## 安装需要版本

```bash
$ brew install node@6
```
如果需要6.x.x中最新版本，可以使用

```bash
$ brew install node6-lts
```

## 切换版本

* 首先取消当前版本

```bash
$ brew unlink node
```

* 切换到需要的版本

```bash
$ brew link node@6 [--force]
```

> 注意：在切换版本的时候，可能会需要用到 --force命令，强制执行。

在切换版本时，可能会有一些文件需要删除，注意提示内容，执行即可

**例如：**

```bash
$ rm '/usr/local/include/node/pthread-fixes.h'
```
## 检查切换是否成功

```bash
$ node -v
```

## 添加Path

```bash
$ which node # => /usr/local/bin/node
$ export NODE_PATH='/usr/local/lib/node_modules' # <--- add this ~/.bashrc
```

## 删除所有Node

```bash
$ brew uninstall node
# 或者 `brew uninstall --force node` 移除所有版本
$ brew prune
$ rm -f /usr/local/bin/npm /usr/local/lib/dtrace/node.d
$ rm -rf ~/.npm
```

## 写在最后

出现这个问题是在安装Yarn的时候遇到的。在使用`HomeBrew`安装`Yarn`的时候，需要`brew link node`，但是link之后的版本是最新的7.9。

本来新版本的Node带来了更多的特性，然而在使用`ng-cli`生成的项目中，打包的时候，`node-sass`一直出问题，因此需要工具来管理Node版本，固有此总结。

同时，Yarn也是一个很方便的包管理器，推荐在安装包时尝试一下`Yarn`

## 参考文章

> [`brew link node` required for Yarn install #1505](https://github.com/yarnpkg/yarn/issues/1505)

> [How do I completely uninstall Node.js, and reinstall from beginning (Mac OS X)](http://stackoverflow.com/questions/11177954/how-do-i-completely-uninstall-node-js-and-reinstall-from-beginning-mac-os-x)

> [How do I downgrade node or install a specific previous version using homebrew?](https://apple.stackexchange.com/questions/171530/how-do-i-downgrade-node-or-install-a-specific-previous-version-using-homebrew)


