FROM ubuntu:20.04

ARG FRAMEWORK_TAG=master
ARG WEB_TAG=master

WORKDIR /root/

ENV GOPATH=/usr/local/go
ENV DEBIAN_FRONTEND=noninteractive
ENV SWOOLE_VERSION=v4.4.16 
# Install
RUN apt update 

RUN apt install -y mysql-client git build-essential unzip make golang cmake flex bison \
    && apt install -y libprotobuf-dev libprotobuf-c-dev zlib1g-dev libssl-dev \
    && apt install -y curl wget net-tools iproute2 \
    #intall php tars
    && apt install -y php php-dev php-cli php-gd php-curl php-mysql \
    && apt install -y php-zip php-fileinfo php-redis php-mbstring tzdata git make wget \
    && apt install -y build-essential libmcrypt-dev php-pear \
    # Get and install nodejs
    && apt install -y nodejs npm \ 
    && npm install -g npm pm2 \
    # Get and install JDK
    && apt install -y openjdk-11-jdk \
    && apt clean

RUN apt install -y python3 python3-pip maven \
    && pip3 install requests \
    && apt clean

# Clone Tars repo and init php submodule
RUN cd /root/ && git clone https://github.com/TarsCloud/Tars.git \
    && cd /root/Tars/ \
    && git submodule update --init --recursive php \
    #intall PHP Tars module
    && cd /root/Tars/php/tars-extension/ && phpize \
    && ./configure --enable-phptars && make && make install \
    && echo "extension=phptars.so" > /etc/php/7.4/cli/conf.d/10-phptars.ini \
    # Install PHP swoole module
    && cd /root && git clone https://github.com/swoole/swoole \
    && cd /root/swoole && git checkout $SWOOLE_VERSION \
    && cd /root/swoole \
    && phpize && ./configure --with-php-config=/usr/bin/php-config \
    && make \
    && make install \
    && echo "extension=swoole.so" > /etc/php/7.4/cli/conf.d/20-swoole.ini \
    # Do somethine clean
    && cd /root && rm -rf swoole \
    && mkdir -p /root/phptars && cp -f /root/Tars/php/tars2php/src/tars2php.php /root/phptars 

# Install tars go
RUN go get github.com/TarsCloud/TarsGo/tars \
    && cd $GOPATH/src/github.com/TarsCloud/TarsGo/tars/tools/tars2go \
    && go build .  \
    && mkdir -p /usr/local/go/bin \
    && chmod a+x /usr/local/go/src/github.com/TarsCloud/TarsGo/tars/tools/tars2go/tars2go \
    && ln -s /usr/local/go/src/github.com/TarsCloud/TarsGo/tars/tools/tars2go/tars2go /usr/local/go/bin/tars2go 

RUN mkdir -p /tmp/Tars && cd /tmp/Tars && git clone --branch $FRAMEWORK_TAG https://github.com/TarsCloud/TarsFramework framework --recursive 
RUN cd /tmp/Tars && git clone --branch $WEB_TAG https://github.com/TarsCloud/TarsWeb web

RUN cd /tmp/Tars/framework/build/ \
    && cmake .. && make -j4 && make install \
    && cp -rf /tmp/Tars/web /usr/local/tars/cpp/deploy/ \
    && rm -rf /tmp 

RUN /usr/local/tars/cpp/deploy/tar-server.sh

ENTRYPOINT [ "/usr/local/tars/cpp/deploy/docker-init.sh" ]

#web
EXPOSE 3000
#user system
EXPOSE 3001
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
