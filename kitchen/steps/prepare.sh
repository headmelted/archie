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

if [ "$COBBLER_STRATEGY" == "cross" ]; then
  
  echo "Adding cross-compilation target of [$COBBLER_ARCH]";
  dpkg --add-architecture $COBBLER_ARCH;
  
  packages_to_install="crossbuild-essential-$COBBLER_ARCH";
  
fi;

echo "Preparing to install dependencies";
if [ "$COBBLER_STRATEGY" == "cross" ] || [ "$COBBLER_STRATEGY" == "emulate" ] || [ "$COBBLER_STRATEGY" == "virtualize" ]; then
  packages_to_install="$packages_to_install $COBBLER_HOST_DEPENDENCIES";
fi;

for cobbler_dependency_package in $COBBLER_TARGET_DEPENDENCIES; do
  if [ "$COBBLER_STRATEGY" == "cross" ] || [ "$COBBLER_STRATEGY" == "hybrid" ]; then
    $cobbler_dependency_package="$cobbler_dependency_package:$COBBLER_ARCH";
  fi;
  packages_to_install="$packages_to_install $cobbler_dependency_package";
done;
  
echo "Installing dependency packages";
apt-get install -y $packages_to_install;

echo "Checking presence of NVM";
. ~/kitchen/env/setup_nvm.sh;

echo "Environment prepared";
