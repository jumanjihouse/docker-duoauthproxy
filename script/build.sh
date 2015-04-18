#!/bin/bash
set -e

. script/functions

common_tag="duoauthproxy-common"
builder_tag="duoauthproxy-builder:${base_distro}"
runtime_tag="duoauthproxy:${base_distro}"
hub_tag="jumanjiman/${runtime_tag}"

# We need radclient for testing.
smitty docker build --rm -t radclient radclient/

# We need radiusd for testing.
smitty docker build --rm -t radiusd radiusd/

smitty pushd $base_distro
smitty docker build --rm -t $common_tag .
smitty popd

smitty pushd builder
smitty docker build --rm -t $builder_tag .
smitty popd

smitty pushd runtime
smitty rm -fr duoauthproxy.tgz || :
docker rm -f builder &> /dev/null || :
smitty docker run --name builder $builder_tag bash -c "tar czf /tmp/duoauthproxy.tgz /opt/duoauthproxy"
smitty docker cp builder:/tmp/duoauthproxy.tgz .
smitty docker build --rm -t $runtime_tag .
smitty docker tag -f $runtime_tag $hub_tag
smitty popd
