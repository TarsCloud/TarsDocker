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
docker buildx create --use --name tars-builder-basedocker
docker buildx inspect tars-builder-basedocker --bootstrap
docker run --rm --privileged docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64

docker buildx build . -t tarscloud/tars-env-full:$dockerTag --platform=linux/amd64,linux/arm64 -f Dockerfile --push
