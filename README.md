[查看中文版本](README.zh.md)

# Tars Docker

## Intro

Tars [here](https://github.com/TarsCloud/Tars/blob/master/Install.md)

Directory Intro:
- framework: Docker build script of Tars Docker, Docker includes tars framework and web.

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
 
### Install Tars Framework

**If you want build docker yourself, See[here](https://github.com/TarsCloud/Tars/blob/master/Install.zh.md)**

1. Pull Images

```sh
docker pull tarscloud/framework
```

2. Start Images

```
docker run -d --net=host -e MYSQL_HOST=xxxxx -e MYSQL_ROOT_PASSWORD=xxxxx \
        -eREBUILD=false -eINET=enp3s0 -eSLAVE=false \
        -v/data/log/app_log:/usr/local/app/tars/app_log \
        -v/data/log/web_log:/usr/local/app/web/log \
        -v/data/patchs:/usr/local/app/patchs \
        -v/etc/localtime:/etc/localtime \
        tarscloud/framework
```

MYSQL_HOST: mysql ip address

MYSQL_ROOT_PASSWORD: mysql root password

INET: The name of the network interface (as you can see in ifconfig, such as eth0) indicates the native IP bound by the framework. Note that it cannot be 127.0.0.1

REBUILD: Whether to rebuild the database is usually false. If there is an error in the intermediate installation and you want to reset the database, you can set it to true

SLAVE: slave node

Map three directories to the host:

- -v/data/log/app_log:/usr/local/app/tars/app_log, tars application logs
- -v/data/log/web_log:/usr/local/app/web/log, web log
- -v/data/log/web_log/auth:/usr/local/app/web/demo/log, web auth log
- -v/data/patchs:/usr/local/app/patchs, Publish package path

**If you want to deploy multiple nodes, just execute docker run... On different machines. Pay attention to the parameter settings**

**Here, you must use --net=host to indicate that the docker and the host are on the same network**

Access `http://${your_machine_ip}:3000` open tars web

### Scale up tarsnode


After Tars framework install, you can deploy tarsnode in other machine, then you can deploy your tars server to these machines through web.

After web(>=1.3.1), you can deploy tarsnode online


## Appreciation
The building of this repository is based on some people's work.

Thanks for [tattoo](https://github.com/TarsDocker), [panjen](https://github.com/panjen/docker-tars), [luocheng812](https://github.com/luocheng812/docker_tars).
