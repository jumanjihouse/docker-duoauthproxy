#!/bin/bash
set -e

. script/functions

# Show licenses using the same commands as in README.
# If either of these commands fails, the build aborts.
# Thus you should update these commands and the README.
eula='/opt/duoauthproxy/doc/eula-linux.txt'
dir='/root/duoauthproxy-*-src'
echo
echo '==== Duo licenses ===='
# Note: This shows the Duo EULA as well as the open-source licenses
# of the various 3rd-party components used in the proxy.
dir='/opt/duoauthproxy/doc/'
smitty docker run --rm -it --entrypoint sh duoauthproxy -c "find $dir -type f -exec cat {} +"
echo
echo '==== List of 3rd-party licenses ===='
# This one is just for completeness.
dir='/root/duoauthproxy-*-src'
smitty docker run --rm -it --entrypoint sh duoauthproxy-builder -c "find $dir -iname '*license*'"