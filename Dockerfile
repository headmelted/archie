FROM ubuntu:cosmic
ARG arch
ARG triplet
WORKDIR /workspace
COPY kitchen /kitchen/
ADD cobble.sh /
RUN . /cobble.sh
RUN rm /cobble.sh
