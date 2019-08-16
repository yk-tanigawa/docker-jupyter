# our base image
FROM jupyter/datascience-notebook:latest

#RUN sudo apt-get update

RUN conda update -n base conda \
&& conda install -c conda-forge r-latex2exp r-plotly jupyter_contrib_nbextensions \
&& conda install -c r r-gridextra \
&& conda install -c pdiakumis r-googlesheets \
&& jupyter contrib nbextension install --user

# RUN R -e "install.packages(c('googlesheets'), repos = 'http://cran.us.r-project.org')"

# run the application
CMD ["jupyter", "lab", "--NotebookApp.token=''"]
#CMD ["start-notebook.sh", "--NotebookApp.password=''", ]

