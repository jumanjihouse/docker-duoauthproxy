FROM alpine:3.6

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
      patch \
      py-setuptools \
      python-dev \
      tar \
    && rm -f /var/cache/apk/* && \
    adduser -D duo

ARG VERSION

# Build and install authproxy.
ADD https://dl.duosecurity.com/duoauthproxy-${VERSION}-src.tgz /root/
COPY build /root/
COPY config.patch /root/
RUN /root/build
