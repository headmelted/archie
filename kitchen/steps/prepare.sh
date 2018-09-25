#!/bin/bash
set -e;

echo "Setting COBBLER_HOME";
export COBBLER_HOME=$HOME;

echo "COBBLER_HOME is $COBBLER_HOME";

echo "Setting environment";
. ~/kitchen/env/linux/setup.sh;

#if [ "$COBBLER_STRATEGY" == "emulate" ] ; then

  #echo "We're in an emulated chroot, executing second stage debootstrap";
  #/debootstrap/debootstrap --second-stage;
  
#else

#  if [ "$COBBLER_STRATEGY" == "hybrid" ] ; then
  
#    echo "Using hybrid strategy, attempt to enter jail to execute second stage debootstrap";
#    . ~/kitchen/steps/jail.sh /debootstrap/debootstrap --second-stage;
    
#  fi;

#fi;

if [ "$COBBLER_STRATEGY" == "cross" ] || [ "$COBBLER_STRATEGY" == "hybrid" ] ; then
  
  echo "Adding cross-compilation target of [$COBBLER_ARCH]";
  dpkg --add-architecture $COBBLER_ARCH;
 
  if [ "$COBBLER_ARCH" != "amd64" ] && [ "$COBBLER_ARCH" != "i386" ] ; then packages_to_install="crossbuild-essential-$COBBLER_ARCH"; fi;
 
  echo "Updating $[COBBLER_ARCH] packages";
  apt-get update -yq;
  
fi;

echo "Preparing to install dependencies";
packages_to_install="$packages_to_install $COBBLER_HOST_DEPENDENCIES";

for cobbler_dependency_package in $COBBLER_TARGET_DEPENDENCIES; do
  if [ "$COBBLER_STRATEGY" == "cross" ] ; then
    cobbler_dependency_package="$cobbler_dependency_package:$COBBLER_ARCH";
  fi;
  packages_to_install="$packages_to_install $cobbler_dependency_package";
done;

echo "Packages to install:";
echo $packages_to_install;
  
if [ "$COBBLER_STRATEGY" == "cross" ] || [ "$COBBLER_STRATEGY" == "virtualize" ] ; then
  echo "Installing dependency packages";
  apt-get install -y $packages_to_install;
else
  echo "Installing dependency packages in jail for [$COBBLER_ARCH]";
  . ~/kitchen/steps/jail.sh apt-get install -y $packages_to_install;
fi;

echo "[$HOME] is where the ♥ is";

echo "Environment prepared";
