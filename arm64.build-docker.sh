
if [ $# -lt 2 ]; then
    echo "$0 COMMAND(base/framework/tars/tars-node/php/java/nodejs/cpp/go) TAG"
    exit 0
fi

COMMAND=$1
TAG="arm64-$2"

case $1 in
    "base")
        docker build -t tarscloud/tars-env-full:$TAG -f basedocker/full/arm64.Dockerfile basedocker/full 
        ;;
    "tars")
        docker build -t tarscloud/tars:$TAG tars
        ;;
    "framework")
        docker rmi -f tarscloud/framework:$TAG
        docker build -t tarscloud/framework:$TAG -f framework/arm64.Dockerfile
        ;;
    "tars-node")
        docker rmi -f tarscloud/tars-node:$TAG
        docker build -t tarscloud/tars-node:$TAG -f tarsnode/full/arm64.Dockerfile
        ;;
    "php")
        docker rmi -f tarscloud/tars-node-php:$TAG
        docker build -t tarscloud/tars-node-php:$TAG -f tarsnode/php/arm64.Dockerfile
        ;;
    "java")
        docker rmi -f tarscloud/tars-node-java:$TAG
        docker build -t tarscloud/tars-node-java:$TAG -f tarsnode/java/arm64.Dockerfile
        ;;
    "nodejs")
        docker rmi -f tarscloud/tars-node-nodejs:$TAG
        docker build -t tarscloud/tars-node-nodejs:$TAG -f tarsnode/nodejs/arm64.Dockerfile
        ;;
    "go")
        docker rmi -f tarscloud/tars-node-go:$TAG
        docker build -t tarscloud/tars-node-go:$TAG -f tarsnode/cpp/arm64.Dockerfile
        ;;
    "cpp")
        docker rmi -f tarscloud/tars-node-cpp:$TAG
        docker build -t tarscloud/tars-node-cpp:$TAG -f tarsnode/cpp/arm64.Dockerfile
        ;;
   *)
        echo "[$0 COMMAND TAG]: COMMAND: base/tars/framework/tars-node/php/java/nodejs/cpp/go"
esac
