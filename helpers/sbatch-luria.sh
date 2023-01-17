#!/bin/bash
#SBATCH --job-name=jupyter
#SBATCH --output=/net/bmc-lab5/data/kellis/users/tanigawa/slurm-logs/repos/yk-tanigawa/docker-jupyter/helpers/sbatch-luria.%A.out
#SBATCH  --error=/net/bmc-lab5/data/kellis/users/tanigawa/slurm-logs/repos/yk-tanigawa/docker-jupyter/helpers/sbatch-luria.%A.err
#SBATCH --nodes=1
#SBATCH --ntasks=6
#SBATCH --mem=64000
#SBATCH --time=28-00:00:00
#SBATCH -p kellis
#SBATCH --exclude=b[1-4]

set -beEuo pipefail

sbatch --dependency=afterany:${SLURM_JOBID} sbatch-luria.sh

bash jupyter-luria.sh

