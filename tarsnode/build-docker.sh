#!/bin/bash

if (( $# < 1 ))
then
    echo $#
    echo "$0 dir(cpp/full/java/nodejs/php)"
    exit 1
fi

dir=$1

dockerTag=$2

if [ "$dockerTag" == "" ]; then
    dockerTag=$dir
fi

if [ ! -d $dir ]; then
    echo "dir:$dir not exists."
    exit -1
fi

export DOCKER_CLI_EXPERIMENTAL=enabled 
docker run --rm --privileged tonistiigi/binfmt:latest --install all
docker buildx create --name tars-framework-builder-$dir --use
docker buildx inspect --bootstrap --builder tars-framework-builder-$dir

docker buildx build $1 -t tarscloud/tars-node:$dockerTag --platform=linux/amd64,linux/arm64 -f $1/Dockerfile --push
