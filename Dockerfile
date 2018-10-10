FROM debian:stretch-slim
ARG DOCKER_TAG	
ENV COBBLER_DOCKER_TAG=$DOCKER_TAG
COPY kitchen /root/kitchen/
RUN if [ -n "${DOCKER_TAG}" ]; /bin/bash -c '. /root/kitchen/tools/initialize.sh'; fi;