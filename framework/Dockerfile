# pull source and build docker auto in docker hub
FROM centos/systemd

WORKDIR /root/

# COPY MariaDB.repo /etc/yum.repos.d/

RUN yum makecache fast; yum install -y yum-utils psmisc mysql-devel  net-tools wget unzip telnet mysql-devel git gcc gcc-c++ cmake make glibc-devel flex bison ncurses-devel protobuf-devel zlib-devel openssl-devel

RUN rpm -ivh https://repo.mysql.com/mysql80-community-release-el7.rpm
RUN yum install -y mysql-community-client
# RUN which mysql

RUN	mkdir -p /usr/local/mysql && ln -s /usr/lib64/mysql /usr/local/mysql/lib && ln -s /usr/include/mysql /usr/local/mysql/include && echo "/usr/local/mysql/lib/" >> /etc/ld.so.conf && ldconfig \
	&& cd /usr/local/mysql/lib/ && rm -f libmysqlclient.a && ls -l /usr/local/mysql/lib/ && ln -s libmysqlclient.so.*.*.* libmysqlclient.a 

RUN wget https://github.com/nvm-sh/nvm/archive/v0.35.1.zip && unzip v0.35.1.zip && cp -rf nvm-0.35.1 /root/.nvm \
	&& echo ". /root/.nvm/nvm.sh" >> /root/.bashrc \
	&& echo ". /root/.nvm/bash_completion" >> /root/.bashrc \
	&& source /root/.bashrc \
	&& nvm install v12.13.0 \
	&& npm install -g npm pm2 

RUN	cd /root/ && git clone https://github.com/TarsCloud/Tars \
	&& cd /root/Tars/ && git submodule update --init --recursive framework \
	&& git submodule update --init --recursive web


# COPY tar-server.sh /usr/local/tars/cpp/deploy/framework/servers/
COPY make-docker.sh /root/
RUN /root/make-docker.sh
	
ENTRYPOINT [ "/usr/local/tars/cpp/deploy/docker-init.sh" ]

EXPOSE 3000
EXPOSE 3001
