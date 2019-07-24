# our base image
FROM jupyter/datascience-notebook:latest

#RUN sudo apt-get update
RUN conda install -c r r-gridextra 

# run the application
CMD ["jupyter", "lab", "--NotebookApp.token=''"]
#CMD ["start-notebook.sh", "--NotebookApp.password=''", ]

