FROM ubuntu:cosmic
ARG DOCKER_TAG
WORKDIR /workspace
COPY kitchen /kitchen/
