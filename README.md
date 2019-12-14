# Tars Docker

## Introduction
Tars comes from the robot in Interstellar movie. Tars is a high-performance RPC framework based on name service and Tars protocol, also integrated administration platform, and implemented hosting-service via flexible schedule. More information please see [here](https://github.com/TarsCloud/Tars/blob/master/Install.md).

Tars docker provides docker images for tars framework, which make it deploy easily and efficiently. This repository provides 2 images: tars and tarsnode.

tars: An image to run tarsregistry, tarsAdminRegistry, tarsnode, tarsconfig, tarspatch, and tarsweb service, which can run apps including cpp, java, php, nodejs and golang, also provides the development environment for tars.

tarsnode: An image to run tarsnode for scale, supporting apps including cpp, java, php, nodejs and golang.

## Usage
### Docker instalation

For example, run the follow commands in Centos: 
```sh
sudo su
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce 
systemctl start docker
systemctl enable docker
```
Use command as follow to check whether docker install correctly or not.
```sh
docker version
```

### Install Mysql By Docker
```sh
docker pull mysql:5.6
docker run --name mysql -e MYSQL_ROOT_PASSWORD='root@appinside' -d -p 3306:3306 -v /data/mysql-data:/var/lib/mysql mysql:5.6
```

**NOTICE:--net=host Indicates that MySQL is bound to the machine IP **


## Install Tars By Docker

You can install Tars in two machine, one is master, anther is slave. And you can only install master.

MYSQL_HOST: mysql ip address

MYSQL_ROOT_PASSWORD: mysql root password

INET: The name of the network interface (as you can see in ifconfig, such as eth0) indicates the native IP bound by the framework. Note that it cannot be 127.0.0.1

REBUILD: Whether to rebuild the database is usually false. If there is an error in the intermediate installation and you want to reset the database, you can set it to true

SLAVE: slave node

```sh
docker pull tarsdocker/tars:2
#install master in one machine 
docker run -d --net=host -e MYSQL_HOST=xxxxx -e MYSQL_ROOT_PASSWORD=xxxxx \
        -eREBUILD=false -eINET=eth0 -eSLAVE=false \
        -v/data/log/app_log:/usr/local/app/tars/app_log \
        -v/data/log/web/web_log:/usr/local/app/web/log \
        -v/data/log/auth/web_log:/usr/local/app/web/demo/log \
        -v/data/patchs:/usr/local/app/patchs \
        tarsdocker/tars:2 sh /root/tars-install/docker-init.sh

#install slave in anther machine 
docker run -d --net=host -e MYSQL_HOST=xxxxx -e MYSQL_ROOT_PASSWORD=xxxxx \
        -eREBUILD=false -eINET=eth0 -eSLAVE=true \
        -v/data/log/app_log:/usr/local/app/tars/app_log \
        -v/data/log/web/web_log:/usr/local/app/web/log \
        -v/data/log/auth/web_log:/usr/local/app/web/demo/log \
        -v/data/patchs:/usr/local/app/patchs \
        tarsdocker/tars:2 sh /root/tars-install/docker-init.sh
```

**NOTICE:--net=host Indicates that Tars is bound to the machine IP **

access: `http://${master}:3000` to tars web.


### Scale up tarsnode
Please replace the ${registry_ip} with your tarsregistry ip, and then run the following commands.
```
docker pull tarsdocker/tarsnode
docker run -d -it --name tarsnode -e MASTER=${registry_ip} -v /data:/data tarsdocker/tarsnode
```
**NOTICE**:
You can  check ${registry_ip} using follow commands
``` sh
docker inspect --format='{{.NetworkSettings.IPAddress}}' tars
```

## Appreciation
The building of this repository is based on some people's work.

Thanks for [tattoo](https://github.com/TarsDocker), [panjen](https://github.com/panjen/docker-tars), [luocheng812](https://github.com/luocheng812/docker_tars).
