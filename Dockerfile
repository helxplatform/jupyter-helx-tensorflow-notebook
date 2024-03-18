ARG BASE_IMAGE_TAG=v0.1.0
FROM containers.renci.org/helxplatform/jupyter/helx-notebook:$BASE_IMAGE_TAG

USER root

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN conda config --set restore_free_channel true && \
    conda install -y -q numba cudatoolkit && \
    pip install --no-cache-dir nvidia-cudnn-cu11 && \
    pip install --no-cache-dir \
       mlxtend \
       nibabel \
       tensorflow \
       torch && \
    fix-permissions "${CONDA_DIR}" /home

# Install cmake required for Torch installation
RUN apt-get update \ 
    && apt-get -y install cmake libreadline-dev
# Install Torch
RUN git clone https://github.com/torch/distro.git ./opt/torch-lua --recursive \
    && cd /opt/torch-lua \
    && TORCH_LUA_VERSION=LUA52 ./install.sh \
    && fix-permissions /opt/torch-lua /home
RUN echo "source /opt/torch-lua/install/bin/torch-activate" >> /etc/skel/.bashrc

WORKDIR /
USER $NB_USER
