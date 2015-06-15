FROM alpine:3.2

RUN apk add --update freeradius openssl && rm -f /var/cache/apk/*
COPY users /etc/raddb/users
COPY clients.conf /etc/raddb/clients.conf
ENTRYPOINT ["/usr/sbin/radiusd"]
CMD ["-f"]
