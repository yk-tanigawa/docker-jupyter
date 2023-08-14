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

if [ ! -d "/tmp/${USER}" ] ; then mkdir -p "/tmp/${USER}" ; fi

cd ${HOME}
#singularity -s exec --bind ${LOCAL_SCRATCH}:/jupyter-runtime ${simg} /opt/jupyter-start.sh
singularity -s exec \
--bind /net/bmc-lab5/data/kellis:/net/bmc-lab5/data/kellis \
--bind /net/bmc-lab6/data/lab/kellis:/net/bmc-lab6/data/lab/kellis \
--bind /home/${USER}:/home/${USER} \
--bind /tmp/${USER}:/tmp_${USER} \
-H /home/jovyan \
${simg} jupyter notebook --NotebookApp.token='' --port 18181
