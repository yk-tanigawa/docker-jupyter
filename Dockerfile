#Specify our base image
FROM jupyter/datascience-notebook:latest

RUN conda update -n base conda 

# Copy additional files
WORKDIR /opt
COPY misc/glmnet_2.0-20.tar.gz .
COPY misc/zstd-1.4.4.tar.gz .
COPY misc/snpnet-v.0.2.0.tar.gz .
RUN tar -xzvf zstd-1.4.4.tar.gz

# install zstd
WORKDIR /opt/zstd-1.4.4
RUN make install PREFIX=/opt/conda

# Install packages
WORKDIR /opt
RUN conda install -c conda-forge r-latex2exp r-plotly jupyter_contrib_nbextensions dask \
&& conda install -c r r-gridextra \
&& conda install -c plotly plotly \
&& pip install rpy2 zstandard zstd h5py modin \
&& jupyter contrib nbextension install --user

# Add the bash kernel
RUN pip install bash_kernel \
&& python -m bash_kernel.install

# Add a Python 2 environment
RUN conda create --yes --name py27 python=2.7 anaconda
#RUN ["/bin/bash", "-c", "source activate py27 && cd plink-ng/2.0/Python && python setup.py build_ext && python setup.py install && python -m ipykernel install --user --name py27 --display-name py27 && conda deactivate && cd -"]
RUN ["/bin/bash", "-c", "source activate py27 && python -m ipykernel install --user --name py27 --display-name py27 && conda deactivate" ]

# Install R packages from CRAN/Bioconductor
RUN R -e "install.packages(c('devtools', 'BiocManager', 'googledrive', 'googlesheets', 'ggpointdensity', 'glmnet', 'pcLasso', 'BGData', 'pROC', 'h5', 'snow', 'snowfall'), repos = 'http://cran.us.r-project.org', dependencies=TRUE)" \
&& R -e "BiocManager::install('impute')" \
&& R -e "install.packages(c('PMA'), repos = 'http://cran.us.r-project.org', dependencies=TRUE)"

# pull pgenlib/pgenlibr
WORKDIR /opt
RUN git clone https://github.com/chrchang/plink-ng.git
RUN R -e "Sys.setenv(TAR = '/bin/tar'); install.packages('plink-ng/2.0/pgenlibr', repos = NULL, type='source');"

# install other packages
RUN R -e "install.packages(c('ggrepel'), repos='http://cran.us.r-project.org', dependencies=TRUE)"
RUN R -e "Sys.setenv(TAR = '/bin/tar'); devtools::install_github('tidyverse/googlesheets4'); devtools::install_github('junyangq/glmnetPlus'); devtools::install_github('NightingaleHealth/ggforestplot'); install.packages('glmnet_2.0-20.tar.gz', repos = NULL, type='source'); install.packages('snpnet-v.0.2.0.tar.gz', repos = NULL, type='source')"

RUN cp -ar /home/jovyan/.jupyter             /opt/jupyter-config
RUN cp -ar /home/jovyan/.local/share/jupyter /opt/jupyter-data


RUN R -e "install.packages(c('pheatmap', 'DataExplorer', 'esquisse', 'mlr', 'parsnip', 'ranger'), repos = 'http://cran.us.r-project.org', dependencies=TRUE)"
RUN R -e "install.packages(c('UpSetR'), repos = 'http://cran.us.r-project.org', dependencies=TRUE)"

# add launch script
WORKDIR /opt
COPY jupyter-start.sh .

