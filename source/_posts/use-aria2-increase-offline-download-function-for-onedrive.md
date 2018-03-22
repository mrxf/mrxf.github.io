---
title: 使用Aria2为OneDrive增加离线下载功能
date: 2018-03-07 21:22:10
tags: [centos]
---

![OneDrive](http://cdn.thisjs.com/blog/Microsoft-OneDrive.jpg)

本文介绍如何利用云服务器，为OneDrive增加离线下载功能。在充分利用云服务器空闲资源的同时，享受OneDrive强大的在线影音、文档编辑功能。

<!--more-->

## 太长不看的背景介绍

<details>
   <summary>还是点开看看吧</summary>

微软推出的OneDrive拥有非常强大的功能，可以在多个终端管理自己的文件，国内访问速度非常快，下载文件可以达到满速，不会像百度云那样即使有百兆网络，也只能每秒100k左右的下载速度。如果无法愉快的使用GoogleDrive，那么OneDrive是一个非常不错的选择。

在国内的主流云盘中，都会有一个离线下载的功能，即允许用户添加下载任务，服务器会自动将资源下载到云盘中，用户过段时间就可以查看自己的文件了。

使用`离线下载`功能一般有如下两个目的

1. 将需要观看的影视资源，下载到服务器中，过段时间就可以直接在线观看 *(百度云)*

2. 利用服务器的高速网络，将本来比较慢速的资源提前下载好，再取回本地 *(迅雷离线)*

而本次为OneDrive搭建的离线下载功能，主要推荐的使用方法如下：

1. 将需要阅读的文档资源，离线下载到OneDrive中，随时随地查看
2. 将需要编辑的Office资源离线保存，使用Office Online编辑
3. 将喜欢的音乐离线保存，随时随地听
4. 将喜欢的影视作品离线保存，随时随地观看
5. ~~将墙外的一些影视、图像资源保存到自己的OneDrive中(需要国外服务器)~~

不推荐的使用方法：

1. 将喜欢的游戏离线保存到服务器，过段时间再下载到电脑上
2. 将需要安装的大型软件离线保存
</details>

## 实现思路：

添加下载任务 => 将资源保存到服务器中 => 在服务器上将资源同步到OneDrive中 => 在OneDrive中查看资源

## 准备材料：

* 一台云服务器
* OneDrive

> **备注：** 本次使用的云服务器安装的是**CentOs 7.2**系统

## 首先实现将服务器上的资源同步到OneDrive

我们采用了[Linux OneDrive](https://github.com/skilion/onedrive)的开源项目。


### 安装git用于Clone GitHub上的资源

```
yum install git
```

### 开始安装onedrive

```
# 安装依赖
sudo yum install libcurl-devel
sudo yum install sqlite-devel
curl -fsS https://dlang.org/install.sh | bash -s dmd

# 安装OneDrive
git clone https://github.com/skilion/onedrive.git
cd onedrive
make
sudo make install
```

如果你在make过程中遇到了`dmd：命令未找到`错误，请先激活dmd，方法如下

```
# 激活
source ~/dlang/dmd-2.079.0/activate
# 取消激活
deactivate
```
安装完成之后，需要配置一下需要同步的内容，因为Onedrive默认会将服务器上所有的内容都同步下来，这样非常慢。

在onedrive 目录下执行以下三行命令，创建OneDrive配置文件
```
mkdir -p ~/.config/onedrive
cp ./config ~/.config/onedrive/config
vim ~/.config/onedrive/config
```

配置信息可以参考如下
```
# 本地同步的位置
sync_dir = "/home/download/onedrive"
# 符合以下规则的目录或者内容，将跳过同步
skip_file = "影视|软件工具"
```

* 这里使用`/home/download/onedrive`作为同步目录，是为了给Aria2留出下载目录，可以根据自己需要随便修改
* skip_file可以使用|添加多个规则

接下来为OneDrive执行授权，在命令行中执行

```
onedrive
```
会输出一个授权地址，复制授权地址到本地浏览器中打开，授权登录之后，将授权后的**全部地址**拷贝过来粘贴即可

从现在开始，只要执行OneDrive即可将本地的资源与服务端的内容同步。

但是我们希望在关闭SSH终端之后，依然可以自动同步。

官方推荐的方案是:

```
systemctl --user enable onedrive
systemctl --user start onedrive
```
但是在Centos 7.2中会出现错误，因此可以使用`nohup`、`screen`等命令允许在关闭SSH终端之后，继续执行，执行以下命令即可

```
nohup onedrive -m &
```

现在，我们在服务器上的文件操作，都会同步到OneDrive中了。


如果需要结束后台同步，找到ID，结束即可
```
[root@onedrive ~]# ps -ef|grep onedrive
root      40504      1  0 12:21 ?        00:00:02 onedrive -m
[root@onedrive ~]# kill 40504
```

## 安装Aria2实现远程下载

首先安装Aria2

```
yum install aria2
```

配置
```
mkdir /home/soft/aria2c -p
touch /home/soft/aria2c/aria2.session
vim /home/soft/aria2c/aria2.conf
```

配置内容参考如下

```
#用户名
#rpc-user=user
#密码
#rpc-passwd=passwd
#上面的认证方式不建议使用,建议使用下面的token方式
#设置加密的密钥
rpc-secret=token
#允许rpc
enable-rpc=true
#允许所有来源, web界面跨域权限需要
rpc-allow-origin-all=true
#允许外部访问，false的话只监听本地端口
rpc-listen-all=true
#RPC端口, 仅当默认端口被占用时修改
rpc-listen-port=6800
#最大同时下载数(任务数), 路由建议值: 3
max-concurrent-downloads=3
#断点续传
continue=true
#同服务器连接数
max-connection-per-server=3
#最小文件分片大小, 下载线程数上限取决于能分出多少片, 对于小文件重要
min-split-size=10M
#单文件最大线程数, 路由建议值: 5
split=10
#下载速度限制
max-overall-download-limit=0
#单文件速度限制
max-download-limit=0
#上传速度限制
max-overall-upload-limit=0
#单文件速度限制
max-upload-limit=0
#断开速度过慢的连接
#lowest-speed-limit=0
#验证用，需要1.16.1之后的release版本
#referer=*
#文件保存路径, 默认为当前启动位置
dir=/home/download/onedrive
input-file=/home/soft/aria2c/aria2.session
save-session=/home/soft/aria2c/aria2.session
save-session-interval=60
#文件缓存, 使用内置的文件缓存, 如果你不相信Linux内核文件缓存和磁盘内置缓存时使用, 需要1.16及以上版本
#disk-cache=0
#另一种Linux文件缓存方式, 使用前确保您使用的内核支持此选项, 需要1.15及以上版本(?)
#enable-mmap=true
#文件预分配, 能有效降低文件碎片, 提高磁盘性能. 缺点是预分配时间较长
#所需时间 none < falloc ? trunc << prealloc, falloc和trunc需要文件系统和内核支持
file-allocation=prealloc
```
**几个关键内容：**

* `rpc-secret`用于设置访问token
* `dir` 设置到OneDrive的目录


启动Aria2服务：
```
aria2c --conf-path=/home/soft/aria2c/aria2.conf -D
```

**接下来安装UI界面**

UI界面采用[webui-aria2](https://github.com/ziahamza/webui-aria2)

进入`/home/wwwroot`目录，克隆项目

```
git clone https://github.com/ziahamza/webui-aria2.git
```

**使用Nginx启动界面服务**

安装nginx
```
# 安装
sudo yum install nginx

# 作为服务启动
sudo systemctl start nginx
```

# 配置Nginx

```
vim vim /etc/nginx/nginx.conf
```
修改root目录到项目所在位置

```
server {
        listen       80 default_server;
        listen       [::]:80 default_server;
        server_name  _;
        root         /home/wwwroot/webui-aria2;

        # Load configuration files for the default server block.
        include /etc/nginx/default.d/*.conf;

        location / {
        }
}
```

重启Nginx

```
nginx -s reload
```

打开对应地址，发现已经成功了

![成功界面](http://cdn.thisjs.com/blog/linksuccess.png)

测试下载文件

![下载文件](http://cdn.thisjs.com/blog/downafile.png)

注意设置dir为OneDrive下的目录

![成功转存](http://cdn.thisjs.com/blog/down-upload-success.png)

过一会儿在Onedrive上，就会发现文件已经成功转存。


## 参考文献

[Ubuntu 14 安装aria2c与web ui将老旧笔记本改装成下载机](https://www.micronbot.com/Linux/aria2c.html)

[Linux ssh状态下如何后台运行程序？ - yegle的回答](https://www.zhihu.com/question/20709809/answer/15939097)