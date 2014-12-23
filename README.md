Duo Authproxy on Centos6
========================

Overview
--------

[Duo Authentication Proxy](https://www.duosecurity.com/docs/authproxy_reference)
provides a local proxy service to enable on-premise integrations
between VPNs, devices, applications, and
[Duo two-factor authentication](https://www.duosecurity.com/docs).

This repo provides a way to build Duo Authentication Proxy into
a docker image and run it as a container.


Status
------

:warning: This is not ready for deployment.


References
----------------

* [Duo Authentication Proxy](https://www.duosecurity.com/docs/authproxy_reference)
* [Duo two-factor authentication](https://www.duosecurity.com/docs)


How-to
------

Build this image locally on a host with Docker:

    git clone https://github.com/jumanjihouse/docker-duoauthproxy.git
    cd docker-duoauthproxy
    docker build --rm -t duoauthproxy .

Run a container with bash from the built image:

    docker run --rm -it duoauthproxy bash


Licenses
--------

All files in this repo are subject to LICENSE (also in this repo).

Your usage of the built docker image is subject to the terms at
/root/duoauthproxy-*-src/duoauthproxy-build/doc/eula-linux.txt
within the built image.

View the Duo end-user license agreement:

    eula='/root/duoauthproxy-*-src/duoauthproxy-build/doc/eula-linux.txt'
    docker run --rm -it duoauthproxy bash -c "cat $eula"

Get a list of licenses for third-party components within the image:

    dir='duoauthproxy-*-src
    docker run --rm -it duoauthproxy bash -c "find $dir -iregex '.*license.*'"

At the time this document is created, the above commands shows:

    duoauthproxy-2.4.8-src/pkgs/Twisted-14.0.2/LICENSE
    duoauthproxy-2.4.8-src/pkgs/netaddr-0.7.10/docs/source/license.rst
    duoauthproxy-2.4.8-src/pkgs/netaddr-0.7.10/LICENSE
    duoauthproxy-2.4.8-src/pkgs/pyOpenSSL-0.13.1/LICENSE
    duoauthproxy-2.4.8-src/pkgs/six-1.3.0/LICENSE
    duoauthproxy-2.4.8-src/pkgs/zope.interface-4.0.5/LICENSE.txt
    duoauthproxy-2.4.8-src/pkgs/dpkt-1.7/LICENSE
    duoauthproxy-2.4.8-src/pkgs/pycrypto-2.6/LEGAL/copy/LICENSE.libtom
    duoauthproxy-2.4.8-src/pkgs/pycrypto-2.6/LEGAL/copy/LICENSE.orig
    duoauthproxy-2.4.8-src/pkgs/pycrypto-2.6/LEGAL/copy/LICENSE.python-2.2
    duoauthproxy-2.4.8-src/pkgs/virtualenv-1.9.1/LICENSE.txt
    duoauthproxy-2.4.8-src/pkgs/pyparsing-1.5.7/LICENSE
    duoauthproxy-2.4.8-src/pkgs/pyrad-2.0/LICENSE.txt
