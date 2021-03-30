FROM ubuntu:20.04

WORKDIR /root/

# Install
RUN apt update 
RUN apt install -y build-essential unzip make golang cmake curl wget
RUN apt install -y libprotobuf-dev libprotobuf-c-dev  zlib1g-dev libssl-dev
RUN apt-get clean
#RUN apt get -y install yum-utils psmisc net-tools wget unzip telnet zlib-devel openssl-devel gdb gcc gcc-c++ \
    # && apt get -y install make iproute which glibc-devel 

# copy source
COPY entrypoint.sh /sbin/

RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
