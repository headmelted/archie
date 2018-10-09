FROM debian:stretch-slim
ARG DOCKER_TAG	
ENV COBBLER_DOCKER_TAG=$DOCKER_TAG
COPY kitchen /root/kitchen/
COPY rootfs /root/jail/
RUN /bin/bash -c '. /root/kitchen/steps/bootstrap.sh'
ENTRYPOINT /bin/bash -c '/build.sh'