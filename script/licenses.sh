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
dir='/opt/duoauthproxy/doc/'
smitty docker run --rm -it --entrypoint sh duoauthproxy -c "find $dir -type f -exec cat {} +"
echo
echo '==== List of 3rd-party licenses ===='
smitty docker run --rm -it --entrypoint sh duoauthproxy-builder -c "find $dir -iname '*license*'"
