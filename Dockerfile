FROM alpine:3.4
MAINTAINER Thomas Boerger <thomas@webhippie.de>

EXPOSE 22 3000

RUN apk update && \
  apk add \
    su-exec \
    ca-certificates \
    sqlite \
    bash \
    git \
    linux-pam \
    s6 \
    curl \
    openssh \
    tzdata && \
  rm -rf \
    /var/cache/apk/* && \
  addgroup \
    -S -g 1000 \
    git && \
  adduser \
    -S -H -D \
    -h /data/git \
    -s /bin/bash \
    -u 1000 \
    -G git \
    git

ENV USER git
ENV GITEA_CUSTOM /data/gitea
ENV GODEBUG=netdns=go

VOLUME ["/data"]

ENTRYPOINT ["/usr/bin/entrypoint"]
CMD ["/bin/s6-svscan", "/etc/s6"]

COPY docker /

COPY public /app/gitea/public
COPY templates /app/gitea/templates
COPY bin/gitea /app/gitea/gitea
