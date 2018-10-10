ARG FROM_IMAGE=debian:stretch-slim
FROM $FROM_IMAGE
ENV COBBLER_DOCKER_TAG=$DOCKER_TAG
COPY kitchen /root/kitchen/
RUN if [ "${DOCKER_TAG}" != "base" ]; then /bin/bash -c '. /root/kitchen/tools/cobbler_initialize.sh'; fi;