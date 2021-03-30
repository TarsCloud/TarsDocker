FROM ubuntu:20.04
#FROM centos/systemd

WORKDIR /root/

ENV GOPATH=/usr/local/go
ENV JAVA_HOME /usr/java/jdk-10.0.2
ENV DEBIAN_FRONTEND=noninteractive
# Install
# RUN apt install -y mysql-client net-tools wget unzip telnet zlib-devel openssl-devel git gcc gcc-c++ \
RUN apt update 
RUN apt install -y mysql-client git build-essential unzip make golang
RUN apt install -y libprotobuf-dev libprotobuf-c-dev 
RUN apt install -y zlib1g-dev curl libssl-dev
RUN apt install -y wget

    ## cmake
#RUN mkdir -p /root/cmake/ && cd /root/cmake \
#    && wget https://tars-thirdpart-1300910346.cos.ap-guangzhou.myqcloud.com/src/cmake-3.16.4.tar.gz  \
#    && tar xzf cmake-3.16.4.tar.gz && cd cmake-3.16.4 && ./configure  && make -j4 && make install && rm -rf /root/cmake 

RUN apt install -y cmake && cmake --version
# #intall php tars
 RUN apt install -y php php-mysql php-gd tzdata

RUN cd /root/ \
     && git clone git://github.com/TarsCloud/Tars \
     && cd /root/Tars/ \
     && git submodule update --init --recursive php  

 RUN apt install -y php-dev

 RUN cd /tmp \
     && curl -fsSL https://getcomposer.org/installer | php \
     && chmod +x composer.phar \
     && mv composer.phar /usr/local/bin/composer \
     && cd /root/Tars/php/tars-extension/ \
     && phpize --clean \
     && phpize \
     && ./configure --enable-phptars --with-php-config=/usr/bin/php-config \
     && make \
     && make install && mkdir -p /etc/php.d/\
     && echo "extension=phptars.so" > /etc/php.d/phptars.ini \
     && mkdir -p /root/phptars \
     && cp -f /root/Tars/php/tars2php/src/tars2php.php /root/phptars \
     # Install PHP swoole module
     && pecl install swoole \
     && echo "extension=swoole.so" > /etc/php.d/swoole.ini 

    # Install tars go
RUN go get github.com/TarsCloud/TarsGo/tars \
    && cd $GOPATH/src/github.com/TarsCloud/TarsGo/tars/tools/tars2go \
    && go build . 

    # Get and install nodejs
RUN wget https://github.com/nvm-sh/nvm/archive/v0.35.1.zip \
    && unzip v0.35.1.zip \
    && cp -rf nvm-0.35.1 /root/.nvm \
    # && echo 'NVM_DIR="/root/.nvm";' >> /root/.zshrc; \
    && echo ". /root/.nvm/nvm.sh" >> /root/.zshrc \
    && echo ". /root/.nvm/bash_completion" >> /root/.zshrc 

# RUN rm /bin/sh && ln -s /bin/bash /bin/sh
RUN export NVM_DIR=/root/.nvm && . /root/.nvm/nvm.sh \
    && nvm install v12.13 \
    && npm install -g npm pm2 

    # Get and install JDK
RUN apt install -y openjdk-11-jdk
