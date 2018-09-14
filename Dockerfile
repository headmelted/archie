FROM ubuntu:cosmic
ARG DOCKER_TAG
ENV arch=amd64
RUN echo "TAG: $DOCKER_TAG"
WORKDIR /workspace
COPY kitchen /kitchen/
# ADD cobble.sh /
# RUN . /cobble.sh
# RUN rm /cobble.sh
