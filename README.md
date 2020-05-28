# Yosuke's docker image of Jupyter notebook environment

To normalize notebook environment, Yosuke creates and maintains Docker image of Jupyter notebook.
The image is pushed to [Docker Hub](https://hub.docker.com/r/yosuketanigawa/jupyter_yt).

## How to run the notebook

You should able to run this container with the following command:

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

We also have run scripts for yosuke's environment.

- `run-local.sh`
- `run-sherlock.sh`
- `run-bejerano.sh`

For job submission with a custom time limit (due to scheduled system maintenance, etc.):

```{bash}
sbatch -p mrivas --qos=high_p --output=/scratch/groups/mrivas/users/ytanigaw/simg/logs/jupyter.%A.out --error=/scratch/groups/mrivas/users/ytanigaw/simg/logs/jupyter.%A.err --nodes=1 --cores=6 --mem=64000 --time=5-16:00:00 run-sherlock.sh
```

## clean-up old images

`bash docker-image-clean-up.sh`

## How to build a new version

We now have a wrapper script. `$ bash docker.update.push.sh 20200404` etc.
You will also need to update the `run-misc.sh` to update the default version.

```{bash}
# pull the latest version of the base image
docker pull jupyter/datascience-notebook:latest

# build an image
docker build -t yosuketanigawa/jupyter_yt:20200415 .
  
# image management
docker images

docker tag aedb45fa398c yosuketanigawa/jupyter_yt:20190723

# docker login
docker login
docker push yosuketanigawa/jupyter_yt:20190723
```

## Reference

- [Docker file for the base image](https://github.com/jupyter/docker-stacks/blob/master/base-notebook/Dockerfile)

## Version history

- 2020/5/28: add a script to pull the latest image, [`pull-sherlock.sh`](pull-sherlock.sh).
- 2020/4/13: we updated the documentation.
- 2020/4/4: we removed the dependencies to the private repositories.

## Acknowledgement

[![Wold you buy me some coffee?](https://www.buymeacoffee.com/assets/img/custom_images/orange_img.png)](https://www.buymeacoffee.com/yosuketanigawa)

