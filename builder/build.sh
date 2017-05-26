#!/bin/bash
set -e
set -x

# https://duo.com/support/documentation/authproxy_reference#installation

# Build and install authproxy.
cd /root
tar xzf duoauthproxy-*-src.tgz
cd duoauthproxy*

patch -p0 -i /root/config.patch

pushd pkgs
# Erase bundled dirs.
find . -maxdepth 1 -type d -iname 'cryptography*' -exec rm -fr {} +
find . -maxdepth 1 -type d -iname 'pyopenssl*'    -exec rm -fr {} +
find . -maxdepth 1 -type d -iname 'pyasn1*'       -exec rm -fr {} +

# Download and extract new bundle(s).

# https://github.com/pyca/cryptography/issues/3247
curl -L -o cryptography.tgz https://github.com/pyca/cryptography/archive/1.9.tar.gz
tar xzf cryptography.tgz

# Be compatible with pyca-cryptography.
curl -L -o pyopenssl.tgz https://github.com/pyca/pyopenssl/archive/17.0.0.tar.gz
tar xzf pyopenssl.tgz

# Be compatible with pyca-cryptography.
curl -L -o asn1crypto.tgz https://github.com/wbond/asn1crypto/archive/0.22.0.tar.gz
tar xzf asn1crypto.tgz

popd

export PYTHON=$(which python)
make
cd duoauthproxy-build
./install --install-dir=/opt/duoauthproxy --service-user=duo --create-init-script=yes
