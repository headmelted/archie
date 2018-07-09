FROM ubuntu:cosmic
WORKDIR /workspace
COPY kitchen /kitchen/
ADD cobble.sh /
RUN . /cobble.sh
RUN rm /cobble.sh
