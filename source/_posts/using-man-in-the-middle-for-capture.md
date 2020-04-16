---
title: 使用MiTM的方式进行无线抓包调试
date: 2018-04-07 22:03:51
tags: [中间人, 开发, 抓包]
---

[![](https://cdn.thisjs.com/img/20180405173639.png)](https://cdn.thisjs.com/img/20180405173639.png)

## 背景介绍

在开发的过程中，常常会遇到需要抓包，查看请求数据的情况。

*   在Windows平台上，常用的软件是 [<u>Fiddler</u>](https://www.telerik.com/fiddler)
*   而在OS X系统中，要使用的软件则是 [<u>Wireshark</u>](https://www.wireshark.org/)
*   在Android平台上，使用的则是 [<u>Packet Capture</u>](https://play.google.com/store/apps/details?id=app.greyshirts.sslcapture)

本来各自负责各自的平台，非常的和平。但是我们会遇到在一个平台上调试其他设备的数据请求情况。
<!--more-->

比如在Windows上调试手机设备，我们可以在Fiddler中开启**允许其他设备远程连接**，然后在手机设备中设置VPN为电脑IP，这样手机的数据会通过电脑进行请求，这样我们就可以在Fiddler中抓取手机中的数据包了。

这项操作其实还可以简化，那就是不需要手机进行任何设置，我们就可以直接直接获取手机上的数据包。这时候，我们就可以使用神奇的 **Ettercap** 了，该软件可以实现一个中间人攻击的思路，进行抓包分析。

![](https://cdn.thisjs.com/img/mitmblogeng-1.png)

> 中间人攻击是指**攻击**者与通讯的两端分别建立独立的联系，并交换其所收到的数据，使通讯的两端认为他们正在通过一个私密的连接与对方直接对话，但事实上整个会话都被攻击者完全控制

基于此，我们便不需要通过手机端的设置或者允许，我们在这个环节中，扮演攻击者，就可以快速的开始对其抓包分析了。

以下介绍在os X系统中进行中间人攻击抓包的方式。

## 安装工具包

我们需要的几个工具如下：

*   nmap (_端口扫描器_)
*   ettercap (_中间人攻击工具_)
*   Wireshark (_包分析工具_)
使用Homebrew安装这几个包非常方便。
```
$ brew install nmap
```
```
$ brew install ettercap
```

在安装Ettercap的时候可以选择带GUI界面的，只需要在后面追加`--with-gtk+` 参数即可。

```
$ brew install wireshark --with-qt
```

##  具体操作

### 1. 查看局域网IP信息

首先，**电脑要与手机在同一个局域网中**。接下来，通过IP查看局域网使用的网段。在终端中，使用以下其中一个命令，查看IP地址。

```
ipconfig getifaddr en0 # 使用无线网连接
ipconfig getifaddr en1 # 使用以太网连接
ipconfig getifaddr en3 # 使用其他适配器连接
```

### 2. 扫描同一局域网中的网络使用情况。

接下来我们使用namp查看同一网段下，有哪些设备在连接。会得到类似以下结果。

```
$ nmap -sP  192.168.199.0/24

Starting Nmap 7.60 ( https://nmap.org ) at 2018-04-05 18:10 CST
Nmap scan report for Hiwifi.lan (192.168.199.1)
Host is up (0.0030s latency).
Nmap scan report for android-5ea1fea3b816a66.lan (192.168.199.153)
Host is up (0.031s latency).
Nmap scan report for zMBP.lan (192.168.199.169)
Host is up (0.0021s latency).
Nmap scan report for RedmiNote4X-hongmish.lan (192.168.199.198)
Host is up (0.035s latency).
Nmap scan report for iPad.lan (192.168.199.202)
Host is up (0.037s latency).
Nmap scan report for iPhone-7.lan (192.168.199.234)
Host is up (0.0068s latency).
Nmap done: 256 IP addresses (6 hosts up) scanned in 3.07 seconds

```
<del>当然，如果你通过手机的链接信息中，直接获取到手机IP的话，该步骤可以省略。</del>

可以看到这里有多个设备在连接，而我本次需要测试的是`android…….lan (192.168.199.153)` 这一个IP。

### 3. 开始Ettercap

这里使用curses图形化界面启动，参数为`-C`，如果使用GUI界面的话，参数为`-G`

```
sudo ettercap -C
```
[![](https://cdn.thisjs.com/img/etttercap-index.png)](https://cdn.thisjs.com/img/etttercap-index.png)

进入该界面后，依次选择`Sniff` -&gt; `Unified sniffing...U` -&gt; 输入网络类型值(_参考上面查询IP的参数，默认en0_) -&gt; `Hosts` -&gt; `Scan for hosts` -&gt; `Hosts list`

[![](https://cdn.thisjs.com/img/ettercap-hosts-list.png)](https://cdn.thisjs.com/img/ettercap-hosts-list.png)

这里可以看到扫描出来的同网段IP，在编写该文章的时候，有些其他设备已经离线了，因此本列表中扫描到的与使用namp扫描出来数量不同。但是如果记住了对应设备的IP，依旧可以使用。

这里，`192.168.199.1` 为网关，本次中间人攻击就是要实现欺骗设备 `192.168.199.153` 与网关 `192.168.199.1`之间的通讯。

接下来，需要将这两个IP分别加入嗅探的目标中，依次进入`Targets` -&gt; `Select TARGET(s) ` -&gt; 在TARGET1中输入/`192.168.199.153//`  TARGET1中输入/`192.168.199.1//`

**备注：这里的Target格式为 `MAC/IPs/PORTs/`**

这时，查看Current targets可以看到当前的目标列表。

[![](https://cdn.thisjs.com/img/ettercap-current-targets.png)](https://cdn.thisjs.com/img/ettercap-current-targets.png)

执行`MiTM` -&gt; `ARP poisoning...` -&gt; Parameters为空即可

这时，已经通过ARP欺骗的方式，成功开始了中间人攻击。可以通过`View` -&gt; `Statistics`查看该设备的数据情况。

[![](https://cdn.thisjs.com/img/ettercap-statistics-view.png)](https://cdn.thisjs.com/img/ettercap-statistics-view.png)

### 4. 分析数据

现在，我们已经成功监听了设备和网关之间数据。现在需要试着分析这些数据了。那么就要使用Wireshark了。

```
sudo wireshark
```

我们简单做一下筛选，只展示IP地址为192.168.199.153的POST请求。
```
ip.addr == 192.168.199.153 &amp;&amp; http.request.method == "POST"
```

我在手机的一个非https网站(www.div.io)中进行了登录测试。可以在wireshark中获取到了POST的JSON数据信息。

[![](https://cdn.thisjs.com/img/wireshark-post-userinfo-data.png)](https://cdn.thisjs.com/img/wireshark-post-userinfo-data.png)

可以看到登录的用户名密码都是以明文的方式传输的，非常方便的进行了数据抓包调试。

### 4.2 延伸

我们一直使用POST方式来获取该设备的登录信息，但是如果该设备已经登录过了，我们应该如何抓取到可以使用的信息呢？——当然是Cookie信息了。

将过滤的请求方式改为GET，在随便找到一个HTML页面之后，会发现其中带有Cookie信息。

[![](https://cdn.thisjs.com/img/wireshark-cookie-info.png)](https://cdn.thisjs.com/img/wireshark-cookie-info.png)

将该Cookie信息，保存下来，在任意浏览器中导入该Cookie信息，即可实现『登录』的效果。

[![](https://cdn.thisjs.com/img/wireshark-cookie-login.png)](https://cdn.thisjs.com/img/wireshark-cookie-login.png)

## 小结

至此，我们已经利用非常古老的的中间人攻击的方式，实现了不需要手机任何操作，就可以抓取手机数据包的功能。该方法在设置好之后，非常方便，可以快速切换设备，也可以多个设备同时抓包测试。

当然，我们也发现了其中的问题，那就是如果使用该方式对其他人的手机进行渗入，是不是就会导致数据泄露呢？理论上是会出现这种情况的，但是前面也提到，这是比较古老的攻击方式，只要设备上安装了任意的『XX安全卫士』『xx管家』，不要随便连接公共的WIFI，都可以保证我们的设备安全。

## 参考文档

*   [同一局域网环境下的arp欺骗和中间人攻击（mac）](https://youyuejiajia.wordpress.com/2016/03/20/%E5%90%8C%E4%B8%80%E5%B1%80%E5%9F%9F%E7%BD%91%E7%8E%AF%E5%A2%83%E4%B8%8B%E7%9A%84arp%E6%AC%BA%E9%AA%97%E5%92%8C%E4%B8%AD%E9%97%B4%E4%BA%BA%E6%94%BB%E5%87%BB%EF%BC%88mac%EF%BC%89/)
*   [wireshark怎么抓包 wireshark抓包详细图文教程](https://jingyan.baidu.com/article/c35dbcb0866b698916fcbc81.html)
*   [Man In The Middle Attack! (ARP Poisoning) using ettercap to sniff login information](https://www.youtube.com/watch?v=0a7o9FKzWOc)
*   [使用ettercap实现中间人攻击](http://blog.51cto.com/isnull/1738199)
*   [如何用Ettercap实现“中间人攻击”](http://www.freebuf.com/sectool/125104.html)
*   [Wireshark学习笔记——如何快速抓取HTTP数据包](https://blog.csdn.net/xukai871105/article/details/31008635)
*   [Ettercap的arp攻击方法](http://blog.51cto.com/wxfplane/1749951)