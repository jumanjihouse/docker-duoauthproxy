Duo AuthProxy on Linux
======================

Project URL: [https://github.com/jumanjihouse/docker-duoauthproxy](https://github.com/jumanjihouse/docker-duoauthproxy)
<br />
Docker hub: [https://registry.hub.docker.com/u/jumanjiman/duoauthproxy/](https://registry.hub.docker.com/u/jumanjiman/duoauthproxy/)

Overview [![wercker status](https://app.wercker.com/status/29aaf67f4cb14dee1e8acdc1360e8f52/s/master "wercker status")](https://app.wercker.com/project/bykey/29aaf67f4cb14dee1e8acdc1360e8f52)
--------

Duo Authentication Proxy provides a local proxy service to enable
on-premise integrations between VPNs, devices, applications,
and hosted Duo or Trustwave two-factor authentication (2fa).

This repo provides a way to build Duo Authentication Proxy into
a docker image and run it as a container.
It provides containers based on your choice of:

| Image name                         |    Image size |
|:---------------------------------- | -------------:|
| jumanjiman/duoauthproxy:alpine     |         83 MB |
| jumanjiman/duoauthproxy:centos6    |        409 MB |
| jumanjiman/duoauthproxy:centos7    |        422 MB |
| jumanjiman/duoauthproxy:ubuntu     |        307 MB |

*Image size is approximate as of the last time I checked.*

The repo is set up to compile the software in a "builder" container,
then copy the built binaries into a "runtime" container free of development tools.
The build script in this git repo performs these steps:

1. Build "duoauthproxy-common" image based on your preferred distro.
   This image has a "duo" unprivileged user.
   You can remove this image after the build finishes.

2. Build "duoathproxy-builder" image that builds the authproxy.
   The build script patches the authproxy install script to
   **run as the duo unprivileged user** and install unattended.
   You can remove this image after the build finishes.

3. Build "duoauthproxy:${distro}" image that contains the runtime
   without any development tools.
   This is the image you use to run an authproxy container.

Build integrity

An unattended test harness runs the build script for each of
the supported distributions and runs acceptance tests, including
authentication against a test radius server with live Duo integration
as a second factor. If all tests pass on master branch in the
unattended test harness, it pushes the built images to the
Docker hub.


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

4. If step 3 is successful, AuthProxy establishes a single HTTPS connection
   to DUO hosted service to validate second authentication factor with user.

5. User provides the second authentication factor, either *approve* or *deny*.

6. DUO terminates the HTTPS connection established by AuthProxy with pass/fail,
   and AuthProxy returns the pass/fail to Application.

7. Application accepts or denies the user authentication attempt.


### References

* [Duo Authentication Proxy](https://www.duosecurity.com/docs/authproxy_reference)
* [2fa on Citrix Netscaler via the Duo AuthProxy](https://www.duosecurity.com/docs/citrix_netscaler)
* [Duo 2fa integrations](https://www.duosecurity.com/docs)
* [Trustwave managed 2fa](http://www.trustwave.com/Services/Managed-Security/Managed-Two-Factor-Authentication/)


How-to
------

### Pull an already-built image

These images are built as part of the test harness on wercker.
If all tests pass on master branch, then the images are pushed
into the docker hub.

* Alpine latest stable: `docker pull jumanjiman/duoauthproxy:alpine`
* Ubuntu latest stable: `docker pull jumanjiman/duoauthproxy:ubuntu`
* Centos6 latest stable: `docker pull jumanjiman/duoauthproxy:centos6`
* Centos7 latest stable: `docker pull jumanjiman/duoauthproxy:centos7`


### Configure the authproxy

The image assumes the configuration is at `/etc/duoauthproxy/authproxy.cfg`
and provides a basic, default config file.

You want `docker logs <cid>` to be meaningful, so
your custom config should contain a `[main]` section that includes:

    [main]
    log_stdout=true

The `contrib` directory in this git repo contains a sample config
for an authproxy that provides secondary authentication to NetScaler.

See [https://www.duosecurity.com/docs/authproxy_reference]
(https://www.duosecurity.com/docs/authproxy_reference) for all options.


### Run the authproxy

Edit the sample config file or provide your own:

    vim contrib/authproxy.cfg
    sudo cp contrib/authproxy.cfg /etc/duoauthproxy/

Copy the sample unit file into place and activate:

    sudo cp contrib/duoauthproxy.service /etc/systemd/system/
    sudo systemctl enable duoauthproxy
    sudo systemctl start duoauthproxy

Alternatively, you can run the container in detached mode from the CLI:

    docker run -d \
      --name duoauthproxy \
      -p 1812:1812/udp \
      -p 18120:18120/udp \
      -v /etc/duoauthproxy:/etc/duoauthproxy \
      jumanjiman/duoauthproxy:centos6


### Forward logs to a central syslog server

There are multiple approaches. An easy way is to use
https://github.com/progrium/logspout to forward the logs.

The `contrib` directory in this git repo provides a
sample systemd unit file to run logspout.

Edit the unit file to specify your server:

    vim contrib/logspout.service

Copy the modified unit file into place and activate:

    sudo cp contrib/logspout.service /etc/systemd/system/
    sudo systemctl enable logspout
    sudo systemctl start logspout


### Build the docker image

Build an image with your preferred userspace locally on a host with Docker:

    script/build.sh centos6
    script/build.sh centos7
    script/build.sh ubuntu

Run a container with bash from the built image:

    docker run --rm -it --entrypoint=/bin/bash duoauthproxy:centos6
    docker run --rm -it --entrypoint=/bin/bash duoauthproxy:centos7
    docker run --rm -it --entrypoint=/bin/bash duoauthproxy:ubuntu

Build all images:

    script/build-all.sh


### Test locally

An acceptance test harness runs on
[wercker.com](https://app.wercker.com/#applications/54a04a9107fa3ea41500fd01)
for each pull request. You do not need to do anything other than open a PR
in order to test changes on wercker.

As an alternative, you can run the acceptance test harness locally to verify operation.
First, create a free personal account at https://signup.duosecurity.com/
and create two integrations.

First integration:

* Integration type: RADIUS
* Integration name: test-radius-allow
* Policy: Allow access (Unenrolled users will pass through without two-factor authentication)
* Username normalization: None

Second integration:

* Integration type: RADIUS
* Integration name: test-radius-deny
* Policy: Deny access (Unenrolled users will be denied access)
* Username normalization: None

:warning: This test harness assumes your Duo account does *not*
have a user named "test".

Create a local file at the root of the repo named `environment`.
The file holds keys for the integrations you created above.

    # environment
    API_HOST=api-xxxxxxxx.duosecurity.com

    # This integration allows users without 2fa.
    IKEY_ALLOW=DIxxxxxxxxxxxxxxxxxx
    SKEY_ALLOW=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

    # This integration denies users without 2fa.
    IKEY_DENY=DIxxxxxxxxxxxxxxxxxx
    SKEY_DENY=xxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxxx

Run the test harness on a single image:

    script/test.sh centos6
    script/test.sh centos7
    script/test.sh ubuntu

Run the test harness on all images:

    script/test-all.sh


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


Thanks
------

Thanks to Duo for providing free personal accounts that make
the test harness in this repo possible.
