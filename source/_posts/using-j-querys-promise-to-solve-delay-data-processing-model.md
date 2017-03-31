---
title: 使用jQuery的promise模式解决延迟数据处理问题
date: 2016-10-26 10:34:59
tags: [jQuery,promise]
---

在使用jQuery进行开发的时候，有时候会遇到在某个方法里，需要通过$.ajax方法获取数据，在对数据处理完之后
再将处理后的数据进行返回

{% plantuml %}
    title 请求过程

    == 调用方法 ==

    fn1 -> fn2: 调用方法

    == 数据请求 ==

    fn2 -> 服务器: 请求数据

    ... 异步请求 ...
    服务器 --> fn2: 数据返回

    fn2 -> fn2: 数据处理

    == 返回数据 ==

    fn2 -> fn1: 返回处理数据

{% endplantuml %}

<!--more-->
如果使用普通的方式进行数据返回，在还没有获取到服务器数据的时候，
就返回了一个值null，这样自然不是我们想要的结果

因此可以使用promise模式解决这个问题

**获取数据并处理的方法**
```js
    function fun2(){
        var deferred = $.Deferred();
        $.get("url", function (data) {
            // 处理1
        }).done(function (data) {
             deferred.resolve(data);
        })
        return deferred.promise();
    }

```

**调用的方法**

```js
    function fn1(){
        $.when(fn2())
        .done(function (data) {
           //获取到处理后的data值
        })
    }
```

> 参考文档
> 
> http://www.ruanyifeng.com/blog/2011/08/a_detailed_explanation_of_jquery_deferred_object.html

> http://www.cnblogs.com/lvdabao/p/jquery-deferred.html

