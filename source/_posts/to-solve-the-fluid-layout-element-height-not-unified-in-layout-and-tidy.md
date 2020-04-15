---
title: 解决流式布局元素高度不统一导致布局不整齐问题
date: 2016-12-01 17:47:19
tags: [javascript]
---

在页面布局中，在使用float布局大量相同属性元素的时候，如果元素的高度不固定，某个元素的高度过高，可能会阻挡元素的“流动”，会出现如图的情况。

![float](https://cdn.thisjs.com/github/probfloat-long.png)

<!--more-->

这时我们只要保证后面的高度也大于或等于该元素高度，即可让后面的元素流动到前面

![float-succ](https://cdn.thisjs.com/github/probfloat-long2.png)

所以一种常见的解决方案是

## 瀑布流

![waterfull](https://cdn.thisjs.com/github/probwaterfull.png)

瀑布流的实现方法，网上已经有大量教程，详情参阅

 [脚本之家—实现瀑布流](https://www.jb51.net/article/34141.htm)

 [前端开发—瀑布流的实现方法](https://www.wufangbo.com/tag/%E7%80%91%E5%B8%83%E6%B5%81js/)

 ## 将同一列设置为统一高度

 有时候，我们可能并不需要瀑布流的布局，因为在展示某些数据的时候，会显得比较混乱。

 ![float3](https://cdn.thisjs.com/github/probfloat-long3.png)

 要实现该效果，只需如下几步

 1. 获取所有元素
 2. 获取相同offsetTop值的元素，即同一行的元素
 3. 比较同一行元素的高度，取最大的height值，赋给每一个元素即可

如果遇到使用ng-repeat生成的元素无法获取自动高度问题，可以参考如下文章

> [解决无法获取ngRepeat生成元素样式的问题](https://mrxf.github.io/2016/12/01/%E8%A7%A3%E5%86%B3%E6%97%A0%E6%B3%95%E8%8E%B7%E5%8F%96ngRepeat%E7%94%9F%E6%88%90%E5%85%83%E7%B4%A0%E6%A0%B7%E5%BC%8F%E7%9A%84%E9%97%AE%E9%A2%98/)