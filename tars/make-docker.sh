
#!/bin/bash

export MYSQL_IP=127.0.0.1
export MYSQL_ROOT_PASSWORD=root
export MYSQL_ROOT_PASSWORD=root@appinside
export DBTarsPass=tars2015
export REBUILD=false
export SLAVE=false

#########################################################################################
MIRROR=http://mirrors.cloud.tencent.com

mkdir -p /usr/local/mysql; ln -s /usr/lib64/ /usr/local/mysql/lib;ln -s /usr/include/mysql  /usr/local/mysql/include; ls /usr/local/mysql/lib/libmysql*;cd /usr/local/mysql/lib/; ln -s libmysqlclient.so.18.0.0 libmysqlclient.a 
ls -l /usr/local/mysql/lib/libmysql*

# Modify for MySQL 8
sed -i '32s/rt/rt crypto ssl/' /root/Tars/framework/CMakeLists.txt \

mkdir -p /data && chmod u+x /root/Tars/framework/build/build.sh 

cd /root/Tars/framework/build/ && ./build.sh all \
	&& ./build.sh install \
	&& cp -rf /root/Tars/web /usr/local/tars/cpp/deploy/

wget https://github.com/nvm-sh/nvm/archive/v0.35.1.zip;unzip v0.35.1.zip; cp -rf nvm-0.35.1 $HOME/.nvm

echo 'NVM_DIR="$HOME/.nvm"; [ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"; [ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion";' >> $HOME/.bashrc;

source $HOME/.bashrc; export NVM_NODEJS_ORG_MIRROR=${MIRROR}/nodejs-release; \
	nvm install v12.13.0 ; \
	npm config set registry ${MIRROR}/npm/; \
	npm install -g npm pm2; \
	cd /usr/local/tars/cpp/deploy/web; npm install; \
	cd /usr/local/tars/cpp/deploy/web/demo;npm install

cp -rf /usr/local/tars/cpp/deploy/web/sql/*.sql /usr/local/tars/cpp/deploy/framework/sql/
cp -rf /usr/local/tars/cpp/deploy/web/demo/sql/*.sql /usr/local/tars/cpp/deploy/framework/sql/
 
strip /usr/local/tars/cpp/deploy/framework/servers/tars*/bin/tars*

TARS=(tarsAdminRegistry tarslog tarsconfig tarsnode  tarsnotify  tarspatch  tarsproperty  tarsqueryproperty  tarsquerystat  tarsregistry  tarsstat) 

cd /usr/local/tars/cpp/deploy/framework/servers; 

for var in ${TARS[@]} 
  do tar czf ${var}.tgz ${var} 
done

mkdir -p /usr/local/tars/cpp/deploy/web/files/

cp -rf /usr/local/tars/cpp/deploy/framework/servers/*.tgz /usr/local/tars/cpp/deploy/web/files/


#########################################################################


# Install
yum -y install epel-release 
yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm 
yum -y install yum-utils && yum-config-manager --enable remi-php72 \
yum -y install git gcc gcc-c++ golang make wget cmake mysql mysql-devel unzip iproute which glibc-devel flex bison ncurses-devel protobuf-devel zlib-devel kde-l10n-Chinese glibc-common hiredis-devel rapidjson-devel boost boost-devel php php-cli php-devel php-mcrypt php-cli php-gd php-curl php-mysql php-zip php-fileinfo php-phpiredis php-seld-phar-utils tzdata 
# Set timezone
ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone 
	# Install MySQL8 C++ Connector
tar zxf mysql-connector-c++-8.0.11-linux-el7-x86-64bit.tar.gz && cd mysql-connector-c++-8.0.11-linux-el7-x86-64bit 
cp -Rf include/jdbc/* /usr/include/mysql/ && cp -Rf include/mysqlx/* /usr/include/mysql/ && cp -Rf lib64/* /usr/lib64/mysql/ 
cd /root && rm -rf mysql-connector* 
mkdir -p /usr/local/mysql; ls -l /usr/local/mysql; ln -s /usr/lib64/ /usr/local/mysql/lib;ln -s /usr/include/mysql /usr/local/mysql/include; cd /usr/local/mysql/lib/; ln -s libmysqlclient.so.18.0.0 libmysqlclient.a 
#	&& mkdir -p /usr/local/mysql && ln -s /usr/lib64/mysql /usr/local/mysql/lib && ln -s /usr/include/mysql /usr/local/mysql/include && echo "/usr/local/mysql/lib/" >> /etc/ld.so.conf && ldconfig \
#	&& cd /usr/local/mysql/lib/ && rm -f libmysqlclient.a && ln -s libmysqlclient.so.*.*.* libmysqlclient.a \

	# Start to build
cd /tmp && curl -fsSL https://getcomposer.org/installer | php 
chmod +x composer.phar && mv composer.phar /usr/local/bin/composer 
cd /root/Tars/php/tars-extension/ && phpize --clean && phpize 
./configure --enable-phptars --with-php-config=/usr/bin/php-config && make && make install 
echo "extension=phptars.so" > /etc/php.d/phptars.ini 
	# Install PHP swoole module
cd /root && wget -c -t 0 https://github.com/swoole/swoole-src/archive/v2.2.0.tar.gz 
tar zxf v2.2.0.tar.gz && cd swoole-src-2.2.0 && phpize && ./configure && make && make install \
echo "extension=swoole.so" > /etc/php.d/swoole.ini \
cd /root && rm -rf v2.2.0.tar.gz swoole-src-2.2.0 \
mkdir -p /root/phptars && cp -f /root/Tars/php/tars2php/src/tars2php.php /root/phptars \
# Install tars go
go get github.com/TarsCloud/TarsGo/tars \
cd $GOPATH/src/github.com/TarsCloud/TarsGo/tars/tools/tars2go && go build . \
# Get and install JDK
mkdir -p /root/init && cd /root/init/ \
echo "export JAVA_HOME=/usr/java/jdk-10.0.2" >> /etc/profile \
echo "CLASSPATH=\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> /etc/profile \
echo "PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile \
echo "export PATH JAVA_HOME CLASSPATH" >> /etc/profile \
echo "export JAVA_HOME=/usr/java/jdk-10.0.2" >> /root/.bashrc \
echo "CLASSPATH=\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> /root/.bashrc \
echo "PATH=\$JAVA_HOME/bin:\$PATH" >> /root/.bashrc \
echo "export PATH JAVA_HOME CLASSPATH" >> /root/.bashrc \

cd /usr/local/ && tar zxvf apache-maven-3.5.4-bin.tar.gz && echo "export MAVEN_HOME=/usr/local/apache-maven-3.5.4/" >> /etc/profile 

# Set aliyun maven mirror
# && sed -i '/<mirrors>/a\\t<mirror>\n\t\t<id>nexus-aliyun<\/id>\n\t\t<mirrorOf>*<\/mirrorOf>\n\t\t<name>Nexus aliyun<\/name>\n\t\t<url>http:\/\/maven.aliyun.com\/nexus\/content\/groups\/public<\/url>\n\t<\/mirror>' /usr/local/apache-maven-3.5.4/conf/settings.xml \
echo "export PATH=\$PATH:\$MAVEN_HOME/bin" >> /etc/profile 
echo "export PATH=\$PATH:\$MAVEN_HOME/bin" >> /root/.bashrc 
source /etc/profile && mvn -v 
rm -rf apache-maven-3.5.4-bin.tar.gz 
cd /root/Tars/java && source /etc/profile && mvn clean install && mvn clean install -f core/client.pom.xml 
mvn clean install -f core/server.pom.xml 
cd /root/init && mvn archetype:generate -DgroupId=com.tangramor -DartifactId=TestJava -DarchetypeArtifactId=maven-archetype-webapp -DinteractiveMode=false 
cd /root/Tars/java/examples/quickstart-server/ && mvn tars:tars2java && mvn package 
yum clean all && rm -rf /var/cache/yum

rm -rf /root/Tars
