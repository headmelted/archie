FROM debian:stretch-slim
ARG DOCKER_TAG	
ENV COBBLER_DOCKER_TAG=$DOCKER_TAG
COPY kitchen /root/kitchen/
COPY rootfs /root/jail/
ENTRYPOINT /bin/bash -c '. /root/kitchen/steps/bootstrap_prepare.sh'
