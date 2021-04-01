# pull source and build docker auto in docker hub
FROM ubuntu:20.04

WORKDIR /root/

ENV TARS_INSTALL  /usr/local/tars/cpp/deploy

ARG FRAMEWORK_TAG=master
ARG WEB_TAG=master

# Install
RUN apt update 
RUN DEBIAN_FRONTEND=noninteractive apt install -y mysql-client git build-essential unzip make golang flex bison net-tools wget cmake
RUN apt install -y libprotobuf-dev libprotobuf-c-dev 
RUN apt install -y zlib1g-dev curl libssl-dev
RUN apt install -y nodejs npm
RUN apt-get clean

# Get and install nodejs
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# Install Tars framework
RUN mkdir -p /tmp/Tars && cd /tmp/Tars && git clone --branch $FRAMEWORK_TAG https://github.com/TarsCloud/TarsFramework framework --recursive 
RUN cd /tmp/Tars && git clone --branch $WEB_TAG https://github.com/TarsCloud/TarsWeb web
RUN mkdir -p /data \
	&& chmod u+x /tmp/Tars/framework/build/build.sh \
	&& cd /tmp/Tars/framework/build/ \
	&& cmake .. && make -j4 && make install \
	&& cp -rf /tmp/Tars/web /usr/local/tars/cpp/deploy/ \
	&& rm -rf /tmp 

RUN	${TARS_INSTALL}/tar-server.sh

ENTRYPOINT [ "/usr/local/tars/cpp/deploy/docker-init.sh" ]

EXPOSE 3000
EXPOSE 3001
