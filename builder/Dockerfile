FROM duoauthproxy-common

ENV REFRESHED_AT 2015-Apr-16

# Build and install authproxy.
COPY install.patch /root/
ADD https://dl.duosecurity.com/duoauthproxy-latest-src.tgz /root/
COPY build.sh /root/
RUN /root/build.sh
