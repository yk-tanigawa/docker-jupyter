#!/bin/bash
set -beEuo pipefail

SRCNAME=$(greadlink -f "${0}")
SRCDIR=$(dirname "${SRCNAME}")
source $(dirname "${SRCDIR}")/run-misc.sh

cd $(dirname ${SRCDIR})

docker build -t ${docker_hub_image_name}:dev .
