FROM alpine:3.2

# If you change this, you must also change circle.yml.
ENV VERSION 2.4.11

RUN apk upgrade --update --available && \
    apk add \
      bash \
      python \
      gcc \
      gmp-dev \
      libc-dev \
      libgcc \
      make \
      openssl-dev \
      patch \
      py-openssl \
      py-setuptools \
      python-dev \
    && rm -f /var/cache/apk/* && \
    adduser -D duo

# Build and install authproxy.
COPY install.patch /root/
ADD https://dl.duosecurity.com/duoauthproxy-${VERSION}-src.tgz /root/
COPY build.sh /root/
RUN /root/build.sh
