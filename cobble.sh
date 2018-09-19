#!/bin/bash
set -e;

echo "Entering kitchen to setup Cobbler";
cd /root/kitchen;

echo "Marking all files in kitchen executable (this directory should contain scripts and executables only!)";
chmod +x /root/kitchen/**/*;

echo "Setting environment";
. ./env/linux/setup.sh;
. ./env/linux/display.sh;

if [ "$COBBLER_ARCH" != "amd64" ]
then
  cobbler_cross_architectures="$COBBLER_ARCH";
  if [ "$COBBLER_ARCH" != "i386" ]
  then
    cobbler_foreign_architectures="$COBBLER_ARCH";
  fi
fi

cobbler_packages_to_install="gcc-$COBBLER_GNU_TRIPLET g++-$COBBLER_GNU_TRIPLET"

for cobbler_cross_architecture in $cobbler_cross_architectures; do cobbler_packages_to_install="$cobbler_packages_to_install \
crossbuild-essential-$cobbler_cross_architecture"; done

echo "Updating package sources"
apt-get update -yq;

echo "Installing apt-utils in isolation";
apt-get install -y apt-utils;

echo "Installing base Cobbler dependencies";
apt-get install -y qemu qemu-user-static debootstrap proot;

echo "Create the jail";
. ./steps/build_target_jail.sh;

#echo "Adding yarn signing key"
#curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -

#echo "Adding yarn repository"
#echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

echo "Cobbler ready for [$COBBLER_ARCH]";
