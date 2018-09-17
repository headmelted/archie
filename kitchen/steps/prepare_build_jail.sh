#!/bin/bash
set -e;

# Call build_target_jail for the cleanroom
. ~/kitchen/steps/build_target_jail.sh "$COBBLER_CLEANROOM_DIRECTORY";

echo "Entering [$COBBLER_ARCH] jail";
chroot $COBBLER_CLEANROOM_DIRECTORY && \

echo "Entering kitchen" && \
cd /home/kitchen && \

echo "Setting environment" && \
. ./env/linux/setup.sh && \

echo "Updating [$COBBLER_ARCH] jail packages" && \
apt-get update -yq && \

echo "Installing standard and dependency packages" && \
apt-get install -y curl gnupg git pkg-config libsecret-1-dev libglib2.0-dev software-properties-common xvfb wget python curl zip p7zip-full rpm graphicsmagick libwww-perl libxml-libxml-perl libxml-sax-expat-perl \
dpkg-dev perl libconfig-inifiles-perl libxml-simple-perl liblocale-gettext-perl libdpkg-perl libconfig-auto-perl libdebian-dpkgcross-perl ucf debconf dpkg-cross tree \
libx11-dev libxkbfile-dev zlib1g-dev libc6-dev ${cobbler_dependency_packages} && \

echo "Exiting chroot environment";

echo "Entering jail directory (WITHOUT chroot)";
cd kitchen;

echo "Checking presence of NVM";
. ./env/setup_nvm.sh;

echo "Build jail is ready";
