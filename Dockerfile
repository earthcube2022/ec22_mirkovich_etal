# jupyter setup
FROM continuumio/miniconda3
RUN /opt/conda/bin/conda install jupyter -y

# install AMGeO 2.0.2 from zip
# TODO: fix to correct version when possible
RUN apt-get update -y && apt-get install gcc gfortran unzip -y && mkdir /opt/notebook
COPY AMGeO-wjmirk-git-auth.zip AMGeO-main.zip
RUN unzip AMGeO-main.zip
#RUN cd AMGeO-main && pip install numpy && pip install -r requirements.txt && python setup.py develop
RUN cd AMGeO-wjmirk-git-auth && pip install numpy && pip install -r requirements.txt && python setup.py develop

# matplotlib/numpy/xarray installed with AMGeO
# apexpy
RUN pip install apexpy==1.1.0
# cartopy install
RUN conda install -c conda-forge cartopy=0.20.2

### create user with a home directory
ARG NB_USER=jovyan
ARG NB_UID=1000
ENV USER ${NB_USER}
ENV NB_UID ${NB_UID}
ENV HOME /home/${NB_USER}

RUN adduser --disabled-password \
    --gecos "Default user" \
    --uid ${NB_UID} \
    ${NB_USER}

# prepare notebooks
WORKDIR ${HOME}
COPY WM_01_AMGeO-2.0.ipynb . 
COPY amgeo_out/ amgeo_out/ 
COPY static/ static/ 

# give user permissions to files in HOME
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}