FROM debian:stretch
ARG DOCKER_TAG
ENV COBBLER_ARCH=$DOCKER_TAG
COPY kitchen /root/kitchen/
ADD cobble.sh /
RUN /bin/bash -c '. /cobble.sh'
RUN rm /cobble.sh
ENTRYPOINT /root/kitchen/cook.sh
