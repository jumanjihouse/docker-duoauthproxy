#!/bin/bash
set -e

. script/functions

for distro in $distros; do
  script/build.sh $distro
done

smitty echo duoauthproxy images and sizes
docker images | grep duoauthproxy | grep -v common | sort
