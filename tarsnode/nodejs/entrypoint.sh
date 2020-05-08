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

if [ "$DOMAIN" != "" ]; then
	MachineIp=${DOMAIN}
else
	MachineIp=$(ip addr | grep inet | grep eth0 | awk '{print $2;}' | sed 's|/.*$||')
fi

mkdir -p /usr/local/app/tars/
mkdir -p /usr/local/app/tars/tarsnode

mkdir -p /data/tars/app_log
mkdir -p /data/tars/remote_app_log
mkdir -p /data/tars/tarsnode-data

ln -s /data/tars/app_log /usr/local/app/tars/app_log 
ln -s /data/tars/remote_app_log /usr/local/app/tars/remote_app_log 
ln -s /data/tars/tarsnode-data /usr/local/app/tars/tarsnode/data

trap 'exit' SIGTERM SIGINT

while [ 1 ]
do
	rm -rf get_tarsnode.sh

	wget -O get_tarsnode.sh "${WEB_HOST}/get_tarsnode?ip=${MachineIp}&runuser=root"

	sleep 1

	if [ -f "get_tarsnode.sh" ]; then
		
		echo "get_tarsnode.sh: --------------------------------------------------------"
		cat get_tarsnode.sh

		chmod a+x get_tarsnode.sh

		./get_tarsnode.sh

		if [ -f "/usr/local/app/tars/tarsnode/util/check.sh" ]; then

			echo "tarsnode.conf: --------------------------------------------------------"

			cat /usr/local/app/tars/tarsnode/conf/tars.tarsnode.config.conf 
			echo "install tarsnode succ, check tarsnode alive"

			while [ 1 ]
			do
				sleep 3
				/usr/local/app/tars/tarsnode/util/check.sh
			done
		fi

	fi

	echo "install tarsnode failed, retry 3 seconds later..."
	sleep 3
done
