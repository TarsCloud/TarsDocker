FROM docker:19.03 AS idocker
RUN mv $(command -v  docker) /tmp/docker

FROM ubuntu:20.04

WORKDIR /root/
ENV DEBIAN_FRONTEND=noninteractive
# Install
RUN apt update 
RUN apt install -y build-essential unzip make golang cmake curl wget libprotobuf-dev libprotobuf-c-dev  zlib1g-dev libssl-dev \
    && apt-get clean
COPY --from=idocker /tmp/docker /usr/local/bin/docker

RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# copy source
COPY entrypoint.sh /sbin/

RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
