FROM centos:7
# FROM centos/systemd

WORKDIR /root/

# Timezone
ENV TZ=Asia/Shanghai

ENV MYSQL_IP 127.0.0.1
# ENV DBPort 3306
ENV MYSQL_ROOT_PASSWORD root
ENV MYSQL_ROOT_PASSWORD root@appinside
ENV DBTarsPass tars2015
ENV REBUILD false
ENV SLAVE false

# Network interface (if use --net=host, maybe network interface does not named eth0)
ENV INET eth0

ENV GOPATH=/usr/local/go
ENV JAVA_HOME /usr/java/jdk-10.0.2
ENV MAVEN_HOME /usr/local/apache-maven-3.5.4

COPY centos7_base.repo epel-7.repo /etc/yum.repos.d/
RUN yum makecache fast

# Install
RUN yum -y install https://repo.mysql.com/yum/mysql-8.0-community/el/7/x86_64/mysql80-community-release-el7-1.noarch.rpm \
	&& yum -y install epel-release \
	&& yum -y install yum-utils && yum-config-manager --enable remi-php72 \
	&& yum -y install git gcc gcc-c++ golang make wget cmake mysql mysql-devel unzip iproute which glibc-devel flex bison ncurses-devel protobuf-devel zlib-devel kde-l10n-Chinese glibc-common hiredis-devel rapidjson-devel boost boost-devel php php-cli php-devel php-mcrypt php-cli php-gd php-curl php-mysql php-zip php-fileinfo php-phpiredis php-seld-phar-utils tzdata
	# Set timezone
RUN	ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone 
	# Install MySQL8 C++ Connector
RUN	wget -c -t 0 https://dev.mysql.com/get/Downloads/Connector-C++/mysql-connector-c++-8.0.11-linux-el7-x86-64bit.tar.gz

RUN	tar zxf mysql-connector-c++-8.0.11-linux-el7-x86-64bit.tar.gz && cd mysql-connector-c++-8.0.11-linux-el7-x86-64bit \
	&& cp -Rf include/jdbc/* /usr/include/mysql/ && cp -Rf include/mysqlx/* /usr/include/mysql/ && cp -Rf lib64/* /usr/lib64/mysql/ \
	&& cd /root && rm -rf mysql-connector* \
	&& mkdir -p /usr/local/mysql && ln -s /usr/lib64/mysql /usr/local/mysql/lib && ln -s /usr/include/mysql /usr/local/mysql/include && echo "/usr/local/mysql/lib/" >> /etc/ld.so.conf && ldconfig \
	&& cd /usr/local/mysql/lib/ && ls	\
	&& rm -f libmysqlclient.a && ln -s libmysqlclient.so libmysqlclient.a 
	# Get latest tars src
RUN	cd /root/ && git clone https://github.com/TarsCloud/Tars \
	&& cd /root/Tars/ && git submodule update --init --recursive framework \
	&& git submodule update --init --recursive web \
	&& git submodule update --init --recursive php \
	&& git submodule update --init --recursive go \
	&& git submodule update --init --recursive java \
	&& mkdir -p /data && chmod u+x /root/Tars/framework/build/build.sh 
	# Modify for MySQL 8
RUN	sed -i '32s/rt/rt crypto ssl/' /root/Tars/framework/CMakeLists.txt 
	# Start to build
RUN	cd /root/Tars/framework/build/ && ./build.sh all \
	&& ./build.sh install \
	&& cp -rf /root/Tars/web /usr/local/tars/cpp/deploy/ \
	&& cd /tmp && curl -fsSL https://getcomposer.org/installer | php \
	&& chmod +x composer.phar && mv composer.phar /usr/local/bin/composer \
	&& cd /root/Tars/php/tars-extension/ && phpize --clean && phpize \
	&& ./configure --enable-phptars --with-php-config=/usr/bin/php-config && make && make install \
	&& echo "extension=phptars.so" > /etc/php.d/phptars.ini 
	# Install PHP swoole module
# RUN	cd /root && wget -c -t 0 https://github.com/swoole/swoole-src/archive/v2.2.0.tar.gz \
# 	&& tar zxf v2.2.0.tar.gz && cd swoole-src-2.2.0 && phpize && ./configure && make && make install \
# 	&& echo "extension=swoole.so" > /etc/php.d/swoole.ini \
# 	&& cd /root && rm -rf v2.2.0.tar.gz swoole-src-2.2.0 \
# 	&& mkdir -p /root/phptars && cp -f /root/Tars/php/tars2php/src/tars2php.php /root/phptars 
# 	# Install tars go
# RUN	go get github.com/TarsCloud/TarsGo/tars \
# 	&& cd $GOPATH/src/github.com/TarsCloud/TarsGo/tars/tools/tars2go && go build . 
	# Get and install nodejs
RUN	wget https://github.com/nvm-sh/nvm/archive/v0.35.1.zip;unzip v0.35.1.zip; cp -rf nvm-0.35.1 $HOME/.nvm \
	&& echo 'NVM_DIR="$HOME/.nvm"; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion";' >> $HOME/.bashrc \
	&& source $HOME/.bashrc; export NVM_NODEJS_ORG_MIRROR=http://mirrors.cloud.tencent.com/nodejs-release;nvm install v12.13.0 ;npm config set registry http://mirrors.cloud.tencent.com/npm/;npm install -g npm pm2;cd /usr/local/tars/cpp/deploy/web; npm install;cd /usr/local/tars/cpp/deploy/demo;npm install 

	# && wget -qO- https://raw.githubusercontent.com/creationix/nvm/v0.33.11/install.sh | bash \
	# && source ~/.bashrc && nvm install v8.11.3 \
	# && cp -Rf /root/Tars/web /usr/local/tarsweb && cd /usr/local/tarsweb/ && npm install \
	# && npm install -g pm2 @tars/deploy @tars/stream @tars/rpc @tars/logs @tars/config @tars/monitor @tars/notify @tars/utils @tars/dyeing @tars/registry \
	# Get and install JDK
# RUN	mkdir -p /root/init && cd /root/init/  \
# 	&& wget https://mirror.its.sfu.ca/mirror/CentOS-Third-Party/NSG/common/x86_64/jdk-10.0.2_linux-x64_bin.rpm \
# 	&& rpm -ivh /root/init/jdk-10.0.2_linux-x64_bin.rpm && rm -rf /root/init/jdk-10.0.2_linux-x64_bin.rpm \
# 	&& echo "export JAVA_HOME=/usr/java/jdk-10.0.2" >> /etc/profile \
# 	&& echo "CLASSPATH=\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> /etc/profile \
# 	&& echo "PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile \
# 	&& echo "export PATH JAVA_HOME CLASSPATH" >> /etc/profile \
# 	&& echo "export JAVA_HOME=/usr/java/jdk-10.0.2" >> /root/.bashrc \
# 	&& echo "CLASSPATH=\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> /root/.bashrc \
# 	&& echo "PATH=\$JAVA_HOME/bin:\$PATH" >> /root/.bashrc \
# 	&& echo "export PATH JAVA_HOME CLASSPATH" >> /root/.bashrc \
# 	&& cd /usr/local/ && wget -c -t 0 https://mirrors.tuna.tsinghua.edu.cn/apache/maven/maven-3/3.5.4/binaries/apache-maven-3.5.4-bin.tar.gz \
# 	&& tar zxvf apache-maven-3.5.4-bin.tar.gz && echo "export MAVEN_HOME=/usr/local/apache-maven-3.5.4/" >> /etc/profile 
	# Set aliyun maven mirror
	# && sed -i '/<mirrors>/a\\t<mirror>\n\t\t<id>nexus-aliyun<\/id>\n\t\t<mirrorOf>*<\/mirrorOf>\n\t\t<name>Nexus aliyun<\/name>\n\t\t<url>http:\/\/maven.aliyun.com\/nexus\/content\/groups\/public<\/url>\n\t<\/mirror>' /usr/local/apache-maven-3.5.4/conf/settings.xml \
# RUN	echo "export PATH=\$PATH:\$MAVEN_HOME/bin" >> /etc/profile \
# 	&& echo "export PATH=\$PATH:\$MAVEN_HOME/bin" >> /root/.bashrc \
# 	&& source /etc/profile && mvn -v \
# 	&& rm -rf apache-maven-3.5.4-bin.tar.gz \
# 	&& cd /root/Tars/java && source /etc/profile && mvn clean install && mvn clean install -f core/client.pom.xml \
# 	&& mvn clean install -f core/server.pom.xml \
# 	&& cd /root/init && mvn archetype:generate -DgroupId=com.tangramor -DartifactId=TestJava -DarchetypeArtifactId=maven-archetype-webapp -DinteractiveMode=false \
# 	&& cd /root/Tars/java/examples/quickstart-server/ && mvn tars:tars2java && mvn package \
# 	&& yum clean all && rm -rf /var/cache/yum

# Whether mount Tars process path to outside, default to false (support windows)
ENV MOUNT_DATA false

VOLUME ["/data"]
	
# copy source
# COPY install.sh /root/init/
COPY entrypoint.sh /sbin/

# ADD confs /root/confs

RUN chmod 755 /sbin/entrypoint.sh
ENTRYPOINT [ "/sbin/entrypoint.sh", "start" ]

#Expose ports
EXPOSE 3000
EXPOSE 3001
EXPOSE 80
