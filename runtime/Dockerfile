FROM alpine:3.5

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

RUN apk upgrade --update && \
    apk add \
      python \
      'libressl2.4-libssl>=2.4.4-r0' \
      && \
    rm -f /var/cache/apk/* && \
    adduser -D -s /sbin/nologin duo

# Use ADD, not COPY, to keep image small.
ADD duoauthproxy.tgz /

COPY entrypoint.py /
COPY authproxy.cfg /etc/duoauthproxy/authproxy.cfg
RUN chown duo /etc/duoauthproxy/authproxy.cfg

COPY harden.sh /usr/sbin/harden.sh
RUN /usr/sbin/harden.sh

ENV PATH /opt/duoauthproxy/bin:$PATH
USER duo
ENTRYPOINT ["/entrypoint.py"]
CMD ["authproxy", "-c", "/etc/duoauthproxy/authproxy.cfg"]
