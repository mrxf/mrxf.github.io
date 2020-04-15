---
title: js判断图片是否加载完成并获取图片的宽度
date: 2014-06-15 19:28:09
tags: javascript
---
在使用[turnJS](http://www.turnjs.com/)的时候，遇到了加载的图片大小撑破了界面的问题，所以采取了一些方法来解决获取到图片的宽度不一的情况，js处理图片主要是利用javascript中Image对象，通过 onload 事件和 onreadystatechange 来进行判断。

<!--more-->

* 第一中方法，通过onload事件，比如：
```html
<script type="text/javascript">
var obj=new Image();
obj.src="https://cdn.thisjs.com/github/ngFilter.jpg";
obj.onload=function(){
	alert('图片的宽度为：'+obj.width+'；图片的高度为：'+obj.height);
	document.getElementById("mypic").innnerHTML="<img src='"+this.src+"' />";
}
</script>
<div id="mypic">onloading……</div>
```
* 第二种方法，使用 onreadystatechange 来判断
```html
<script type="text/javascript">
var obj=new Image();
obj.src="https://cdn.thisjs.com/github/ngFilter.jpg";
obj.onreadystatechange=function(){
	if(this.readyState=="complete"){
		alert('图片的宽度为：'+obj.width+'；图片的高度为：'+obj.height);
		document.getElementById("mypic").innnerHTML="<img src='"+this.src+"' />";
	}
}
</script>
<div id="mypic">onloading……</div>
```