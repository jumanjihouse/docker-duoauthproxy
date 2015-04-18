FROM alpine:latest

ONBUILD RUN apk upgrade --update && \
            apk add bash python && \
            rm -f /var/cache/apk/*
RUN adduser -D duo
