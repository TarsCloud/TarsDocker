# pull source and build docker auto in docker hub
FROM centos/systemd

WORKDIR /root/

ENV TARS_INSTALL  /usr/local/tars/cpp/deploy

# RUN rpm -ivh https://repo.mysql.com/mysql57-community-release-el7.rpm

RUN yum makecache fast \
	&& yum install -y yum-utils psmisc file which net-tools wget unzip telnet git gcc gcc-c++ make glibc-devel flex bison ncurses-devel protobuf-devel zlib-devel openssl-devel \
	&& mkdir -p /root/cmake/ && cd /root/cmake \
	&& wget https://tars-thirdpart-1300910346.cos.ap-guangzhou.myqcloud.com/src/cmake-3.16.4.tar.gz  \
	&& tar xzf cmake-3.16.4.tar.gz && cd cmake-3.16.4 && ./configure  && make && make install \
	&& mkdir -p /root/Tars && cd /root/Tars && git clone https://github.com/TarsCloud/TarsFramework framework --recursive \
	&& git clone https://github.com/TarsCloud/TarsWeb web \
	&& mkdir -p /data && chmod u+x /root/Tars/framework/build/build.sh \
	&& cd /root/Tars/framework/build/ && ./build.sh all \
	&& ./build.sh install \
	&& cp -rf /root/Tars/web /usr/local/tars/cpp/deploy/ \
	&& wget https://github.com/nvm-sh/nvm/archive/v0.35.1.zip && unzip v0.35.1.zip && cp -rf nvm-0.35.1 /root/.nvm \
	&& echo ". /root/.nvm/nvm.sh" >> /root/.bashrc \
	&& echo ". /root/.nvm/bash_completion" >> /root/.bashrc \
	&& source /root/.bashrc \
	&& nvm install v12.13.0 \
	&& npm install -g npm pm2 \
	&& source $HOME/.bashrc	\
	&& rm -rf /root/Tars \
	&& yum clean all && rm -rf /var/cache/yum 

RUN ${TARS_INSTALL}/tar-server.sh

ENTRYPOINT [ "/usr/local/tars/cpp/deploy/docker-init.sh" ]

EXPOSE 3000
EXPOSE 3001
