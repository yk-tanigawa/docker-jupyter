#!/bin/bash
set -beEuo pipefail

SRCNAME=$(greadlink -f "${0}")
SRCDIR=$(dirname "${SRCNAME}")

source $(dirname "${SRCDIR}")/run-misc.sh

version=$1

docker build -t ${docker_hub_image_name}:${version} .
docker push ${docker_hub_image_name}:${version}
