FROM ubuntu:20.04

WORKDIR /root/

ENV DEBIAN_FRONTEND=noninteractive
# Get and install nodejs
RUN apt update && apt install -y wget
RUN wget https://github.com/nvm-sh/nvm/archive/v0.35.1.zip \
    && unzip v0.35.1.zip \
    && cp -rf nvm-0.35.1 /root/.nvm \
    && echo ". /root/.nvm/nvm.sh" >> /root/.bashrc \
    && echo ". /root/.nvm/bash_completion" >> /root/.bashrc \
    && source /root/.bashrc \
    && nvm install v16.13.0 \
    && npm install -g npm pm2 \
    #tars nodejs 
    && source /root/.bashrc \
    && rm v0.35.1.zip
# copy source
COPY entrypoint.sh /sbin/

RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
