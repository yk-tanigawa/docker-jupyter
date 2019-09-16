# our base image
FROM jupyter/datascience-notebook:latest

RUN conda update -n base conda \
&& conda install -c conda-forge r-latex2exp r-plotly jupyter_contrib_nbextensions \
&& conda install -c r r-gridextra \
&& conda install -c plotly plotly \
&& jupyter contrib nbextension install --user

# Add Python 2 environment
RUN conda create --yes --name py27 python=2.7 anaconda 

# install R packages
RUN R -e "install.packages(c('devtools', 'BiocManager', 'googledrive', 'googlesheets', 'ggpointdensity', 'glmnet', 'pcLasso', 'BGData', 'pROC'), repos = 'http://cran.us.r-project.org', dependencies=TRUE)" \
&& R -e "BiocManager::install('impute')" \
&& R -e "install.packages(c('PMA'), repos = 'http://cran.us.r-project.org', dependencies=TRUE)"

RUN R -e "Sys.setenv(TAR = '/bin/tar'); devtools::install_github('tidyverse/googlesheets4'); devtools::install_github('junyangq/glmnetPlus'); devtools::install_github('junyangq/snpnet'); devtools::install_github('NightingaleHealth/ggforestplot')"

COPY misc/glmnet_2.0-20.tar.gz glmnet_2.0-20.tar.gz

RUN R -e "Sys.setenv(TAR = '/bin/tar'); install.packages('glmnet_2.0-20.tar.gz', repos = NULL, type='source')"

# run the application
CMD ["jupyter", "lab", "--NotebookApp.token=''"]
#CMD ["start-notebook.sh", "--NotebookApp.password=''", ]

