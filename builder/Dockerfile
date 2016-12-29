FROM alpine:3.5

ARG VERSION

RUN apk upgrade --update --available && \
    apk add \
      bash \
      curl \
      python \
      gcc \
      gmp-dev \
      libc-dev \
      libffi-dev \
      libgcc \
      'libressl-dev>=2.4.4-r0' \
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
