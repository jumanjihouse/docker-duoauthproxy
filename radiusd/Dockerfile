FROM centos:centos6

RUN yum -y install freeradius; yum clean all
ADD users /etc/raddb/users
ADD clients.conf /etc/raddb/clients.conf
ENTRYPOINT ["/usr/sbin/radiusd"]
CMD ["-f"]
