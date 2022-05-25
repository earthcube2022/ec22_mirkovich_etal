# AMGeO Image
FROM ghcr.io/amgeo-collaboration/amgeo-earthcube-workshop-2022:latest

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

# dummmy credentials file
COPY amgeo_user.json .local/share/AMGeO/amgeo_user.json

# give user permissions to files in HOME
USER root
RUN chown -R ${NB_UID} ${HOME}
USER ${NB_USER}