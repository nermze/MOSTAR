FROM condaforge/mambaforge:latest

LABEL maintainer="nermze@gmail.com"
LABEL version="1.0.3"
LABEL description="MOSTAR - Modular ONT-Short read Taxonomic Assembly and Resistome-Evolution pipeline"

WORKDIR /opt/mostar

COPY environment.yml .
RUN mamba env create -f environment.yml -n mostar_env && \
    mamba clean -afy

ENV PATH=/opt/conda/envs/mostar_env/bin:$PATH

COPY . .
RUN /opt/conda/envs/mostar_env/bin/python -m pip install --no-deps .

RUN /opt/conda/envs/mostar_env/bin/amrfinder -u

RUN /opt/conda/envs/mostar_env/bin/msf_data install --target /opt/macsy-models CONJScan

COPY entrypoint.sh /usr/local/bin/entrypoint.sh
RUN chmod +x /usr/local/bin/entrypoint.sh

WORKDIR /data

ENTRYPOINT ["/usr/local/bin/entrypoint.sh"]
CMD ["--help"]
