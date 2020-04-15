---
title: 解决Ubuntu下phpstorm配置完php环境之后仍出现502错误
date: 2014-05-25 21:06:56
tags: 操作系统
---
即使安装了php环境之后，仍然会出现502运行错误，这个问题是缺少-cgi导致的

<!--more-->

![问题图片](https://i.stack.imgur.com/3GHlJ.png)

解决方案

`sudo apt-get install php5-cgi  `