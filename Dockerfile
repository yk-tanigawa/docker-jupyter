#Specify our base image
FROM jupyter/datascience-notebook:2022-03-09
# https://hub.docker.com/r/jupyter/datascience-notebook/tags
# FROM jupyter/datascience-notebook:latest


# Install Ubuntu/Debian packages
USER root
RUN apt-get update \
# install software-properties-common first so that we can call add-apt-repository
&&  apt-get install -y software-properties-common \
&&  add-apt-repository ppa:ubuntugis/ubuntugis-unstable \
&&  apt-get install -y libcurl4-gnutls-dev zlib1g-dev libudunits2-dev libgdal-dev libgeos-dev libproj-dev libcairo2-dev libhdf5-dev \
&&  apt-get install -y libmariadb-dev


ENV R_REMOTES_NO_ERRORS_FROM_WARNINGS="true"

# conda
USER $NB_UID
WORKDIR /opt
RUN conda install mamba -n base -c conda-forge \
&&  mamba update -n base conda
RUN mamba install -c conda-forge r-latex2exp r-plotly jupyter_contrib_nbextensions dask dash modin h5py zstandard pyarrow \
&&  mamba install -c plotly plotly

# bash kernel
RUN pip install bash_kernel \
&&  python -m bash_kernel.install

# Jupyter extensions
RUN jupyter contrib nbextension install --user \
&&  jupyter labextension install @jupyterlab/github

# Python via pip
ADD /requirements/Python.pip.txt /opt/requirements/Python.pip.txt
RUN pip install -r /opt/requirements/Python.pip.txt

# R via CRAN
ADD /requirements/R.CRAN.txt /opt/requirements/R.CRAN.txt
RUN R -e "install.packages(c('BiocManager', 'devtools'), repos = 'http://cran.us.r-project.org', dependencies=TRUE)"
RUN R -e "for(CRAN_pkg in read.table('/opt/requirements/R.CRAN.txt', header = FALSE)$V1){ install.packages(CRAN_pkg, repos = 'http://cran.us.r-project.org', dependencies=TRUE) }"

# R via Bioconductor
ADD /requirements/R.Bioc.txt /opt/requirements/R.Bioc.txt
RUN R -e "for(bioc_pkg in read.table('/opt/requirements/R.Bioc.txt', header = FALSE)$V1){ BiocManager::install(bioc_pkg) }"

# R vis GitHub
# install other packages from GitHub
ADD /requirements/R.GitHub.txt /opt/requirements/R.GitHub.txt
RUN R -e "Sys.setenv(TAR = '/bin/tar'); devtools::install_github('chrchang/plink-ng', subdir='2.0/pgenlibr');" \
&&  R -e "Sys.setenv(TAR = '/bin/tar'); devtools::install_github('chrchang/plink-ng', subdir='2.0/cindex');" \
&&  R -e "Sys.setenv(TAR = '/bin/tar'); for(gh_pkg in read.table('/opt/requirements/R.GitHub.txt', header = FALSE)$V1){ devtools::install_github(gh_pkg) }"

USER $NB_UID
# additional packages from git submodules
ADD _submodules/cud4 /opt/cud4
RUN R -e "install.packages('/opt/cud4', repos = NULL, type='source')"

# additional package
# RUN R -e "install.packages(c('arrow'), repos = 'http://cran.us.r-project.org', dependencies=TRUE)"
# RUN R -e "Sys.setenv(TAR = '/bin/tar'); devtools::install_github(c('coolbutuseless/ggpattern'))"
# RUN R -e "BiocManager::install('scPCA')"
RUN R -e "install.packages(c('dynamicTreeCut'), repos = 'http://cran.us.r-project.org', dependencies=TRUE)"
RUN R -e "BiocManager::install('rhdf5')"
RUN R -e "Sys.setenv(TAR = '/bin/tar'); devtools::install_github(c('carbocation/aberrant'))"

# copy Jupyter-related directories
USER root
RUN cp -ar /home/jovyan/.jupyter             /opt/jupyter-config \
&&  cp -ar /home/jovyan/.local/share/jupyter /opt/jupyter-data

# add launch script
USER $NB_UID
WORKDIR /opt
COPY jupyter-start.sh .
