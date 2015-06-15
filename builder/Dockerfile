FROM duoauthproxy-common

# If you change this, you must also change circle.yml.
ENV VERSION 2.4.11

# Build and install authproxy.
COPY install.patch /root/
ADD https://dl.duosecurity.com/duoauthproxy-${VERSION}-src.tgz /root/
COPY build.sh /root/
RUN /root/build.sh
