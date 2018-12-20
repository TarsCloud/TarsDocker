# Tars Docker

## Introduction
Tars comes from the robot in Interstellar movie. Tars is a high-performance RPC framework based on name service and Tars protocol, also integrated administration platform, and implemented hosting-service via flexible schedule. More information please see [here](https://github.com/TarsCloud/Tars/blob/master/Introduction.en.md).

Tars docker provides docker images for tars framework, which make it deploy easily and efficiently. This repository provides 2 images: tars and tarsnode.

tars: An image to run tarsregistry, tarsAdminRegistry, tarsnode, tarsconfig, tarspatch, and tarsweb service, which can run apps including cpp, java, php, nodejs and golang, also provides the development environment for tars.

tarsnode: An image to run tarsnode for scale, supporting apps including cpp, java, php, nodejs and golang.

## Usage
### Quickstart
Please replace the ${your_machine_ip} and ${your_mysql_ip} with your machine ip and your mysql ip, and then run the following commands.
```sh
git clone https://github.com/TarsCloud/TarsDocker.git
docker pull mysql:5.6
docker pull tarsdocker/tars
docker run --name mysql -e MYSQL_ROOT_PASSWORD='root@appinside' -d -p 3306:3306 -v /data/mysql-data:/var/lib/mysql mysql:5.6
docker run -d -it --name=tars --link mysql -e MOUNT_DATA=true -e DBIP=${your_mysql_ip} -e DBPort=3306 -e DBUser=root -e DBPassword=root@appinside -p 3000:3000 -v /data:/data tars
```
Then access http://${your_machine_ip}:3000 to enjoy tars.

### Parameter explanation
MYSQL_ROOT_PASSWORD: provide mysql root password for mysql docker

DBIP: provide mysql host for tars docker

DBPort: provide mysql's port for tars docker

DBUser: provide mysql admin's username for tars docker

DBPassword: provide mysql admin's password for tars docker


### Scale up tarsnode
Please replace the ${your_machine_ip} and ${your_mysql_ip} with your machine ip and your mysql ip, and then run the following commands.
```
git clone https://github.com/TarsCloud/TarsDocker.git
docker pull mysql:5.6
docker pull tarsdocker/tarsnode
docker run --name mysql -e MYSQL_ROOT_PASSWORD='root@appinside' -d -p 3306:3306 -v /data/mysql-data:/var/lib/mysql mysql:5.6
docker run -d -it --name tarsnode --link mysql -e MOUNT_DATA=true -e DBIP=${your_mysql_ip} -e DBPort=3306 -e DBUser=root -e DBPassword=root@appinside -p 8080:8080 -v /data:/data tarsnode
```

## Appreciation
The building of this repository is based on some people's work.

Thanks for [tattoo](https://github.com/TarsDocker), [panjen](https://github.com/panjen/docker-tars), [luocheng812](https://github.com/luocheng812/docker_tars).
