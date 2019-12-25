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

MachineIp=$(ip addr | grep inet | grep ${INET} | awk '{print $2;}' | sed 's|/.*$||')

# echo "runuser: ${runuser}, ip:${ip}, port:${port}, machine_ip:${machine_ip}, registryAddress:${registryAddress}"
cd /root

while [ 1 ]
	rm -rf tarsnode

	wget http://${webHost}/tarsnode?ip=${MachineIp}&runuser=root

	if [ -f tarsnode-install.sh ]; then
		chmod a+x tarsnode
		./tarsnode
	fi 

	sleep 3
fi
