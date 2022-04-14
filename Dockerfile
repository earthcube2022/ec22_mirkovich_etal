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

# prepare notebooks
WORKDIR ${HOME}
COPY AMGeO-API.ipynb . 
COPY amgeo_out/ .