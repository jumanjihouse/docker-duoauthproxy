FROM alpine:3.3

RUN apk upgrade --update && \
    apk add python && \
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
