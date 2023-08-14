#!/bin/bash
#SBATCH --job-name=jupyter
#SBATCH --output=/net/bmc-lab5/data/kellis/users/tanigawa/slurm-logs/repos/yk-tanigawa/docker-jupyter/helpers/sbatch-luria.%A.out
#SBATCH  --error=/net/bmc-lab5/data/kellis/users/tanigawa/slurm-logs/repos/yk-tanigawa/docker-jupyter/helpers/sbatch-luria.%A.err
#SBATCH --nodes=1
#SBATCH --ntasks=18
#SBATCH --mem=500000
#SBATCH --time=28-00:00:00
#SBATCH -p kellis
#SBATCH --exclude=b[1,3,4]

set -beEuo pipefail

bash jupyter-luria.sh
