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

### Start services
Clone project from github:
```sh
git clone https://github.com/TarsCloud/TarsDocker.git
```
Start the services:
```sh
docker-compose up
```

Then access `http://${your_machine_ip}:3000` to enjoy tars.

### Parameter explanation
MYSQL_ROOT_PASSWORD: provide mysql root password for mysql docker

DBIP: provide mysql host for tars docker

DBPort: provide mysql's port for tars docker

DBUser: provide mysql admin's username for tars docker

DBPassword: provide mysql admin's password for tars docker


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
