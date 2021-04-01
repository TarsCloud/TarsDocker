#!/bin/bash

function LOG_ERROR()
{
    if (( $# < 1 ))
    then
        echo -e "\033[33m usesage: LOG_ERROR msg \033[0m";
    fi

    local msg=$(date +%Y-%m-%d" "%H:%M:%S);

    msg="${msg} $@";

    echo -e "\033[31m $msg \033[0m";        
}

function LOG_INFO()
{
    local msg=$(date +%Y-%m-%d" "%H:%M:%S);

    for p in $@
    do
        msg=${msg}" "${p};
    done

    echo -e "\033[32m $msg \033[0m"         
}

WORKING_DIR=$(cd $(dirname "$0") && pwd)

# clone framework source code
# TarsFramework
mkdir -p /tmp/framework-auto-build
rm -rf /tmp/framework-auto-build/framework
cd /tmp/framework-auto-build
LOG_INFO "Clone TarsFramework "
git clone  https://github.com/TarsCloud/TarsFramework framework --recursive
errNo=$(echo $?)
if [ $errNo != '0' ]; then
    LOG_ERROR "Failed to clone TarsFramework master"
    exit $errNo
fi
cd framework

frameworkReleaseTag=$(git describe --tags `git rev-list --tags --max-count=1`  --abbrev=0 --always)

# TarsWeb
cd /tmp/framework-auto-build/
rm -rf /tmp/framework-auto-build/web
git clone https://github.com/TarsCloud/TarsWeb web
errNo=$(echo $?)
if [ $errNo != '0' ]; then
    LOG_ERROR "Failed to clone TarsWeb master"
    exit $errNo
fi

cd web 

webReleaseTag=$(git describe --tags `git rev-list --tags --max-count=1`  --abbrev=0 --always)

${WORKING_DIR}/build-docker.sh $frameworkReleaseTag $webReleaseTag $frameworkReleaseTag

# function LOG_ERROR()
# {
# 	if (( $# < 1 ))
# 	then
# 		echo -e "\033[33m usesage: LOG_ERROR msg \033[0m";
# 	fi
	
# 	local msg=$(date +%Y-%m-%d" "%H:%M:%S);

#     msg="${msg} $@";

# 	echo -e "\033[31m $msg \033[0m";	
# }

# function LOG_INFO()
# {
# 	local msg=$(date +%Y-%m-%d" "%H:%M:%S);
	
# 	for p in $@
# 	do
# 		msg=${msg}" "${p};
# 	done
	
# 	echo -e "\033[32m $msg \033[0m"  	
# }


# WORKING_DIR=$(cd $(dirname "$0") && pwd)
# LOG_INFO "Building framework docker image for master deploy"

# # clone framework source code
# # TarsFramework
# mkdir -p /tmp/framework-auto-build
# rm -rf /tmp/framework-auto-build/framework
# cd /tmp/framework-auto-build
# LOG_INFO "Clone TarsFramework "
# git clone  https://github.com/TarsCloud/TarsFramework framework --recursive
# errNo=$(echo $?)
# if [ $errNo != '0' ]; then
#     LOG_ERROR "Failed to clone TarsFramework master"
#     exit $errNo
# fi

# # TarsWeb
# cd /tmp/framework-auto-build/
# rm -rf /tmp/framework-auto-build/web
# git clone https://github.com/TarsCloud/TarsWeb web
# errNo=$(echo $?)
# if [ $errNo != '0' ]; then
#     LOG_ERROR "Failed to clone TarsWeb master"
#     exit $errNo
# fi

# # build docker image
# LOG_INFO "Building framework docker image tarscloud/framework:latest"
# docker build $WORKING_DIR --file "${WORKING_DIR}/Dockerfile" --tag tarscloud/framework:latest --build-arg FRAMEWORK_TAG=master --build-arg WEB_TAG=master
# errNo=$(echo $?)
# if [ $errNo != '0' ]; then
#     LOG_ERROR "Failed to build framework docker, tag: latest"
#     exit $errNo
# fi


# # test docker image
# cd /tmp/framework-auto-build/
# rm -rf /tmp/framework-auto-build/TarsDemo
# git clone https://github.com/TarsCloud/TarsDemo
# cd TarsDemo
# LOG_INFO "Starting framework image test."
# # run TarsDemo to test framework based on local image before docker push
# ./autorun.sh latest latest false false
# errNo=$(echo $?)
# if [ $errNo != '0' ]; then
#     LOG_ERROR "Framework test failed, tag: latest"
#     exit $errNo
# fi
# # push docker image
# docker push tarscloud/framework:latest
