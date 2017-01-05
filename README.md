Duo AuthProxy on Linux
======================

[![Version](https://images.microbadger.com/badges/version/jumanjiman/duoauthproxy.svg)](http://microbadger.com/images/jumanjiman/duoauthproxy "View on microbadger.com")&nbsp;
[![Download size](https://images.microbadger.com/badges/image/jumanjiman/duoauthproxy.svg)](http://microbadger.com/images/jumanjiman/duoauthproxy "View on microbadger.com")&nbsp;
[![Docker Registry](https://img.shields.io/docker/pulls/jumanjiman/duoauthproxy.svg)](https://hub.docker.com/r/jumanjiman/duoauthproxy/)&nbsp;
[![Circle CI](https://circleci.com/gh/jumanjihouse/docker-duoauthproxy.png?circle-token=08f5a2b5348f48e4e629da800f3e0ad410025dca)](https://circleci.com/gh/jumanjihouse/docker-duoauthproxy/tree/master 'View CI builds')

Project URL: [https://github.com/jumanjihouse/docker-duoauthproxy](https://github.com/jumanjihouse/docker-duoauthproxy)
<br />
Docker hub: [https://registry.hub.docker.com/u/jumanjiman/duoauthproxy/](https://registry.hub.docker.com/u/jumanjiman/duoauthproxy/)
<br />
Image metadata: [https://microbadger.com/#/images/jumanjiman/duoauthproxy](https://microbadger.com/#/images/jumanjiman/duoauthproxy)
<br />
Current version: Duo Authproxy 2.4.19
([release notes](https://duo.com/support/documentation/authproxy-notes))

:warning: Duo Authproxy 2.4.18 resolves
[DUO-PSA-2016-002](https://duo.com/labs/psa/duo-psa-2016-002).


Overview
--------

Duo Authentication Proxy provides a local proxy service to enable
on-premise integrations between VPNs, devices, applications,
and hosted Duo or Trustwave two-factor authentication (2fa).

This repo provides a way to build Duo Authentication Proxy into
a docker image and run it as a container.


### Network diagram

![Duo network diagram](https://duo.com/assets/img/documentation/authproxy/radius-network-diagram.png)
<br />Source: [https://duo.com/support/documentation/radius](https://duo.com/support/documentation/radius)

Actors:

* *Application or Service* is any RADIUS **client**, such as Citrix Netscaler,
  Juniper SSL VPN, Cisco ASA, f5, OpenVPN, or [others](https://duo.com/support/documentation).

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

5. Duo independently confirms the user second authentication factor,
   either *approve* or *deny*.

6. DUO terminates the HTTPS connection established by AuthProxy with pass/fail,
   and AuthProxy returns the pass/fail to Application.

7. Application accepts or denies the user authentication attempt.


### References

* [Duo Authentication Proxy](https://duo.com/support/documentation/authproxy_reference)
* [2fa on Citrix Netscaler via the Duo AuthProxy](https://duo.com/support/documentation/citrix_netscaler)
* [Duo 2fa integrations](https://duo.com/support/documentation)
* [Trustwave managed 2fa](http://www.trustwave.com/Services/Managed-Security/Managed-Two-Factor-Authentication/)


### Build integrity

The repo is set up to compile the software in a "builder" container,
then copy the built binaries into a "runtime" container free of development tools.

![workflow](assets/docker_hub_workflow.png)

An unattended test harness runs the build script for each of
the supported distributions and runs acceptance tests, including
authentication against a test radius server with live Duo integration
as a second factor. If all tests pass on master branch in the
unattended test harness, it pushes the built images to the
Docker hub.


How-to
------

### Report issues

* For issues with the Docker image build of this git repo:
  https://github.com/jumanjihouse/docker-duoauthproxy/issues

* For security issues with the upstream Duo AuthProxy:
  https://duo.com/legal/security-response

To contribute enhancements to this repo, please see
[`CONTRIBUTING.md`](CONTRIBUTING.md) in this repo.


### Pull an already-built image

These images are built as part of the test harness on CircleCI.
If all tests pass on master branch, then the image is pushed
into the docker hub.

    docker pull jumanjiman/duoauthproxy:latest

The "latest" tag always points to the latest version.
In general, you should prefer to use a pessimistic (i.e., specific) tag.
The runtime image on Docker hub has tags that match:

    <upstream_authproxy_version>-<build_date>T<build_time>-<git_hash>

These tags allow to correlate any image to the authproxy version, the build date and time,
and the git commit from this repo that was used to build the image.

We push the tags automatically from the test harness, and
we occasionally delete old tags from the Docker hub by hand.
See https://hub.docker.com/r/jumanjiman/duoauthproxy/tags/ for released tags.


### View labels

Each built image has labels that generally follow http://label-schema.org/

We add a label, `ci-build-url`, that is not currently part of the schema.
This extra label provides a permanent link to the CI build for the image.

View the ci-build-url label on a built image:

    docker inspect \
      -f '{{ index .Config.Labels "io.github.jumanjiman.ci-build-url" }}' \
      jumanjiman/duoauthproxy

Query all the labels inside a built image:

    docker inspect jumanjiman/duoauthproxy | jq -M '.[].Config.Labels'


### Configure the authproxy

The image assumes the configuration is at `/etc/duoauthproxy/authproxy.cfg`
and provides a basic, default config file.

You want `docker logs <cid>` to be meaningful, so
your custom config should contain a `[main]` section that includes:

    [main]
    log_stdout=true

The `contrib` directory in this git repo contains a sample config
for an authproxy that provides secondary authentication to NetScaler.

See [https://duo.com/support/documentation/authproxy_reference]
(https://duo.com/support/documentation/authproxy_reference) for all options.


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
      --read-only \
      --cap-drop=all \
      --cap-add=setgid \
      --cap-add=setuid \
      jumanjiman/duoauthproxy:latest

The above example uses `--read-only` and `--cap-drop all` as recommended by the
CIS Docker Security Benchmarks:

* [Docker 1.6](https://benchmarks.cisecurity.org/tools2/docker/CIS_Docker_1.6_Benchmark_v1.0.0.pdf)
* [Docker 1.11](https://benchmarks.cisecurity.org/tools2/docker/CIS_Docker_1.11.0_Benchmark_v1.0.0.pdf)
* [Docker 1.12](https://benchmarks.cisecurity.org/tools2/docker/CIS_Docker_1.12.0_Benchmark_v1.0.0.pdf)


### Forward logs to a central syslog server

There are multiple approaches. An easy way is to use
https://github.com/gliderlabs/logspout to forward the logs.

The `contrib` directory in this git repo provides a
sample systemd unit file to run logspout.

Edit the unit file to specify your server:

    vim contrib/logspout.service

Copy the modified unit file into place and activate:

    sudo cp contrib/logspout.service /etc/systemd/system/
    sudo systemctl enable logspout
    sudo systemctl start logspout


### Build the docker image

Build an image locally on a host with Docker:

    script/build.sh

Run a container interactively from the built image:

    docker run --rm -it --entrypoint sh duoauthproxy


### Test locally

See [TESTING.md](TESTING.md) in this git repo.


Licenses
--------

All files in this repo are subject to [LICENSE](LICENSE) (also in this repo).

Your usage of the built docker image is subject to the terms
within the built image.

View the Duo end-user license agreement and the open-source licenses
of 3rd-party libraries used in the proxy:

    dir='/opt/duoauthproxy/doc/'
    docker run --rm -it --entrypoint sh duoauthproxy -c "find $dir -type f -exec cat {} +"

Get a list of licenses for third-party components within the images:

    dir='/root/duoauthproxy-*-src'
    docker run --rm -it --entrypoint sh duoauthproxy-builder -c "find $dir -iname '*license*'"


Thanks
------

Thanks to Duo for providing free personal accounts that make
the test harness in this repo possible.
