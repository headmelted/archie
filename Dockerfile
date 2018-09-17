FROM debian:stretch-slim
ARG DOCKER_TAG
ENV COBBLER_ARCH=$DOCKER_TAG
COPY kitchen /kitchen/
WORKDIR /kitchen
ADD cobble.sh /
RUN /bin/bash -c '. /cobble.sh'
RUN rm /cobble.sh
