FROM docker:19.03 AS idocker
RUN mv $(command -v  docker) /tmp/docker

FROM tarscloud/tars-env-full

COPY --from=idocker /tmp/docker /usr/local/bin/docker

COPY entrypoint.sh /sbin/

RUN chmod 755 /sbin/entrypoint.sh

ENTRYPOINT [ "/sbin/entrypoint.sh" ]
