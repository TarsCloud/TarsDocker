FROM tarscloud/tars-env-full

WORKDIR /root/

RUN yum install -y bison flex \
    && mkdir -p /root/Tars && cd /root/Tars && git clone https://github.com/TarsCloud/TarsFramework framework --recursive \
    && cd /root/Tars/framework/build/ && cmake .. && make -j4 && make install \
    && rm -rf /root/Tars \
    && yum clean all && rm -rf /var/cache/yum 

RUN source /root/.bashrc \
    && cd /usr/local/tars/cpp/deploy/  \
    && git clone https://github.com/TarsCloud/TarsWeb web  \

RUN /usr/local/tars/cpp/deploy/tar-server.sh

ENTRYPOINT [ "/usr/local/tars/cpp/deploy/docker-init.sh" ]

#web
EXPOSE 3000
#user system
EXPOSE 3001
#tarslog
EXPOSE 18993
#tarspatch
EXPOSE 18793
#tarsqueryproperty
EXPOSE 18693
#tarsconfig
EXPOSE 18193
#tarsnotify
EXPOSE 18593
#tarsproperty
EXPOSE 18493
#tarsquerystat
EXPOSE 18393
#tarsstat
EXPOSE 18293
#tarsAdminRegistry
EXPOSE 12000
#tarsnode
EXPOSE 19385
#tarsregistry
EXPOSE 17890
EXPOSE 17891
