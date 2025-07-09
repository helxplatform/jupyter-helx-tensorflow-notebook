ARG BASE_IMAGE_TAG=v0.1.4
FROM containers.renci.org/helxplatform/jupyter/helx-notebook:$BASE_IMAGE_TAG

USER root

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN apt-get install -y graphviz libgraphviz-dev && \
    conda config --set restore_free_channel true && \
    conda install -y -q numba cudatoolkit && \
    pip install --no-cache-dir nvidia-cudnn-cu11 && \
    pip install --no-cache-dir \
    graphviz \
    mlxtend \
    nibabel \
    pydot \
    pygraphviz
RUN pip install --no-cache-dir "numpy<2"
RUN pip install --no-cache-dir tensorflow
RUN pip install --no-cache-dir \
    torch \
    timm
RUN fix-permissions "${CONDA_DIR}" /home
RUN python -c "import pandas as pd"

WORKDIR /
USER $NB_USER
