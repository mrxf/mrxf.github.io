---
title: js获取表单提交的数据并修改其他表单笔记
date: 2014-05-29 16:08:15
tags: javascript
---
首先在提交按钮上面加入一个点击事件
`onclick="fun(); `
这样的好处是直接屏蔽掉提交的默认事件，否则需要屏蔽浏览器的默认事件来防止按钮的自动提交。
接下来是fun()的事件

<!--more-->

```js
function fun(){  
    var jine=parseInt(document.getElementById("ckje").value);  
    var lixi=jine*3.25/100;  
    var benxi=lixi+jine;  
    document.getElementById("lixi").value=lixi;  
    document.getElementById("benxi").value=benxi;  
}  

```

这样就实现了简单的计算，并且将计算结果输出到了页面上。