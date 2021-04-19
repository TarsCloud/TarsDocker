FROM ubuntu:20.04

WORKDIR /root/

ENV DEBIAN_FRONTEND=noninteractive
# Get and install nodejs
RUN apt update && apt install -y nodejs npm wget && npm install -g pm2

# copy source
COPY entrypoint.sh /sbin/

RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
