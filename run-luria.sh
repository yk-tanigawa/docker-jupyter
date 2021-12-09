#!/bin/bash
set -beEuo pipefail

ml load singularity

#. $(dirname $(readlink -f $0))/run-misc.sh
. run-misc.sh

if [ $# -gt 1 ] ; then version=$1 ; else version=${DEFAULT_VERSION} ; fi

simg="/net/bmc-lab5/data/kellis/users/tanigawa/software/jupyter_yt/jupyter_yt_${version}.sif"

if [ ! -f ${simg} ] ; then
    cd $(dirname ${simg})
    singularity pull docker://yosuketanigawa/jupyter_yt:${version}
    cd -
fi

cd ${HOME}
#singularity -s exec --bind ${LOCAL_SCRATCH}:/jupyter-runtime ${simg} /opt/jupyter-start.sh
singularity -s exec \
--bind /net/bmc-lab5/data/kellis:/net/bmc-lab5/data/kellis \
--bind /net/bmc-lab5/data/kellis2:/net/bmc-lab5/data/kellis2 \
-H /home/jovyan \
${simg} jupyter notebook --NotebookApp.token=''

