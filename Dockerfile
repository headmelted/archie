FROM debian:stretch
ARG DOCKER_TAG	
ENV COBBLER_DOCKER_TAG=$DOCKER_TAG	
ENV COBBLER_INSTALL_DEPENDENCIES_AT_BUILD="true"
ENV COBBLER_HOST_DEPENDENCIES="git curl gnupg pkg-config software-properties-common \
xvfb wget python curl zip p7zip-full rpm  libwww-perl libxml-libxml-perl libxml-sax-expat-perl \
dpkg-dev perl libconfig-inifiles-perl libxml-simple-perl liblocale-gettext-perl libdpkg-perl libconfig-auto-perl \
libdebian-dpkgcross-perl ucf debconf dpkg-cross tree libc6-dev"
ENV COBBLER_TARGET_DEPENDENCIES="libgtk2.0-0 libglib2.0-dev graphicsmagick libsecret-1-dev libxkbfile-dev \
libx11-dev libxdmcp-dev libdbus-1-3 libpcre3 libselinux1 libp11-kit0 libcomerr2 libk5crypto3 \
libkrb5-3 libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 libxcursor1 libxfixes3 libfreetype6 libavahi-client3 \
libgssapi-krb5-2 libtiff5 fontconfig-config libgdk-pixbuf2.0-common libgdk-pixbuf2.0-0 libfontconfig1 libcups2 \
libcairo2 libc6-dev linux-libc-dev libatk1.0-0 libx11-xcb-dev libxtst6 libxss-dev libxss1 libgconf-2-4 \
libasound2 libnss3 zlib1g libx11-dev libxkbfile-dev zlib1g-dev"
COPY kitchen /root/kitchen/
ADD cobble.sh /
RUN /bin/bash -c '. /cobble.sh'
RUN rm /cobble.sh
ENTRYPOINT /bin/bash -c '. /root/kitchen/steps/bootstrap.sh'
