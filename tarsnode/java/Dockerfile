FROM centos/systemd

WORKDIR /root/
# JDK_1.8
ENV JAVA_HOME /usr/java/jdk1.8.0_202-amd64
    # Get and install JDK
RUN  mkdir -p /root/init \
    && cd /root/init/ \
    && wget https://mirror.its.sfu.ca/mirror/CentOS-Third-Party/RCG/common/x86_64/jdk-8u202-linux-x64.rpm \
    && rpm -ivh /root/init/jdk-8u202-linux-x64.rpm \
    && rm -rf /root/init/jdk-8u202-linux-x64.rpm \
    && echo "export JAVA_HOME=/usr/java/jdk1.8.0_202-amd64" >> /etc/profile \
    && echo "CLASSPATH=\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> /etc/profile \
    && echo "PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile \
    && echo "export PATH JAVA_HOME CLASSPATH" >> /etc/profile \
    && echo "export JAVA_HOME=/usr/java/jdk1.8.0_202-amd64" >> /root/.bashrc \
    && echo "CLASSPATH=\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> /root/.bashrc \
    && echo "PATH=\$JAVA_HOME/bin:\$PATH" >> /root/.bashrc \
    && echo "export PATH JAVA_HOME CLASSPATH" >> /root/.bashrc \
    && yum clean all \
    && rm -rf /var/cache/yum

# copy source
COPY entrypoint.sh /sbin/

RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
