---
title: 移动应用展示收纳效果
date: 2017-04-24 16:51:55
tags: css3
---

<img src="http://o93mwnwp7.bkt.clouddn.com/demo/phone/appshowcase.png" alt="手机展示效果" title="手机展示效果" />

最近在阅读[Codrops][1]时，遇到了一个不错的手机APP效果，想着可以用在视差滚动宣传页中，便尝试着也制作了一下。

<!--more-->

整体思路不是很复杂，即旋转整体，展示图片

主要用到的CSS3属性有

* [perspective][2]  // 这是为了让手机旋转的时候，有3D效果
* [perspective-origin][3]  // 设置观察消失点
* transition // 设置过渡效果
* transform  // 变换

## 整个手机设备的transform效果

```css
transform: rotateY(50deg) rotateX(20deg) translateZ(-$dv-height/2 + $depth);
```

## 宣传图像的变换效果

```css
@for $i from 1 through 5 {
	.expand-view .page-#{$i} {
		transform: translateZ($depth/2 + $screengap * $i);
	}
}
```

## 为图像添加鼠标滑过效果

> 在页面展开之后，鼠标滑过每个图层，其他图层透明度为0.1

1. 获取鼠标滑过的图层的兄弟节点，设置他们的style

```js
Array.prototype.filter.call(el.parentNode.children, function(child){
  return child !== el;
});
```
2. 为鼠标滑过的图层添加`active` Class，通过css :not()选择器，选择非`.active` Class的元素，设置他们的透明度

这里采用的是**第二种**方法。

## 最终效果预览

<script async src="//jsrun.net/YxkKp/embed/all/light/"></script>


[1]: (https://tympanus.net/codrops/2013/08/01/3d-effect-for-mobile-app-showcase/)
[2]: (https://developer.mozilla.org/zh-CN/docs/Web/CSS/perspective)
[3]: (https://developer.mozilla.org/zh-CN/docs/Web/CSS/perspective-origin)