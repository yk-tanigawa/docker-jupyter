# Yosuke's docker image of Jupyter notebook environment

To normalize the computing environment across different computing resources, Yosuke uses a Docker image of Jupyter. This repository contains a [Docker file](Dockerfile) and helper scripts. The image is pushed to [Docker Hub](https://hub.docker.com/r/yosuketanigawa/jupyter_yt). In some computing environment, we use Singularity to run the container image.

## How to run some commands within the container?

We have a wrapper for `singularity -s exec`. Assuming that you have a symlink to one of the `helpers/run-simg-*.sh` scripts, you can call the script like this.

```{bash}
bash run-simg.sh R
```

## How to pull the latest image?

You can specify the version number with the `-v` option in the same wrapper script.

```{bash}
bash run-simg.sh -v 20200701
```

## How to run the notebook?

We have helper scripts for Yosuke's environments. Please see the [`helpers`](helpers) directory.

You should be able to run this container with the following command:

```{bash}
docker_jupyter_tmp=/tmp/docker-jupyter
bind_dst=/home/$USER
if [ ! -d ${docker_jupyter_tmp} ] ; then mkdir -p ${docker_jupyter_tmp} ; fi
docker run -it \
--user=root -e NB_USER=jovyan -e NB_UID=$(id -u) -e NB_GID=$(id -g) \
-w ${bind_dst} --rm -p ${port}:8888 \
--mount type=bind,src=${bind_dst},dst=${bind_dst} \
--mount type=bind,src=${docker_jupyter_tmp},dst=/jupyter-runtime \
yosuketanigawa/jupyter_yt:latest
```

For job submission with a custom time limit (due to scheduled system maintenance, etc.):

```{bash}
sbatch -p mrivas --qos=high_p --output=/scratch/groups/mrivas/users/ytanigaw/simg/logs/jupyter.%A.out --error=/scratch/groups/mrivas/users/ytanigaw/simg/logs/jupyter.%A.err --nodes=1 --cores=6 --mem=64000 --time=5-16:00:00 run-sherlock.sh
```

## Yosuke's usage

We have wrapper scripts written for different computing environments. We place the following symlinks:

- run-simg.sh
- jupyter.sh
- logs

### Adding packages and testing the containers

```{bash}
bash helpers/build-dev-local.sh
bash helpers/jupyter-local.sh dev
```

### pushing it to Docker hub

```{bash}
bash helpers/push2hub-local.sh 20220902
```

## References

- [Docker file for the base image](https://github.com/jupyter/docker-stacks/blob/master/base-notebook/Dockerfile)

## Version history

- 2022/1/23: Update Docker image. We now have the [`requirements`](requirements) folder that lists the R and Python packages.
- 2020/7/1: Update Docker image. This now includes the [latest glmnet (version 4.0.2)](https://www.rdocumentation.org/packages/glmnet/versions/4.0-2 ).
- 2020/5/28: add a script to pull the latest image, [`pull-sherlock.sh`](pull-sherlock.sh).
- 2020/4/13: we updated the documentation.
- 2020/4/4: we removed the dependencies to the private repositories.

## Acknowledgements

[![Wold you buy me some coffee?](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/yosuketanigawa)
