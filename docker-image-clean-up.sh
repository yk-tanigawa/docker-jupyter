#!/bin/bash
set -beEuo pipefail

docker rmi -f $(docker images -q jupyter_yt | sed -n '3,$p') $(docker images -q --filter "dangling=true")

