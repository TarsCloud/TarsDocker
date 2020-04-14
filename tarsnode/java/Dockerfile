FROM centos/systemd

WORKDIR /root/

ENV JAVA_HOME /usr/java/jdk-10.0.2
    # Get and install JDK
RUN  mkdir -p /root/init \
    && cd /root/init/ \
    && wget https://tars-thirdpart-1300910346.cos.ap-guangzhou.myqcloud.com/src/jdk-10.0.2_linux-x64_bin.rpm \
    && rpm -ivh /root/init/jdk-10.0.2_linux-x64_bin.rpm \
    && rm -rf /root/init/jdk-10.0.2_linux-x64_bin.rpm \
    && echo "export JAVA_HOME=/usr/java/jdk-10.0.2" >> /etc/profile \
    && echo "CLASSPATH=\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> /etc/profile \
    && echo "PATH=\$JAVA_HOME/bin:\$PATH" >> /etc/profile \
    && echo "export PATH JAVA_HOME CLASSPATH" >> /etc/profile \
    && echo "export JAVA_HOME=/usr/java/jdk-10.0.2" >> /root/.bashrc \
    && echo "CLASSPATH=\$JAVA_HOME/lib/dt.jar:\$JAVA_HOME/lib/tools.jar" >> /root/.bashrc \
    && echo "PATH=\$JAVA_HOME/bin:\$PATH" >> /root/.bashrc \
    && echo "export PATH JAVA_HOME CLASSPATH" >> /root/.bashrc \
    && yum clean all \
    && rm -rf /var/cache/yum

# copy source
COPY entrypoint.sh /sbin/

RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
