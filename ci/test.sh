#!/bin/bash
#
# ================================================================================
# This script uses several containers:
# - radiusd: exists for test purposes only; acts as radius server for primary auth
# - radclient: exists for test purposes only; acts as "application or service"
# - duoauthproxy_1: uses duo integration that "allows" authentication
# - duoauthproxy_2: uses duo integration that "denies" authentication
#
# We test against the "internal" docker IPs (i.e., 172.17.42.0/24) to
# avoid challenges with NAT and RADIUS.
#
# Docker uses static NAT, which means services that do not reside on the same
# host as the authproxy container work fine. However, containers and processes
# on the same host as authproxy container source from 172.17.42.0/24.
#
# See http://docstore.mik.ua/orelly/networking_2ndEd/fire/ch21_07.htm
# for more info on RADIUS and NAT.
#
# See https://docs.docker.com/articles/networking/#container-networking
# for more info on Docker networking.
# ================================================================================

# Any failure causes script to fail.
set -eEu
set -o pipefail

# shellcheck disable=SC1091
[[ -r environment ]] && . environment

# shellcheck disable=SC1091
. ci/vars

# shellcheck disable=SC1091
. ci/functions.sh

echo
echo Show vars.
info "RADIUS_TAG is ${RADIUS_TAG}"
info "VERSION is ${VERSION}"
info "VCS_REF is ${VCS_REF}"
info "BUILD_DATE is ${BUILD_DATE}"
info "TAG is ${TAG}"

# Ensure dependencies are up-to-date.
. ci/bootstrap.sh

# Run various checks unrelated to Puppet.
run_precommit

echo
echo Configure fixtures.
if docker ps -a --format '{{.Names}}' --filter Name=src | grep -E '^src$' &>/dev/null; then
  docker rm -fv src
fi
docker create --name=src duoauthproxy sh
docker cp src:/opt/duoauthproxy/conf/ca-bundle.crt fixtures/
cp -f fixtures/ca-bundle.crt fixtures/allow/
cp -f fixtures/authproxy.cfg fixtures/allow/authproxy.cfg
sed -i "s/API_HOST/${API_HOST}/g" fixtures/allow/authproxy.cfg
sed -i "s/IKEY/${IKEY_ALLOW}/g" fixtures/allow/authproxy.cfg
sed -i "s/SKEY/${SKEY_ALLOW}/g" fixtures/allow/authproxy.cfg
cp -f fixtures/ca-bundle.crt fixtures/deny/
cp -f fixtures/authproxy.cfg fixtures/deny/authproxy.cfg
sed -i "s/API_HOST/${API_HOST}/g" fixtures/deny/authproxy.cfg
sed -i "s/IKEY/${IKEY_DENY}/g" fixtures/deny/authproxy.cfg
sed -i "s/SKEY/${SKEY_DENY}/g" fixtures/deny/authproxy.cfg

echo
echo Build or pull supplementary images we use to test.
docker-compose build config_allow
docker-compose build config_deny
docker-compose pull --parallel radiusd radclient

echo
echo Start the containers we need to test.
smitty docker-compose up -d authproxy_allow
smitty docker-compose up -d authproxy_deny
smitty docker-compose up -d radiusd

echo
echo Invoke BATS tests.
echo
bats test/test_*.bats

echo
echo Tear down containers.
smitty docker-compose down
