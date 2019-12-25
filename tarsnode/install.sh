#!/bin/bash

#/**
# * Tencent is pleased to support the open source community by making Tars available.
# *
# * Copyright (C) 2016THL A29 Limited, a Tencent company. All rights reserved.
# *
# * Licensed under the BSD 3-Clause License (the "License"); you may not use this file except 
# * in compliance with the License. You may obtain a copy of the License at
# *
# * https://opensource.org/licenses/BSD-3-Clause
# *
# * Unless required by applicable law or agreed to in writing, software distributed 
# * under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
# * CONDITIONS OF ANY KIND, either express or implied. See the License for the 
# * specific language governing permissions and limitations under the License.
# */

# MachineIp=$(ip addr | grep inet | grep ${INET_NAME} | awk '{print $2;}' | sed 's|/.*$||')

# echo "runuser: ${runuser}, ip:${ip}, port:${port}, machine_ip:${machine_ip}, registryAddress:${registryAddress}"
cd /root

rm -rf tarsnode

wget http://${WEBHOST}/tarsnode?runuser=root

if [ -f tarsnode.sh ]; then
	chmod a+x tarsnode
	./tarsnode

	echo "* * * * * /usr/local/app/tars/tarsnode/util/monitor.sh" >> /etc/crontab
fi 



# MachineIp=$(ip addr | grep inet | grep ${INET_NAME} | awk '{print $2;}' | sed 's|/.*$||')
# MachineName=$(cat /etc/hosts | grep ${MachineIp} | awk '{print $2}')

# install_node_services(){
# 	echo "base services ...."
	
# 	# mkdir -p /data/tars/tarsnode_data && ln -s /data/tars/tarsnode_data /usr/local/app/tars/tarsnode/data

# 	# modify core service config
# 	cd /usr/local/app/tars

# 	sed -i "s/dbhost.*=.*192.168.2.131/dbhost = ${DBIP}/g" `grep dbhost -rl ./*`
# 	sed -i "s/registry.tars.com/${MASTER}/g" `grep registry.tars.com -rl ./*`
# 	sed -i "s/192.168.2.131/${MachineIp}/g" `grep 192.168.2.131 -rl ./*`
# 	sed -i "s/db.tars.com/${DBIP}/g" `grep db.tars.com -rl ./*`
# 	sed -i "s/dbport.*=.*3306/dbport = ${DBPort}/g" `grep dbport -rl ./*`
# 	sed -i "s/web.tars.com/${MachineIp}/g" `grep web.tars.com -rl ./*`

# 	if [ ${MOUNT_DATA} = true ];
# 	then
# 		mkdir -p /data/tarsnode_data && ln -s /data/tarsnode_data /usr/local/app/tars/tarsnode/data
# 	fi
	
# 	chmod u+x tarsnode_install.sh
# 	./tarsnode_install.sh
	
# 	echo "* * * * * /usr/local/app/tars/tarsnode/util/monitor.sh" >> /etc/crontab
# }

# install_node_services
