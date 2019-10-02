#!/bin/bash
set -beEuo pipefail

export JUPYTER_CONFIG_DIR="/opt/jupyter-config"
export JUPYTER_PATH="/opt/jupyter-data"
export JUPYTER_DATA_DIR="${JUPYTER_PATH}"

jupyter --paths

jupyter notebook --NotebookApp.token=''

