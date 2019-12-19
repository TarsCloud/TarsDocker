# pull source and build docker auto in docker hub
FROM centos/systemd

WORKDIR /root/

ENV MYSQL_IP 127.0.0.1
ENV MYSQL_ROOT_PASSWORD root
ENV MYSQL_ROOT_PASSWORD root@appinside
ENV DBTarsPass tars2015
ENV REBUILD false
ENV SLAVE false

ENV MIRROR http://mirrors.cloud.tencent.com

COPY centos7_base.repo MariaDB.repo epel-7.repo /etc/yum.repos.d/

RUN yum makecache fast; yum install -y yum-utils psmisc MariaDB-client net-tools wget unzip telnet mysql-devel git gcc gcc-c++ cmake make glibc-devel flex bison ncurses-devel protobuf-devel zlib-devel openssl-devel

RUN	cd /root/ && git clone https://github.com/TarsCloud/Tars \
	&& cd /root/Tars/ && git submodule update --init --recursive framework \
	&& git submodule update --init --recursive web

RUN mkdir -p /usr/local/mysql; ln -s /usr/lib64/ /usr/local/mysql/lib;ln -s /usr/include/mysql  /usr/local/mysql/include; ls /usr/local/mysql/lib/libmysql*;cd /usr/local/mysql/lib/; ln -s libmysqlclient.so.18.0.0 libmysqlclient.a 
RUN ls -l /usr/local/mysql/lib/libmysql*

RUN	mkdir -p /data && chmod u+x /root/Tars/framework/build/build.sh 

RUN	cd /root/Tars/framework/build/ && ./build.sh all \
	&& ./build.sh install \
	&& cp -rf /root/Tars/web /usr/local/tars/cpp/deploy/

RUN wget https://github.com/nvm-sh/nvm/archive/v0.35.1.zip;unzip v0.35.1.zip; cp -rf nvm-0.35.1 $HOME/.nvm

RUN echo 'NVM_DIR="$HOME/.nvm"; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion";' >> $HOME/.bashrc;

RUN source $HOME/.bashrc; export NVM_NODEJS_ORG_MIRROR=${MIRROR}/nodejs-release; \
	nvm install v12.13.0 ; \
	npm config set registry ${MIRROR}/npm/; \
	npm install -g npm pm2; \
	cd /usr/local/tars/cpp/deploy/web; npm install; \
	cd /usr/local/tars/cpp/deploy/web/demo;npm install

RUN strip /usr/local/tars/cpp/deploy/framework/servers/tars*/bin/tars*
COPY tar-server.sh /usr/local/tars/cpp/deploy/framework/servers/
RUN /usr/local/tars/cpp/deploy/framework/servers/tar-server.sh 
RUN mkdir -p /usr/local/tars/cpp/deploy/web/files/;cp -rf /usr/local/tars/cpp/deploy/framework/servers/*.tgz /usr/local/tars/cpp/deploy/web/files/
RUN rm -rf /root/Tars
	
ENTRYPOINT [ "/usr/local/tars/cpp/deploy/docker-init.sh" ]

EXPOSE 3000
EXPOSE 3001
