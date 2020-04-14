FROM centos/systemd

WORKDIR /root/

    # Get and install nodejs
RUN get https://github.com/nvm-sh/nvm/archive/v0.35.1.zip \
    && unzip v0.35.1.zip \
    && cp -rf nvm-0.35.1 /root/.nvm \
    # && echo 'NVM_DIR="/root/.nvm";' >> /root/.bashrc; \
    && echo ". /root/.nvm/nvm.sh" >> /root/.bashrc \
    && echo ". /root/.nvm/bash_completion" >> /root/.bashrc \
    && source /root/.bashrc \
    && nvm install v12.13.0 \
    && npm install -g npm pm2 \
    #tars nodejs 
    && source /root/.bashrc \
    && npm install -g pm2 @tars/deploy @tars/stream @tars/rpc @tars/logs @tars/config @tars/monitor @tars/notify @tars/utils @tars/dyeing @tars/registry \

# copy source
COPY entrypoint.sh /sbin/

RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
