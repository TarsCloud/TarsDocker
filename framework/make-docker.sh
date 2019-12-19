
#!/bin/bash

export MYSQL_IP=127.0.0.1
export MYSQL_ROOT_PASSWORD=root
export MYSQL_ROOT_PASSWORD=root@appinside
export DBTarsPass=tars2015
export REBUILD=false
export SLAVE=false

MIRROR=http://mirrors.cloud.tencent.com

mkdir -p /usr/local/mysql; ln -s /usr/lib64/ /usr/local/mysql/lib;ln -s /usr/include/mysql  /usr/local/mysql/include; ls /usr/local/mysql/lib/libmysql*;cd /usr/local/mysql/lib/; ln -s libmysqlclient.so.18.0.0 libmysqlclient.a 
ls -l /usr/local/mysql/lib/libmysql*

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

strip /usr/local/tars/cpp/deploy/framework/servers/tars*/bin/tars*

TARS=(tarsAdminRegistry tarslog tarsconfig tarsnode  tarsnotify  tarspatch  tarsproperty  tarsqueryproperty  tarsquerystat  tarsregistry  tarsstat) 

cd /usr/local/tars/cpp/deploy/framework/servers; 

for var in ${TARS[@]} 
  do tar czf ${var}.tgz ${var} 
done

mkdir -p /usr/local/tars/cpp/deploy/web/files/

cp -rf /usr/local/tars/cpp/deploy/framework/servers/*.tgz /usr/local/tars/cpp/deploy/web/files/
rm -rf /root/Tars
