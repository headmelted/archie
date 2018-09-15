FROM ubuntu:cosmic
ARG DOCKER_TAG
COPY kitchen /kitchen/
WORKDIR /kitchen
