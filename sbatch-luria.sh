#!/bin/bash
#SBATCH --job-name=jupyter
#SBATCH --output=/net/bmc-lab5/data/kellis/users/tanigawa/.logs/jupyter_yt/jupyter.%A.out
#SBATCH  --error=/net/bmc-lab5/data/kellis/users/tanigawa/.logs/jupyter_yt/jupyter.%A.err
#SBATCH --nodes=1
#SBATCH --cores=6
#SBATCH --mem=64000
#SBATCH --time=28-00:00:00
#SBATCH -p kellis

set -beEuo pipefail

sbatch --dependency=afterany:${SLURM_JOBID} sbatch-luria.sh

bash run-luria.sh

