#!/bin/bash
set -e

# https://www.duosecurity.com/docs/authproxy_reference#installation

dev_tools="
  gcc
  gmp-dev
  libc-dev
  libgcc
  make
  openssl-dev
  patch
  py-openssl
  py-setuptools
  python-dev
"
apk add --update $dev_tools

# Build and install authproxy.
cd /root
tar xzf duoauthproxy-latest-src.tgz
cd duoauthproxy*
export PYTHON=$(which python)
make
cd duoauthproxy-build
patch -p0 < /root/install.patch
./install
