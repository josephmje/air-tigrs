FROM apache/airflow:2.2.4-python3.8

USER airflow

RUN apt-get update && apt-get install --no-install-recommends -y \
    git

# Installing datman
RUN git clone https://github.com/tigrlab/datman.git /src/datman && \
    cd /src/datman && \
    pip install --no-cache-dir .[all]

ENV PATH="${PATH}:/src/datman/bin:/src/datman/assets"

# Installing air-tigrs
COPY . /src/air-tigrs
RUN cd /src/air-tigrs && \
    pip install --no-cache-dir .[all]

# Setting study config
ENV DM_CONFIG=/src/air-tigrs/airtigrs/data/tests/test_config.yml
ENV DM_SYSTEM=test

WORKDIR /home/airflow
ENTRYPOINT ["/bin/bash"]
