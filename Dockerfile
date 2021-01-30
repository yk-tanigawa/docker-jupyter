#Specify our base image
FROM jupyter/datascience-notebook:latest

# Install Ubuntu/Debian packages
USER root
RUN apt-get update \
# install software-properties-common first so that we can call add-apt-repository
&&  apt-get install -y software-properties-common \
&&  add-apt-repository ppa:ubuntugis/ubuntugis-unstable \
&&  apt-get install -y libcurl4-gnutls-dev zlib1g-dev libudunits2-dev libgdal-dev libgeos-dev libproj-dev

# Install packages from conda
USER $NB_UID
ENV R_REMOTES_NO_ERRORS_FROM_WARNINGS="true"
WORKDIR /opt
RUN conda update -n base conda \
&&  conda install -c conda-forge r-latex2exp r-plotly jupyter_contrib_nbextensions dask dash modin h5py zstandard \
&&  conda install -c conda-forge --strict-channel-priority pyarrow r-arrow \
&&  conda install -c plotly plotly \
&&  jupyter contrib nbextension install --user \
# Add the bash kernel
&&  pip install bash_kernel \
&&  python -m bash_kernel.install \
# Install Python packages
&&  pip install rpy2 zstd \
# Install R packages from CRAN/Bioconductor
&&  R -e "install.packages(c('future', 'future.apply', 'devtools', 'BiocManager', 'tidyverse', 'gridextra', 'ggrepel', 'UpSetR', 'corrr', 'corrplot', 'h5', 'snow', 'snowfall', 'glmnet', 'pcLasso', 'PMA', 'pROC', 'rstan', 'brms', 'TwoSampleMR', 'MendelianRandomization', 'forestplot', 'meta', 'googledrive', 'googlesheets', 'ggpointdensity', 'BGData', 'pheatmap', 'DataExplorer', 'esquisse', 'mlr', 'parsnip', 'ranger', 'VennDiagram', 'ggdendro', 'corrplot', 'igraph', 'Hmisc', 'docopt', 'svglite', 'lobstr', 'arrow', 'vroom'), repos = 'http://cran.us.r-project.org', dependencies=TRUE)"  \
&&  R -e "BiocManager::install('impute')" \
# install other packages from GitHub
&&  R -e "Sys.setenv(TAR = '/bin/tar'); devtools::install_github('chrchang/plink-ng', subdir='2.0/pgenlibr');" \
&&  R -e "Sys.setenv(TAR = '/bin/tar'); devtools::install_github('chrchang/plink-ng', subdir='2.0/cindex');" \
&&  R -e "Sys.setenv(TAR = '/bin/tar'); devtools::install_github(c('tidyverse/googlesheets4', 'NightingaleHealth/ggforestplot', 'junyangq/glmnetPlus', 'rivas-lab/snpnet', 'r-lib/sloop', 'mkanai/corrplot'))" \
&&  R -e "Sys.setenv(TAR = '/bin/tar'); remotes::install_github(c('paul-buerkner/brms'))"

# # Add a Python 2 environment
# RUN conda create --yes --name py27 python=2.7 anaconda
# #RUN ["/bin/bash", "-c", "source activate py27 && cd plink-ng/2.0/Python && python setup.py build_ext && python setup.py install && python -m ipykernel install --user --name py27 --display-name py27 && conda deactivate && cd -"]
# RUN ["/bin/bash", "-c", "source activate py27 && python -m ipykernel install --user --name py27 --display-name py27 && conda deactivate" ]

# additional packages
# RUN conda install -c conda-forge r-arrow
# RUN conda install -c conda-forge pyarrow
# RUN R -e "arrow::install_arrow()"

# additional packages from git submodules
ADD _submodules/cud4 /opt/cud4
RUN R -e "install.packages('/opt/cud4', repos = NULL, type='source')"

# copy Jupyter-related directories
USER root
RUN cp -ar /home/jovyan/.jupyter             /opt/jupyter-config \
&&  cp -ar /home/jovyan/.local/share/jupyter /opt/jupyter-data

# add launch script
USER $NB_UID
WORKDIR /opt
COPY jupyter-start.sh .
