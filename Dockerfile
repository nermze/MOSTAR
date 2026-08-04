FROM condaforge/mambaforge:latest

LABEL maintainer="nermze@gmail.com"
LABEL version="1.0.2"
LABEL description="MOSTAR - Modular ONT-Short read Taxonomic Assembly and Resistome-Evolution pipeline"

COPY environment.yml /tmp/environment.yml

RUN mamba env create -f /tmp/environment.yml -n mostar_env && \
    mamba clean -afy

ENV PATH=/opt/conda/envs/mostar_env/bin:$PATH

ENTRYPOINT ["mostar"]
CMD ["--help"]
