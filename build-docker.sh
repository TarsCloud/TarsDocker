
if [ $# -lt 2 ]; then
    echo "$0 COMMAND(base/framework/tars/tars-node/php/java/nodejs/cpp/go) TAG"
    exit 0
fi

COMMAND=$1
TAG=$2

case $1 in
    "base")
#        docker rmi -f tarscloud/tars-env-full:$TAG
        docker build -t tarscloud/tars-env-full:$TAG basedocker/full
        ;;
    "tars")
#        docker rmi -f tarscloud/tars:$TAG
        docker build -t tarscloud/tars:$TAG tars
        ;;
    "framework")
        docker rmi -f tarscloud/framework:$TAG
        docker build -t tarscloud/framework:$TAG framework
        ;;
    "tars-node")
        docker rmi -f tarscloud/tars-node:$TAG
        docker build -t tarscloud/tars-node:$TAG tarsnode/full
        ;;
    "php")
        docker rmi -f tarscloud/tars-node-php:$TAG
        docker build -t tarscloud/tars-node-php:$TAG tarsnode/php
        ;;
    "java")
        docker rmi -f tarscloud/tars-node-java:$TAG
        docker build -t tarscloud/tars-node-java:$TAG tarsnode/java
        ;;
    "nodejs")
        docker rmi -f tarscloud/tars-node-nodejs:$TAG
        docker build -t tarscloud/tars-node-nodejs:$TAG tarsnode/nodejs
        ;;
    "go")
        docker rmi -f tarscloud/tars-node-go:$TAG
        docker build -t tarscloud/tars-node-go:$TAG tarsnode/cpp
        ;;
    "cpp")
        docker rmi -f tarscloud/tars-node-cpp:$TAG
        docker build -t tarscloud/tars-node-cpp:$TAG tarsnode/cpp
        ;;
   *)
        echo "[$0 COMMAND TAG]: COMMAND: base/tars/framework/tars-node/php/java/nodejs/cpp/go"
esac
