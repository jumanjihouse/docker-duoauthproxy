FROM alpine:latest

RUN apk add --update freeradius openssl && rm -f /var/cache/apk/* && \
    /etc/raddb/certs/bootstrap && \
    rm -f /etc/raddb/certs/bootstrap
COPY users /etc/raddb/users
COPY clients.conf /etc/raddb/clients.conf
ENTRYPOINT ["/usr/sbin/radiusd"]
CMD ["-f"]
