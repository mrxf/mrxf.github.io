---
title: 使用JavaScript判断元素中是否含有某个样式
date: 2018-03-28 20:18:26
tags: [JavaScript]
---
![题图](https://cdn.zhshy.me/img/hero.png)

看到这个题目，立马想到的就是 **element.classList.contains()** 和 **$(element).hasClass()** 方法。

但是，在一些低版本浏览器中，classList无法使用，这个时候就可以自己实现类似jQuery的hasClass()函数。

<!--more-->

![classList的兼容性](https://cdn.zhshy.me/img/classlist-can-use.png)
<p style="text-align: center;font-size: 10px;"> <i>classList的兼容性</i> </p>

假如我们有如下测试元素

```html
<div id="LL" class="a b hello-world"></div>
```

## 简单正则匹配法

最开始我们找到的方法如下，即使用正则判断单词边界的方式判断是否存在className

```js
 function hasClass(element, className) {
  const regExp = new RegExp("\\b"+className+"\\b", "gi");
  return regExp.test(element.className);
}
```
在样式的名字为hello-world之类的带有-连接符的情况，测试hello和world都会返回true，这并不满足我们的预期。

## IndexOf方法

同理，还有简单的使用 **indexOf()** 方法判断，也会导致这样的问题。

```js
function hasClass(element, className) {
  return element.className.indexOf(className) > -1;
}
```
这时候，不仅hello和world返回true，h/e/l/等单个字符都会返回true。

我们改进一下该方法:

```js
function hasClass(element, className) {
  return (" " + element.className + " " ).indexOf(" "+className+" ") > -1;
}
```

现在根据样式名称加" "的方式，判断一个元素是否含有该样式。在大部分的测试中，已经没有了问题。

但是！！！我们遇到了这样的神奇代码：

```html
<div id="tab" class="hello-world	a	b	world"></div>
```

看上去和正常的代码没有太大区别，然而样式名称间的分隔符居然 **是TAB，不是空格！**

那么使用空格作为分隔符检索的方式就失效了。不过我们可以在检索之前将内容格式化一下即可。将tab和多余的空格一起替换为空格即可。

```js
function hasClass(element, className) {
  const replacedName = element.className.replace(/\t*\s+/g, ' ');
  return (" " + replacedName + " " ).indexOf(" "+className+" ") > -1;
}
```

这样，无论是遇到tab键，还是-连接符问题都可以很好的解决了。好方法 **get√**

## 优化正则匹配法

另外，在查阅[YOU MIGHT NOT NEED JQUERY](http://youmightnotneedjquery.com/)时，遇到了如下方法。

```js
function hasClass(element, className) {
    return new RegExp('(^| )' + className + '( |$)', 'gi').test(element.className);
}
```

该方法也是基于样式左右的空格，使用正则进行匹配，同时考虑到了样式开头如果没有空格的问题。但是依旧没有考虑到 **TAB** 作为分隔符的问题，我们可以将格式化的字符串作为匹配内容，也可以直接将该情况添加到正则中即可。

```js
function hasClass(element, className) {
  return new RegExp('(^| |\\t)' + className + '(\\t| |$)', 'gi').test(element.className);
}
```

好啦，现在又有一个新方法**get√**

现在，非常方便的方法我们已经拥有了2个，那么我们开始天马行空(~~不考虑性能~~)的部分吧。

## 边界匹配法变种

同样是利用了样式边界的思路。我们将className字符串进行分割，然后使用for循环，进行查找。

```js
function hasClass(element, className) {
   const replacedName = element.className.replace(/\t*\s+/g, ' ');
   const aClassName = replacedName.split(' ')
   for (let i = 0; i < aClassName.length; i++) {
     if (className === aClassName[i]) {
       return true
     }
   }
   return false
}
```

至于为什么不用filter，includes等高阶函数，主要是为了照顾低版本浏览器，如果浏览器版本支持的话，还是用 **classList.contains** 吧。

## 使用getElementsByClassName()法

思路：根据className匹配元素数组，然后查找其中是否含有对应的元素。

```js
function hasClass(element, className) {
  var aSameClassEle = document.getElementsByClassName(className);
  for(var i=0; i < aSameClassEle.length; i++) {
    if(aSameClassEle[i] === element) {
      return true;
    }
  }
  return false;
}
```

好了，这样在判断一个元素是否含有某个样式的时候，就有不同的方法可以用了。如果要做兼容性的话，只需要在前面加个判断if(element.classList)，在有classList方法的浏览器中使用classList.contains()方法，其他浏览器使用这些方法中的一个即可。

## 参考资料

[What is the best way to check if element has a class?](https://stackoverflow.com/questions/10960573/what-is-the-best-way-to-check-if-element-has-a-class)

[YOU MIGHT NOT NEED JQUERY](http://youmightnotneedjquery.com/)