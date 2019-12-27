[View English](README.md)

# 目录
> * [介绍](#chapter-1)
> * [Docker部署Tars框架](#chapter-2)
> * [扩展tarsnode](#chapter-3)

# 1 <a id="chapter-1"></a>介绍

Tars介绍请[参见](https://github.com/TarsCloud/Tars/blob/master/Install.zh.md)

在部署Tars之前, 请务必阅读Tars部署的[基本概念](https://github.com/TarsCloud/Tars/blob/master/Deploy.zh.md)

目录介绍
- framework: Tars框架Docker制作脚本, 制作的docker包含了框架核心服务和web管理平台
- tars: Tars框架Docker制作脚本, 和framework比, 增加了java, nodejs等运行时支持, 即可以把java, nodejs服务发布到docker里面(docker里面安装了jdk, node, php环境)
- tarsnode: tarsnode Docker制作脚本, 内置了java, nodejs等运行时支持, 即可以把java, nodejs服务发布到docker里面(docker里面安装了jdk, node, php环境)

# 2 <a id="chapter-2"></a>Docker部署Tars框架
## 2.1 安装Docker

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

## 2.2 安装Mysql

使用docker安装来安装mysql(目前只考虑了linux上, 时间和本机同步)

```sh
docker pull mysql:5.6
docker run --name mysql --net=host -e MYSQL_ROOT_PASSWORD='root@appinside' -d -p 3306:3306 \
        -v/etc/localtime:/etc/localtime \
        -v /data/mysql-data:/var/lib/mysql mysql:5.6
```
 
**注意:--net-host表示Docker网络和本机一样** 

## 2.3 安装Tars框架

**如果你想源码自己编译docker, 请[参见](https://github.com/TarsCloud/Tars/blob/master/Install.zh.md)**

使用docker安装Tars框架, 有两个镜像可供选择: framework & tars

**注意: 区别在于是否希望把业务服务部署在镜像内(不推荐, 不方便Tars框架升级)**

### 2.3.1 使用tarscloud/framework部署
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

### 2.3.2 使用tarscloud/tars部署
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

### 2.3.3 参数解释

MYSQL_IP: mysql数据库的ip地址

MYSQL_ROOT_PASSWORD: mysql数据库的root密码

INET: 网卡的名称(ifconfig可以看到, 比如eth0), 表示框架绑定本机IP, 注意不能是127.0.0.1

REBUILD: 是否重建数据库,通常为false, 如果中间装出错, 希望重置数据库, 可以设置为true

SLAVE: 是否是从节点, 可以部署多台机器, 通常一主一从即可.

映射目录到宿主机
- -v/data/tars:/data/tars, include: tars应用日志, web日志, 发布包目录

**如果希望多节点部署, 则在不同机器上执行docker run ...即可, 注意参数设置!**

**这里必须使用 --net=host, 表示docker和宿主机在相同网络** 

详细说明可以[参见](https://github.com/TarsCloud/Tars/blob/master/Install.zh.md)

安装完毕后, 访问 `http://${your_machine_ip}:3000` 打开web管理平台

## 3 <a id="chapter-3"></a>扩展tarsnode

Tars框架安装好以后, 可以在其他节点机部署tarsnode, 这样业务服务就可以通过管理平台部署到这些节点机上了.

扩展节点机也有几种方式:
- web在线安装
- 节点机脚本安装
- docker化安装

### 3.1 web在线安装

web(>=1.4.1)提供了在线安装tarsnode的功能, 安装时需要输入节点机的ip, 密码等信息, 完成自动tarsnode的安装(需要自己增加crontab监控tarsnode)

注意:
- tarsnode.tgz安装包是在部署时, 安装脚本自动copy到web/files目录下的
- 如果不存在, 需要自己生成tarsnode.tgz, 如下操作
>- 编译framework, make install
```
cd /usr/local/tars/cpp/framework/servers
tar czf tarsnode.tgz tarsnode
cp tarsnode.tgz yourweb/files
```

**节点机需要支持wget命令**

### 3.2 节点机脚本安装

节点机上也可以自动去安装tarsnode, 前提是节点机能正常访问web, 且web支持online安装

在节点上运行:
```
wget http://webhost/get_tarsnode?ip=xxx&runuser=root
chmod a+x get_tarsnode
./get_tarsnode
```

参数说明:
- ip: 本机ip
- runuser: 运行tarsnode的用户

即完成tarsnode的安装, 然后添加监控:

在crontab配置一个进程监控，确保TARS框架服务在出现异常后能够重新启动。
```
* * * * * /usr/local/app/tars/tarsnode/util/monitor.sh
```

### 3.3 docker化安装

如果希望业务服务运行在一个docker里面, 可以采用该方式:

```sh
docker pull tarscloud/tars-node
```

```sh
docker run -d --net=host -eINET=eth0 -eWEB_HOST=xxxxx \
        -v/data/tars:/data/tars \
        -v/etc/localtime:/etc/localtime \
        tarscloud/tars-node

#例如:
docker run -d --net=host -eINET=eth0 -eWEB_HOST=http://172.16.0.7:3000 \
        -v/data/tars:/data/tars \
        -v/etc/localtime:/etc/localtime \
        tarscloud/tars-node        
```

**注意: http://172.16.0.7:3000 是TarsWeb的访问地址**

这种方式通常使用在k8s的部署中才使用, 此时不需要--net=host, docker被k8s管理.

### 3.4 注意事项

tars和tarsnode的镜像和老版本相比, 去掉了ip变化后的更新db的逻辑, 建议stateful headless模式部署, 节点机都用域名来管理.

## 感谢
自动编译的脚本参考了下面同学工作, 感谢!

Thanks for [tattoo](https://github.com/TarsDocker), [panjen](https://github.com/panjen/docker-tars), [luocheng812](https://github.com/luocheng812/docker_tars).
