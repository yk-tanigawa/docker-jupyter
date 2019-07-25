# our base image
FROM jupyter/datascience-notebook:latest

#RUN sudo apt-get update
RUN conda update -n base conda \
&& conda install -c r r-gridextra \
&& conda install -c conda-forge r-latex2exp

# run the application
CMD ["jupyter", "lab", "--NotebookApp.token=''"]
#CMD ["start-notebook.sh", "--NotebookApp.password=''", ]

