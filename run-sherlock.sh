#!/bin/bash
set -beEuo pipefail

#. $(dirname $(readlink -f $0))/run-misc.sh
. run-misc.sh

if [ $# -gt 1 ] ; then version=$1 ; else version=${DEFAULT_VERSION} ; fi

simg="/scratch/groups/mrivas/users/ytanigaw/simg/jupyter_yt_${version}.sif"

if [ ! -f ${simg} ] ; then
    cd $(dirname ${simg})
    singularity pull docker://yosuketanigawa/jupyter_yt:${version}
    cd -
fi

cd ${HOME}
#singularity -s exec --bind ${LOCAL_SCRATCH}:/jupyter-runtime ${simg} /opt/jupyter-start.sh
singularity -s exec -H /home/jovyan ${simg} jupyter notebook --NotebookApp.token=''

