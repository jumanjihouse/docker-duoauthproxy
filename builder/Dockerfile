FROM alpine:3.4

ARG VERSION

RUN apk upgrade --update --available && \
    apk add --no-cache -X http://dl-4.alpinelinux.org/alpine/edge/main \
      'libressl-dev>=2.4.4-r0' \
      && \
    apk add \
      bash \
      curl \
      python \
      gcc \
      gmp-dev \
      libc-dev \
      libffi-dev \
      libgcc \
      make \
      py-setuptools \
      python-dev \
      tar \
    && rm -f /var/cache/apk/* && \
    adduser -D duo

# Build and install authproxy.
ADD https://dl.duosecurity.com/duoauthproxy-${VERSION}-src.tgz /root/
COPY build.sh /root/
RUN /root/build.sh
