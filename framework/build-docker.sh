#!/bin/bash
frameworkLatestTag=$1

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
LOG_INFO "Building framework docker image for $frameworkLatestTag deploy"

# read version information from tag
tagVersions=(${frameworkLatestTag//./ })
mainVersion=0
subVersion=0
buildNum=0
for ((i=0; i<${#tagVersions[@]}; i++))
do
    version=${tagVersions[$i]}
    if [ ${version: 0: 1} = "v" ]; then
        version=${version: 1}
    elif [ ${version: 0: 1} = "V" ]; then
        version=${version: 1}
    fi
    case $i in
        0)
            mainVersion=$version
            ;;
        1)
            subVersion=$version
            ;;
        2)
            buildNum=$version
            ;;
    esac
done

LOG_INFO "Main version detected: $mainVersion"
LOG_INFO "  Subversion detected: $subVersion"
LOG_INFO "Build number detected: $buildNum"

# clone framework source code
# TarsFramework
mkdir -p /tmp/framework-auto-build
rm -rf /tmp/framework-auto-build/framework
cd /tmp/framework-auto-build
LOG_INFO "Checkout to TarsFramework tag:$frameworkLatestTag"
git clone --branch $frameworkLatestTag https://github.com/TarsCloud/TarsFramework framework --recursive
errNo=$(echo $?)
if [ $errNo != '0' ]; then
    LOG_ERROR "Failed to checkout TarsFramework tag $frameworkLatestTag"
    exit $errNo
fi

# TarsWeb
cd /tmp/framework-auto-build/
rm -rf /tmp/framework-auto-build/web
git clone --branch "release/$mainVersion.$subVersion" https://github.com/TarsCloud/TarsWeb web
errNo=$(echo $?)
if [ $errNo != '0' ]; then
    LOG_ERROR "Failed to checkout TarsWeb release/$mainVersion.$subVersion"
    exit $errNo
fi
cd /tmp/framework-auto-build/web
# get latest tag for the detected version sequence in case release branch contains undeploied changes.
webLatestTag=$(git describe --tags `git rev-list --tags --max-count=1`  --abbrev=0 --always)
LOG_INFO "Tag $webLatestTag for TarsWeb detected"
git checkout $webLatestTag
errNo=$(echo $?)
if [ $errNo != '0' ]; then
    LOG_ERROR "Failed to checkout webLatestTag tag $webLatestTag"
    exit $errNo
fi

# build docker image
LOG_INFO "Building framework docker image tarscloud/framework:$frameworkLatestTag"
docker build $WORKING_DIR --file "${WORKING_DIR}/Dockerfile" --tag tarscloud/framework:$frameworkLatestTag --build-arg FRAMEWORK_TAG=$frameworkLatestTag --build-arg WEB_TAG=$webLatestTag

# test docker image
cd /tmp/framework-auto-build/
git clone https://github.com/TarsCloud/TarsDemo
cd TarsDemo
LOG_INFO "Starting framework image test."
# run TarsDemo to test framework based on local image before docker push
./autorun.sh $frameworkLatestTag latest false false

# push docker image
docker push tarscloud/framework:$frameworkLatestTag