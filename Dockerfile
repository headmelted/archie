FROM ubuntu:cosmic
#ARG arch=armhf
#ARG triplet=arm-linux-gnueabihf
WORKDIR /workspace
COPY kitchen /kitchen/
ADD cobble.sh /
RUN . /cobble.sh
RUN rm /cobble.sh
