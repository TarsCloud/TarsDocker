FROM centos/systemd

WORKDIR /root/

ENV WEBHOST=http://127.0.0.1
ENV INET=eth0
ENV GOPATH=/usr/local/go
ENV JAVA_HOME /usr/java/jdk-10.0.2
# ENV MAVEN_HOME /usr/local/apache-maven-3.5.4

RUN rpm -ivh https://repo.mysql.com/mysql57-community-release-el7.rpm

# Install
# RUN yum -y install https://repo.mysql.com/yum/mysql-8.0-community/el/7/x86_64/mysql80-community-release-el7-1.noarch.rpm \
RUN	yum install -y mysql mysql-devel \	
	&& yum -y install epel-release \
	&& yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
	&& yum -y install yum-utils && yum-config-manager --enable remi-php72 \
	&& yum -y install yum-utils psmisc net-tools wget unzip telnet zlib-devel openssl-devel git gcc gcc-c++ \
	&& yum -y install golang make cmake iproute which glibc-devel ncurses-devel \
	&& yum -y install protobuf-devel kde-l10n-Chinese glibc-common \
	&& yum -y install php php-cli php-devel php-mcrypt php-cli php-gd php-curl php-mysql php-zip php-fileinfo php-phpiredis php-seld-phar-utils tzdata  \
	#install mysql lib
	&& mkdir -p /usr/local/mysql && ln -s /usr/lib64/mysql /usr/local/mysql/lib && ln -s /usr/include/mysql /usr/local/mysql/include && echo "/usr/local/mysql/lib/" >> /etc/ld.so.conf && ldconfig \
	# && cd /usr/local/mysql/lib/ && rm -f libmysqlclient.a && ls -l /usr/local/mysql/lib/ && ln -s libmysqlclient.so.*.*.* libmysqlclient.a \
	# Get latest tars src
	&& cd /root/ && git clone https://github.com/TarsCloud/Tars \
	&& cd /root/Tars/ \
	&& git submodule update --init --recursive php \
	#intall php
	&& cd /tmp && curl -fsSL https://getcomposer.org/installer | php \
	&& chmod +x composer.phar && mv composer.phar /usr/local/bin/composer \
	&& cd /root/Tars/php/tars-extension/ && phpize --clean && phpize \
	&& ./configure --enable-phptars --with-php-config=/usr/bin/php-config && make && make install \
	&& echo "extension=phptars.so" > /etc/php.d/phptars.ini \
	# Install PHP swoole module
	&& cd /root && wget -c -t 0 https://github.com/swoole/swoole-src/archive/v2.2.0.tar.gz \
	&& tar zxf v2.2.0.tar.gz && cd swoole-src-2.2.0 && phpize && ./configure && make && make install \
	&& echo "extension=swoole.so" > /etc/php.d/swoole.ini \
	&& cd /root && rm -rf v2.2.0.tar.gz swoole-src-2.2.0 \
	&& mkdir -p /root/phptars && cp -f /root/Tars/php/tars2php/src/tars2php.php /root/phptars \
	# Install tars go
	&& go get github.com/TarsCloud/TarsGo/tars \
	&& cd $GOPATH/src/github.com/TarsCloud/TarsGo/tars/tools/tars2go && go build . \
	# Get and install nodejs
	&& wget https://github.com/nvm-sh/nvm/archive/v0.35.1.zip && unzip v0.35.1.zip && cp -rf nvm-0.35.1 /root/.nvm \
	# && echo 'NVM_DIR="/root/.nvm";' >> /root/.bashrc; \
	&& echo ". /root/.nvm/nvm.sh" >> /root/.bashrc \
	&& echo ". /root/.nvm/bash_completion" >> /root/.bashrc \
	&& source /root/.bashrc \
	&& nvm install v12.13.0 \
	&& npm install -g npm pm2 \
	#tars nodejs 
	&& source /root/.bashrc && npm install -g pm2 @tars/deploy @tars/stream @tars/rpc @tars/logs @tars/config @tars/monitor @tars/notify @tars/utils @tars/dyeing @tars/registry \
	# Get and install JDK
	&& mkdir -p /root/init && cd /root/init/ \
	&& wget https://mirror.its.sfu.ca/mirror/CentOS-Third-Party/RCG/common/x86_64/jdk-10.0.2_linux-x64_bin.rpm \
	&& rpm -ivh /root/init/jdk-10.0.2_linux-x64_bin.rpm && rm -rf /root/init/jdk-10.0.2_linux-x64_bin.rpm \
	&& echo "export JAVA_HOME=/usr/java/jdk-10.0.2" >> /etc/profile \
	&& echo "CLASSPATH=\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> /etc/profile \
	&& echo "PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile \
	&& echo "export PATH JAVA_HOME CLASSPATH" >> /etc/profile \
	&& echo "export JAVA_HOME=/usr/java/jdk-10.0.2" >> /root/.bashrc \
	&& echo "CLASSPATH=\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> /root/.bashrc \
	&& echo "PATH=\$JAVA_HOME/bin:\$PATH" >> /root/.bashrc \
	&& echo "export PATH JAVA_HOME CLASSPATH" >> /root/.bashrc \
	&& yum clean all && rm -rf /var/cache/yum

# Whether mount Tars process path to outside, default to false (support windows)
# ENV MOUNT_DATA false

# Network interface (if use --net=host, maybe network interface does not named eth0)
# ENV INET_NAME eth0

# VOLUME ["/data"]

# copy source
# COPY install.sh /root/init/
COPY entrypoint.sh /sbin/

# ADD confs /root/confs

RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]

