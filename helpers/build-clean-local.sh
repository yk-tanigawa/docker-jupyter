#!/bin/bash
set -beEuo pipefail

SRCNAME=$(greadlink -f "${0}")
SRCDIR=$(dirname "${SRCNAME}")

cd $(dirname ${SRCDIR})

docker build --no-cache .
