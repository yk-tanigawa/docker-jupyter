#!/bin/bash
set -beEuo pipefail

source run-misc.sh

if [ $# -gt 0 ] ; then version=$1 ; else version=${DEFAULT_VERSION} ; fi
if [ $# -gt 1 ] ; then dimg=$2 ; else dimg="yosuketanigawa/jupyter_yt:${version}" ; fi
if [ $# -gt 2 ] ; then port=$3 ; else port="8889" ; fi
if [ $# -gt 3 ] ; then tmp_dir=$4 ; else tmp_dir=/tmp ; fi

bind_dst="/home/ytanigaw"

docker run -it -w ${bind_dst} --rm -p ${port}:8888 \
--mount type=bind,src=/Users/$USER,dst=${bind_dst} \
--mount type=bind,src=${tmp_dir},dst=/jupyter-runtime \
${dimg} \
/opt/jupyter-start.sh

