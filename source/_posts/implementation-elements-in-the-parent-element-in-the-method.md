---
title: 实现元素在父元素中居中的方法
date: 2016-02-02 17:47:10
tags: css
---
在网页制作中，常常会遇到需要将一个元素水平，垂直居中。  
最常见的##水平##居中自然是行级元素`text-align:center`,块级元素在父级元素`text-align:center`之后margin的左右值为auto。但是需要同时垂直居中的话，有以下5种不错的方法。

<!--more-->

* 第一：是行级元素的垂直水平居中，一般是文字的垂直居中，这时候，设置文字的`line-height=`元素的高度即可。这样一行文字就会占用整个容器的高度，自然实现了垂直居中。

* 第二：对于图片元素的垂直居中，首先定义一个空标签，设置高度为100%，宽度为0，`vertical-align: middle;`，设置图片的`vertical-align: middle;`即可

* 第三：对于块级元素的居中，可以使用一下3种方法
1. 父级元素设置`position:relative`,设置子元素
    ```css
    position:absolute;
    left:50%;
    top:50%;
    transform:translate(-50%,-50%);
    ```
    这个思路也很简单，就是之前常用的
     ```css
    position:absolute;
    left:50%;
    top:50%;
    margin-top:-图片宽度/2;
    margin-left:-图片宽度/2;
    ```
    使用CSS3的变换，位移图片的一半
    
2. 使用弹性盒模型实现居中，父级元素定义为`display:-webkit-box`，设置子元素
    ```css
    -webkit-box-pack:center;
	-webkit-box-align:center;
    ```
    这种的使用范围比较窄
    
3. 设置父级元素`position:relative`，设置子元素
    ```css
    position:absolute;
    left:0;
    top:0;
    right:0;
    bottom:0;
    margin:auto;
    ```
    
**每一种方法都有一些缺点，对于选择哪种，可以根据实际开发进行选择**