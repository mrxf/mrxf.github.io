---
title: 实现一个URL中的中文路径英文化工具
date: 2017-03-21 10:21:15
tags: [vue,lodash]
---

![题图](http://cdn.thisjs.com/url-address.jpg?imageView/2/w/500)

在使用[Hexo](https://hexo.io/)创建博客的时候，所有的博客内容为了与主题内容相同，使用了中文命名，导致生成的链接也是中文目录。

<!--more-->

最近将博客迁移到Centos中之后，由于中文文件名导致404问题。所以决定将所有的中文文件名改为对应的英文名，希望仿照[W3CPlus](http://www.w3cplus.com/)的命名方式

* 对应英文翻译
* 所有字母小写
* 空格变为- 

![W3C命名方式](http://cdn.thisjs.com/github/en-demo.png)

最初使用手动方式将文件名拷贝到[谷歌翻译](http://translate.google.cn/)，得到翻译结果之后，将翻译结果变为小写，将空格替换为"-"，由于重复操作太多，所以决定写个小工具，来进行后面的2步操作。

由于`Vue`的双向数据绑定的便利，所以使用Vue对数据进行监听修改，采用[loadash](https://lodash.com/)来进行数据处理

### 所有字母小写

```js
_.lowerCase(str)

```

### 空格变为-

使用正则表达式替换即可

```js
str.replace(/\s+/g, "-")

```
但是这时候可能会出现一个问题，在字符串前后都有空格的时候`" Hello World "`，会生成`"-hello-world-"`,这不是我们需要的

所以在替换之前将首尾空格去掉即可

```js
_.trim(str)

```
所以初版就是这样子的

![第一版功能](http://cdn.thisjs.com/github/first-result.png)

## 添加翻译、复制功能

但是这样还是需要切换页面进行复制粘贴，因此可以直接将翻译过程省略，首先想到的是[有道翻译api](http://fanyi.youdao.com/openapi)，申请完key之后，发现如果使用json方式获取数据，那么会有跨域问题，只能使用jsonp方式，但是vue官方推荐的[axios](https://github.com/mzabriskie/axios)并不支持jsonp，所以采用[vue-resource](https://github.com/pagekit/vue-resource)。

{% plantuml %}
    title 请求流程

    View -> Watcher : 数据改变

    Watcher -> Methods : 调用方法

    Methods --> 有道翻译 : 请求数据

    有道翻译 --> Methods: 数据返回

    Methods -> Methods : 数据格式化

    Methods -> View : 展示数据 

{% endplantuml %}

但是每次输入框发生变化，就会触发一次数据请求，而有道翻译每天提供**1000**次请求，所以，使用lodash的debounce方法，减少请求次数，在输入结束500ms之后，再发起请求。

```js
getTrans:_.debounce(function(){},500)

```

最后使用[clipboardjs](https://clipboardjs.com/)为格式化的结果提供一个复制功能。这样就更加方便了。

<script async src="//jsrun.net/yPkKp/embed/all/light/"></script>

> 但是这样还是有些不方便，因为仍然需要选择文件名，然后粘贴，再复制粘贴，多了很多重复操作，所以可以使用Node的文档读取与操作功能实现该功能。