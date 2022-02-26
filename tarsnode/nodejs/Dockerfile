FROM docker:19.03 AS idocker
RUN mv $(command -v  docker) /tmp/docker

FROM ubuntu:20.04

WORKDIR /root/

ENV DEBIAN_FRONTEND=noninteractive
# Get and install nodejs
RUN apt update && apt install -y wget
RUN apt install -y npm \
    && npm install -g npm pm2 n \
    && n install v16.13.0 
COPY --from=idocker /tmp/docker /usr/local/bin/docker
RUN rm /bin/sh && ln -s /bin/bash /bin/sh

# copy source
COPY entrypoint.sh /sbin/

RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
