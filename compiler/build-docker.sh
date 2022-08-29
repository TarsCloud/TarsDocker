#!/bin/bash

dockerTag=$1

if [ "$dockerTag" == "" ]; then
    dockerTag="latest"
fi

export DOCKER_CLI_EXPERIMENTAL=enabled 
docker run --rm --privileged tonistiigi/binfmt:latest --install all
docker buildx create --name tars-framework-builder --use
docker buildx inspect --bootstrap --builder tars-framework-builder


docker buildx build . -t tarscloud/compiler:$dockerTag --platform=linux/amd64,linux/arm64 -f Dockerfile --push
