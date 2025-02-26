ARG BASE_IMAGE=quay.io/jupyter/pytorch-notebook:cuda12-pytorch-2.6.0

FROM ${BASE_IMAGE}

# Switch to root for software installs
USER root
WORKDIR /opt

# Install rclone, Ollama and VS Code Server
RUN curl https://rclone.org/install.sh | bash \
 && curl -fsSL https://ollama.com/install.sh | sh \
 && curl -fsSL https://code-server.dev/install.sh | sh
 
# Fix any permissions issues caused by installing software via root
RUN fix-permissions "${CONDA_DIR}" \
 && fix-permissions "/home/${NB_USER}"

# Switch back to notebook user
USER $NB_USER
WORKDIR /home/${NB_USER}

# Add LLM packages
RUN mamba install -y -n base \
    ollama-python \
    openai \
    pyaudio \
    portaudio \
    cuda-nvcc \
    huggingface_hub \
    dask-kubernetes \
    chromadb

# Install VS Code Server proxy, FastChat, vLLM
RUN pip install \
    jupyter-codeserver-proxy \
    fschat \
    jupyter-ai[all]

# Install troublemakers
RUN pip install transformers \
bitsandbytes \
accelerate \
langchain \
xformers \
peft \
gptqmodel \
autoawq \
trl \
deepspeed
