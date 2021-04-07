#!/bin/bash

if (( $# < 3 ))
then
    echo $#
    echo "$0 frameworkTag(for example: v2.4.12) webTag(for example: v2.4.16) dockerTag push(false/true)"
    exit 1
fi

frameworkTag=$1
webTag=$2
dockerTag=$3
push=$4

if [ "$push" == "true" ]; then
	push="true"
else
	push="false"
fi

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
LOG_INFO "Building framework docker image for framework:$frameworkTag, web:$webTag dockerTag:$dockerTag"

# test docker image
cd /tmp/framework-auto-build/
rm -rf /tmp/framework-auto-build/TarsDemo
git clone https://github.com/TarsCloud/TarsDemo
cd TarsDemo

#--------------------------------------------------------------------------------------------

export DOCKER_CLI_EXPERIMENTAL=enabled 
docker buildx create --use --name tars-builder-tars
docker buildx inspect tars-builder-tars --bootstrap
docker run --rm --privileged docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64

#--------------------------------------------------------------------------------------------
docker buildx build $WORKING_DIR --file "${WORKING_DIR}/Dockerfile" --tag tarscloud/tars:$dockerTag --build-arg FRAMEWORK_TAG=$frameworkTag --build-arg WEB_TAG=$webTag --platform=linux/amd64 -o type=docker

errNo=$(echo $?)
if [ $errNo != '0' ]; then
    LOG_ERROR "Failed to build framework docker, tag: $frameworkTag"
    exit $errNo
fi

LOG_INFO "Starting amd64 framework image test."
# run TarsDemo to test framework based on local image before docker push
./autorun.sh $dockerTag latest false false
errNo=$(echo $?)
if [ $errNo != '0' ]; then
    LOG_ERROR "Framework test failed, tag: $frameworkTag"
    exit $errNo
fi


#--------------------------------------------------------------------------------------------
#docker buildx build $WORKING_DIR --file "${WORKING_DIR}/Dockerfile" --tag tarscloud/tars:$dockerTag --build-arg FRAMEWORK_TAG=$frameworkTag --build-arg WEB_TAG=$webTag --platform=linux/arm64 -o type=docker

#errNo=$(echo $?)
#if [ $errNo != '0' ]; then
#    LOG_ERROR "Failed to build framework docker, tag: $frameworkTag"
#    exit $errNo
#fi

#LOG_INFO "Starting arm64 framework image test."
# run TarsDemo to test framework based on local image before docker push
#./autorun.sh $dockerTag latest false false
#errNo=$(echo $?)
#if [ $errNo != '0' ]; then
#    LOG_ERROR "Framework test failed, tag: $frameworkTag"
#    exit $errNo
#fi

#--------------------------------------------------------------------------------------------

# push docker image

if [ "$push" == "true" ]; then
	docker buildx build $WORKING_DIR --file "${WORKING_DIR}/Dockerfile" --tag tarscloud/tars:$dockerTag --build-arg FRAMEWORK_TAG=$frameworkTag --build-arg WEB_TAG=$webTag --platform=linux/amd64,linux/arm64 --push
fi

