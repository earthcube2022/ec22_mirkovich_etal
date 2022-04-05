# jupyter setup
FROM continuumio/miniconda3
RUN /opt/conda/bin/conda install jupyter -y

### create user with a home directory
ARG NB_USER
ARG NB_UID
ENV USER ${NB_USER}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}
WORKDIR ${HOME}

RUN apt-get update -y && apt-get install gcc gfortran unzip -y && mkdir /opt/notebook

# install AMGeO
COPY AMGeO-main.zip .
RUN unzip AMGeO-main.zip 
RUN cd AMGeO-main && pip install numpy && pip install -r requirements.txt && python setup.py develop

# prepare notebooks
WORKDIR ${HOME}
COPY AMGeO-Api.ipynb
COPY amgeo_out/ .

# prepare notebook
#COPY AMGeO-Api-Release.ipynb README.md /opt/notebook/
#COPY static/ /opt/notebook/static/
#COPY amgeo_out/ /opt/notebook/amgeo_out/
#COPY jupyter_notebook_config.py /.jupyter/
#CMD jupyter notebook --allow-root --config='/.jupyter/jupyter_notebook_config.py'
