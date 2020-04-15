---
title: 探索无头浏览器的应用场景
date: 2017-09-16 10:27:09
tags: [无头浏览器, 爬虫]
---

![自动化操作](https://cdn.thisjs.com/blog/automateexpenses.jpg)

[Headless browser](https://en.wikipedia.org/wiki/Headless_browser)会带给我非常亲切的感觉，因为总能让我回想起[按键精灵](http://www.anjian.com/)和[AutoHotKey](https://www.autohotkey.com/)这两款非常实用的小工具。

<!--more-->

能有这样的感觉，大概是因为它们都操作基于用户界面，但是在运行时，可以让用户忽略用户界面吧。

无头浏览器有哪些实用的使用场景呢？

# 1. 自动化E2E测试
常用的E2E测试工具如`nightwatch`,`Karma`，都支持无头浏览器，这样在测试时，无需打开UI界面，即可完成对应的测试内容。

# 2. 解决登录问题
在使用一些网站API时，会遇到一些网站需要先登录的情况。

标准的网站，允许使用Post方法发送用户名及密码，返回对应的Token，之后的请求即可使用该Token，这时候我们可以直接使用[Request](https://www.npmjs.com/package/request)包即可。

但是遇到一些网站，并没有对外开放API接口，每次请求数据是通过登录后的Cookis进行判断。这时候我们也可以使用Request,截取`Set-Cookie` 头部信息即可。

但是，还有一些网站，在登录时候，需要添加服务器发送给客户端的安全码，这个时候如果单单使用`Request`就有些费力了。
![识别码](https://cdn.thisjs.com/random.png)

这时，使用无头浏览器可以很好的解决这个问题，这里使用Google Chrome的[puppeteer](https://github.com/GoogleChrome/puppeteer)编写例子。

```js
const puppeteer = require('puppeteer');

(async () => {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    await page.goto('http://youruri/api?redirect=anotheruri');  // 进入对应的登录页面
    /**
     * 这里测试的页面用户名input为autofocus属性
     * 不同页面可以使用选择器
     */
    await page.type('username');
    await page.press('Tab');
    await page.type('password');
    await page.press('Enter');
    page.on('response', res => {
        if(res.hasOwnProperty('headers')){
            for(let key in res.headers){
                if(key === 'set-cookie'){
                   // 在这里进行获取Cookie信息操作
                }else{
                    continue;
                }
            }
        }
    });
    await page.waitForNavigation();
    browser.close();
})();
```
简单几步，就可以获取到对应的Cookie信息，将该Cookie信息保存起来，就可以在其他请求中使用了。

# 3. 网络爬虫
在爬取一些网页时，对于普通的网页，我们可以直接使用Request, 发送GET请求，获取页面内容，然后进行分析，获取其中的数据。

但是这里有一个缺陷，即我们只能获取到网页的HTML内容，无法获取到页面XHR获取到的内容，即我们无法执行页面的JS。
这就导致我们无法获取那些动态加载的数据，甚至大部分单页面APP。

这时无头浏览器的作用就非常明显了，无头浏览器即没有用户界面的浏览器，浏览器功能全部存在，因此执行JS也不在话下。

## 例：

我们使用Request，get请求知乎某用户的关注列表[https://www.zhihu.com/people/zhang-shu-yuan-18/following](https://www.zhihu.com/people/zhang-shu-yuan-18/following),然后使用[Cheerio](https://www.npmjs.com/package/cheerio)获取关注的用户名。
```js
const request = require('request');
const cheerio = require('cheerio');

request.get('https://www.zhihu.com/people/zhang-shu-yuan-18/following', (error, res, body) => {
    const $ = cheerio.load(body);
    $('.UserLink-link').each((index, item) => {
        console.log($(item).text());
    })
})
```
会发现只有三个结果
```
柳佳
李沫霖
Jim Liu
```
这是因为剩余的内容需要Ajax加载，这时，我们使用[puppeteer](https://github.com/GoogleChrome/puppeteer)进行获取。

```js
const puppeteer = require('puppeteer');
const cheerio = require('cheerio');
(async function () {
    const browser = await puppeteer.launch();
    const page = await browser.newPage();
    await page.goto('https://www.zhihu.com/people/zhang-shu-yuan-18/following');
    let pageContent =await page.content();
    const $ = cheerio.load(pageContent);
    $('.UserLink-link').each((index, item) => {
        console.log($(item).text());
    })
    browser.close();
})()
```
这时，一整页的数据全部加在进来了，打印`$('.UserLink-link').length`会发现有40条数据。

> 当然，如果找到了该页面加载用户的API，直接使用该API请求数据是最方便的了

# 4. SSR服务端渲染

由于有些搜索引擎在抓取页面的时候，并不执行页面里的JS，因此会导致很多单页面APP的内容无法被搜索引擎更好的收录。

这时，可以使用无头浏览器，做服务端渲染。在判断访问来路为`XXX-spider`之后，将页面内容，在服务端使用无头浏览器执行一遍，将执行后的HTML内容，返回给搜索引擎，这样搜索引擎就可以获取到执行JS后的内容了。

> 最后，这里收集了一些常用的无头浏览器

* [Phantomjs](http://phantomjs.org/) Webkit内核的无头浏览器，广泛应用于E2E测试
* [SlimerJS](https://slimerjs.org/) 类似Phantomjs，使用Gecko内核
* [puppeteer](https://github.com/GoogleChrome/puppeteer) Google Chrome团队推出的，可以直接在node中使用

# 参考资料

* [Headless Browser and scraping](https://stackoverflow.com/questions/18539491/headless-browser-and-scraping-solutions)
* [使用Nightwatch进行端到端测试](http://www.infoq.com/cn/news/2014/02/nightwatch)
* [运用phantomjs无头浏览器破解四种反爬虫技术](http://python.jobbole.com/86415/)