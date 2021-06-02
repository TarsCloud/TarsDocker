#!/bin/bash

dockerTag=$1

if [ "$dockerTag" == "" ]; then
    dockerTag="latest"
fi

export DOCKER_CLI_EXPERIMENTAL=enabled 
docker buildx create --use --name tars-builder-compiler
docker buildx inspect tars-builder-compiler --bootstrap
docker run --rm --privileged docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64

docker buildx build . -t tarscloud/compiler:$dockerTag --platform=linux/amd64,linux/arm64 -f Dockerfile --push
