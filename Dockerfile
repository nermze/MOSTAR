FROM continuumio/miniconda3:latest

LABEL maintainer="nermze@gmail.com"
LABEL version="1.0.1"
LABEL description="MOSTAR - Modular ONT-Short-read Taxonomic Assembly and Resistome-Evolution pipeline"

# Install mostar and all dependencies from bioconda
RUN conda install -y -c bioconda -c conda-forge mostar=1.0.1 && \
    conda clean -afy

# Set entrypoint
ENTRYPOINT ["mostar"]
CMD ["--help"]
