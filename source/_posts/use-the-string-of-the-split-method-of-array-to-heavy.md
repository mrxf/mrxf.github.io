---
title: 使用字符串的split方法，对数组进行去重
date: 2016-07-04 22:48:13
tags: [javascript]
---
在解决数组的去重问题的时候，一般可以使用循环，将元素进行对比，如果不重复，那么就将元素存入到数组中去。

我在想这个问题的时候，参考了字符串的统计字符出现次数的思路

`times = testString.split('char').length-1`

<!-- more -->

每次去数组的第一个字符，作为分割的字符，将字符从字符串中删除掉，以此循环，直到最后一组相同的字符被删除。就可以得到一个不重复的数组。

```js
function unique(arr) {
  var newArr = [];
  while (arr.length > 0) {
    newArr.push(arr[0]);
    arr = arr.join("").split(newArr[newArr.length-1]).join("").split("");
  }
  return newArr;
}
```

对生成的数组再次进行`.join("").split("")`操作的原因是，分割的字符串可能会出现空字符存在于数组的情况，用这种方法删除多余的空字符。

---

同时还有其他的三种思路在下面作为参考

1 . 第一种是比较常规的方法

思路：

* 构建一个新的数组存放结果
* for循环中每次从原数组中取出一个元素，用这个元素循环与结果数组对比
* 若结果数组中没有该元素，则存到结果数组中

```js
Array.prototype.unique1 = function(){
 var res = [this[0]];
 for(var i = 1; i < this.length; i++){
  var repeat = false;
  for(var j = 0; j < res.length; j++){
   if(this[i] == res[j]){
    repeat = true;
    break;
   }
  }
  if(!repeat){
   res.push(this[i]);
  }
 }
 return res;
}
var arr = [1, 'a', 'a', 'b', 'd', 'e', 'e', 1, 0]
alert(arr.unique1());
```
2 . 第二种方法比上面的方法效率要高
思路：
* 先将原数组进行排序
* 检查原数组中的第i个元素 与 结果数组中的最后一个元素是否相同，因为已经排序，所以重复元素会在相邻位置
* 如果不相同，则将该元素存入结果数组中

```js
Array.prototype.unique2 = function(){
 this.sort(); //先排序
 var res = [this[0]];
 for(var i = 1; i < this.length; i++){
  if(this[i] !== res[res.length - 1]){
   res.push(this[i]);
  }
 }
 return res;
}
var arr = [1, 'a', 'a', 'b', 'd', 'e', 'e', 1, 0]
alert(arr.unique2());
```
> 第二种方法也会有一定的局限性，因为在去重前进行了排序，所以最后返回的去重结果也是排序后的。如果要求不改变数组的顺序去重，那这种方法便不可取了。

3 . **第三种方法（推荐使用）**
思路：
* 创建一个新的数组存放结果
* 创建一个空对象
* for循环时，每次取出一个元素与对象进行对比，如果这个元素不重复，则把它存放到结果数组中，同时把这个元素的内容作为对象的一个属性，并赋值为1，存入到第2步建立的对象中。
说明：至于如何对比，就是每次从原数组中取出一个元素，然后到对象中去访问这个属性，如果能访问到值，则说明重复。

```js
Array.prototype.unique3 = function(){
 var res = [];
 var json = {};
 for(var i = 0; i < this.length; i++){
  if(!json[this[i]]){
   res.push(this[i]);
   json[this[i]] = 1;
  }
 }
 return res;
}
var arr = [112,112,34,'你好',112,112,34,'你好','str','str1'];
alert(arr.unique3());
```
