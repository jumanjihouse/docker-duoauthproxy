# Note: We have to patch DUO config.mk and update
# their src tarball to use pyOpenSSL >= 0.14 as described at
# https://github.com/pyca/pyopenssl/issues/276
FROM alpine:3.4

# If you change this, you must also change circle.yml.
ENV VERSION 2.4.17

RUN apk upgrade --update --available && \
    apk add --no-cache -X http://dl-4.alpinelinux.org/alpine/edge/main \
      'openssl-dev>=1.0.2h-r0' \
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
      patch \
      py-setuptools \
      python-dev \
    && rm -f /var/cache/apk/* && \
    adduser -D duo

# Build and install authproxy.
COPY install.patch /root/
COPY config.patch /root/
ADD https://dl.duosecurity.com/duoauthproxy-${VERSION}-src.tgz /root/
COPY build.sh /root/
RUN /root/build.sh
