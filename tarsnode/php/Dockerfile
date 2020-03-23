FROM centos/systemd

WORKDIR /root/

ENV WEB_HOST=http://127.0.0.1:3000
ENV INET=eth0

#RUN rpm -ivh https://repo.mysql.com/mysql57-community-release-el7.rpm

#RUN mv /etc/yum.repos.d/CentOS-Base.repo /etc/yum.repos.d/CentOS-Base.repo.backup \
#    && curl -o /etc/yum.repos.d/CentOS-Base.repo http://mirrors.aliyun.com/repo/Centos-7.repo \
#    &&  yum makecache

# Install
RUN yum -y install https://repo.mysql.com/yum/mysql-8.0-community/el/7/x86_64/mysql80-community-release-el7-1.noarch.rpm \
	RUN	yum install -y epel-release \
	&& yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
	#	&& yum -y install yum-utils \
	&& yum-config-manager --enable remi-php72 \
	#	&& yum -y install yum-utils psmisc net-tools wget unzip telnet zlib-devel openssl-devel git gcc gcc-c++ \
	#	&& yum -y install golang make cmake iproute which glibc-devel ncurses-devel \
	#	&& yum -y install protobuf-devel kde-l10n-Chinese glibc-common \
	&& yum -y install php-cli php-devel php-mcrypt php-cli php-gd php-curl php-mysql php-zip php-fileinfo php-seld-phar-utils php-redis php-mbstring tzdata git make \
	#install mysql lib
	#	&& mkdir -p /usr/local/mysql && ln -s /usr/lib64/mysql /usr/local/mysql/lib && ln -s /usr/include/mysql /usr/local/mysql/include && echo "/usr/local/mysql/lib/" >> /etc/ld.so.conf && ldconfig \
	# && cd /usr/local/mysql/lib/ && rm -f libmysqlclient.a && ls -l /usr/local/mysql/lib/ && ln -s libmysqlclient.so.*.*.* libmysqlclient.a \
	# Get latest tars src


	&& cd /root/ && git clone https://gitee.com/TarsCloud/Tars.git \
	&& cd /root/Tars/ \
	&& git submodule update --init --recursive php \
	#intall php
	&& cd /root \
	&& cd /root/Tars/php/tars-extension/ && phpize --clean && phpize \
	&& ./configure --enable-phptars  && make && make install \
	&& echo "extension=phptars.so" > /etc/php.d/phptars.ini \
	# Install PHP swoole module
	&& yum install centos-release-scl -y \
	&& yum install devtoolset-7 -y \
	&& cd /root && git clone https://gitee.com/swoole/swoole \
	&& cd /root/swoole && git checkout v4.4.15 \
	&& scl enable devtoolset-7 bash \
	&& source scl_source enable devtoolset-7 \
	&& cd /root/swoole \
	&& phpize && ./configure  --with-php-config=/usr/bin/php-config \
	&& make \
	&& make install \
	&& echo "extension=swoole.so" > /etc/php.d/swoole.ini \
	&& cd /root && rm -rf v4.4.15.tar.gz swoole-src-4.4.15 \
	&& mkdir -p /root/phptars && cp -f /root/Tars/php/tars2php/src/tars2php.php /root/phptars \
	#    && yum remove gcc automake autoconf libtool make -y \
	&& yum clean all && rm -rf /var/cache/yum


RUN yum remove gcc automake autoconf libtool make php-devel php  -y
# copy source
COPY entrypoint.sh /sbin/

RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
#CMD [ "/sbin/entrypoint.sh" ]
