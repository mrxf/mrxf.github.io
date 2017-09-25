---
title: 解决无法获取ngRepeat生成元素样式的问题
date: 2016-12-01 15:44:08
tags: [angular,javascript]
---

![ng](http://o93mwnwp7.bkt.clouddn.com/github/ngrepeatAngularJS-header-image.png)

在使用Angular进行开发的过程中，使用ng-repeat生成多个元素之后，如果元素的宽高是auto，那么我们在使用
`css()`、`getComputedStyle`、`offsetHeight`或者`clientHeight`都会获取到0，我们无法获取到元素的实际高度。

这是因为DOM的渲染是异步的，导致计算元素属性信息在DOM渲染完成之前就已经完成了，因此无法获取到DOM真正渲染结束之后属性。

在Angular中，我们可以使用以下几种方法进行处理

<!--more-->

## 使用$watch方法来进行脏值检查

当元素信息发生改变之后，将最新的数据赋值给变量即可

例如：

**Directive**

```js
myApp.directive('heightBind', function() {
  return {
    scope: {
      heightValue: '='
    },
    link: function($scope, $element) {
      $scope.$watch(function() {
        $scope.heightValue = $element.height();
      });
    }
  }
})
```

**HTML**
```html
< div height-bind height-value="containerHeight"></div>
```

## 当然，也可以使用`$apply`来完成同样的事情

```js
 setTimeout(function(){
  $scope.containerHeight = $('#container').height()
  $scope.$apply();
}, 0);
```

## 使用自带的脏值检查方法

我们知道，angular的一些方法会自动进行脏值检查，因此我们可以将上面的方法稍微改动一下即可

```js
$timeout(function () {
    // 获取元素信息
});
```

> 参考资料 http://stackoverflow.com/questions/25108780/height-of-container-with-ng-repeat-directive-is-zero