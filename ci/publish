#!/bin/bash
set -e
set -u
set -o pipefail

################################################################################
# Publish the image(s) to Docker Hub.
################################################################################

# shellcheck disable=SC1091
. ci/vars

# shellcheck disable=SC2154
docker login -u "${user}" -p "${pass}"
docker tag duoauthproxy jumanjiman/duoauthproxy:"${TAG}"
docker push jumanjiman/duoauthproxy:"${TAG}"
docker tag duoauthproxy jumanjiman/duoauthproxy:latest
docker push jumanjiman/duoauthproxy:latest
docker logout

curl -X POST 'https://hooks.microbadger.com/images/jumanjiman/duoauthproxy/a6qK4f-H4zzOMK1R2wA_Oovckew='
