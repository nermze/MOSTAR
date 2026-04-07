# Use a fast, pre-configured Mamba base
FROM mambaorg/micromamba:1.5.8

# Switch to root to install system-level basics
USER root
RUN apt-get update && apt-get install -y wget curl procps && rm -rf /var/lib/apt/lists/*

# Copy env file into the container
COPY --chown=$MAMBA_USER:$MAMBA_USER environment.yml /tmp/env.yaml

# Build the environment
RUN micromamba install -y -n base -f /tmp/env.yaml && \
    micromamba clean --all --yes

# Ensure the conda binaries are in the path
ENV PATH="/opt/conda/bin:$PATH"

# Setup the workspace
WORKDIR /app
COPY . /app

# Install Mostar 
RUN pip install .

# Create a mount point for the user's data
RUN mkdir /data
WORKDIR /data

# When the user runs the container, it executes 'mostar'
ENTRYPOINT ["mostar"]
