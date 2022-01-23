#!/bin/bash
set -beEuo pipefail

SRCNAME=$(readlink -f "${0}")
SRCDIR=$(dirname "${SRCNAME}")

cd $(dirname ${SRCDIR})

docker --config /cluster/u/ytanigaw/.docker build --network=host --no-cache .
