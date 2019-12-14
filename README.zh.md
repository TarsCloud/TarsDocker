# Tars Docker

## 介绍
查看Tars详细介绍, 请参考 [here](https://github.com/TarsCloud/Tars/blob/master/Install.md).

Tars docker提供了docker的images, 能够快速的部署tars环境. 提供了tars和tarsnode两个镜像.

tars: 内置了所有tars基础框架的镜像, 启动后, 则完成了基础框架的启动.

tarsnode: tarsnode的节点镜像, 每台服务器上部署一个, 用于管理本机的所有tars服务, tarsnode需要连接到tars镜像

## 使用
### Docker安装

Centos上: 
```sh
sudo su
yum install -y yum-utils device-mapper-persistent-data lvm2
yum-config-manager --add-repo https://download.docker.com/linux/centos/docker-ce.repo
yum install -y docker-ce 
systemctl start docker
systemctl enable docker
```
运行命令查看docker已经安装成功:
```sh
docker version
```

### docker安装mysql

```sh
docker pull mysql:5.6
docker run --name mysql --net=host -e MYSQL_ROOT_PASSWORD='root@appinside' -d -p 3306:3306 -v /data/mysql-data:/var/lib/mysql mysql:5.6

```

**注意:--net=host表示mysql绑定在本机IP**

## docker安装Tars框架

框架可以安装在两台机器上, 一台master, 一台slave, 也可以只安装master,  注意有几个参数需要设定:

MYSQL_IP: mysql数据库的ip地址

MYSQL_ROOT_PASSWORD: mysql数据库的root密码

INET: 网卡的名称(ifconfig可以看到, 比如eth0), 表示框架绑定本机IP, 注意不能是127.0.0.1

REBUILD: 是否重建数据库,通常为false, 如果中间装出错, 希望重置数据库, 可以设置为true

SLAVE: 是否是从节点

```sh
docker pull tarsdocker/tars:2
#选择一台机器, 安装master
docker run -d --net=host -e MYSQL_HOST=xxxxx -e MYSQL_ROOT_PASSWORD=xxxxx \
        -eREBUILD=false -eINET=eth0 -eSLAVE=false \
        -v/data/log/app_log:/usr/local/app/tars/app_log \
        -v/data/log/web/web_log:/usr/local/app/web/log \
        -v/data/log/auth/web_log:/usr/local/app/web/demo/log \
        -v/data/patchs:/usr/local/app/patchs \
        tarsdocker/tars:2 sh /root/tars-install/docker-init.sh

#另外一台机器, 安装slave        
docker run -d --net=host -e MYSQL_HOST=xxxxx -e MYSQL_ROOT_PASSWORD=xxxxx \
        -eREBUILD=false -eINET=eth0 -eSLAVE=true \
        -v/data/log/app_log:/usr/local/app/tars/app_log \
        -v/data/log/web/web_log:/usr/local/app/web/log \
        -v/data/log/auth/web_log:/usr/local/app/web/demo/log \
        -v/data/patchs:/usr/local/app/patchs \
        tarsdocker/tars:2 sh /root/tars-install/docker-init.sh
```

访问Master主机: `http://${master}:3000` 即可访问web管理平台

### 部署tarsnode
替换 ${registry_ip} 为tars镜像的ip.
```
docker pull tarsdocker/tarsnode
docker run -d -it --name tarsnode -e MASTER=${registry_ip} -v /data:/data tarsdocker/tarsnode
```
**注意**:
你可以用一下命令查看 ${registry_ip} 
``` sh
docker inspect --format='{{.NetworkSettings.IPAddress}}' tars
```

## 感谢
感谢以下同学提供了方法:

Thanks for [tattoo](https://github.com/TarsDocker), [panjen](https://github.com/panjen/docker-tars), [luocheng812](https://github.com/luocheng812/docker_tars).
