#!/bin/bash
set -e

. script/functions

check_init() {
  max_sleep=5
  while [[ $max_sleep -gt 0 ]]; do
    max_sleep=$(( $max_sleep - 1 ))
    echo -n .
    sleep 1
    docker logs duoauthproxy | grep -ohi 'init complete'
    rc=$?
    [[ $rc -eq 0 ]] && break
  done
  echo
  return $rc
}

smitty docker rm -f duoauthproxy || :
smitty docker run --rm --entrypoint /bin/bash duoauthproxy:${base_distro} -c "cat /etc/os-release || cat /etc/centos-release"
smitty docker run -d --name duoauthproxy duoauthproxy:${base_distro}
smitty check_init
