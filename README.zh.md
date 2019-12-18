[View English](README.md)

# Tars Docker

## Intro

Tars [here](https://github.com/TarsCloud/Tars/blob/master/Install.md)

目录介绍
- framework: Tars Docker制作脚本, 制作的docker包含了框架核心服务和web管理平台, 会被dockerhub关联, 自动构建, 并提供下载
- tars: 早期的制作脚本, 针对新版本源码制作docker会有bug(等待修复中), 具体参见 [tars](tars/README.md)
- tarsnode: 早期的tarsnode脚本, 针对新版本源码制作docker会有bug(等待修复), 具体参见 [tars](tars/README.md). 新版本web(>1.3.1)可以在web管理平台在线安装的tarsnode, 不用docker也比较方便了. 

## 使用
### Docker安装

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

### Install Mysql

使用docker安装来安装mysql(目前只考虑了linux上, 时间和本机同步)

```sh
docker pull mysql:5.6
docker run --name mysql --net=host -e MYSQL_ROOT_PASSWORD='root@appinside' -d -p 3306:3306 \
        -v/etc/localtime:/etc/localtime \
        -v /data/mysql-data:/var/lib/mysql mysql:5.6
```
 
**注意:--net-host表示Docker网络和本机一样** 

### 安装Tars框架

**如果你想源码自己编译docker, 请参见 [here](https://github.com/TarsCloud/Tars/blob/master/Install.zh.md)**

1. 拉取镜像
```sh
docker pull tarscloud/framework
```

2. 启动镜像(目前只考虑了linux上, 时间和本机同步)
```sh
docker run -d --net=host -e MYSQL_HOST=xxxxx -e MYSQL_ROOT_PASSWORD=xxxxx \
        -eREBUILD=false -eINET=eth0 -eSLAVE=false \
        -v/data/log/app_log:/usr/local/app/tars/app_log \
        -v/data/log/web/web_log:/usr/local/app/web/log \
        -v/data/log/auth/web_log:/usr/local/app/web/demo/log \
        -v/data/patchs:/usr/local/app/patchs \
        -v/etc/localtime:/etc/localtime \
        tarscloud/framework
```

MYSQL_IP: mysql数据库的ip地址

MYSQL_ROOT_PASSWORD: mysql数据库的root密码

INET: 网卡的名称(ifconfig可以看到, 比如eth0), 表示框架绑定本机IP, 注意不能是127.0.0.1

REBUILD: 是否重建数据库,通常为false, 如果中间装出错, 希望重置数据库, 可以设置为true

SLAVE: 是否是从节点, 可以部署多台机器, 通常一主一从即可.

映射三个目录到宿主机
- -v/data/log/app_log:/usr/local/app/tars/app_log, tars应用日志
- -v/data/log/web_log/web:/usr/local/app/web/log, web log
- -v/data/log/web_log/auth:/usr/local/app/web/demo/log, web auth log
- -v/data/patchs:/usr/local/app/patchs 发布包路径

**如果希望多节点部署, 则在不同机器上执行docker run ...即可, 注意参数设置!**

**这里必须使用 --net=host, 表示docker和宿主机在相同网络** 

安装完毕后, 访问 `http://${your_machine_ip}:3000` 打开web管理平台

### 扩展tarsnode

Tars框架安装好以后, 可以在其他节点机部署tarsnode, 这样你的业务服务就可以通过管理平台部署到这些节点机上了.

web(>=1.3.1)后的版本, 可以在web上在线安装tarsnode


## 感谢
自动编译的脚本参考了下面同学工作, 感谢!

Thanks for [tattoo](https://github.com/TarsDocker), [panjen](https://github.com/panjen/docker-tars), [luocheng812](https://github.com/luocheng812/docker_tars).
