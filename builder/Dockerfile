FROM centos:7.5.1804

RUN \
    yum install -y \
      bash \
      curl \
      python \
      gcc \
      gmp-devel \
      libc-devel \
      libffi-devel \
      libgcc \
      openssl-devel \
      linux-headers \
      make \
      patch \
      procps \
      py-setuptools \
      python-devel \
      tar \
      zlib-devel \
    && rm -fr /var/cache/yum && \
    useradd duo

ARG VERSION

# Build and install authproxy.
ADD https://dl.duosecurity.com/duoauthproxy-${VERSION}-src.tgz /root/
COPY build /root/
RUN /root/build

RUN mkdir -p /opt/duoauthproxy/log \
    && chown -R duo:duo /opt/duoauthproxy/log
VOLUME /opt/duoauthproxy/log
