#!/bin/bash
frameworkRelease=$1

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
LOG_INFO "Building framework docker image for $frameworkRelease test"

# read version information from tag
releaseVersions=(${frameworkRelease//./ })
mainVersion=0
subVersion=0
for ((i=0; i<${#releaseVersions[@]}; i++))
do
    version=${releaseVersions[$i]}
    case $i in
        0)
            mainVersion=$version
            ;;
        1)
            subVersion=$version
            ;;
    esac
done

LOG_INFO "Main version detected: $mainVersion"
LOG_INFO "  Subversion detected: $subVersion"

# clone framework source code
# TarsFramework
mkdir -p /tmp/framework-auto-test
rm -rf /tmp/framework-auto-test/framework
cd /tmp/framework-auto-test
LOG_INFO "Checkout to TarsFramework release/$frameworkRelease"
git clone --branch "release/$frameworkRelease" https://github.com/TarsCloud/TarsFramework framework --recursive
errNo=$(echo $?)
if [ $errNo != '0' ]; then
    LOG_ERROR "Failed to checkout TarsFramework release $frameworkRelease"
    exit $errNo
fi

# TarsWeb
cd /tmp/framework-auto-test/
rm -rf /tmp/framework-auto-test/web
git clone --branch "release/$mainVersion.$subVersion" https://github.com/TarsCloud/TarsWeb web
errNo=$(echo $?)
if [ $errNo != '0' ]; then
    LOG_ERROR "Failed to checkout TarsWeb release/$mainVersion.$subVersion"
    exit $errNo
fi
cd /tmp/framework-auto-test/web
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
LOG_INFO "Building framework docker image tarscloud/framework:$frameworkRelease"
docker build $WORKING_DIR --file "${WORKING_DIR}/Dockerfile" --tag tarscloud/framework:$frameworkRelease --build-arg FRAMEWORK_TAG="release/$frameworkRelease" --build-arg WEB_TAG=$webLatestTag
errNo=$(echo $?)
if [ $errNo != '0' ]; then
    LOG_ERROR "Failed to build framework docker, tag: $frameworkLatestTag"
    exit $errNo
fi

# test docker image
cd /tmp/framework-auto-test/
rm -rf /tmp/framework-auto-test/TarsDemo
git clone https://github.com/TarsCloud/TarsDemo
cd TarsDemo
LOG_INFO "Starting framework image test."
# run TarsDemo to test framework based on local image
./autorun.sh $frameworkRelease latest false false
errNo=$(echo $?)
if [ $errNo != '0' ]; then
    LOG_ERROR "Framework test failed, tag: $frameworkLatestTag"
    exit $errNo
fi