FROM ubuntu:20.04

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
    && apt install -y build-essential libmcrypt-dev php-pear composer\
    # Get and install nodejs
    && apt install -y nodejs npm \ 
    && npm install -g npm pm2 \
    # Get and install JDK
    && apt install -y openjdk-11-jdk maven \
    && apt clean \
    && rm -rf /var/cache/apt

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

RUN cd /root/Tars/ \
    && git submodule update --init --recursive cpp \ 
    && cd /root/Tars/cpp \
    && mkdir -p build \
    && cd build \
    && cmake .. \
    && make -j4 \
    && make install

RUN npm install -g @tars/deploy
