FROM ubuntu:cosmic
ARG DOCKER_TAG
ENV arch=$DOCKER_TAG
COPY kitchen /kitchen/
WORKDIR /kitchen
ADD cobble.sh /
RUN . /cobble.sh
RUN rm /cobble.sh
