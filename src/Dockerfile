FROM centos:centos6

# Ensure pre-installed packages are up-to-date.
RUN yum -y update; yum clean all
ONBUILD RUN yum -y update; yum clean all

# Install dependencies.
RUN yum -y install epel-release; yum clean all

# https://www.duosecurity.com/docs/authproxy_reference#installation
RUN yum -y install \
    gcc make openssl-devel python-devel \
    tar \
    which \
    patch \
    ; yum clean all

ADD install.patch /root/
ADD https://dl.duosecurity.com/duoauthproxy-latest-src.tgz /root/
RUN useradd duo

# Build and install authproxy.
RUN cd /root; \
    tar xzf duoauthproxy-latest-src.tgz; \
    cd duoauthproxy*; \
    export PYTHON=$(which python); \
    make; \
    cd duoauthproxy-build; \
    patch -p0 < /root/install.patch; \
    ./install

# `docker run' starts bash by default.
CMD ["/bin/bash"]
