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
docker run --rm --privileged docker/binfmt:820fdd95a9972a5308930a2bdfb8573dd4447ad3 && cat /proc/sys/fs/binfmt_misc/qemu-aarch64  

# 编译多平台镜像
docker buildx build -t tarscloud/tars-env-test:latest --platform=linux/amd64,linux/arm64 -f basedocker/full/arm64.Dockerfile basedocker/full 

```