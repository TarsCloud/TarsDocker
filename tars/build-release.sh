#!/bin/bash

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

./build-docker.sh $frameworkReleaseTag $webReleaseTag 
