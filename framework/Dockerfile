# pull source and build docker auto in docker hub
FROM centos/systemd

WORKDIR /root/

ENV TARS_INSTALL  /usr/local/tars/cpp/deploy

RUN rpm -ivh https://repo.mysql.com/mysql57-community-release-el7.rpm

RUN yum makecache fast \
	&& yum install -y yum-utils psmisc file which net-tools wget unzip telnet git gcc gcc-c++ cmake make glibc-devel flex bison ncurses-devel protobuf-devel zlib-devel openssl-devel \
	&& yum install -y mysql mysql-devel \
	&& yum clean all && rm -rf /var/cache/yum

#RUN rpm -ivh https://repo.mysql.com/mysql80-community-release-el7.rpm
#RUN yum install -y mysql mariadb-libs mariadb-devel

#RUN rpm -ivh https://repo.mysql.com/mysql80-community-release-el7.rpm
#RUN yum install -y mysql-community-client
# RUN which mysql

RUN	mkdir -p /usr/local/mysql && ln -s /usr/lib64/mysql /usr/local/mysql/lib && ln -s /usr/include/mysql /usr/local/mysql/include && echo "/usr/local/mysql/lib/" >> /etc/ld.so.conf && ldconfig 
#	&& cd /usr/local/mysql/lib/ && rm -f libmysqlclient.a && ls -l /usr/local/mysql/lib/ && ln -s libmysqlclient.so.*.*.* libmysqlclient.a 

RUN	cd /root/ && git clone https://github.com/TarsCloud/Tars \
	&& cd /root/Tars/ && git submodule update --init --recursive framework \
	&& git submodule update --init --recursive web \
	&& mkdir -p /data && chmod u+x /root/Tars/framework/build/build.sh \
	&& cd /root/Tars/framework/build/ && ./build.sh all \
	&& ./build.sh install \
	&& cp -rf /root/Tars/web /usr/local/tars/cpp/deploy/ \
	&& rm -rf /root/Tars

RUN wget https://github.com/nvm-sh/nvm/archive/v0.35.1.zip && unzip v0.35.1.zip && cp -rf nvm-0.35.1 /root/.nvm \
	&& echo ". /root/.nvm/nvm.sh" >> /root/.bashrc \
	&& echo ". /root/.nvm/bash_completion" >> /root/.bashrc \
	&& source /root/.bashrc \
	&& nvm install v12.13.0 \
	&& npm install -g npm pm2 \
	&& source $HOME/.bashrc	\
	&& cd /usr/local/tars/cpp/deploy/web && npm install \
	&& cd /usr/local/tars/cpp/deploy/web/demo && npm install

RUN ${TARS_INSTALL}/tar-server.sh

ENTRYPOINT [ "/usr/local/tars/cpp/deploy/docker-init.sh" ]

EXPOSE 3000
EXPOSE 3001
