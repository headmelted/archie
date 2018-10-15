ARG FROM_IMAGE=debian:stretch-slim
FROM $FROM_IMAGE
ARG DOCKER_TAG=base
COPY kitchen /root/kitchen/
RUN echo "Tag is [${DOCKER_TAG}]." && if [ "${DOCKER_TAG}" != "base" ]; then /bin/bash -c "export ARCHIE_DOCKER_TAG=${DOCKER_TAG}; . /root/kitchen/tools/archie_initialize.sh;"; fi;