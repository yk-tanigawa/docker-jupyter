# Helper scripts

## How to build a new version?

```{bash}
bash helpers/build-clean-local.sh

bash helpers/push2hub-local.sh 20220123
```

You will also need to update the `run-misc.sh` to update the default version.

## How to clean-up old images?

```{bash}
bash helpers/docker-image-clean-up.sh
```

## list of scripts

- To build an image
  - build-clean-bejerano.sh
  - build-clean-local.sh
- To push the image to Docker Hub
  - push2hub-local.sh
- To clean-up unused images
  - docker-image-clean-up.sh
- To run the container
  - jupyter-bejerano.sh
  - jupyter-local.sh
  - jupyter-luria.sh
  - jupyter-sherlock.sh
- To submit SLURM job
  - sbatch-luria.sh
  - sbatch-sherlock.sh
- To run a command in the image
  - run-simg-luria.sh
  - run-simg-sherlock.sh
