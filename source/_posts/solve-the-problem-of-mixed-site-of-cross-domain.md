---
title: 解决混合网址导致的跨域问题
date: 2016-06-30 14:37:37
tags: [跨域]
---
如果网站使用https安全方式加载HTML内容，但是其中的资源如js、图片等文件使用了http的不安全方式加载，就会触发混合内容的错误。在chrome浏览器中的提示为
> “Mixed Content: The page at 'https://yourwebsite.com/' was loaded over HTTPS，but requested an insecure script 'http://anotherweb.com/script.js'.This request has been blocked；the content must be served over HTTPS.”   

<!--more-->

以及   

> Mixed Content: The page at 'https://yourweb.com/' was loaded over HTTPS，but requested an insecure image 'http://anotherweb.com/image.jpg'.This content should also be served over HTTPS

这时候可以将引用的外域的资源的前面的地址 **http://** 改为 **//** 即可，这样就会让加载的方式默认使用https的方式加载资源。