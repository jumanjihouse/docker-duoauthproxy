#!/bin/bash

# https://www.duosecurity.com/docs/authproxy_reference#installation

. /etc/os-release || :

if [[ $ID =~ ubuntu ]]; then
  dev_tools="
    build-essential
    libssl-dev
    python-dev
  "
  apt-get update
  apt-get -q -y install $dev_tools
  apt-get clean
elif [[ $ID =~ alpine ]]; then
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
  apk-install $dev_tools
else
  # Assume centos or similar.
  dev_tools="
    gcc
    make
    openssl-devel
    patch
    python-devel
    tar
    which
  "
  yum -y install $dev_tools
  yum clean all
fi

# Build and install authproxy.
cd /root
tar xzf duoauthproxy-latest-src.tgz
cd duoauthproxy*
export PYTHON=$(which python)
make
cd duoauthproxy-build
patch -p0 < /root/install.patch
./install
