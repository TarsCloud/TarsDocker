# docker build . -f base-compiler.Dockerfile -t tarscloud/base-compiler:master --build-arg BRANCH=master

FROM golang:1.17-bullseye AS igolang

FROM php:7.4.26-apache-bullseye AS iphp

# image debian:bullseye had "ls bug", we use busybox ls instead
RUN rm -rf /bin/ls

RUN apt update                                                                         \
    && apt install git libssl-dev zlib1g-dev busybox  libzip-dev  -y                   \
    && busybox --install

RUN yes ''| pecl install igbinary zstd redis swoole                                    \
    && echo "extension=igbinary.so" > /usr/local/etc/php/conf.d/igbinary.ini           \
    && echo "extension=zstd.so" > /usr/local/etc/php/conf.d/zstd.ini                   \
    && echo "extension=redis.so" > /usr/local/etc/php/conf.d/redis.ini                 \
    && echo "extension=swoole.so" > /usr/local/etc/php/conf.d/swoole.ini

RUN docker-php-ext-configure zip && docker-php-ext-install zip

RUN cd /root                                                                           \
    && git clone https://github.com/TarsPHP/tars-extension.git                         \
    && cd /root/tars-extension                                                         \
    && phpize                                                                          \
    && ./configure --enable-phptars                                                    \
    && make                                                                            \
    && make install                                                                    \
    && echo "extension=phptars.so" > /usr/local/etc/php/conf.d/phptars.ini

FROM openjdk:8-bullseye AS ijava

FROM node:lts-bullseye AS inode

FROM docker:19.03 AS idocker
RUN mv $(command -v  docker) /tmp/docker

FROM devth/helm:v3.7.1 AS ihelm
RUN mv $(command -v  helm) /tmp/helm

FROM bitnami/kubectl:1.20 AS ikubectl
RUN cp -rf $(command -v  kubectl) /tmp/kubectl

FROM php:7.4.26-apache-bullseye
ENV DEBIAN_FRONTEND=noninteractive

COPY --from=igolang /usr/local /usr/local
COPY --from=igolang /go /go
COPY --from=iphp /usr/local /usr/local
COPY --from=ijava /usr/local /usr/local
COPY --from=inode /usr/local /usr/local
COPY --from=idocker /tmp/docker /usr/local/bin/docker
COPY --from=ihelm /tmp/helm /usr/local/bin/helm
COPY --from=ikubectl /tmp/kubectl /usr/local/bin/kubectl

ENV PATH=/usr/local/openjdk-8/bin:/usr/local/go/bin:/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin
ENV GOPATH=/go

ARG BRANCH

# image debian:bullseye had "ls bug", we use busybox ls instead

RUN rm -rf /bin/ls

RUN apt update                                                                         \
    && apt install -y git cmake make maven gdb bison flex                              \
    ca-certificates openssl telnet curl wget default-mysql-client                      \
    iputils-ping vim tcpdump net-tools binutils procps tree python python3             \
    libssl-dev zlib1g-dev libzip-dev  tzdata localepurge                               \
    busybox && busybox --install

RUN locale-gen en_US.utf8
ENV LANG en_US.utf8

RUN go get github.com/TarsCloud/TarsGo/tars \
    && go install github.com/TarsCloud/TarsGo/tars/tools/tars2go@latest               \
    && go install github.com/TarsCloud/TarsGo/tars/tools/tarsgo@latest

RUN go env -w GO111MODULE=on

RUN cd /root                                                                           \
    && git clone https://github.com/TarsCloud/TarsCpp.git --recursive                  \
    && cd /root/TarsCpp                                                                \
    && git checkout $BRANCH && git submodule update --remote --recursive               \
    && mkdir -p build                                                                  \
    && cd build                                                                        \
    && cmake ..                                                                        \
    && make -j4                                                                        \
    && make install                                                                    \
    && cd /                                                                            \
    && rm -rf /root/TarsCpp

RUN apt purge -y                                                                       \
    && apt clean all                                                                   \
    && rm -rf /var/lib/apt/lists/*                                                     \
    && rm -rf /var/cache/*.dat-old                                                     \
    && rm -rf /var/log/*.log /var/log/*/*.log

RUN curl -sS https://getcomposer.org/installer | php \
    && mv composer.phar /usr/local/bin/composer \
    && chmod +x /usr/local/bin/composer

RUN npm install -g @tars/deploy

RUN echo "#!/bin/bash" > /bin/start.sh && echo "while true; do sleep 10; done" >> /bin/start.sh && chmod a+x /bin/start.sh

CMD ["/bin/start.sh"]
