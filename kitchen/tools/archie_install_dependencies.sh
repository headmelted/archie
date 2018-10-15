#!/bin/bash
set -e;

echo "Setting ARCHIE_HOME";
export ARCHIE_HOME=$HOME;

echo "ARCHIE_HOME is $ARCHIE_HOME";

if [ "$ARCHIE_ARCH" == "amd64" ] || [ "$ARCHIE_ARCH" == "i386" ]; then
  echo "Installing base gcc and g++ for amd64";
  packages_to_install="gcc g++";
  if [ "$ARCHIE_ARCH" == "i386" ] ; then packages_to_install="$packages_to_install g++-multilib"; fi;
else
  echo "Installing [$ARCHIE_GNU_TRIPLET] gcc and g++";
  packages_to_install="gcc-$ARCHIE_GNU_TRIPLET g++-$ARCHIE_GNU_TRIPLET dpkg-cross";
fi;

if [ "$ARCHIE_ARCH" != "amd64" ] && [ "$ARCHIE_STRATEGY" == "cross" ] ; then
  echo "Adding cross-compilation target of [$ARCHIE_ARCH]";
  dpkg --add-architecture $ARCHIE_ARCH;
fi;

echo "Updating APT caches prior to dependency installation";
apt-get update -yq;

echo "Preparing to install dependencies";
packages_to_install="$packages_to_install $ARCHIE_HOST_DEPENDENCIES";

for archie_dependency_package in $ARCHIE_TARGET_DEPENDENCIES; do
  if [ "$ARCHIE_STRATEGY" == "cross" ] ; then
    archie_dependency_package="$archie_dependency_package:$ARCHIE_ARCH";
  fi;
  packages_to_install="$packages_to_install $archie_dependency_package";
done;

echo "Packages to install:";
echo $packages_to_install;
  
if [ "$ARCHIE_STRATEGY" == "cross" ] || [ "$ARCHIE_STRATEGY" == "virtualize" ] ; then
  echo "Installing dependency packages";
  apt-get install -y $packages_to_install;
else
  echo "Installing dependency packages in jail for [$ARCHIE_ARCH]";
  $ARCHIE_HOME/kitchen/env/linux/archie_jail.sh apt-get install -y $packages_to_install;
fi;

echo "[$HOME] is where the ♥ is";

echo "Dependencies installed";

. $ARCHIE_HOME/kitchen/env/linux/display.sh;
