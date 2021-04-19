FROM ubuntu:20.04

WORKDIR /root/
ENV DEBIAN_FRONTEND=noninteractive
# Install
RUN apt update 
RUN apt install -y build-essential unzip make golang cmake curl wget libprotobuf-dev libprotobuf-c-dev  zlib1g-dev libssl-dev \
    && apt-get clean

# copy source
COPY entrypoint.sh /sbin/

RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
