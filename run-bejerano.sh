#!/bin/bash
set -beEuo pipefail

. run-misc.sh

if [ $# -gt 1 ] ; then version=$1 ; else version=${DEFAULT_VERSION} ; fi
port="8890"

dimg="yosuketanigawa/jupyter_yt:${version}"
bind_dst="/home/ytanigaw"

docker run -it -w ${bind_dst} --rm -p ${port}:8888 \
--mount type=bind,src=/cluster/u/$USER,dst=${bind_dst} \
--mount type=bind,src=/afs/cs.stanford.edu/group/evodevo,dst="${bind_dst}-afs" \
${dimg}

