# Yosuke's docker image of jupyter

To normalize notebook environment, Yosuke creates and maintains Docker image of Jupyter notebook.
The image is pushed to [Docker Hub](https://hub.docker.com/r/yosuketanigawa/jupyter_yt).

## How to run the notebook

We have run scripts.

- `run-local.sh`
- `run-sherlock.sh`
- `run-bejerano.sh`

## clean-up old images

`bash docker-image-clean-up.sh`

## How to build a new version

We now have a wrapper script. `$ bash docker.update.push.sh 20200404` etc.
You will also need to update the `run-misc.sh` to update the default version.

```{bash}
# pull the latest version of the base image
docker pull jupyter/datascience-notebook:latest

# build an image
docker build -t jupyter_yt:20190723 .
  
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

- 2020/4/4: we removed the dependencies to the private repositories.
