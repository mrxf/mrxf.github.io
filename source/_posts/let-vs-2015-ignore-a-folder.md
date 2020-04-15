---
title: 让vs2015忽略某个文件夹
date: 2017-02-24 10:09:28
tags: [vs2015,开发工具]
---

<img src="https://cdn.thisjs.com/thisjs/images.png" width="500" alt="Vs2015" />

在使用vs2015开发前端项目的时候，将整个网站项目引用进解决方案之后，软件会扫描全部的文件夹。
但是`node_modules`，`bower_components`的文件夹嵌套，会严重影响扫描的速度

<!--more-->

暂时的解决方案是，将不需要被扫描的文件夹隐藏即可，但是要取消掉隐藏二级目录

