---
title: MongoDB在x86系统上的启动错误解决
date: 2016-04-05 14:12:53
tags: MongoDB
---

在帮别人的电脑上安装MongoDB的时候，发现出现了无法启动服务的错误。

在对应的bin目录启动MongoDB服务

> mongod.exe --dbpath  C:\database\db

<!--more-->

但是启动出现了错误，提示了

`Cannot start server. The default storage engine 'wiredTiger' is not available with this build of mongod. Please specify a different storage engine explicitly, e.g. -`

原来是默认的wiredTiger引擎不支持x86系统

在官方网站上就有对应的说明

> Starting in MongoDB 3.0, the WiredTiger storage engine is available in the 64-bit builds.

这样将存储引擎换成mmapv1就可以正常使用了，所以在启动服务的时候，在后面加入`--storageEngine=mmapv1
`就可以了

所以完整的启动服务方法就是

`mongod.exe --dbpath  C:\database\db --storageEngine=mmapv1`