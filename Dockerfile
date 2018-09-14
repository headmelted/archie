FROM ubuntu:cosmic
ARG DOCKER_TAG
ENV arch=amd64
WORKDIR /workspace
COPY kitchen /kitchen/
ADD cobble.sh /
RUN . /cobble.sh
RUN rm /cobble.sh
