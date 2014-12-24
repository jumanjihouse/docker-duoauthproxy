FROM duoauthproxy-common

# Build and install authproxy.
ADD install.patch /root/
ADD https://dl.duosecurity.com/duoauthproxy-latest-src.tgz /root/
ADD build.sh /root/
RUN /root/build.sh
