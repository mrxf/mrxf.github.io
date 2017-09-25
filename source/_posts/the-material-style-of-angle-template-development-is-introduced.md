---
title: 基于Material样式的Angle模板开发介绍
date: 2016-11-21 16:48:52
tags: [angular,javascript,material]
---

[Angle](https://wrapbootstrap.com/theme/angle-bootstrap-admin-template-WB04HF123)是一款强大的后台界面模板，提供了包括jQuery、reactjs、angular、material、backend-mean等不同开发语言以及模式的模板。使用该模板可以开发出非常漂亮的管理界面

![Angle](http://o93mwnwp7.bkt.clouddn.com/github/angle-dash.png)

以下是使用Material版本的Angle的开发介绍

<!--more-->

# 环境

正常开发需要从`seed`项目开始，本次使用的是`material-seed`进行开发。

## 文件夹介绍

```
+-- app/  // 项目的打包输出目录
|   +-- css/
|   +-- documentation/  // 介绍文档
|   +-- img/
|   +-- js/
|   +-- i18n/
|   +-- pages/
|   +-- vendor/
|   +-- views/
+-- master/   // 项目的开发目录
|   +-- jade/ 
|   |   +-- pages/
|   |   +-- views/
|   +-- js/
|   |   +-- modules/
|   |   |   +-- controllers/
|   |   |   +-- directives/
|   |   |   +-- services/
|   |   +-- custom/
|   +-- sass/
|   |   +-- app/
|   |   +-- bootstrap/
|   |   +-- themes/
|   +-- gulpfile.js
|   +-- package.json
|   +-- bower.json
+-- server/  // 模拟服务器数据交互的json文件，页面左侧的树形文件就在其中
|   +-- *.json
+-- vendor/    // 第三方库，由master中bower加载依赖，使用gulp在发布的时候发布到该文件夹中
+-- index.html   // 入口文件
```

## 开发环境

首先需要基本的环境

[![npm](https://img.shields.io/npm/v/npm.svg?style=flat-square)]() [![Bower](https://img.shields.io/bower/v/bootstrap.svg?style=flat-square)]()

进入开发目录`master`,安装项目所需依赖npm包,使用命令行

```cmd
npm install
```

使用bower安装所需插件，安装之前可以将所需要的插件改为自己需要的版本，比如`angular-material`可以改为最新版本

```
bower install
```

## 打包发布项目

如果使用less编写的样式，那么可以在`master`目录下直接运行命令

```
gulp
```

如果使用sass编写样式，需要在后面加入参数
```
gulp --usesass
```

这时，在服务器环境下，打开index.html文件就可以看到基本的页面内容。

**Note:**

> 在开发过程中最好一直开启gulp，保持watch的运行，这样所做改变就会立即被打包生成


# 开发

## 路由

项目使用`ui-router`插件配置路由，修改添加路由的需要在`master/js/modules/routes/routes.config.js`文件中配置

### 添加新的state

在已存在的state下追加即可，格式如下

```js
.state('app.someroute', {
    url: '/some_url',
    templateUrl: 'path_to_template.html',
    controller: 'someController',
    resolve: angular.extend(
    helper.resolveFor(), {
    // YOUR RESOLVES GO HERE
    }
    )
})
```
其中`resolve`是用于加载页面所需要的第三方vendor，配置文件参见

## Module 与 Controller

每个页面模块的js文件是存放于同一个文件夹中的，可以参考，`master/js/modules/material/`。

因此创建一个新的模块可以在`custom`或者`modules`文件夹中添加自己的文件夹，然后添加`moduleName.config.js`和`moduleName.controller.js`文件
格式可参考`master/js/modules/material/`文件夹中的文件

以下是一个简单的module例子
```js
(function () {
    'use strict';

    angular
        .module('app.moduleName', [
            'ngMaterial'
        ]);
})();
```

以下是controller的简单例子

```js
(function () {
    'use strict';

    angular
        .module('app.moduleName')
        .controller('moduleNameController', moduleNameController);

    moduleNameController.$inject = [];
    function moduleNameController() {
       
    }
})();

```

之后，将该module添加到`/master/js/app.module.js`文件中

## 表现页面Jade *(pug)*

该项目页面使用[jade](http://naltatis.github.io/jade-syntax-docs/)预编译语言编写，位于`/master/jade/`文件夹中。

在该文件夹下创建对应的文件，或者创建新的文件夹，将自己的jade文件添加对应目录下。

如果已经开启了gulp watch，那么此时，在`/app/views/`就可以看到对应的html文件

## 样式 Sass或Less

sass和less的开发目录位于`/master/sass/`或`/master/less/`目录下。

在其中的`app`目录下创建自己项目的文件夹,在其中添加``**ss``文件。

然后在`master/sass/app.scss` *(或less)* 文件中 将我们的scss文件import进来，保证编译的时候可以被编译到。

## Hello World！

如果已经写好了对应的，jade文件，Scss文件以及js文件，并且已经配置好路由。

这时候在服务器环境下打开，输入对应的路由地址，预览页面吧。

![Hello world](http://o93mwnwp7.bkt.clouddn.com/github/angle-view.png)


# 部署

发布项目，正常项目发布仅仅需要以下文件

```
|
|--app
|--vendor
|--index.html
```

如果在server中依然存在一些mock的文件，那么需要将server文件夹一并发布


# Tips

## 将链接加入左侧栏

修改`/server/sidebar-menu.json`文件即可

以下是创建一个一级目录的简单例子

```json
{
    "text": "Welcome",
    "sref": "app.welcome",
    "icon": "icon-tag"
}
```

## 修改加载动画

需要修改加载动画的样式，查阅`/master/js/modules/preloader/preloader.directive.js`文件，并且修改其中指定的css样式以及文件即可。

如果需要临时屏蔽加载动画，注释掉index.jade文件中的
```jade
 div(data-preloader)
 ```

 ## 使用LazyLoad为页面加载第三方依赖

以下以实现一个加载动画效果为例。

可能用到的插件有 *（可以按照自己的需求删减添加）*

* `whirl` 
* `spinkit`
* `loaders.css`

**首先，在`master`文件夹中使用bower安装以上包**

```
bower install whirl spinkit loaders.css
```

安装完，之后，需要让gulp在打包的时候，将以上包的文件打包到`vendor`目录中。
修改`/master/vendor.json`文件，在其后面添加

```json
  "bower_components/loaders.css/loaders.css",
  "bower_components/spinkit/css/spinkit.css",
  "bower_components/whirl/dist/whirl.css"
```
这样，gulp就会将对应的文件添加到vendor目录中

**在lazyload/lazyload.constants.js**中配置第三方包

在scripts中添加以下代码
```js
//spinner用到的库
'loaders.css':          ['vendor/loaders.css/loaders.css'],
'spinkit':              ['vendor/spinkit/css/spinkit.css'],
'whirl':                ['vendor/whirl/dist/whirl.css']
```
或者
```js
'spinner':          ['vendor/loaders.css/loaders.css',
                     'vendor/spinkit/css/spinkit.css',
                     'vendor/whirl/dist/whirl.css']
```

**在路由配置中为页面添加对应的引用**

在`/master/js/modules/routes/routes.config.js` 文件中为对应的路由添加引用

```js
.state('app.moduleName', {
    resolve: helper.resolveFor('loaders.css'，'spinkit','whirl')
})
```

如果是第二种写法，则使用

```js
.state('app.moduleName', {
    resolve: helper.resolveFor('spinner')
})
```

这时，在对应的页面加载的时候，可以看到资源已经被加载进来

![spinner](http://o93mwnwp7.bkt.clouddn.com/github/angleReslove.png)

**使用插件为我们提供的功能**

在jade文件中，添加测试效果，即可看到对应的加载动画
```jade
.row
  .col-md-4
    .panel.panel-default
      .panel-heading
        h5 Folding Cube
      .panel-body.loader-demo.loader-demo-sk
        .sk-folding-cube
          .sk-cube1.sk-cube
          .sk-cube2.sk-cube
          .sk-cube4.sk-cube
          .sk-cube3.sk-cube
```
![spinner](http://o93mwnwp7.bkt.clouddn.com/github/angle-spinner.gif)

更多效果可以参阅
 [whirl](http://jh3y.github.io/whirl/) 
 [spinkit](http://tobiasahlin.com/spinkit/) 
 [loaders.css](https://connoratherton.com/loaders)

或者官方Demo中的`/app/spinners`页面




