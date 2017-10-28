FROM alpine:3.6

RUN apk upgrade --update && \
    apk add \
      python \
      'libressl2.5-libssl>=2.5.5-r0' \
      && \
    rm -f /var/cache/apk/* && \
    adduser -D -s /sbin/nologin duo

# Use ADD, not COPY, to keep image small.
ADD duoauthproxy.tgz /

COPY harden /usr/sbin/harden
RUN /usr/sbin/harden

COPY authproxy.cfg /etc/duoauthproxy/authproxy.cfg
USER duo
ENTRYPOINT ["/opt/duoauthproxy/bin/authproxy"]
CMD ["-c", "/etc/duoauthproxy/authproxy.cfg"]

ARG CI_BUILD_URL
ARG BUILD_DATE
ARG VCS_REF
ARG VERSION

LABEL \
    io.github.jumanjiman.ci-build-url=$CI_BUILD_URL \
    io.github.jumanjiman.version=$VERSION \
    io.github.jumanjiman.build-date=$BUILD_DATE \
    io.github.jumanjiman.vcs-ref=$VCS_REF \
    io.github.jumanjiman.license="MIT" \
    io.github.jumanjiman.docker.dockerfile="/runtime/Dockerfile" \
    io.github.jumanjiman.vcs-type="Git" \
    io.github.jumanjiman.vcs-url="https://github.com/jumanjihouse/docker-duoauthproxy.git"
