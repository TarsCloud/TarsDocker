FROM ubuntu:20.04

WORKDIR /root/
ENV DEBIAN_FRONTEND=noninteractive
RUN apt update && apt install -y openjdk-11-jdk wget && apt-get clean

# copy source
COPY entrypoint.sh /sbin/

RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
