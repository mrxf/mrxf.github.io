---
title: Navicat清空Mysql表后让id自增再从1开始
date: 2014-05-31 12:02:44
tags: MySql
---
在使用navicat清空了数据库的表之后，我们发现，数据依旧是从上次的字段最后一个值增加的，这时候需要使用`alter table table_name AUTO_INCREMENT=n`(n为起始值)命令来重置自增字段的起始数字，

<!--more-->

当然，可以直接使用`truncate table table_name`清空表 id就会从1开始.