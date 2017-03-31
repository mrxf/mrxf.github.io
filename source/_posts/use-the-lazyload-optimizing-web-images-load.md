---
title: 使用lazyload优化网页图片的加载
date: 2014-07-03 11:48:07
tags: [javascript,jquery,lazyload]
---

在遇到单页面中有大量的图片的时候，会产生一系列的问题，比如
> * 网页加载速度变慢

> * 消耗用户的大量流量

因为用户有时候并不会浏览完全部的内容，但是一次性的加载，会导致用户体验的下降。

这时候，这款基于jQuery的小插件**lazyload**就派上了用场。

<!--more-->

基本设计思路是：

* 拥有一个统一的图片占位符，加快加载的时间
* 当滚动高度到达图片的上面，或者到达图片高度的时候，将data-数据（储存着真实地址）的数据加载到src属性中。

这样就实现了延时加载的效果

基本使用方法

> * 首先将js文件引入

> * 在需要使用的标签加载插件

```html
<script type="text/javascript"> 
$(function() { 
$("img").lazyload({ 
effect : "fadeIn" 
}); 
}); 
</script> 
```

**API**

```js
	placeholder : "img/grey.gif", //用图片提前占位
    // placeholder,值为某一图片路径.此图片用来占据将要加载的图片的位置,待图片加载时,占位图则会隐藏
  effect: "fadeIn", // 载入使用何种效果
    // effect(特效),值有show(直接显示),fadeIn(淡入),slideDown(下拉)等,常用fadeIn
  threshold: 200, // 提前开始加载
    // threshold,值为数字,代表页面高度.如设置为200,表示滚动条在离目标位置还有200的高度时就开始加载图片,可以做到不让用户察觉
  event: 'click',  // 事件触发时才加载
    // event,值有click(点击),mouseover(鼠标划过),sporty(运动的),foobar(…).可以实现鼠标莫过或点击图片才开始加载,后两个值未测试…
  container: $("#container"),  // 对某容器中的图片实现效果
    // container,值为某容器.lazyload默认在拉动浏览器滚动条时生效,这个参数可以让你在拉动某DIV的滚动条时依次加载其中的图片
  failurelimit : 10 // 图片排序混乱时
     // failurelimit,值为数字.lazyload默认在找到第一张不在可见区域里的图片时则不再继续加载,但当HTML容器混乱的时候可能出现可见区域内图片并没加载出来的情况,failurelimit意在加载N张可见区域外的图片,以避免出现这个问题.
```