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
docker buildx create --use --name tars-builder-$dir
docker buildx inspect tars-builder-$dir --bootstrap
docker run --rm --privileged docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64

docker buildx build $1 -t tarscloud/tars-node:$dockerTag --platform=linux/amd64,linux/arm64 -f $1/Dockerfile --push
