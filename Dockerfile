FROM condaforge/mambaforge:latest

LABEL maintainer="nermze@gmail.com"
LABEL version="1.0.1"
LABEL description="MOSTAR - Modular ONT-Short read Taxonomic Assembly and Resistome-Evolution pipeline"

RUN mamba install -y -c bioconda -c conda-forge python=3.11 mostar=1.0.1 && \
    mamba clean -afy

ENV PATH="/opt/conda/bin:$PATH"
ENV CONDA_PREFIX="/opt/conda"

ENTRYPOINT ["mostar"]
CMD ["--help"]
