ARG BASE_IMAGE_TAG=0cdd09a
FROM containers.renci.org/helxplatform/jupyter/helx-notebook:$BASE_IMAGE_TAG

USER root

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

RUN mamba install --yes \
    'tensorflow' && \
    mamba clean --all -f -y

RUN pip install \
       mlxtend \
       nibabel \
       torch && \
    fix-permissions "${CONDA_DIR}"

WORKDIR /
USER $NB_USER
