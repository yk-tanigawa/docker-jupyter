# Yosuke's docker image of jupyter

To normalize notebook environment, Yosuke creates and maintains Docker image of Jupyter notebook.

## How to run the notebook

We have run scripts.

- `run-local.sh`
- `run-sherlock.sh`
- `run-bejerano.sh`

## How to build a new version

```
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

