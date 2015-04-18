FROM alpine:latest

RUN apk add --update freeradius openssl && rm -f /var/cache/apk/* && \
    /etc/raddb/certs/bootstrap && \
    rm -f /etc/raddb/certs/bootstrap
ADD users /etc/raddb/users
ADD clients.conf /etc/raddb/clients.conf
ENTRYPOINT ["/usr/sbin/radiusd"]
CMD ["-f"]
