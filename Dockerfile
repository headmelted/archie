FROM ubuntu:cosmic
COPY kitchen /kitchen/
WORKDIR /kitchen
ADD cobble.sh /
RUN . /cobble.sh
RUN rm /cobble.sh
