---
title: 淘宝提供ip数据库api
date: 2013-07-23 16:51:04
tags: [API]
---
地址：[ip.taobao.com](http://ip.taobao.com)
**接口说明**
---
1. 请求接口（GET）：
`http://ip.taobao.com/service/getIpInfo.php?ip=[ip地址字串]`
2. 响应信息：
（json格式的）国家 、省（自治区或直辖市）、市（县）、运营商

<!--more-->

3. 返回数据格式：
```
{"code":0,"data":{"ip":"210.75.225.254","country":"\u4e2d\u56fd","area":"\u534e\u5317",
"region":"\u5317\u4eac\u5e02","city":"\u5317\u4eac\u5e02","county":"","isp":"\u7535\u4fe1",
"country_id":"86","area_id":"100000","region_id":"110000","city_id":"110000",
"county_id":"-1","isp_id":"100017"}}
```
**访问限制**
---
为了保障服务正常运行，每个用户的访问频率需小于10qps。
其中code的值的含义为，0：成功，1：失败。

---

*另外补充*
搜狐IP地址查询接口（默认GBK）：http://pv.sohu.com/cityjson
搜狐IP地址查询接口（可设置编码）：http://pv.sohu.com/cityjson?ie=utf-8
搜狐另外的IP地址查询接口：http://txt.go.sohu.com/ip/soip