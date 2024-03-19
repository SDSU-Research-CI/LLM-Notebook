FROM gitlab-registry.nrp-nautilus.io/prp/jupyter-stack/prp:v1.3

# Switch to root for software installs
USER root
WORKDIR /opt

# Install rclone
RUN curl https://rclone.org/install.sh | bash
 
# Fix any permissions issues caused by installing software via root
RUN fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

# Switch back to notebook user
USER $NB_USER
WORKDIR /home/${NB_USER}

# Add Conda Kernels for additional conda env kernels
RUN conda install -y -c conda-forge nb_conda_kernels -n base

COPY environment.yml .

RUN conda env create -y -f environment.yml

# # Add new conda env
# RUN conda create -y -n llm python=3.11.5

# # Copy custom packages list
# COPY requirements.txt .

# # Install custom packages in new env
# RUN source activate llm \
#  && pip install -r requirements.txt
