#!/bin/bash
set -e

. script/functions

# Build the authproxy.
smitty docker build -t duoauthproxy-builder builder/

# Remove artifacts from previous runs.
smitty rm -fr duoauthproxy.tgz || :
docker rm -f builder &> /dev/null || :

# Create a tarball of built authproxy.
smitty docker run --name builder duoauthproxy-builder bash -c "tar czf /tmp/duoauthproxy.tgz /opt/duoauthproxy"

# Copy tarball into place and build runtime image.
# NOTE: The build args are set by environment vars in circle.yml
smitty docker cp builder:/tmp/duoauthproxy.tgz runtime/
smitty docker build \
  --build-arg VCS_REF=${VCS_REF} \
  --build-arg BUILD_DATE=${BUILD_DATE} \
  --build-arg VERSION=${VERSION} \
  -t duoauthproxy \
  runtime/
