
if [ $# -lt 1 ]; then
    echo $0 version
    exit
fi

workdir=$(cd $(dirname $0); pwd)

docker rmi -f tars-framework:$1
docker build ${workdir}/. -t tars-framework:$1

