#!/bin/bash
set -beEuo pipefail

SRCNAME=$(readlink -f "${0}")
SRCDIR=$(dirname "${SRCNAME}")

ml load singularity/3.5.0

source $(dirname "${SRCDIR}")/run-misc.sh

if [ $# -gt 1 ] ; then version=$1 ; else version=${DEFAULT_VERSION} ; fi

simg="${simg_d_luria}/jupyter_yt_${version}.sif"

if [ ! -f ${simg} ] ; then
    cd $(dirname ${simg})
    singularity pull "docker://${docker_hub_image_name}:${version}"
    cd -
fi

cd ${HOME}
#singularity -s exec --bind ${LOCAL_SCRATCH}:/jupyter-runtime ${simg} /opt/jupyter-start.sh
singularity -s exec \
--bind /net/bmc-lab5/data/kellis:/net/bmc-lab5/data/kellis \
-H /home/jovyan \
${simg} jupyter notebook --NotebookApp.token='' --port 18181

