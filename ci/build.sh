#!/bin/bash
set -e
set -u
set -o pipefail

################################################################################
# Build the docker image(s). Invoke as "ci/build".
################################################################################

# shellcheck disable=SC1091
[[ -r environment ]] && . environment

cat >ci/vars <<EOF
# shellcheck shell=bash
declare -rx  VERSION=2.9.0
declare -rx  BUILD_DATE=$(date +%Y%m%dT%H%M)
declare -rx  VCS_REF=$(git describe --abbrev=7 --tags --always)
declare -rx  TAG=\${VERSION}-\${BUILD_DATE}-git-\${VCS_REF}

# Tag for radiusd and radclient used in test harness.
# For local testing, override this in "environment" as described in TESTING.md.
declare -rx  RADIUS_TAG=\${RADIUS_TAG:-3.0.15-r3-20171202T1557-git-296bc50}
EOF

# shellcheck disable=SC1091
. ci/vars

# shellcheck disable=SC1091
. ci/functions.sh

# Build the authproxy.
smitty docker-compose build builder

# Remove artifacts from previous runs.
smitty rm -fr duoauthproxy.tgz || :
docker rm -f builder &>/dev/null || :

# Create a tarball of built authproxy.
smitty docker run --name builder duoauthproxy-builder bash -c "tar czf /tmp/duoauthproxy.tgz /opt/duoauthproxy"

# Copy tarball into place and build runtime image.
smitty docker cp builder:/tmp/duoauthproxy.tgz runtime/
smitty docker-compose build runtime
