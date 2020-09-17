#!/bin/bash
set -beEuo pipefail

version=$1

docker build --no-cache -t jupyter_yt:${version} .
image_id=$(docker images | awk '(NR==2){print $3}')
docker tag ${image_id} yosuketanigawa/jupyter_yt:${version}
docker push yosuketanigawa/jupyter_yt:${version}

