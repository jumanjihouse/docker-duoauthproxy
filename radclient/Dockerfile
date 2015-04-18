FROM alpine:latest

RUN apk add --update freeradius-radclient && rm -f /var/cache/apk/*
COPY test.conf /root/test.conf
ENTRYPOINT ["radclient"]
