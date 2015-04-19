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
set -e

. script/functions
[[ -r environment ]] && . environment

stop_container() {
  docker rm -f $1 &> /dev/null || :
}

check_init() {
  # Did the daemon start?
  max_sleep=5
  while [[ $max_sleep -gt 0 ]]; do
    max_sleep=$(( $max_sleep - 1 ))
    sleep 1
    docker logs duoauthproxy | grep -ohi 'init complete'
    rc=$?
    [[ $rc -eq 0 ]] && break
  done
  echo
  return $rc
}

start_authproxy() {
  api_host=$1
  ikey=$2
  skey=$3

  # Create a data container.
  docker rm -f authproxy-config &> /dev/null || :
  docker run --name authproxy-config -v /etc/duoauthproxy --entrypoint=true duoauthproxy:${base_distro}
  docker run --volumes-from authproxy-config alpine:latest sed -i "s/RADIUSD_IP/${radiusd_ip}/g" /etc/duoauthproxy/authproxy.cfg
  docker run --volumes-from authproxy-config alpine:latest sed -i "s/API_HOST/${api_host}/g" /etc/duoauthproxy/authproxy.cfg
  docker run --volumes-from authproxy-config alpine:latest sed -i "s/IKEY/${ikey}/g" /etc/duoauthproxy/authproxy.cfg
  docker run --volumes-from authproxy-config alpine:latest sed -i "s/SKEY/${skey}/g" /etc/duoauthproxy/authproxy.cfg

  # Start duoauthproxy.
  smitty docker run -d --read-only --name duoauthproxy --volumes-from authproxy-config duoauthproxy:${base_distro}
  check_init
}

attempt_proxy_auth() {
  # Do we expect to "Allow" or "Deny" access?
  expectation=$1
  ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' duoauthproxy)
  smitty docker run --net=host -t radclient -f /root/test.conf ${ip}:1812 auth foo | tee /tmp/auth.out
  grep "${expectation}ing unknown user" /tmp/auth.out &> /dev/null
}

# Clean up from prior tests.
stop_container duoauthproxy
stop_container radiusd

# Are we running the expected base distro?
smitty docker run --entrypoint /bin/bash duoauthproxy:${base_distro} -c "cat /etc/os-release"

# Start radiusd for test.
# We use `-t' so that we can log to stdout for `docker logs'.
smitty docker run -d -t --name radiusd radiusd -f -l /dev/stdout
radiusd_ip=$(docker inspect --format '{{ .NetworkSettings.IPAddress }}' radiusd)
echo radiusd is running on ${radiusd_ip}

# Check that we can connect to radiusd directly.
# The client connection compensates for the time it takes radiusd to init.
smitty docker run -t radclient -f /root/test.conf ${radiusd_ip}:1812 auth testing123

# Do we see output from `docker logs radiusd'?
smitty docker logs radiusd | tee /tmp/radiusd.log
grep 'Ready to process requests' /tmp/radiusd.log &> /dev/null

# Start authproxy.
start_authproxy $API_HOST $IKEY_ALLOW $SKEY_ALLOW

# Can we auth via proxy?
attempt_proxy_auth Allow

# Stop authproxy.
stop_container duoauthproxy

# Start another authproxy.
start_authproxy $API_HOST $IKEY_DENY $SKEY_DENY

# Can we auth via proxy?
attempt_proxy_auth Deny

# Stop authproxy.
stop_container duoauthproxy
