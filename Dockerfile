#  https://hub.docker.com/layers/library/python/3.9-slim-bullseye/images/sha256-de58dcff6a8ccd752899e667aded074ad3e8f5fd552969ec11276adcb18930a4
FROM python@sha256:de58dcff6a8ccd752899e667aded074ad3e8f5fd552969ec11276adcb18930a4

ARG DEBIAN_FRONTEND="noninteractive"

RUN apt-get update -qq && \
    apt-get install -y -qq --no-install-recommends \
        git && \
    rm -rf /var/lib/apt/lists/*

ARG TEMPLATEFLOW_HOME="/templateflow"

WORKDIR /code

COPY [".", "/code"]

RUN pip3 install --no-cache-dir pip==23.0.1 && \
    pip3 install --no-cache-dir --requirement requirements.txt && \
    python3 -c "from templateflow.api import get; get(['MNI152NLin2009cAsym', 'MNI152NLin6Asym'])" && \
    pip3 --no-cache-dir install --editable .

ENV TEMPLATEFLOW_HOME=${TEMPLATEFLOW_HOME}

RUN git submodule update --init --recursive && python3 tools/download_templates.py

ENTRYPOINT ["/usr/local/bin/giga_connectome"]
