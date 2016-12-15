#!/bin/bash
set -e
set -x

# https://duo.com/support/documentation/authproxy_reference#installation

# Build and install authproxy.
cd /root
tar xzf duoauthproxy-*-src.tgz
cd duoauthproxy*

export PYTHON=$(which python)
make
cd duoauthproxy-build
./install --install-dir=/opt/duoauthproxy --service-user=duo --create-init-script=yes
