FROM ubuntu:xenial
WORKDIR /workspace

RUN echo "Adding architectures supported by cobbler"
RUN dpkg --add-architecture armhf
RUN dpkg --add-architecture arm64

RUN echo "Adding ubuntu ports for multiarch packages"
ADD cobbler.list /etc/apt.sources.list.d/cobbler.list;

echo "Binding all unfiltered repositories to intel";
sed -i 's/deb http/deb [arch=amd64,i386] http/g' /etc/apt/sources.list;
sed -i 's/deb http/deb [arch=amd64,i386] http/g' /etc/apt/sources.list.d/*.list;

RUN apt-get install -y \
software-properties-common xvfb wget git python curl zip p7zip-full \
rpm graphicsmagick libwww-perl libxml-libxml-perl libxml-sax-expat-perl \
dpkg-dev perl libconfig-inifiles-perl libxml-simple-perl \
liblocale-gettext-perl libdpkg-perl libconfig-auto-perl \
libdebian-dpkgcross-perl ucf debconf dpkg-cross \
zlib1g-dev qemu binfmt-support qemu-user-static \
gcc-arm-linux-gnueabihf \
g++-arm-linux-gnueabihf \
libc6-armhf-cross \
libstdc++6-armhf-cross \
crossbuild-essential-armhf \
libgtk2.0-0:armhf \
libxkbfile-dev:armhf \
libx11-dev:armhf \
libxdmcp-dev:armhf \
libdbus-1-3:armhf \
libpcre3:armhf \
libselinux1:armhf \
libp11-kit0:armhf \
libcomerr2:armhf \
libk5crypto3:armhf \
libkrb5-3:armhf \
libpango-1.0-0:armhf \
libpangocairo-1.0-0:armhf \
libpangoft2-1.0-0:armhf \
libxcursor1:armhf \
libxfixes3:armhf \
libfreetype6:armhf \
libavahi-client3:armhf \
libgssapi-krb5-2:armhf \
libjpeg8:armhf \
libtiff5:armhf \
fontconfig-config \
libgdk-pixbuf2.0-common \
libgdk-pixbuf2.0-0:armhf \
libfontconfig1:armhf \
libcups2:armhf \
libcairo2:armhf \
libc6-dev:armhf \
libatk1.0-0:armhf \
libx11-xcb-dev:armhf \
libxtst6:armhf \
libxss-dev:armhf \
libgconf-2-4:armhf \
libasound2:armhf \
libnss3:armhf \
zlib1g:armhf \
gcc-aarch64-linux-gnu \
g++-aarch64-linux-gnu \
libc6-arm64-cross \
libstdc++6-arm64-cross \
crossbuild-essential-arm64 \
libgtk2.0-0:arm64 \
libxkbfile-dev:arm64 \
libx11-dev:arm64 \
libxdmcp-dev:arm64 \
libdbus-1-3:arm64 \
libpcre3:arm64 \
libselinux1:arm64 \
libp11-kit0:arm64 \
libcomerr2:arm64 \
libk5crypto3:arm64 \
libkrb5-3:arm64 \
libpango-1.0-0:arm64 \
libpangocairo-1.0-0:arm64 \
libpangoft2-1.0-0:arm64 \
libxcursor1:arm64 \
libxfixes3:arm64 \
libfreetype6:arm64 \
libavahi-client3:arm64 \
libgssapi-krb5-2:arm64 \
libjpeg8:arm64 \
libtiff5:arm64 \
fontconfig-config \
libgdk-pixbuf2.0-common \
libgdk-pixbuf2.0-0:arm64 \
libfontconfig1:arm64 \
libcups2:arm64 \
libcairo2:arm64 \
libc6-dev:arm64 \
libatk1.0-0:arm64 \
libx11-xcb-dev:arm64 \
libxtst6:arm64 \
libxss-dev:arm64 \
libgconf-2-4:arm64 \
libasound2:arm64 \
libnss3:arm64 \
zlib1g:arm64;

RUN apt-get update -yq
