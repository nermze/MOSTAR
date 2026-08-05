#!/bin/bash
set -e

source /opt/conda/etc/profile.d/conda.sh
conda activate mostar_env

exec mostar "$@"
