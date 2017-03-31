---
title: Ubuntu12添加程序启动器
date: 2014-05-21 15:11:48
tags: 操作系统
---
> * 在/usr/share/applications目录下

```
cd /usr/share/applications  
vim eclipse.desktop  
```
<!---more-->

> * 编辑eclipse.desktop并保存。简单的配置示例：

```
[Desktop Entry]  
Version=1.0  
Name=eclipse  
Exec=/home/hu/soft/eclipse/eclipse  
Terminal=false  
Icon=/home/hu/soft/eclipse/icon.xpm  
Type=Application  
Categories=Development  
```