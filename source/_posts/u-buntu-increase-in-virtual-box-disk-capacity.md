---
title: UBuntu中增加virtualBox中磁盘的容量
date: 2014-05-23 18:02:23
tags: 操作系统
---
在使用Ubuntu中虚拟机装操作系统之后发现操作系统中的硬盘容量不足，可以使用如下方法动态修改磁盘的容量

`VBoxManage modifyhd YOUR_HARD_DISK.vdi --resize SIZE_IN_MB  `

<!--more-->

进入到虚拟磁盘的目录，输入以上代码即可。
修改完之后，进入windows系统，使用磁盘管理软件就可以修改大小了。

`YOUR_HARD_DISK.vdi--你的虚拟磁盘名字`
`SIZE_IN_MB--重新定义大小以M为单位  `  