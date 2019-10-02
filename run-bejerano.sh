#!/bin/bash
set -beEuo pipefail

. $(dirname $(readlink -f $0))/run-misc.sh

if [ $# -gt 1 ] ; then version=$1 ; else version=${DEFAULT_VERSION} ; fi
port="8890"

dimg="yosuketanigawa/jupyter_yt:${version}"
bind_dst="/home/ytanigaw"
tmp_dir=/tmp/u/$USER/jupyter
if [ ! -d $tmp_dir ] ; then mkdir -p $tmp_dir ; fi

docker run -it -w ${bind_dst} --rm -p ${port}:8888 \
--mount type=bind,src=/cluster/u/$USER,dst=${bind_dst} \
--mount type=bind,src=/cluster,dst=/cluster \
--mount type=bind,src=${tmp_dir},dst=/jupyter-runtime \
${dimg} \
/opt/jupyter-start.sh

