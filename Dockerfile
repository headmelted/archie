ARG FROM_IMAGE=$(if [ "${DOCKER_TAG}" == "base" ]; then echo "debian:stretch-slim"; else echo "headmelted/cobbler:base"; fi;);
FROM $FROM_IMAGE
ENV COBBLER_DOCKER_TAG=$DOCKER_TAG
COPY kitchen /root/kitchen/
RUN if [ "${DOCKER_TAG}" != "base" ]; then /bin/bash -c '. /root/kitchen/tools/cobbler_initialize.sh'; fi;