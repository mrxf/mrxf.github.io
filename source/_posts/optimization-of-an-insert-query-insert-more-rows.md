---
title: 优化一次INSERT查询，插入多行记录
date: 2014-06-10 10:14:36
tags: [PHP,MySql]
---
如果我们想往数据库表中插入一行记录，可以使用以下SQL语句：
`INSERT INTO tbl_name (col1,col2) VALUES (15,16);`
 那如果我们想插入多行记录呢？可能你会想到多次运行INSERT语句即可，就像下面的php代码示例：
 ```php
 $a = 1;
$b = 1;
while (5 == $a)
{
    $sql = "INSERT INTO tbl_name (col1,col2) VALUES ($a,$b)";
    mysql_query($sql);
    $a++;
    $b++;
}
```
<!--more-->

但是这样执行的效率太低，尤其是在执行数量过大的情况下，会大大的占用服务器的资源。
在查看其他的sql备份导入软件之后发现，他们使用的方法如下。
```php
INSERT INTO `userTable` (`user_id`, `user_name`) VALUES
(1, 'dsf'),
(2, 'fgy'),
(3, 'faad');
```

  这样只需执行一次SQL查询，即可插入多行记录，大大提高了效率，使用php编程的时候，可以使用字符串连接的方式连接sql语句即可:

  ```php
  $a = 1;
while (5 == $a)
{
    if (1 == $a)
        $sql = "INSERT INTO tbl_name (col1,col2) VALUES ($a,$b)";
    else
        $sql .= ",($a,$b)";

    $a++;
    $b++;
}
mysql_query($sql);
```