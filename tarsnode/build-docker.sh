#!/bin/sh
targetDir="./${1}"
tag="tarsnode:${1}"
if [ "${1}" = 'full' ]; then
    tag="tarsnode:latest"
fi
echo "Copy entrypoint.sh to ${targetDir}"
cp ./entrypoint.sh $targetDir
echo "Redirect build context to ${targetDir}"
cd $targetDir
echo "Building tarsnode docker image with tag ${tag}"
docker build . -t $tag
