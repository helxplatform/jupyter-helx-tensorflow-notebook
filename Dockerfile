ARG BASE_IMAGE_TAG=develop-cuda-202309182143
FROM containers.renci.org/helxplatform/jupyter/helx-notebook:$BASE_IMAGE_TAG

USER root

# Fix: https://github.com/hadolint/hadolint/wiki/DL4006
# Fix: https://github.com/koalaman/shellcheck/wiki/SC3014
SHELL ["/bin/bash", "-o", "pipefail", "-c"]

# RUN pip install --no-cache-dir \
#        mlxtend \
#        nibabel \
#        tensorflow \
#        torch && \
#     conda config --set restore_free_channel true && \
#     conda install -y -q numba cudatoolkit && \
#     fix-permissions "${CONDA_DIR}" /home

# RUN pip install --no-cache-dir \
#        mlxtend \
#        nibabel \
#        tensorflow
RUN pip uninstall -y torch && \
    pip install --no-cache-dir --pre torch torchvision torchaudio \
                --index-url https://download.pytorch.org/whl/nightly/cu121 && \
    fix-permissions "${CONDA_DIR}" /home

WORKDIR /
USER $NB_USER
