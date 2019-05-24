# our base image
FROM jupyter/datascience-notebook:latest

# run the application
CMD ["jupyter", "lab", "--NotebookApp.token=''"]
#CMD ["start-notebook.sh", "--NotebookApp.password=''", ]
