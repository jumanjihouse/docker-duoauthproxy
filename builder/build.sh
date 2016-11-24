#!/bin/bash
set -e
set -x

# https://duo.com/support/documentation/authproxy_reference#installation

# Build and install authproxy.
cd /root
tar xzf duoauthproxy-*-src.tgz
cd duoauthproxy*
patch -p0 < /root/config.patch

pushd pkgs
# Erase bundled dirs.
rm -fr pyopenssl*
rm -fr six*

# Download and extract new bundles.
curl -L -o pyopenssl.tgz https://github.com/pyca/pyopenssl/archive/16.2.0.tar.gz
tar xzf pyopenssl.tgz

# python-six extracts by default as gutworth-six-<hash>.
curl -L -o six.tgz https://bitbucket.org/gutworth/six/get/1.10.0.tar.gz
six_dir='six-1.10.0/'
mkdir ${six_dir}
tar xzf six.tgz -C ${six_dir} --strip-components=1
popd

export PYTHON=$(which python)
make
cd duoauthproxy-build
patch -p0 < /root/install.patch
./install
