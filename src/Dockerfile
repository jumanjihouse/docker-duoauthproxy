FROM centos:centos6

# Ensure pre-installed packages are up-to-date.
RUN yum -y update; yum clean all
ONBUILD RUN yum -y update; yum clean all

# Install dependencies.
RUN yum -y install epel-release; yum clean all

# Build and install authproxy.
ADD install.patch /root/
ADD https://dl.duosecurity.com/duoauthproxy-latest-src.tgz /root/
ADD build.sh /root/
RUN /root/build.sh

# `docker run' starts bash by default.
CMD ["/bin/bash"]
