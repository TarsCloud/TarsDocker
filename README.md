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

**If you want build docker yourself, See[here](https://github.com/TarsCloud/Tars/blob/master/Install.md)**

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

Web provides the function of online installation of tarsnode. When installing, you need to input the IP, password and other information of the node machine to complete the installation of automatic tarsnode (you need to add crontab to monitor tarsnode)

NOTICE:
- The tarsnode.tgz installation package is copied to the web/files directory during deployment
- If not, you need to generate tarsnode.tgz yourself, as follows
>- Compile framework, make install
```
cd /usr/local/tars/cpp/framework/servers
tar czf tarsnode.tgz tarsnode
cp tarsnode.tgz yourweb/files
```

**Node machine needs to support WGet command**

### 3.2 Script installation of node machine

Tarsnode can also be installed automatically on the node machine, provided that the node can access the web normally and the web supports online installation.

Run on node machine:

```
wget http://webhost/get_tarsnode?ip=xxx&runuser=root
chmod a+x get_tarsnode
./get_tarsnode
```

NOTICE:
- ip: local node machine ip
- runuser: run tarsnode user

After install tarsnode, add monitor in crontab:
```
* * * * * /usr/local/app/tars/tarsnode/util/monitor.sh
```

### 3.3 Install as a tarsnode docker

If you want the business service to run in a docker, you can use this method:

```sh
docker pull tarscloud/tars-node
```

```sh
docker run -d --net=host -eINET=eth0 -eWEB_HOST=xxxxx \
        -v/data/tars:/data/tars \
        -v/etc/localtime:/etc/localtime \
        tarscloud/tars-node
```

This method is usually used in k8s deployment. At this time, it does not need to --net=host. Docker is managed by k8s

### 3.4 Matters needing attention

Compared with the old version, the image of tars and tarsnode removes the logic of updating dB after IP changes. It is recommended to deploy the stateful headless mode, and the node machines are managed by domain names.

## Appreciation
The building of this repository is based on some people's work.

Thanks for [tattoo](https://github.com/TarsDocker), [panjen](https://github.com/panjen/docker-tars), [luocheng812](https://github.com/luocheng812/docker_tars).
