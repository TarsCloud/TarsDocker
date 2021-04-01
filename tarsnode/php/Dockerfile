FROM ubuntu:20.04

WORKDIR /root/

# -- env settings
ENV WEB_HOST=http://127.0.0.1:3000 \
	INET=eth0 \
	SWOOLE_VERSION=v4.4.16 

ENV DEBIAN_FRONTEND=noninteractive

#intall php tars
RUN apt install -y php php-dev php-cli php-gd php-curl php-mysql \
    php-zip php-fileinfo php-redis php-mbstring tzdata git make wget \
    build-essential libmcrypt-dev php-pear

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
    && make -j \
    && make install && mkdir -p /etc/php.d/\
    && echo "extension=phptars.so" > /etc/php.d/phptars.ini \
    && mkdir -p /root/phptars \
    && cp -f /root/Tars/php/tars2php/src/tars2php.php /root/phptars \
    # Install PHP swoole module
    && pecl install swoole \
    && echo "extension=swoole.so" > /etc/php.d/swoole.ini 

RUN yum install -y epel-release \
	&& yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
	&& yum-config-manager --enable remi-php72 \
	&& yum -y install $PHPIZE_DEPS \
	# Clone Tars repo and init php submodule
	&& cd /root/ && git clone https://gitee.com/TarsCloud/Tars.git \
	&& cd /root/Tars/ \
	&& git submodule update --init --recursive php \
	#intall PHP Tars module
	&& cd /root/Tars/php/tars-extension/ && phpize \
	&& ./configure --enable-phptars && make && make install \
	&& echo "extension=phptars.so" > /etc/php.d/10-phptars.ini \
	# Install PHP swoole module
	&& cd /root && git clone https://github.com/swoole/swoole \
	&& cd /root/swoole && git checkout $SWOOLE_VERSION \
	&& yum install centos-release-scl -y \
	&& yum install devtoolset-7 -y \
	&& scl enable devtoolset-7 bash \
	&& source scl_source enable devtoolset-7 \
	&& cd /root/swoole \
	&& phpize && ./configure --with-php-config=/usr/bin/php-config \
	&& make \
	&& make install \
	&& echo "extension=swoole.so" > /etc/php.d/20-swoole.ini \
	# Do somethine clean
	&& cd /root && rm -rf swoole \
	&& mkdir -p /root/phptars && cp -f /root/Tars/php/tars2php/src/tars2php.php /root/phptars \
	&& yum clean all && rm -rf /var/cache/yum

# IF YOU NOT NEED CLEAN COMMAND, YOU CAN NOTE THIS LINE.
# RUN yum remove gcc automake autoconf libtool make php-devel php  -y

# copy source
COPY entrypoint.sh /sbin/

RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
