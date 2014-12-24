#!/bin/bash
set -e

. script/functions

start() {
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
smitty docker run -d --name duoauthproxy duoauthproxy
smitty start
