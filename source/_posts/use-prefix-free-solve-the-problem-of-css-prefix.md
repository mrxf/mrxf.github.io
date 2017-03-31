---
title: 使用-prefix-free解决CSS前缀的问题
date: 2014-07-08 20:14:50
tags: javascript
---
在网页开发的过程中，会遇到有些低版本浏览器在CSS3样式前面要加入浏览器的标识。

在开发中，可以使用**Can I use**等类型的编辑器插件来帮助开发者进行判断

<!--more-->

同时，也可以直接使用-prefix-free这款小插件来帮助我们解决浏览器前缀的问题。

原本的写代码方式
```css
-webkit-transform: rotate(45deg);

-o-transform: rotate(45deg);

-moz-transform: rotate(45deg);

-ms-transform: rotate(45deg);
```
现在不需要考虑浏览器的前缀问题，直接可以使用
```css
transform: rotate(45deg);
```

这样就省去了很多开发遇到的小兼容性问题，专心来制作网页效果，让开发者更专注于效果本身。

[官方地址](http://leaverou.github.io/prefixfree/)