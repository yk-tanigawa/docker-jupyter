#!/bin/bash
set -beEuo pipefail

SRCNAME=$(readlink -f "${0}")
SRCDIR=$(dirname "${SRCNAME}")
PROGNAME=$(basename $SRCNAME)
VERSION="0.1.0"
NUM_POS_ARGS="1"

source $(dirname "${SRCDIR}")/run-misc.sh
version=${DEFAULT_VERSION}

############################################################
# functions
############################################################

show_default_helper () {
    cat ${SRCNAME} | grep -n Default | tail -n+3 | awk -v FS=':' '{print $1}' | tr "\n" "\t"
}

show_default () {
    cat ${SRCNAME} \
        | tail -n+$(show_default_helper | awk -v FS='\t' '{print $1+1}') \
        | head  -n$(show_default_helper | awk -v FS='\t' '{print $2-$1-1}')
}

usage () {
cat <<- EOF
	$PROGNAME (version $VERSION)
	Run singularity image

	Usage: $PROGNAME [options] commands

	Options:
	  --version    (-v)  The Docker image version

	Default configurations:
	  version=${version}
EOF
    show_default | awk -v spacer="  " '{print spacer $0}'
}

############################################################
# tmp dir
############################################################
tmp_dir_root="${LOCAL_SCRATCH:=/tmp}"
if [ ! -d ${tmp_dir_root} ] ; then mkdir -p $tmp_dir_root ; fi
tmp_dir="$(mktemp -p ${tmp_dir_root} -d tmp-$(basename $0)-$(date +%Y%m%d-%H%M%S)-XXXXXXXXXX)"
# echo "tmp_dir = $tmp_dir" >&2
handler_exit () { rm -rf $tmp_dir ; }
trap handler_exit EXIT

############################################################
# parser start
############################################################
## == Default parameters (start) == ##
simg=__AUTO__
## == Default parameters (end) == ##

declare -a params=()
for OPT in "$@" ; do
    case "$OPT" in
        '-h' | '--help' )
            usage >&2 ; exit 0 ;
            ;;
        '-v' | '--version' )
            version=$2 ; shift 2 ;
            ;;
        '--simg' )
            simg=$2 ; shift 2 ;
            ;;
        '--'|'-' )
            shift 1 ; params+=( "$@" ) ; break
            ;;
        -*)
            echo "$PROGNAME: illegal option -- '$(echo $1 | sed 's/^-*//')'" 1>&2 ; exit 1
            ;;
        *)
            if [[ $# -gt 0 ]] && [[ ! "$1" =~ ^-+ ]]; then
                params+=( "$1" ) ; shift 1
            fi
            ;;
    esac
done

if [ ${#params[@]} -lt ${NUM_POS_ARGS} ]; then
    echo "${PROGNAME}: ${NUM_POS_ARGS} positional arguments are required" >&2
    usage >&2 ; exit 1 ;
fi

############################################################
if [ ${simg} == "__AUTO__" ] ; then
    simg="${simg_d_luria}/jupyter_yt_${version}.sif"
fi

ml load singularity/3.5.0

if [ ! -s ${simg} ] ; then
    cd $(dirname ${simg})
    singularity pull docker://${docker_hub_image_name}:${version}
    cd -
fi

if [ ! -d "/tmp/${USER}" ] ; then mkdir -p "/tmp/${USER}" ; fi

cd $(readlink -f $(pwd))

singularity -s exec \
--bind /net/bmc-lab5/data/kellis:/net/bmc-lab5/data/kellis \
--bind /net/bmc-lab6/data/lab/kellis:/net/bmc-lab6/data/lab/kellis \
--bind /home/${USER}:/home/${USER} \
--bind /tmp/${USER}:/tmp_${USER} \
-H /home/jovyan \
${simg} ${params[@]}
