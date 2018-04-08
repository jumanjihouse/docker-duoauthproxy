#!/bin/bash
set -e
set -u
set -o pipefail

################################################################################
# Clean the local build environment. Invoke as "ci/clean".
################################################################################

# Remove artifacts from previous runs.
rm -fr runtime/duoauthproxy.tgz || :
docker rm -f builder &>/dev/null || :

docker-compose down --volumes --rmi=all || :
