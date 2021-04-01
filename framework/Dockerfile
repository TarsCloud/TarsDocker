# pull source and build docker auto in docker hub
FROM ubuntu:20.04

WORKDIR /root/

ENV TARS_INSTALL  /usr/local/tars/cpp/deploy

ARG FRAMEWORK_TAG=master
ARG WEB_TAG=master 

#ENV DEBIAN_FRONTEND=noninteractive
# Install
RUN apt update 
RUN DEBIAN_FRONTEND=noninteractive apt install -y mysql-client git build-essential unzip make golang flex bison net-tools wget cmake
RUN apt install -y libprotobuf-dev libprotobuf-c-dev 
RUN apt install -y zlib1g-dev curl libssl-dev
RUN apt install -y nodejs npm
RUN apt-get clean


# Get and install nodejs
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

#RN wget https://nodejs.org/dist/v12.13.0/node-v12.13.0-linux-x64.tar.gz && tar xzf node-v12.13.0-linux-x64.tar.gz

#RUN wget https://github.com/nvm-sh/nvm/archive/v0.35.1.zip;unzip v0.35.1.zip; cp -rf nvm-0.35.1 $HOME/.nvm

#ENV HOME=/root
#ENV NVM_DIR=$HOME/.nvm
#ENV PATH=/root//bin:$PATH
#ENV NVM_BIN=/root/.nvm/versions/node/v12.13.0/bin

#RUN echo 'NVM_DIR="$HOME/.nvm"; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion";' >> $HOME/.bashrc
#RUN echo $NVM_DIR/nvm.sh && cat $NVM_DIR/nvm.sh && source $NVM_DIR/nvm.sh  && env
#RUN env
#RUN nvm install v12.13.0 && npm install -g npm pm2 
#RUN npm install -g npm pm2 

# Install Tars framework
RUN mkdir -p /tmp/Tars && cd /tmp/Tars && git clone --branch $FRAMEWORK_TAG https://github.com/TarsCloud/TarsFramework framework --recursive 
RUN cd /tmp/Tars && git clone https://github.com/TarsCloud/TarsWeb web && cd web && export WEB_TAG=$(git describe --tags `git rev-list --tags --max-count=1`  --abbrev=0 --always) && env && git checkout $WEB_TAG
#RUN cd /tmp/Tars && export WEB_TAG=$(git describe --tags `git rev-list --tags --max-count=1`  --abbrev=0 --always) && git clone --branch $WEB_TAG https://github.com/TarsCloud/TarsWeb web 
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
