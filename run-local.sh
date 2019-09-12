#!/bin/bash
set -beEuo pipefail

. $(dirname $(readlink -f $0))/run-misc.sh

if [ $# -gt 1 ] ; then version=$1 ; else version=${DEFAULT_VERSION} ; fi
port="8889"

dimg="yosuketanigawa/jupyter_yt:${version}"
bind_dst="/home/ytanigaw"

docker run -it -w ${bind_dst} --rm -p ${port}:8888 \
--mount type=bind,src=/Users/$USER,dst=${bind_dst} \
${dimg}

