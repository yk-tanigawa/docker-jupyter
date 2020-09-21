#!/bin/bash
set -beEuo pipefail

. $(dirname $(readlink -f $0))/run-misc.sh

if [ $# -gt 1 ] ; then version=$1 ; else version=${DEFAULT_VERSION} ; fi
port="8888"

dimg="yosuketanigawa/jupyter_yt:${version}"
bind_dst="/cluster/u/$USER"
tmp_dir=/tmp/docker-jupyter
if [ ! -d $tmp_dir ] ; then mkdir -p $tmp_dir ; fi
chmod 777 ${tmp_dir}

docker run -it \
--user=root -e NB_USER=jovyan -e NB_UID=17737 -e NB_GID=559 \
-w ${bind_dst} --rm -p ${port}:8888 \
--mount type=bind,src=/cluster/u/$USER,dst=${bind_dst} \
--mount type=bind,src=/cluster/data,dst=/cluster/data,readonly \
--mount type=bind,src=/cluster/gbdb,dst=/cluster/gbdb,readonly \
--mount type=bind,src=/cluster/gbdb-bej,dst=/cluster/gbdb-bej,readonly \
--mount type=bind,src=${tmp_dir},dst=/home/jovyan/.local/share/jupyter \
${dimg}

