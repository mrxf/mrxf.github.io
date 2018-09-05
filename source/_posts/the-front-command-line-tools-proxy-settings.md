---
title: 前端命令行工具代理设置
date: 2017-04-17 14:39:18
tags: [node,git]
---

![npm](http://o93mwnwp7.bkt.clouddn.com/thisjs/tumblr_inline_nn489p271Z1t68bpr_500.png)

在开发过程中，有时候需要安装墙外一些包文件，前端常用的包管理工具有node/bower/sass,以及需要git发布内容，解决方案一般有三种：

* 使用国内镜像
* 设置代理
* 本地安装

<!--more-->

# 国内镜像

使用国内镜像的好处是省去搭建梯子的过程，利用国内连接速度优势，快速下载

## NPM

> 使用淘宝镜像 `https://registry.npm.taobao.org`

安装时启用

```bash
npm install  --registry=https://registry.npm.taobao.org
```
设置全局镜像

```bash
npm config set registry < registry url >
```
> [使用CNPM](http://npm.taobao.org/)

cnpm可以很快的安装完包，但是有些项目，比如Angular，有些包可能会安装出现问题。

## Gem

> 使用[Ruby-China](http://gems.ruby-china.org/)

设置镜像

```bash
gem sources --add https://gems.ruby-china.org/ --remove https://rubygems.org/
```

# 设置代理

设置代理需要有代理服务，保证可以访问到对应的地址

## NPM

设置代理

```bash
npm config set proxy http://server:port
npm config set https-proxy http://server:port
```
取消代理

```bash
npm config delete proxy
npm config delete https-proxy
```
查看代理

```bash
npm config list
```

如果代理不支持https，修改npm存放package的网站地址为非https地址

```bash
$ npm config set registry "http://registry.npmjs.org/"
```

## Git

设置代理

```bash
$ git config --global http.proxy http://server:port

$ git config --global https.proxy http://server:port
```

删除代理

```bash
git config --global --unset http.proxy
git config --global --unset https.proxy
```

查看代理

```bash
git config --global --get http.proxy
git config --global --get https.proxy
```

## Gem

设置代理

> 安装时加上 --http-proxy 参数

```bash
gem install --http-proxy http://proxy:port sass
```

## bower

设置代理

```
# 修改 .bowerrc 文件(如无则新增):

{
    "proxy": "http://proxy:port",
    "https-proxy": "http://proxy:port"
}
```

## apm

apm是github出品的Atom编辑器的包管理器，它默认使用npm的设置，如果需要单独设置

设置代理

```bash
$ apm config set https-proxy https://server:port
```
查看设置

```bash
$ apm config list
```

## 设置命令行代理

> 可以将命令行直接设置代理，这样命令行里的数据链接都会通过代理

* **windows**

这种设置只对本命令行窗口启用

```bash
set http_proxy=http://proxy:port

# 用户名密码则输入
set http_proxy_user=< username >
set http_proxy_pass=< password >
```
* **OS X**

```bash
sudo networksetup -setwebproxy "Ethernet" http://proxy port
```

# 本地安装

## NPM

> 对于有些几乎没有依赖的包，可以通过直接从node_modules文件夹中拷贝的方法实现安装

## Gem

1. 首先通过(rubygems)[https://rubygems.org/] 下载对应的包
2. 通过本地安装

```bash
gem install --local sass.gem
```

# 关于OS X的代理

OS X上有很多其他的下载需要代理，那么我们可以使用`Proxychains` 配合 `shadowsocks` 实现每个命令都可以使用代理

1. 安装工具

```bash
brew install proxychains-ng
```
2. 设置 Proxychains 安装目录下的 `proxychains.conf` 文件

```bash
vim /usr/local/etc/proxychains.conf
```
在`[ProxyList]`下加入
```
socks5  127.0.0.1 1080
```

3. 使用 `proxychains4` 为命令代理

```bash
proxychains4 curl https://www.twitter.com/
proxychains4 git push origin master
```

