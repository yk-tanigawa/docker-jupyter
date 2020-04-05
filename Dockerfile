#Specify our base image
FROM jupyter/datascience-notebook:latest

USER root
RUN apt-get update
USER $NB_UID

RUN conda update -n base conda 

# Install Ubuntu/Debian packages
USER root
RUN apt-get install -y software-properties-common
RUN add-apt-repository ppa:ubuntugis/ubuntugis-unstable
RUN apt-get install -y libudunits2-dev libgdal-dev libgeos-dev libproj-dev
USER $NB_UID

# Install packages from conda
WORKDIR /opt
RUN conda install -c conda-forge r-latex2exp r-plotly jupyter_contrib_nbextensions dask \
&& conda install -c plotly plotly
RUN jupyter contrib nbextension install --user

# Add the bash kernel
RUN pip install bash_kernel \
&& python -m bash_kernel.install

# Install R packages from CRAN/Bioconductor
RUN R -e "install.packages(c('devtools', 'BiocManager'), repos = 'http://cran.us.r-project.org', dependencies=TRUE)" \
&& R -e "BiocManager::install('impute')"
RUN R -e "install.packages(c('tidyverse', 'gridextra', 'ggrepel', 'UpSetR', 'corrr', 'corrplot'), repos = 'http://cran.us.r-project.org', dependencies=TRUE)" \
&& R -e "install.packages(c('h5', 'snow', 'snowfall'), repos = 'http://cran.us.r-project.org', dependencies=TRUE)" \
&& R -e "install.packages(c('glmnet', 'pcLasso', 'PMA', 'pROC'), repos = 'http://cran.us.r-project.org', dependencies=TRUE)" \
&& R -e "install.packages(c('rstan', 'brms'), repos = 'http://cran.us.r-project.org', dependencies=TRUE)" \
&& R -e "install.packages(c('TwoSampleMR', 'MendelianRandomization', 'forestplot', 'meta'), repos = 'http://cran.us.r-project.org', dependencies=TRUE)"
RUN R -e "install.packages(c('googledrive', 'googlesheets', 'ggpointdensity', 'BGData', 'pheatmap', 'DataExplorer', 'esquisse', 'mlr', 'parsnip', 'ranger', 'VennDiagram'), repos = 'http://cran.us.r-project.org', dependencies=TRUE)"

# Install Python packages
RUN pip install rpy2 zstandard zstd h5py modin

# # Add a Python 2 environment
# RUN conda create --yes --name py27 python=2.7 anaconda
# #RUN ["/bin/bash", "-c", "source activate py27 && cd plink-ng/2.0/Python && python setup.py build_ext && python setup.py install && python -m ipykernel install --user --name py27 --display-name py27 && conda deactivate && cd -"]
# RUN ["/bin/bash", "-c", "source activate py27 && python -m ipykernel install --user --name py27 --display-name py27 && conda deactivate" ]

# copy Jupyter-related directories
RUN cp -ar /home/jovyan/.jupyter             /opt/jupyter-config \
&&  cp -ar /home/jovyan/.local/share/jupyter /opt/jupyter-data

# install other packages from GitHub
RUN R -e "Sys.setenv(TAR = '/bin/tar'); devtools::install_github('chrchang/plink-ng', subdir='2.0/pgenlibr');"
RUN R -e "Sys.setenv(TAR = '/bin/tar'); devtools::install_github(c('tidyverse/googlesheets4', 'NightingaleHealth/ggforestplot'))"
ENV R_REMOTES_NO_ERRORS_FROM_WARNINGS="true"
RUN R -e "Sys.setenv(TAR = '/bin/tar'); remotes::install_github(c('paul-buerkner/brms'))"
RUN R -e "Sys.setenv(TAR = '/bin/tar'); devtools::install_github('chrchang/plink-ng', subdir='2.0/cindex');"
RUN R -e "Sys.setenv(TAR = '/bin/tar'); devtools::install_github(c('junyangq/glmnetPlus', 'rivas-lab/snpnet'))"

# add launch script
WORKDIR /opt
COPY jupyter-start.sh .
