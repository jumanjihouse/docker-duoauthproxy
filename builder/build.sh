#!/bin/bash
set -e
set -x

# https://www.duosecurity.com/docs/authproxy_reference#installation

# Build and install authproxy.
cd /root
tar xzf duoauthproxy-*-src.tgz
cd duoauthproxy*
patch -p0 < /root/config.patch
pushd pkgs
curl -L -o pyopenssl.tgz https://github.com/pyca/pyopenssl/archive/0.15.1.tar.gz
tar xzf pyopenssl.tgz
popd
export PYTHON=$(which python)
make
cd duoauthproxy-build
patch -p0 < /root/install.patch
./install
