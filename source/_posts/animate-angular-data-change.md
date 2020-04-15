---
title: angular为绑定数据的变化添加动画
date: 2016-11-30 16:07:07
tags: [angular,javascript]
---

在页面中，我们的数据可能是从服务器实时加载，或者动态变化的，假如我们希望在某些数据发生变化之后，提醒用户是这些数据产生了改变，那么我们可能会想到为这个数据的变化添加一个效果，例如下面这个样子

![datachangge](https://cdn.thisjs.com/github/ng-bind-3GIF.gif)

在angular中，我们可以使用ngAnimate来实现对应的效果

<!--more-->

## 以数据为CLASS，监听样式变化

在需要监听变化的数据前，加入一个以数据作为class名的样式

```html
<span class="my-example value-{{myValue}}">{{myValue}}</span>
```

这时，当数据发生变化之后，会自动添加`新数据-add`,`旧数据-remove`,`新数据-add-active`,`旧数据-remove-active`样式

![add](https://cdn.thisjs.com/github/ng-bind-type.png)

这时，我们在SASS *(less)* 样式中，筛选包含`-add`的样式，为其添加变化中的效果

```css
span.my-example{
    display: inline-block;
    padding: 0 3px;
    background-color: #FFFFFF;
    color: #48a8d6;
    transition: background-color 0.5s linear 0s;
    &[class*="-add"] {
        background-color: #48a8d6;
        color: #FFFFFFF;
    }
}
```

这时在每次数据变化，都会有0.5秒的效果，这样哪些数据发生变化就比较明显了。

## 使用ngAnimateSwap

在 *angular 1.5* 版本之后，可以使用ngAnimateSwap方法检测数据的变化

```html
<div ng-animate-swap="number" class="cell swap-animation" ng-class="colorClass(number)">
    {{ number }}
  </div>
```
详情参阅 [官方文档](https://code.angularjs.org/1.5.8/docs/api/ngAnimate/directive/ngAnimateSwap)

## 监听数据变化，发生变化添加样式

**HTML**

```html
<span animate-on-change="someValue">{{someValue}}</span>
```
**Directive**

```js
myModule.directive('animateOnChange', function($timeout) {
  return function(scope, element, attr) {
    scope.$watch(attr.animateOnChange, function(nv,ov) {
      if (nv!=ov) {
        element.addClass('changed');
        $timeout(function() {
          element.removeClass('changed');
        }, 1000); // Could be enhanced to take duration as a parameter
      }
    });
  };
});
```

**CSS**

```css
[animate-on-change] {
  transition: all 1s;
  -webkit-transition: all 1s;
}
[animate-on-change].changed {
  background-color: red;
  transition: none;
  -webkit-transition: none;
}
```


> 参考资料： http://stackoverflow.com/a/25894670/4945494 
> http://stackoverflow.com/questions/20053557/ng-animate-animation-when-model-changes