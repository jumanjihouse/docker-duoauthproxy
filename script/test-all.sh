#!/bin/bash
set -e

. script/functions

for distro in $distros; do
  script/test.sh $distro
done
