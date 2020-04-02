
if [ $# -lt 2 ]; then
    echo "$0 COMMAND(base/tars/framework/tars-node/php) TAG"
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
        docker build -t tarscloud/tars-node:$TAG tars-node
        ;;
    "php")
        docker rmi -f tars-node/tars-node/tars-node-php:$TAG
        docker build -t tarscloud/tars-node/tars-node-php:$TAG tars-node/php
        ;;
   *)
        echo "[$0 COMMAND TAG]: COMMAND: base/tars/framework/tars-node/php"
esac
