#!/bin/bash
set -e;

echo "Call modprobe";
/sbin/modprobe binfmt_misc;
exit;

echo "Entering kitchen to setup Cobbler";
cd /root/kitchen;

echo "Marking all files in kitchen executable (this directory should contain scripts and executables only!)";
chmod +x /root/kitchen/**/*;

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
apt-get install -y qemu qemu-user-static debootstrap;
 
echo "Using QEMU debootstrap to create jail"
qemu-debootstrap --verbose --arch=$COBBLER_ARCH --variant=minbase stretch cleanroom;

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

echo "Ready to cook";
