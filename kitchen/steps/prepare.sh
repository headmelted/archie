#!/bin/bash
set -e;

echo "Setting environment";
. ~/kitchen/env/linux/setup.sh;

if [ "$COBBLER_STRATEGY" == "emulate" ]; then

  echo "We're in an emulated chroot, executing second stage debootstrap";
  /debootstrap/debootstrap --second-stage;

fi;

echo "Updating [$COBBLER_ARCH] packages";
apt-get update -yq;

if [ "$COBBLER_STRATEGY" == "cross" ]; then
  
  echo "Adding cross-compilation target of [$COBBLER_ARCH]";
  dpkg --add-architecture $COBBLER_ARCH;
  
  echo "Updating APT";
  apt-get update;
 
  if [ "$COBBLER_ARCH" != "amd64" ] && [ "$COBBLER_ARCH" != "i386" ]; then packages_to_install="crossbuild-essential-$COBBLER_ARCH"; fi;
  
fi;

echo "Preparing to install dependencies";
if [ "$COBBLER_STRATEGY" == "cross" ] || [ "$COBBLER_STRATEGY" == "emulate" ] || [ "$COBBLER_STRATEGY" == "virtualize" ]; then
  packages_to_install="$packages_to_install $COBBLER_HOST_DEPENDENCIES";
fi;

for cobbler_dependency_package in $COBBLER_TARGET_DEPENDENCIES; do
  if [ "$COBBLER_STRATEGY" == "cross" ] || [ "$COBBLER_STRATEGY" == "hybrid" ]; then
    cobbler_dependency_package="$cobbler_dependency_package:$COBBLER_ARCH";
  fi;
  packages_to_install="$packages_to_install $cobbler_dependency_package";
done;

echo "Packages to install:";
echo $packages_to_install;
  
echo "Installing dependency packages";
apt-get install -y tree $packages_to_install;

echo "[$HOME] is where the ♥ is";

echo "Environment prepared";
