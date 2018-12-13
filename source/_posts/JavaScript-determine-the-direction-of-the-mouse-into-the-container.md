---
title: javaScript判断鼠标进入容器的方向
date: 2015-09-28 23:39:43
tags: javascript
---

在写一个鼠标进入容器，为容器添加滑入边框的动画效果的时候，遇到了一个小问题，就是需要判断鼠标进入容器的方向，然后再决定边框从哪个方向滑过。

也搜索到了一些解决方案，比如

>以div容器的中心点作为圆心，以高和宽的最小值作为直径画圆，将圆以[π/4，3π/4)，[3π/4，5π/4），[5π/4，7π/4)，[-π/4，π/4)划分为四个象限，鼠标进入容器时的点的atan2(y,x)值在这四个象限里分别对应容器边框的下，右，上，左

<!--more-->

![圆形直径](http://images.cnitblog.com/i/599390/201404/161747198221329.jpg)

最终自己也想到了一个容易理解的方案，那就是当鼠标进入容器的时候，判断鼠标距离哪个边框更加近，就可以得到是从那个方向进入的。

```html
<div id="box"></div>

<script type="text/javascript">
	var oBox = document.getElementById('box');
	oBox.addEventListener('mouseenter',function(event) {
		event = event || window.event;
		var iX = event.offsetX,
			iY = event.offsetY,
			aDistance = [iY,oBox.offsetWidth - iX,oBox.offsetHeight - iY,iX],  //上右下走
			aDirections = ['上','右','下','左'],
			iMinIndex = 0;

			// console.table([aDirections,aDistance]);
				
			for (var i = 0; i < aDistance.length; i++) {
				iMinIndex = aDistance[iMinIndex] > aDistance[i] ? i : iMinIndex;
			}

			oBox.innerText = "鼠标进入的方向是" + aDirections[iMinIndex];

	});
</script>
```
![进入方向](http://cdn.thisjs.com/github/mouseenter.png)