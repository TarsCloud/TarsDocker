FROM centos:7
# FROM centos/systemd

WORKDIR /root/

# Timezone
ENV TZ=Asia/Shanghai

ENV MYSQL_IP 127.0.0.1
# ENV DBPort 3306
ENV MYSQL_ROOT_PASSWORD root
ENV MYSQL_ROOT_PASSWORD root@appinside
ENV DBTarsPass tars2015
ENV REBUILD false
ENV SLAVE false

# Network interface (if use --net=host, maybe network interface does not named eth0)
ENV INET eth0
ENV MIRROR http://mirrors.cloud.tencent.com
# ENV TARS_INSTALL /root/tars-install

COPY centos7_base.repo MariaDB.repo epel-7.repo /etc/yum.repos.d/

RUN yum makecache fast; yum install -y yum-utils psmisc MariaDB-client net-tools wget unzip telnet mysql-devel git gcc gcc-c++ cmake make glibc-devel flex bison ncurses-devel protobuf-devel zlib-devel

# # Install
# RUN yum -y install https://repo.mysql.com/yum/mysql-8.0-community/el/7/x86_64/mysql80-community-release-el7-1.noarch.rpm \
# 	&& yum -y install epel-release \
# 	&& yum -y install yum-utils && yum-config-manager --enable remi-php72 \
# 	&& yum -y install git gcc gcc-c++ golang make wget cmake mysql mysql-devel unzip iproute which glibc-devel flex bison ncurses-devel protobuf-devel zlib-devel
	# Set timezone
RUN	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone 

RUN	cd /root/ && git clone https://github.com/TarsCloud/Tars \
	&& cd /root/Tars/ && git submodule update --init --recursive framework \
	&& git submodule update --init --recursive web

RUN mkdir -p /usr/local/mysql; ln -s /usr/lib64/ /usr/local/mysql/lib;ln -s /usr/include/mysql  /usr/local/mysql/include; ls /usr/local/mysql/lib/libmysql*;cd /usr/local/mysql/lib/; ln -s libmysqlclient.so.18.0.0 libmysqlclient.a 
RUN ls -l /usr/local/mysql/lib/libmysql*

RUN yum -y install openssl-devel
	# Install MySQL8 C++ Connector
# RUN	wget -c -t 0 https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.0.11-linux-el7-x86-64bit.tar.gz

# RUN	tar zxf mysql-connector-c++-8.0.11-linux-el7-x86-64bit.tar.gz && cd mysql-connector-c++-8.0.11-linux-el7-x86-64bit \
# 	&& cp -Rf include/jdbc/* /usr/include/mysql/ && cp -Rf include/mysqlx/* /usr/include/mysql/ && cp -Rf lib64/* /usr/lib64/mysql/ \
# 	&& cd /root && rm -rf mysql-connector* \
# 	&& mkdir -p /usr/local/mysql && ln -s /usr/lib64/mysql /usr/local/mysql/lib && ln -s /usr/include/mysql /usr/local/mysql/include && echo "/usr/local/mysql/lib/" >> /etc/ld.so.conf && ldconfig \
# 	&& cd /usr/local/mysql/lib/ && ls	\
# 	&& rm -f libmysqlclient.a && ln -s libmysqlclient.so libmysqlclient.a 
	# Get latest tars src
RUN	mkdir -p /data && chmod u+x /root/Tars/framework/build/build.sh 
	# Modify for MySQL 8
RUN	sed -i '32s/rt/rt crypto ssl/' /root/Tars/framework/CMakeLists.txt 
	# Start to build
RUN	cd /root/Tars/framework/build/ && ./build.sh all \
	&& ./build.sh install \
	&& cp -rf /root/Tars/web /usr/local/tars/cpp/deploy/

# COPY web ${TARS_INSTALL}/web

#COPY nvm $HOME/.nvm

RUN wget https://github.com/nvm-sh/nvm/archive/v0.35.1.zip;unzip v0.35.1.zip; cp -rf nvm-0.35.1 $HOME/.nvm

RUN echo 'NVM_DIR="$HOME/.nvm"; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion";' >> $HOME/.bashrc;

RUN source $HOME/.bashrc; export NVM_NODEJS_ORG_MIRROR=${MIRROR}/nodejs-release; \
	nvm install v12.13.0 ; \
	npm config set registry ${MIRROR}/npm/; \
	npm install -g npm pm2; \
	cd /usr/local/tars/cpp/deploy/web; npm install; \
	cd /usr/local/tars/cpp/deploy/web/demo;npm install

# COPY framework ${TARS_INSTALL}/framework
# COPY tools ${TARS_INSTALL}/tools
# COPY docker-init.sh tars-install.sh ${TARS_INSTALL}/

# Whether mount Tars process path to outside, default to false (support windows)
# ENV MOUNT_DATA false

# VOLUME ["/data"]
	
# copy source
# COPY install.sh /root/init/
COPY entrypoint.sh /sbin/

# # ADD confs /root/confs

RUN chmod 755 /sbin/entrypoint.sh
ENTRYPOINT [ "/sbin/entrypoint.sh", "start" ]

#Expose ports
EXPOSE 3000
EXPOSE 3001
EXPOSE 80
