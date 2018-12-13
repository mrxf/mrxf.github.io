---
title: 通过node搭建shadowsocks服务器
date: 2017-02-28 17:14:14
tags: 'node'
---

![shadowsocks](http://cdn.thisjs.com/github/ss.png)

在企业开发项目时候，有时需要通过外网网络访问内部服务器，这时候可以通过搭建一个shadowsocks服务器，然后通过shadowsocks客户端连接服务器，访问内网内容。

安装过程如下，服务器已经安装好node服务，并且可以使用`npm`命令

<!--more-->

1. 全局安装shadowsocks模块
```
npm install -g shadowsocks
```
2. 找到安装目录`C:\Users\Administrator\AppData\Roaming\npm\node_modules\shadowsocks
`，编辑`config.json`文件
```
 { 
    "server":"IP地址", 
    "server_port":443, 
    "local_address":"127.0.0.1", 
    "local_port":1080, 
    "password":"密码", 
    "timeout":600, 
    "method":"rc4-md5"
}
```
2. 启动服务，执行命令
```
ssserver
```
