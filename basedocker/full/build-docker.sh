#!/bin/bash

if (( $# < 1 ))
then
    echo $#
    echo "$0 dockerTag"
    exit 1
fi

dockerTag=$1

echo "tag:$dockerTag"

export DOCKER_CLI_EXPERIMENTAL=enabled 
docker run --rm --privileged tonistiigi/binfmt:latest --install all
docker buildx create --name tars-framework-builder --use
docker buildx inspect --bootstrap --builder tars-framework-builder


docker buildx build . -t tarscloud/tars-env-full:$dockerTag --platform=linux/amd64,linux/arm64 -f Dockerfile --push
