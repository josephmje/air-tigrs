FROM apache/airflow:2.2.4-python3.8
LABEL maintainer="tigrlabcamh@gmail.com"

USER root

RUN apt-get update && apt-get install --no-install-recommends -y \
    git

USER airflow

WORKDIR /home/airflow
ENV HOME="/home/airflow"

RUN mkdir -p /home/airflow/code

RUN pip install --upgrade pip

# Installing datman
RUN cd /home/airflow/code && \
    git clone https://github.com/tigrlab/datman.git && \
    cd datman && \
    pip install --no-cache-dir .[all]

ENV PATH="${PATH}:/home/airflow/code/datman/bin://home/airflow/code/datman/assets"

# Installing air-tigrs
COPY . /home/airflow/code/air-tigrs
RUN cd /home/airflow/code/air-tigrs && \
    pip install --no-cache-dir .[all]

# Setting study config
RUN mkdir -p /home/airflow/code/config
COPY /home/airflow/code/air-tigrs/airtigrs/data/tests/test_config.yml /home/airflow/code/config/
COPY /home/airflow/code/air-tigrs/airtigrs/data/tests/TEST_settings.yml /home/airflow/code/config/

ENV DM_CONFIG=/home/airflow/code/config
ENV DM_SYSTEM=test

ENTRYPOINT ["/bin/bash"]

ARG BUILD_DATE
ARG VCS_REF

LABEL org.label-schema.schema-version="1.0" \
      org.label-schema.build-date=$BUILD_DATE \
      org.label-schema.name="tigrlab/air-tigrs" \
      org.label-schema.description="Orchestration of TIGRLab dataflow infrastructure" \
      org.label-schema.url="https://imaging-genetics.camh.ca/air-tigrs/" \
      org.label-schema.vcs-url="https://github.com/tigrlab/air-tigrs" \
      org.label-schema.vcs-ref=$VCS_REF
