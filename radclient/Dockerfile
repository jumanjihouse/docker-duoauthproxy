FROM centos:centos6

RUN yum -y install freeradius-utils; yum clean all
ADD test.conf /root/test.conf
ENTRYPOINT ["radclient"]
