#!/bin/bash
set -e
set -u
set -o pipefail

################################################################################
# Show licenses using the same commands as in README.
# If these commands fail, the build aborts.
# Thus you should update these commands and the README.
################################################################################

. ci/functions.sh

echo
echo '==== Duo licenses ===='
# Note: This shows the Duo EULA as well as the open-source licenses
# of the various 3rd-party components used in the proxy.
declare -r eula_dir='/opt/duoauthproxy/doc/'
smitty docker run --rm -it --entrypoint sh duoauthproxy -c "find ${eula_dir} -type f -exec cat {} +"
echo
echo '==== List of 3rd-party licenses ===='
# This one is just for completeness.
declare -r third_party_dir='/root/duoauthproxy-*-src'
smitty docker run --rm -it --entrypoint sh duoauthproxy-builder -c "find ${third_party_dir} -iname '*license*'"
