#!/bin/bash
set -beEuo pipefail

[[ ${DEFAULT_VERSION:-} -eq 1 ]] && return || readonly DEFAULT_VERSION="20240805"

simg_d_sherlock="/scratch/groups/mrivas/users/ytanigaw/simg"
simg_d_luria="/net/bmc-lab5/data/kellis/users/tanigawa/software/jupyter_yt"
docker_hub_image_name="yosuketanigawa/jupyter_yt"
