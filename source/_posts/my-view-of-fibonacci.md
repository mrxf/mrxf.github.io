---
title: 一个前端眼中的斐波那契数列
date: 2017-09-21 15:29:01
tags: [Javascript]
---
![斐波那契数字游戏](http://o93mwnwp7.bkt.clouddn.com/blog/fibonacci.jpeg)

大学时期，每学习一门新编程语言，就会被要求重新实现一遍斐波那契数列算法。那时，常用的方法即递归法和递推法。那时只对结果感兴趣，只要结果出来了，其他的仿佛就无所谓了。

<!--more-->

现在，成为一名前端工程师之后，再看这个问题，要考虑的情况，也变得更广泛了，可以用的方法也更多了。所以现在希望应用自己了解的知识，再计算一次斐波那契数列。

![格式](http://o93mwnwp7.bkt.clouddn.com/blog/46c741e0cab6469d7e1c54bc054947c9_b.jpg)

首先，斐波那契数列从第0个开始，分别是
```
0, 1, 1, 2, 3, 5, 8, 13, 21, 34, 55, 89, 144, 233……
```
因此要根据该规则，返回第n个斐波那契数

# 递归法

首先，先把之前的递归方法再再再实现一遍。
```js
function fibonacci(n){
    if(n === 1 || n === 0 ) return n;
    return fibonacci(n-1) + fibonacci(n-2);
}
```
递归的思路很简单，即不断调用自身方法，直到n为1或0之后，开始一层层返回数据。

使用递归计算大数字时，性能会特别低，原因有以下2点：

① 在递归过程中，每创建一个新函数，解释器都会创建一个新的函数栈帧，并且压在当前函数的栈帧上，这就形成了调用栈。因而，当递归层数过大之后，就可能造成调用栈占用内存过大或者溢出。

另外，我们在return前加入以下语句，打印一下递归的计算过程。
```js
console.log(`fibonacci(${n-1}) + fibonacci(${n-2})`)
```
当，n为6时，得到的结果为
```cmd
fibonacci(5) + fibonacci(4)
fibonacci(4) + fibonacci(3)
fibonacci(3) + fibonacci(2)
fibonacci(2) + fibonacci(1)
fibonacci(1) + fibonacci(0)
fibonacci(1) + fibonacci(0)
fibonacci(2) + fibonacci(1)
fibonacci(1) + fibonacci(0)
fibonacci(3) + fibonacci(2)
fibonacci(2) + fibonacci(1)
fibonacci(1) + fibonacci(0)
fibonacci(1) + fibonacci(0)
```
② 分析可以发现，递归造成了大量的重复计算。

递归的以上两种缺点，我们可以使用**尾调用优化**和**递推法**来解决。

# 尾调用优化

首先，什么是尾调用。

> **尾调用**是指一个函数里的最后一个动作是一个函数调用的情形：即这个调用的返回值直接被当前函数返回的情形。WikiPad[[1]][a]

用代码来说，就是B函数的返回值被A函数返回了。
```js
function B() {
    return 1;
}
function A() {
    return B();  // return 1
}
```

什么时候会执行尾调用优化呢？

在ES6中，strict模式下，满足以下条件，尾调用优化会开启，此时引擎不会创建一个新的栈帧，而是清除当前栈帧的数据并复用：[[2]][b]

1. 尾调用函数不需要访问当前栈帧中的变量

2. 尾调用返回后，函数没有语句需要继续执行

3. 尾调用的结果就是函数的返回值

举例说明：

以下函数即可开启尾调用优化
```js
"use strict";
function doA() {
    return doB();
}
```
以下函数无法开启尾调用优化
```js
"use strict";
function doC() {
    doD();  // 尾调用的结果不是函数的返回值
}
```
```js
"use strict";
function doE() {
    return 1 + doF(); // 尾调用返回后，函数仍然有语句要运行
}
```

我们使用尾调用优化，重写函数。
```js
'use strict'
function fibonacci(n, current, next) {
    if(n === 1) return next;
    if(n === 0) return 0;
    return fibonacci(n - 1, next, current + next);
}
```
我们可以使用如下方法调用该函数
```js
fibonacci(6, 0, 1);
```
这时，在执行该函数时，由于`引擎不会创建一个新的栈帧，而是清除当前栈帧的数据并复用`，就不会出现内存占用过大的情况了。

得益于ES2015的`默认参数`特性，我们可以将以上函数改写。
```js
'use strict'
function fibonacci(n, current = 0, next = 1) {
    if(n === 1) return next;
    if(n === 0) return 0;
    return fibonacci(n - 1, next, current + next);
}
```
这样在调用时，只需要传递一个参数即可
```js
fibonacci(6);
```
这时，我们在return语句之前，打印其调用过程
```js
console.log(`fibonacci(${n}, ${next}, ${current + next})`);
```
会发现调用过程大大减少
```
fibonacci(6, 1, 1)
fibonacci(5, 1, 2)
fibonacci(4, 2, 3)
fibonacci(3, 3, 5)
fibonacci(2, 5, 8)
```

> **注意:** 在ES 2015中，只有在strict模式下，才会开启尾调用优化

# 递推法
递推法的思路非常符合计算思路，即，f(0)开始，一个个计算下去，直到加到我们需要的值。
```js
function fibonacci(n) {
    const aFi = new Array(n+1);
    aFi[0] = 0; aFi[1] = 1;
    for(let i=2; i<= n; i++){
        aFi[i] = aFi[i-1] + aFi[i-2];
    }

    return aFi[n];
}
```
这里我们定义了一个数组来容纳**所有**的计算结果，但是实际上，我们仅仅需要`f(n-1)`和`f(n-2)`两个值，因此我们可以用两个变量存储这两个值来减少内存开销。
```js
function fibonacci(n) {
    let current = 0;
    let next = 1;
    let temp;
    for(let i = 0; i < n; i++){
        temp = current;
        current = next;
        next += temp;
    }
    return current;
}
```
基于此思路，我们对此使用不同的方法进行改写。

## 变种一 ES2015 结构赋值法

结构赋值[[3]][e]允许我们将值直接从数组中提取到不同变量中。因此我们可以用结构赋值，省略temp中间变量。
```js
function fibonacci(n) {
    let current = 0;
    let next = 1;
    for(let i = 0; i < n; i++){
        [current, next] = [next, current + next];
    }
    return current;
}
```
## 变种二 while的-->形式
```js
function fibonacci(n) {
    let current = 0;
    let next = 1;
    while(n --> 0){
        [current, next] = [next, current + next];
    }
    return current;
}
```
这里的`-->`并不是limit运算符，这只是两个操作符的缩写。即--和>。

这里的
```js
while(n --> 0){}
```
可以改写为
```js
while(n>0) {n--}
```
这里解释一下为什么是这样。

n先进行--操作，n自身的值变为n-1。

然后使用n--的**返回值**与0进行比较大小，而**n--的返回值是n**。

所以，只要`n>0`，那么就会执行`n--`

## 变种三 高级函数
```js
function fibonacci(n){
	let seed = 1;
	return [...Array(n)].reduce(p => {
		const temp = p + seed; 
		seed = p;
		return temp;
	},0)
}
```
这里利用Reduce高级函数[[5]][g]的特性，第一个参数为上一次计算的值，因此这里的pp保存F(n-1)值，而seed则保存F(n-2)的值。

## 变种四 Generator生成器

Generator是ES2015的新特性，得益于该特性，我们可以使用生成器方法，制作一个斐波那契数列生成器。
```js
function* fibonacci(){
    let current = 0;
    let next = 1;
    yield current;
    yield next;

    while(true) {
        [current, next] = [next, current + next];
        yield next;
    }
}
```
使用方法即
```js
const fibo = fibonacci();
for(let i=0; i< 10;i ++){
    console.log(fibo.next().value);
}
```
但是这一个生成器并不是可以生成指定n的函数，详细实现方法，以及可能遇到的坑可以参阅这篇文章[我从用 JavaScript 写斐波那契生成器中学到的令人惊讶的 7 件事][i]。


# 通项公式法

![通项公式](http://o93mwnwp7.bkt.clouddn.com/blog/503d269759ee3d6db9e6f1e046166d224f4adefd.jpg)

斐波那契的通项公式证明，可以参阅[百度百科][h]。比照该公式，可以实现如下代码[[8]][j]：

```js
function fibonacci(n) {
    const SQRT_FIVE = Math.sqrt(5);
    return Math.round(1/SQRT_FIVE * (Math.pow(0.5 + SQRT_FIVE/2, n) - Math.pow(0.5 - SQRT_FIVE/2, n)));
}

```

以上，便是我当前学习到的解决方案。如果你有更好的解决方案，或者对一些方法有异议，也希望可以在评论区不吝赐教。


# 参考资料

[1] [尾调用 - 维基百科，自由的百科全书][a]

[2] [《理解 ES6》阅读整理：函数（Functions）（八）Tail Call Optimization][b]

[3] [解构赋值 - JavaScript | MDN][e]

[4] [关于-->的运算顺序问题][f]

[5] [Array.prototype.reduce() - JavaScript | MDN][g]

[6] [斐波那契数列_百度百科][h]

[7] [我从用 JavaScript 写斐波那契生成器中学到的令人惊讶的 7 件事][i]

[8] [斐波那契数列求和的js方案以及优化][j]

[9] [尾调用优化 - 阮一峰的网络日志][c]

[10] [斐波那契数列算法优化][d]

[a]: https://zh.wikipedia.org/wiki/%E5%B0%BE%E8%B0%83%E7%94%A8
[b]: http://www.cnblogs.com/xfshen/p/6001581.html
[c]: http://www.ruanyifeng.com/blog/2015/04/tail-call.html
[d]: http://www.cnblogs.com/myoleole/archive/2012/12/01/2797709.html
[e]: https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Operators/Destructuring_assignment
[f]: https://www.zhihu.com/question/65662523/answer/233405655
[g]: https://developer.mozilla.org/zh-CN/docs/Web/JavaScript/Reference/Global_Objects/Array/Reduce
[h]: https://baike.baidu.com/item/%E6%96%90%E6%B3%A2%E9%82%A3%E5%A5%91%E6%95%B0%E5%88%97
[i]: http://www.zcfy.cc/article/473
[j]: https://segmentfault.com/a/1190000007115162