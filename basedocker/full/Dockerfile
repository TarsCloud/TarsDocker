FROM centos/systemd

WORKDIR /root/

ENV GOPATH=/usr/local/go
ENV JAVA_HOME /usr/java/jdk-10.0.2

RUN rpm -ivh https://repo.mysql.com/mysql57-community-release-el7.rpm

# Install
# RUN yum -y install https://repo.mysql.com/yum/mysql-8.0-community/el/7/x86_64/mysql80-community-release-el7-1.noarch.rpm \
RUN	yum install -y mysql mysql-devel \	
    && yum -y install epel-release \
    && yum -y install http://rpms.remirepo.net/enterprise/remi-release-7.rpm \
    && yum -y install yum-utils \
    && yum-config-manager --enable remi-php72 \
    && yum -y install yum-utils psmisc net-tools wget unzip telnet zlib-devel openssl-devel git gcc gcc-c++ \
    && yum -y install golang make cmake iproute which glibc-devel ncurses-devel \
    && yum -y install protobuf-devel kde-l10n-Chinese glibc-common \
    && yum -y install php php-cli php-devel php-pear php-mcrypt php-cli php-gd php-curl php-mysql php-zip php-fileinfo php-phpiredis php-seld-phar-utils tzdata  \
    && yum -y install centos-release-scl \
    && yum -y install devtoolset-7-gcc* \
    ## enbale gcc7
    && scl enable devtoolset-7 bash \
    && source scl_source enable devtoolset-7 \
    && mkdir -p /usr/local/mysql \
    #install mysql lib
    && ln -s /usr/lib64/mysql /usr/local/mysql/lib \
    && ln -s /usr/include/mysql /usr/local/mysql/include \
    && echo "/usr/local/mysql/lib/" >> /etc/ld.so.conf \
    && ldconfig \
    # && cd /usr/local/mysql/lib/ && rm -f libmysqlclient.a && ls -l /usr/local/mysql/lib/ && ln -s libmysqlclient.so.*.*.* libmysqlclient.a \
    # Get latest tars src
    && cd /root/ \
    && git clone https://github.com/TarsCloud/Tars \
    && cd /root/Tars/ \
    && git submodule update --init --recursive php \
    #intall php tars
    && cd /tmp \
    && curl -fsSL https://getcomposer.org/installer | php \
    && chmod +x composer.phar \
    && mv composer.phar /usr/local/bin/composer \
    && cd /root/Tars/php/tars-extension/ \
    && phpize --clean \
    && phpize \
    && ./configure --enable-phptars --with-php-config=/usr/bin/php-config \
    && make \
    && make install \
    && echo "extension=phptars.so" > /etc/php.d/phptars.ini \
    && mkdir -p /root/phptars \
    && cp -f /root/Tars/php/tars2php/src/tars2php.php /root/phptars \
    # Install PHP swoole module
    && pecl install swoole \
    && echo "extension=swoole.so" > /etc/php.d/swoole.ini \
    # Install tars go
    && go get github.com/TarsCloud/TarsGo/tars \
    && cd $GOPATH/src/github.com/TarsCloud/TarsGo/tars/tools/tars2go \
    && go build . \
    # Get and install nodejs
    && wget https://github.com/nvm-sh/nvm/archive/v0.35.1.zip \
    && unzip v0.35.1.zip \
    && cp -rf nvm-0.35.1 /root/.nvm \
    # && echo 'NVM_DIR="/root/.nvm";' >> /root/.bashrc; \
    && echo ". /root/.nvm/nvm.sh" >> /root/.bashrc \
    && echo ". /root/.nvm/bash_completion" >> /root/.bashrc \
    && source /root/.bashrc \
    && nvm install v12.13.0 \
    && npm install -g npm pm2 \
    #tars nodejs 
    && source /root/.bashrc \
    && npm install -g pm2 @tars/deploy @tars/stream @tars/rpc @tars/logs @tars/config @tars/monitor @tars/notify @tars/utils @tars/dyeing @tars/registry \
    # Get and install JDK
    && mkdir -p /root/init \
    && cd /root/init/ \
    && wget https://mirror.its.sfu.ca/mirror/CentOS-Third-Party/RCG/common/x86_64/jdk-10.0.2_linux-x64_bin.rpm \
    && rpm -ivh /root/init/jdk-10.0.2_linux-x64_bin.rpm \
    && rm -rf /root/init/jdk-10.0.2_linux-x64_bin.rpm \
    && echo "export JAVA_HOME=/usr/java/jdk-10.0.2" >> /etc/profile \
    && echo "CLASSPATH=\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> /etc/profile \
    && echo "PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile \
    && echo "export PATH JAVA_HOME CLASSPATH" >> /etc/profile \
    && echo "export JAVA_HOME=/usr/java/jdk-10.0.2" >> /root/.bashrc \
    && echo "CLASSPATH=\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> /root/.bashrc \
    && echo "PATH=\$JAVA_HOME/bin:\$PATH" >> /root/.bashrc \
    && echo "export PATH JAVA_HOME CLASSPATH" >> /root/.bashrc \
    && yum clean all \
    && rm -rf /var/cache/yum


