---
title: php实现分页的简单方法
date: 2014-05-18 10:51:28
tags: php
---
实现分页的控制代码

<!--more-->

```php
<?
//获得总页及设定每页显示贴子,开始分页显示
$list_num=5;
$result1=mysql_query("select count(*) from news");
$rs=mysql_fetch_array($result1);
$num=$rs[0];
$pagenumber=ceil($num/$list_num);
$page=$_GET[page];
if($page<2)
{
	$page=0;
}
else
{
	 $page=$page-1;
}
$startnum=$page*5;
//获得总页及设定每页显示贴子
  //循环获取数据开始
  $result = mysql_query("SELECT * FROM news order by date desc limit $startnum,5");
  while($row = mysql_fetch_array($result))
  {
  ?>
 ```
 实现分页
 ```php
  //页码显示
for ($i=1;$i<=($pagenumber);$i++){
echo "<a href=\"news fenye.php?page=$i\">$i</a> ";
}
 //页码显示
?>
```