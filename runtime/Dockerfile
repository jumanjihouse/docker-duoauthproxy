FROM alpine:3.4

RUN apk upgrade --update && \
    apk add python && \
    rm -f /var/cache/apk/* && \
    adduser -D -s /sbin/nologin duo

# Use ADD, not COPY, to keep image small.
ADD duoauthproxy.tgz /

COPY harden.sh /usr/sbin/harden.sh
RUN /usr/sbin/harden.sh

COPY authproxy.cfg /etc/duoauthproxy/authproxy.cfg
USER duo
ENTRYPOINT ["/opt/duoauthproxy/bin/authproxy"]
CMD ["-c", "/etc/duoauthproxy/authproxy.cfg"]
