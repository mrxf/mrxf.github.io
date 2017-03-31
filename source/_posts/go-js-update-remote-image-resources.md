---
title: go.js更新远程图片资源
date: 2016-10-27 11:28:44
tags: [gojs,javascript]
---
[go.js](http://gojs.net/)允许用户使用外部的图片资源，但是最近在做项目的时候，遇到了一个问题
，需要动态更新当前选中node节点上引用的外部图片资源内容。

我们知道，go.js在更新model时，需要使用Transactions API

<!--more-->

```javascript
 diagram.startTransaction("a trans");
    // 更新代码
   
 diagram.commitTransaction("a trans");
```

首先，获取当前选中节点的方法是

```js
 var selnode = myDiagram.selection.first();
 ```

 之后要进行对应的变化

 ```js
  myDiagram.startTransaction("reload node svg");
   // 更新图片地址
  myDiagram.model.setDataProperty(selnode.data, "source", "newSourceUrl");
  // 完成 transaction
  myDiagram.commitTransaction("reload node svg");
```

**这里要注意两个地方**

`setDataProperty`是作用在`myDiagram.model`上面的方法

`setDataProperty`的第一个参数是`selnode.data`，因为我们变化的是data的数据内容，
如果只填写`selnode`则会报错

> *GraphLinksModel.setDataProperty is modifying a GraphObject, "Node#21738(Picture)" go.js:17
Is that really your intent?*


### 参考资源

http://gojs.net/latest/intro/transactions.html

https://forum.nwoods.com/t/binding-picture-source-to-data-uri/5541/2