Duo AuthProxy on Linux
======================

Overview
--------

This repo provides a way to build Duo Authentication Proxy into
a docker image and run it as a container.

[Duo Authentication Proxy](https://www.duosecurity.com/docs/authproxy_reference)
provides a local proxy service to enable on-premise integrations
between VPNs, devices, applications, and
[Duo two-factor authentication](https://www.duosecurity.com/docs).

For example, you can [provide two-factor auth on Citrix Netscaler via the Duo AuthProxy]
(https://www.duosecurity.com/docs/citrix_netscaler).


### Network diagram

![Duo network diagram](https://www.duosecurity.com/static/images/docs/authproxy/radius-network-diagram.png)
<br />Source: [https://www.duosecurity.com/docs/radius](https://www.duosecurity.com/docs/radius)

Actors:

* *Application or Service* is any RADIUS **client**, such as Citrix Netscaler,
  Juniper SSL VPN, Cisco ASA, f5, OpenVPN, or [others](https://www.duosecurity.com/docs).

* *Authentication Proxy* is the container described by this repo.
  - It acts as a RADIUS **server** for the application or service.
  - It acts as a **client** to a primary auth service (either Active Directory or RADIUS).
  - It acts as an HTTPS **client** to DUO hosted service.

* *Active Directory or RADIUS* is a primary authentication service.

* *DUO* is a hosted service to simplify two-factor authentication.

Flow:

1. User provides username and password to the application or service.

2. Application (RADIUS client) offers credentials to AuthProxy (RADIUS server).

3. AuthProxy acts as either a RADIUS client or an Active Directory client
   and tries to authenticate against the primary backend auth service.

4. If step 3 is successful, AuthProxy establishes a single https connection
   to DUO hosted service to validate second authentication factor with user.

5. User provides the second authentication factor, either *approve* or *deny*.

6. DUO terminates the https connection established by AuthProxy with pass/fail,
   and AuthProxy returns the pass/fail to Application.

7. Application accepts or denies the user authentication attempt.


Status
------

:warning: This is not ready for deployment.


References
----------------

* [Duo Authentication Proxy](https://www.duosecurity.com/docs/authproxy_reference)
* [Duo two-factor authentication](https://www.duosecurity.com/docs)


How-to
------

Build an image with your preferred userspace locally on a host with Docker:

    script/build.sh centos6
    script/build.sh centos7
    script/build.sh ubuntu

Run a container with bash from the built image:

    docker run --rm -it --entrypoint=/bin/bash duoauthproxy:centos6
    docker run --rm -it --entrypoint=/bin/bash duoauthproxy:centos7
    docker run --rm -it --entrypoint=/bin/bash duoauthproxy:ubuntu

Run a basic test to see if the container starts with its default config:

    script/test.sh centos6
    script/test.sh centos7
    script/test.sh ubuntu

Build all images:

    $ script/build-all.sh
    duoauthproxy           centos6    f4929afc3b75    8 minutes ago    278.5 MB
    duoauthproxy           centos7    ebc5592683ca    5 minutes ago    419.4 MB
    duoauthproxy           ubuntu     8e6495e7b9b8    3 seconds ago    281.8 MB
    duoauthproxy-builder   centos6    91bda67b530a    9 minutes ago    440.2 MB
    duoauthproxy-builder   centos7    79db91e084e3    5 minutes ago    601 MB
    duoauthproxy-builder   ubuntu     1daefd2370bc    42 seconds ago   541.2 MB

Run the basic test on all images:

    script/test-all.sh


Configuration
-------------

The image assumes the configuration is at `/etc/duoauthproxy/authproxy.cfg`
and provides a basic, default config file.
To provide a custom configuration, create your config at that path on the
docker host and run:

    docker run -d -v /etc/duoauthproxy:/etc/duoauthproxy duoauthproxy

Your custom config should contain a `[main]` section that includes:

    [main]
    log_stdout=true

The above directive ensures that `docker logs <cid>` is meaningful.


Licenses
--------

All files in this repo are subject to LICENSE (also in this repo).

Your usage of the built docker image is subject to the terms
within the built image.

View the Duo end-user license agreement:

    eula='/opt/duoauthproxy/doc/eula-linux.txt'
    docker run --rm -it --entrypoint=/bin/bash duoauthproxy -c "cat $eula"

Get a list of licenses for third-party components within the images:

    dir='/root/duoauthproxy-*-src'
    docker run --rm -it --entrypoint=/bin/bash duoauthproxy-builder -c "find $dir -iregex '.*license.*'"

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
