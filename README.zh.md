[View English](README.md)

Tars整体介绍文档请阅读: https://tarscloud.gitbook.io/

docker部署请参考[docker](https://tarscloud.github.io/TarsDocs/installation/docker.html)

# 使用 buildx 编译多平台docker

linxu内核请升级到4.0以上

```
export DOCKER_CLI_EXPERIMENTAL=enabled

docker buildx create --use --name tars-builder 

docker buildx inspect tars-builder --bootstrap 

docker buildx ls

# linux需要这步, mac不需要
docker run --rm --privileged docker/binfmt:a7996909642ee92942dcd6cff44b9b95f08dad64 && cat /proc/sys/fs/binfmt_misc/qemu-aarch64  

# 编译多平台镜像
docker buildx build -t tarscloud/tars-env-test:latest --platform=linux/amd64,linux/arm64 -f basedocker/full/arm64.Dockerfile basedocker/full 

docker buildx imagetools inspect tarscloud/tars-env-test:latest

docker run --rm docker.io/yangchuansheng/hello-arch:latest@sha256:38e083870044cfde7f23a2eec91e307ec645282e76fd0356a29b32122b11c639

```