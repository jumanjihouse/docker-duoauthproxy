FROM centos:centos6

ONBUILD RUN yum -y update; yum clean all
RUN yum -y install epel-release; yum clean all
RUN useradd duo
