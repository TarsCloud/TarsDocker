FROM ubuntu:20.04

WORKDIR /root/

# -- env settings
ENV SWOOLE_VERSION=v4.4.16 

ENV DEBIAN_FRONTEND=noninteractive

#intall php tars
RUN apt update && apt install -y php php-dev php-cli php-gd php-curl php-mysql \
    php-zip php-fileinfo php-redis php-mbstring tzdata git make wget \
    build-essential libmcrypt-dev php-pear

# Clone Tars repo and init php submodule
RUN cd /root/ && git clone https://gitee.com/TarsCloud/Tars.git \
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

# copy source
COPY entrypoint.sh /sbin/

RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
