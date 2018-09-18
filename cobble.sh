#!/bin/bash
set -e;

echo "Entering kitchen to setup Cobbler";
cd /root/kitchen;

echo "Setting environment";
. ./env/linux/setup.sh;

if [ "$COBBLER_ARCH" != "amd64" ]
then
  cobbler_cross_architectures="$COBBLER_ARCH";
  if [ "$COBBLER_ARCH" != "i386" ]
  then
    cobbler_foreign_architectures="$COBBLER_ARCH";
  fi
fi

echo "-------------------------------------------------------------"
echo "| Environment Summary"
echo "-------------------------------------------------------------"
echo "Target architecture: $COBBLER_ARCH"; 
echo "Non-native target architectures: $cobbler_foreign_architectures";
echo "Cross-compile architectures: $cobbler_cross_architectures";
echo "QEMU architectures: $COBBLER_QEMU_ARCH";
echo "QEMU system emulator set: qemu-system-$COBBLER_QEMU_PACKAGE_ARCH";
echo "C compilers (gcc-): $COBBLER_GNU_TRIPLET";
echo "C++ compilers (gpp-): $COBBLER_GNU_TRIPLET";
echo "-------------------------------------------------------------"

cobbler_packages_to_install="gcc-$COBBLER_GNU_TRIPLET g++-$COBBLER_GNU_TRIPLET"

for cobbler_cross_architecture in $cobbler_cross_architectures; do cobbler_packages_to_install="$cobbler_packages_to_install \
crossbuild-essential-$cobbler_cross_architecture"; done

echo "Updating package sources"
apt-get update -yq;

echo "Installing apt-utils in isolation";
apt-get install -y apt-utils;

echo "Installing base Cobbler dependencies";
apt-get install -y qemu qemu-user-static binfmt-support debootstrap;

echo "Calling binfmts display";
update-binfmts --display;

cobbler_dependency_packages="libgtk2.0-0 libxkbfile-dev 
libx11-dev libxdmcp-dev libdbus-1-3 libpcre3 libselinux1 libp11-kit0 libcomerr2 libk5crypto3 
libkrb5-3 libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 libxcursor1 libxfixes3 libfreetype6 libavahi-client3 
libgssapi-krb5-2 libtiff5 fontconfig-config libgdk-pixbuf2.0-common libgdk-pixbuf2.0-0 libfontconfig1 libcups2 
libcairo2 libc6-dev linux-libc-dev libatk1.0-0 libx11-xcb-dev libxtst6 libxss-dev libxss1 libgconf-2-4 
libasound2 libnss3 zlib1g";

echo "Dependency package install list: ${cobbler_dependency_packages}"

#echo "Adding yarn signing key"
#curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -

#echo "Adding yarn repository"
#echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

echo "Creating [$COBBLER_CLEANROOM_ROOT_DIRECTORY]";
mkdir "$COBBLER_CLEANROOM_ROOT_DIRECTORY";

echo "Creating [$COBBLER_CLEANROOM_RELEASE_DIRECTORY]";
mkdir "$COBBLER_CLEANROOM_RELEASE_DIRECTORY";

echo "Creating [$COBBLER_CLEANROOM_DIRECTORY]";
mkdir "$COBBLER_CLEANROOM_DIRECTORY";

echo "Updating $CC AND $CXX to use [$COBBLER_ARCH] dependencies";
export CC="$CC -L $COBBLER_CLEANROOM_DIRECTORY/usr/lib/$COBBLER_GNU_TRIPLET/";
export CXX="$CXX -L $COBBLER_CLEANROOM_DIRECTORY/usr/lib/$COBBLER_GNU_TRIPLET/";

echo "Ready to cook";
