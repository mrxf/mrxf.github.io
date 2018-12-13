---
title: goJs的一些使用技巧及问题解决方案
date: 2016-10-27 12:01:26
tags: [gojs,javascript]
---

[go.js](http://gojs.net/)是一个非常强大的图表库，使用gojs可以制作不同的图标效果
![gojsIntro](http://cdn.thisjs.com/github/gojsIntro.png)

最近在使用go.js制作流程图效果，遇到了不同的问题，幸运的是，[官方社区](https://forum.nwoods.com/c/gojs)会非常快速的帮助解答遇到的每个问题

以下是我在开发中遇到的一些小问题，以及对应的解决方案

<!--more-->

# 在绘制流程图的过程中，连接线会自动选择最优的路径
![连接线问题](https://forum.nwoods.com/uploads/db3963/original/2X/6/6d8542835dec4100e879b3fd4ce3b6eb84b31db5.png)
![连接线问题2](https://forum.nwoods.com/uploads/db3963/original/2X/1/11ed210d5662c95757457cdae1ae4e188c9ddb24.png)

这个问题的解决方案是
* 为每一个连接点设置不同`Link.toPortId`，就像官方的例子中一样
* 设置`GraphLinksModel.html.linkFromPortIdProperty` 和 `GraphLinksModel.html.linkToPortIdProperty`属性
* 设置`diagram.model`的属性
```js
myDiagram.model.linkFromPortIdProperty = "fromPort"; 
    myDiagram.model.linkToPortIdProperty = "toPort";
```
* 或者直接在初始化load(){}中的json数据中加入代码即可
```js
model.linkFromPortIdProperty = "fromPort"; 
model.linkToPortIdProperty = "toPort";
```

# 根据节点数据进行函数处理

**假如我需要这样一个功能：**

> 如果流程图的连接线没有文字，那么隐藏连接线上的文本panel

这个问题可以根据`go.Binding`暴露对外接口的方式来实现

```js

 new go.Binding("visible", "text", function (t) { return t !== "" })

 ```

 # 设置图像的初始化缩放比例
 
 有时候，我们需要用户在进入界面的时候，就有一个与原始比例不同的缩放比，
 * 可以在创建Diagram的时候进行设置
 ``` js
 myDiagram =
      $(go.Diagram, "myDiagramDiv",  
        {
            scale : 1.3
        });

```
* 同时可以使用`commandHandler`设置缩放比，实现放大缩小按钮

```js
myDiagram.commandHandler.increaseZoom();
myDiagram.commandHandler.decreaseZoom();
```

# 画布无限拖动

> 如果用户在绘制的时候，需要实现两个距离非常远的节点的链接，那么就需要用到无限拖动

```js

myDiagram.scrollMode = go.Diagram.InfiniteScroll;

```

> 同时我们可以通过设置画布属性，来为画布设置多余的留白空间

```js
 scrollMargin: new go.Margin(100, 200, 100, 100),  //设置界面留白空间，允许用户拖动范围
 
 ```


 # 连接线的绕行路线问题

 go.js为我们提供了非常方便的节点绕开方案，即遇到节点之后，连接线会自动绕开。

 ![绕开节点](http://cdn.thisjs.com/github/linkrout.png)

 这个只需在初始化连接线的时候，修改routing属性即可

 ```js
 $(go.Link, 
        {
            routing: go.Link.AvoidsNodes // 绕行节点
        },
 ```

 但是，有时候我们有些节点不需要被绕开，他们可以附着在连接线上，这时候可以为此几点，修改属性`avoidable`即可

 ```js
 avoidable:false
 ```





 # 参考内容

 http://gojs.net/latest/samples/scrollModes.html

 http://gojs.net/latest/intro/index.html

 https://forum.nwoods.com/c/gojs