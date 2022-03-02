FROM docker:19.03 AS idocker
RUN mv $(command -v  docker) /tmp/docker

# pull source and build docker auto in docker hub
FROM ubuntu:20.04

WORKDIR /root/

ENV TARS_INSTALL  /usr/local/tars/cpp/deploy

ARG FRAMEWORK_TAG=master
ARG WEB_TAG=master

# Install
RUN apt update 
ENV DEBIAN_FRONTEND=noninteractive 
RUN apt install -y mysql-client git build-essential unzip make golang flex bison net-tools wget cmake psmisc python3
RUN apt install -y libprotobuf-dev libprotobuf-c-dev 
RUN apt install -y zlib1g-dev curl libssl-dev
# Get and install nodejs
RUN apt install -y npm \
	&& npm install -g npm pm2 n \
	&& n install v16.13.0 

RUN apt-get clean \
	&& rm -rf /var/cache/apt

COPY --from=idocker /tmp/docker /usr/local/bin/docker

# Get and install nodejs
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install Tars framework
RUN mkdir -p /root/Tars && cd /root/Tars && git clone https://github.com/TarsCloud/TarsFramework framework --recursive && cd framework && git checkout $FRAMEWORK_TAG && git submodule update --init --recursive
RUN cd /root/Tars && git clone https://github.com/TarsCloud/TarsWeb web && cd web && git checkout $WEB_TAG 
RUN mkdir -p /data \
	&& chmod u+x /root/Tars/framework/build/build.sh \
	&& cd /root/Tars/framework/build/ \
	&& cmake .. && make -j4 && make install \
	&& cp -rf /root/Tars/web /usr/local/tars/cpp/deploy/ \
	&& rm -rf /root/Tars 

RUN	${TARS_INSTALL}/tar-server.sh

ENTRYPOINT [ "/usr/local/tars/cpp/deploy/docker-init.sh" ]


#web
EXPOSE 3000
#tarslog
EXPOSE 18993
#tarspatch
EXPOSE 18793
#tarsqueryproperty
EXPOSE 18693
#tarsconfig
EXPOSE 18193
#tarsnotify
EXPOSE 18593
#tarsproperty
EXPOSE 18493
#tarsquerystat
EXPOSE 18393
#tarsstat
EXPOSE 18293
#tarsAdminRegistry
EXPOSE 12000
#tarsnode
EXPOSE 19385
#tarsregistry
EXPOSE 17890
EXPOSE 17891