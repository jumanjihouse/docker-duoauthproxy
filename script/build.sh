#!/bin/bash
set -e

. script/functions

# We need radclient for testing.
smitty docker build -t radclient radclient/

# We need radiusd for testing.
smitty docker build -t radiusd radiusd/

# Build the authproxy.
smitty docker build -t duoauthproxy-builder builder/

# Remove artifacts from previous runs.
smitty rm -fr duoauthproxy.tgz || :
docker rm -f builder &> /dev/null || :

# Create a tarball of built authproxy.
smitty docker run --name builder duoauthproxy-builder bash -c "tar czf /tmp/duoauthproxy.tgz /opt/duoauthproxy"

# Copy tarball into place and build runtime image.
smitty docker cp builder:/tmp/duoauthproxy.tgz runtime/
smitty docker build -t duoauthproxy runtime/
