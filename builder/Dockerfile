# alpine:3.2 ships with openssl 1.0.2
#FROM alpine:3.2

# We have to use an older openssl until DUO upgrades
# their src tarball to use pyOpenSSL >= 0.14 as described at
# https://github.com/pyca/pyopenssl/issues/276
FROM alpine:3.1

# If you change this, you must also change circle.yml.
ENV VERSION 2.4.12

RUN apk upgrade --update --available && \
    apk add \
      bash \
      python \
      gcc \
      gmp-dev \
      libc-dev \
      libgcc \
      make \
      openssl-dev=1.0.1p-r0 \
      patch \
      py-setuptools \
      python-dev \
    && rm -f /var/cache/apk/* && \
    adduser -D duo

# Build and install authproxy.
COPY install.patch /root/
ADD https://dl.duosecurity.com/duoauthproxy-${VERSION}-src.tgz /root/
COPY build.sh /root/
RUN /root/build.sh
