ARG BASE_IMAGE=quay.io/jupyter/pytorch-notebook:cuda12-2024-07-29

FROM ${BASE_IMAGE}

# Switch to root for software installs
USER root
WORKDIR /opt

# Install rclone
RUN curl https://rclone.org/install.sh | bash

# Install Ollama
RUN curl -fsSL https://ollama.com/install.sh | sh
 
# Fix any permissions issues caused by installing software via root
RUN fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

# Switch back to notebook user
USER $NB_USER
WORKDIR /home/${NB_USER}

# Add NB Conda Kernels to register jupyter kernels in all conda envs
RUN conda install -y -c conda-forge nb_conda_kernels -n base

# Create llm conda env
COPY environment-llm.yaml .
RUN conda env create -y -f environment-llm.yaml \
 && rm environment-llm.yaml

# RUN conda install -y -n llm -c nvidia -c conda-forge cuda-nvcc deepspeed