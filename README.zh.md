[View English](README.md)

# 1 介绍

Tars [here](https://github.com/TarsCloud/Tars/blob/master/Install.md)

目录介绍
- framework: Tars框架Docker制作脚本, 制作的docker包含了框架核心服务和web管理平台, 会被dockerhub关联, 自动构建, 并提供下载
- tars: Tars框架Docker制作脚本, 和framework比, 增加了java, nodejs等运行时支持, 即可以把java, nodejs服务发布到docker里面(docker里面安装了jdk, node, php环境)
- tarsnode: tarsnode Docker制作脚本, 内置了java, nodejs等运行时支持, 即可以把java, nodejs服务发布到docker里面(docker里面安装了jdk, node, php环境)

# 2 Tars部署方式

介绍TarsDocker部署方式前, 先介绍Tars部署的几种典型方式, 各有优缺点, 可以根据实际情况选择.

需要了解Tars部署基础知识:

Tars整体由mysql+框架服务+业务服务组成:
- mysql, 用于存储各种服务信息
- 框架服务是由多个Tars实现好的服务(c++实现), web管理平台(nodejs)构成
- 业务服务是由开发团队根据产品需求自己实现的服务, 这些服务可以由c++, java, go, nodejs, php等语言实现

Tars完成部署后, 从服务器角度, 它由以下几部分组成:
- mysql集群(主从配置或者集群配置): 通常主从配置即可, 正常情况, 即使mysql挂了, 也不会影响业务服务的运行(但是会影响部署和发布)
- 框架服务: 是由多个c++实现的tars服务 + web管理平台组成, 通常部署在两台机器上, 其中一台会多部署web管理平台, tarspatch, tarsAdminRegistry, 运行过程中框架服务器都挂了, 也不会影响业务服务的运行(影响部署和发布)
- 多台节点服务器: 从1台至上万台, 每台节点服务器上都必须部署一个tarsnode进程, tarsnode要连接到框架服务上(连接tarsregistry)
- 业务自己实现的服务通过web管理平台发布到这些节点服务器上

Tars的部署工作包括:
- mysql的安装
- 框架服务部署(一般是两台服务器)
- 节点服务器部署(部署tarsnode), 一般可以通过web管理平台远程部署节点服务器

**注意:如果节点服务器上可能运行了不同语言实现的业务服务, 那么通常节点服务器的运行环境需要自己安装, 比如安装jdk, node等**

Tars部署方式有以下几种:
- 源码编译部署
- 框架Docker部署
- K8s Docker部署
- K8s 融合部署

## 2.1 源码编译方式部署

源码部署方式是了解Tars非常好的途径, 源码部署细节方式请参见 [here](https://github.com/TarsCloud/Tars/blob/master/Install.zh.md) 中的源码部署部分
主要步骤如下:
- 安装mysql
- 下载源码(TarsFramework)
- 编译源码
- 下载管理平台(TarsWeb)
- 通过一键部署脚本完成部署

源码部署, Tars框架服务都以独立的进程模式运行在服务器上, 可以手工启停, 每个服务都可以独立更新.

**注意:该方式建议对Tars比较熟悉的团队使用**

## 2.2 框架Docker化部署

源码部署虽然可以独立更新, 但是也带来了不便, 毕竟每个模块更新还是比较麻烦的, 同时模块版本可能还有依赖, 更新维护就更麻烦了.

在这种情况下, 可以选择框架Docker化部署: 简单的说, 将框架服务以及web都docker容器化, 启动容器则框架服务都自动启动, 更新时也整体更新.

Tars框架的Docker制作也分三种模式:
- 源码制作, 参见:[here](https://github.com/TarsCloud/Tars/blob/master/Install.zh.md) 中的docker制作部分.
- 自动制作(不包含运行环境), 参见framework目录
- 自动制作(包含运行环境), 参见tars目录

两者区别如下:
- 源码制作
>- 需要手工自己下载源码, 一步一步手工制作docker
>- 镜像都采用了国内镜像, 比较容易制作陈宫
>- 制作的镜像, 不包含运行环境, 即java, php等需要运行时的环境的业务服务, 无法发布到docker镜像内部

- 自动制作
>- 一键运行命令, 既可以完成镜像的制作
>- 采用的系统默认的源, 可能连接海外源, 较慢(但是在github上action制作的时候比较快)
>- framework/tars的区别在于是否包含了java, node, php的运行环境, 即这类业务服务可以发布到docker镜像中运行

## 2.3 K8s Docker 部署

框架Docker部署, 虽然极大方便了框架的部署, 但是对于使用k8s来管理容器的团队而言, 仍然有很多工作要做.

因此这里, 提供一种k8s上部署Tars的方式:
- 将框架服务容器化
- 将tarsnode节点服务也容器化
- 都作为pod部署在k8s上, pod运行的容器当成一台虚拟机
- 通过tars web发布服务到这些容器中运行

tars框架的docker制作方式, 请参见: [here](https://github.com/TarsCloud/TarsDocker/blob/master/tars/README.zh.md)
tarsnode的docker制作方式 请参见: [here](https://github.com/TarsCloud/TarsDocker/blob/master/tarsnode/README.zh.md)

这个docker和上一节的docker的区别在于, 这个docker内部提供了各种语言的运行环境, 简单的说可以把业务服务发布到这个docker内部运行(相当于把docker当成虚拟机)

虽然这种方式并没有把每个服务都做一个pod, 独立运行在k8s上, 但是也基本解决了tars和k8s结合的问题, 虽然不优雅, 当整体可用.

这种模式下需要解决的最核心问题是: 框架服务和tarsnode都作为pod, 可能会死掉并产生漂移, 导致ip会变化, 如何解决?
建议解决方式如下:
- 所有容器可以采用stateful headless模式部署, 每个都有独立的域名, 比如tars-0, tars-1, tarsnode-1, tarsnode-2等...
- tars部署时, 节点和业务都采用域名(不要采用ip), 注意web>=1.3.1之后的版本才支持
- 如果是c++版本, tarscpp也请使用1.2.0之后的版本, 否则域名解析可能不正常

## 2.4 K8s 融合部署

上面K8s的Docker部署, 虽然把Tars部署在k8s上运行起来, 但是实际发布, 扩容并没有使用K8s, 只是把k8s当成了一个容器管理平台了.

Tars和K8s的深度融合仍然在规划和开发中, 预计还有需要一段时间.

# 3 Docker部署Tars框架
## 3.1 Docker安装

Centos上安装Docker如下:
```sh
sudo su
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce 
systemctl start docker
systemctl enable docker
```

安装完毕以后, 查看Docker版本:
```sh
docker version
```

## 3.2 Install Mysql

使用docker安装来安装mysql(目前只考虑了linux上, 时间和本机同步)

```sh
docker pull mysql:5.6
docker run --name mysql --net=host -e MYSQL_ROOT_PASSWORD='root@appinside' -d -p 3306:3306 \
        -v/etc/localtime:/etc/localtime \
        -v /data/mysql-data:/var/lib/mysql mysql:5.6
```
 
**注意:--net-host表示Docker网络和本机一样** 

## 3.3 安装Tars框架

**如果你想源码自己编译docker, 请参见 [here](https://github.com/TarsCloud/Tars/blob/master/Install.zh.md)**

framework & tars 两种镜像都可以, 区别在于是否希望把业务服务部署在镜像内(不推荐, 不方便Tars框架升级)

### 3.3.1 使用framework
1. 拉取镜像
```sh
docker pull tarscloud/framework
```

2. 启动镜像(目前只考虑了linux上, 时间和本机同步)
```sh
docker run -d --net=host -e MYSQL_HOST=xxxxx -e MYSQL_ROOT_PASSWORD=xxxxx \
        -eREBUILD=false -eINET=eth0 -eSLAVE=false \
        -v/data/tars:/data/tars \
        -v/etc/localtime:/etc/localtime \
        tarscloud/framework
```

### 3.3.2 使用tars
1. 拉取镜像
```sh
docker pull tarscloud/tars
```

2. 启动镜像(目前只考虑了linux上, 时间和本机同步)
```sh
docker run -d --net=host -e MYSQL_HOST=xxxxx -e MYSQL_ROOT_PASSWORD=xxxxx \
        -eREBUILD=false -eINET=eth0 -eSLAVE=false \
        -v/data/tars:/data/tars \
        -v/etc/localtime:/etc/localtime \
        tarscloud/tars
```

### 3.3.3 参数解释

MYSQL_IP: mysql数据库的ip地址

MYSQL_ROOT_PASSWORD: mysql数据库的root密码

INET: 网卡的名称(ifconfig可以看到, 比如eth0), 表示框架绑定本机IP, 注意不能是127.0.0.1

REBUILD: 是否重建数据库,通常为false, 如果中间装出错, 希望重置数据库, 可以设置为true

SLAVE: 是否是从节点, 可以部署多台机器, 通常一主一从即可.

映射目录到宿主机
- -v/data/tars:/data/tars, include: tars应用日志, web日志, 发布包目录

**如果希望多节点部署, 则在不同机器上执行docker run ...即可, 注意参数设置!**

**这里必须使用 --net=host, 表示docker和宿主机在相同网络** 

详细说明可以参见: [here](https://github.com/TarsCloud/Tars/blob/master/Install.zh.md)

安装完毕后, 访问 `http://${your_machine_ip}:3000` 打开web管理平台

## 4 扩展tarsnode

Tars框架安装好以后, 可以在其他节点机部署tarsnode, 这样业务服务就可以通过管理平台部署到这些节点机上了.

扩展节点机也有几种方式:
- web在线安装
- 节点机脚本安装
- docker化安装

### 4.1 web在线安装

web(>=1.4.1)提供了在线安装tarsnode的功能, 安装时需要输入节点机的ip, 密码等信息, 完成自动tarsnode的安装(需要自己增加crontab监控tarsnode)

注意:
- tarsnode.tgz安装包是在部署时, copy到web/files目录下的
- 如果不存在, 需要自己生成tarsnode.tgz, 如下操作
>- 编译framework, make install
>- 进入/usr/local/tars/cpp/framework/servers
>- tar czf tarsnode.tgz tarsnode
>- 将tarsnode.tgz copy 到web/files目录下
>- 节点机需要支持wget命令

### 4.2 节点机脚本安装

节点机上也可以自动去安装tarsnode, 前提是节点机能正常访问web, 且web支持online安装

在节点上运行:
```
wget http://webhost/get_tarsnode
chmod a+x get_tarsnode
./get_tarsnode
```

即完成tarsnode的安装

### 4.3 docker化安装

如果希望业务服务运行在一个dockerp里面, 可以采用该方式, docker制作参见tarsnode, 也可以直接拉取使用:

```sh
docker pull tarscloud/tarsnode
```

```sh
docker run -d --net=host -eINET=eth0 -eWEB_HOST=xxxxx \
        -v/data/tars:/data/tars \
        -v/etc/localtime:/etc/localtime \
        tarscloud/tarsnode
```

这种方式通常使用在k8s的部署中才使用, 此时不需要--net=host, docker被k8s管理.

### 4.4 注意事项

tars和tarsnode的镜像和老版本相比, 去掉了ip变化后的更新db的逻辑, 建议stateful headless模式部署, 节点机都用域名来管理.

## 感谢
自动编译的脚本参考了下面同学工作, 感谢!

Thanks for [tattoo](https://github.com/TarsDocker), [panjen](https://github.com/panjen/docker-tars), [luocheng812](https://github.com/luocheng812/docker_tars).
