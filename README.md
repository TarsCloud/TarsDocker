[查看中文版本](README.zh.md)

# Directory
> * [Intro](#chapter-1)
> * [Docker Deploy Tars](#chapter-2)
> * [Expand tarsnode](#chapter-3)

# 1 <a id="chapter-1"></a>Intro
## Intro

Tars See [here](https://github.com/TarsCloud/Tars/blob/master/Install.md)

Before deploy Tars, Please Read [here](https://github.com/TarsCloud/Tars/blob/master/Deploy.md)

Directory Intro:
- framework: Docker build script of Tars, Docker includes tars framework and web.
- tars: Docker build script of Tars, compare to framework, add java, nodejs environment, you can deploy server implement by java/nodejs/php to docker
- tarsnode: Docker build script of tarsnode, add java, nodejs environment, you can deploy server implement by java/nodejs/php to docker

## Usage
### Docker Install

Install Docker in Centos:

```sh
sudo su
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce 
systemctl start docker
systemctl enable docker
```

see Docker version:
```sh
docker version
```

### Install Mysql

Install mysql by docker

```sh
docker pull mysql:5.6
docker run --name mysql --net=host -e MYSQL_ROOT_PASSWORD='root@appinside' -d -p 3306:3306 \
-v /data/mysql-data:/var/lib/mysql  \
-v /etc/localtime:/etc/localtime \
mysql:5.6

```
 
### 2 <a id="chapter-2"></a> Install Tars Framework

**If you want build docker yourself, See[here](https://github.com/TarsCloud/Tars/blob/master/Install.zh.md)**

1. Pull Images

```sh
docker pull tarscloud/framework
```

2. Start Images

```
docker run -d --net=host -e MYSQL_HOST=xxxxx -e MYSQL_ROOT_PASSWORD=xxxxx \
        -eREBUILD=false -eINET=enp3s0 -eSLAVE=false \
        -v/data/tars:/data/tars \
        -v/etc/localtime:/etc/localtime \
        tarscloud/framework
```

MYSQL_HOST: mysql ip address

MYSQL_ROOT_PASSWORD: mysql root password

INET: The name of the network interface (as you can see in ifconfig, such as eth0) indicates the native IP bound by the framework. Note that it cannot be 127.0.0.1

REBUILD: Whether to rebuild the database is usually false. If there is an error in the intermediate installation and you want to reset the database, you can set it to true

SLAVE: slave node

Map directory to the host:

- -v/data/tars:/data/tars, include: tars application logs, web log, Publish package path

**If you want to deploy multiple nodes, just execute docker run... On different machines. Pay attention to the parameter settings**

**Here, you must use --net=host to indicate that the docker and the host are on the same network**

Access `http://${your_machine_ip}:3000` open tars web

### 3 <a id="chapter-3"></a>Scale up tarsnode

After the tars framework is installed, tarsnode can be deployed to other nodes, so that business services can be deployed to these nodes through the management platform.

There are several ways to expand node machines:

- Web online installation
- Script installation of node machine
- Docker installation

### 3.1 Web online installation

web(>=1.4.1)提供了在线安装tarsnode的功能, 安装时需要输入节点机的ip, 密码等信息, 完成自动tarsnode的安装(需要自己增加crontab监控tarsnode)

注意:
- tarsnode.tgz安装包是在部署时, copy到web/files目录下的
- 如果不存在, 需要自己生成tarsnode.tgz, 如下操作
>- 编译framework, make install
>- 进入/usr/local/tars/cpp/framework/servers
>- tar czf tarsnode.tgz tarsnode
>- 将tarsnode.tgz copy 到web/files目录下
>- 节点机需要支持wget命令

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
docker pull tarscloud/tarsnode
```

```sh
docker run -d --net=host -eINET=eth0 -eWEB_HOST=xxxxx \
        -v/data/tars:/data/tars \
        -v/etc/localtime:/etc/localtime \
        tarscloud/tarsnode
```

这种方式通常使用在k8s的部署中才使用, 此时不需要--net=host, docker被k8s管理.

### 3.4 注意事项

tars和tarsnode的镜像和老版本相比, 去掉了ip变化后的更新db的逻辑, 建议stateful headless模式部署, 节点机都用域名来管理.


After Tars framework install, you can deploy tarsnode in other machine, then you can deploy your tars server to these machines through web.

After web(>=1.3.1), you can deploy tarsnode online


## Appreciation
The building of this repository is based on some people's work.

Thanks for [tattoo](https://github.com/TarsDocker), [panjen](https://github.com/panjen/docker-tars), [luocheng812](https://github.com/luocheng812/docker_tars).
