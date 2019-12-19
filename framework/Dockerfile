# pull source and build docker auto in docker hub
FROM centos/systemd

WORKDIR /root/

COPY centos7_base.repo MariaDB.repo epel-7.repo /etc/yum.repos.d/

RUN yum makecache fast; yum install -y yum-utils psmisc MariaDB-client net-tools wget unzip telnet mysql-devel git gcc gcc-c++ cmake make glibc-devel flex bison ncurses-devel protobuf-devel zlib-devel openssl-devel

RUN	cd /root/ && git clone https://github.com/TarsCloud/Tars \
	&& cd /root/Tars/ && git submodule update --init --recursive framework \
	&& git submodule update --init --recursive web

# COPY tar-server.sh /usr/local/tars/cpp/deploy/framework/servers/
COPY make-docker.sh /root/
RUN /root/make-docker.sh
	
ENTRYPOINT [ "/usr/local/tars/cpp/deploy/docker-init.sh" ]

EXPOSE 3000
EXPOSE 3001
