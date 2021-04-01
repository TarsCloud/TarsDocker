FROM ubuntu:20.04
#FROM centos/systemd

WORKDIR /root/

ENV GOPATH=/usr/local/go
ENV JAVA_HOME /usr/java/jdk-10.0.2
ENV DEBIAN_FRONTEND=noninteractive
# Install
RUN apt update 

RUN apt install -y mysql-client git build-essential unzip make golang cmake \
    && apt install -y libprotobuf-dev libprotobuf-c-dev zlib1g-dev libssl-dev \
    && apt install -y curl wget net-tools iproute2

#intall php tars
RUN apt install -y php php-dev php-cli php-gd php-curl php-mysql \
    php-zip php-fileinfo php-redis php-mbstring tzdata git make wget \
    build-essential libmcrypt-dev php-pear

RUN mkdir -p /tmp/pear/cache \
    && pecl channel-update pecl.php.net \
    && pecl install swoole \
    && echo 'extension=swoole.so' >> /etc/php/7.4/cli/conf.d/swoole.ini \
    && pecl install mcrypt \
    && echo 'extension=mcrypt.so' >> /etc/php/7.4/cli/conf.d/mcrypt.ini
    
RUN cd /root/ \
    && git clone git://github.com/TarsCloud/Tars \
    && cd /root/Tars/ \
    && git submodule update --init --recursive php  

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
RUN apt install nodejs npm && npm install -g pm2

# RUN wget https://github.com/nvm-sh/nvm/archive/v0.35.1.zip \
#     && unzip v0.35.1.zip \
#     && cp -rf nvm-0.35.1 /root/.nvm \
#     # && echo 'NVM_DIR="/root/.nvm";' >> /root/.zshrc; \
#     && echo ". /root/.nvm/nvm.sh" >> /root/.zshrc \
#     && echo ". /root/.nvm/bash_completion" >> /root/.zshrc 

# # RUN rm /bin/sh && ln -s /bin/bash /bin/sh
# RUN export NVM_DIR=/root/.nvm && . /root/.nvm/nvm.sh \
#     && nvm install v12.13 \
#     && npm install -g npm pm2 

# Get and install JDK
RUN apt install -y openjdk-11-jdk
