FROM ubuntu:xenial
WORKDIR /workspace
ADD cobble.sh /
RUN . /cobble.sh