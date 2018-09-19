#!/bin/bash
set -e;

echo "Setting environment";
. ~/kitchen/env/linux/setup.sh;

if [ "$COBBLER_STRATEGY" == "emulate" ]; then
  echo "We're in an emulated chroot, executing second stage debootstrap";
  /debootstrap/debootstrap --second-stage;
fi;

echo "Updating [$COBBLER_ARCH] jail packages";
apt-get update -yq;

echo "Installing standard and dependency packages";
apt-get install -y curl gnupg git pkg-config libsecret-1-dev libglib2.0-dev software-properties-common xvfb wget python curl zip p7zip-full rpm graphicsmagick libwww-perl libxml-libxml-perl libxml-sax-expat-perl dpkg-dev perl libconfig-inifiles-perl libxml-simple-perl liblocale-gettext-perl libdpkg-perl libconfig-auto-perl libdebian-dpkgcross-perl ucf debconf dpkg-cross tree libx11-dev libxkbfile-dev zlib1g-dev libc6-dev ${COBBLER_DEPENDENCY_PACKAGES};

echo "Checking presence of NVM";
. ~/kitchen/env/setup_nvm.sh;

echo "Environment prepared";
