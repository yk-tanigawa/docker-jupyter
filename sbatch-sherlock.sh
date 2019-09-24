#!/bin/bash
#SBATCH --job-name=jupyter
#SBATCH --output=/scratch/groups/mrivas/users/ytanigaw/simg/logs/jupyter.%A.out
#SBATCH  --error=/scratch/groups/mrivas/users/ytanigaw/simg/logs/jupyter.%A.err
#SBATCH --nodes=1
#SBATCH --cores=6
#SBATCH --mem=64000
#SBATCH --time=7-00:00:00
#SBATCH -p mrivas

set -beEuo pipefail

sbatch --dependency=afterany:${SLURM_JOBID} sbatch-sherlock.sh
bash run-sherlock.sh

