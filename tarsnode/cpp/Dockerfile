FROM centos/systemd

WORKDIR /root/

# Install
RUN yum -y install yum-utils psmisc net-tools wget unzip telnet zlib-devel openssl-devel gdb gcc gcc-c++ \
    && yum -y install golang make iproute which glibc-devel 

# copy source
COPY entrypoint.sh /sbin/

RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
