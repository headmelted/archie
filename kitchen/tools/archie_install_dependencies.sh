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

echo "Preparing to install host dependencies";
host_packages_to_install="$packages_to_install $ARCHIE_HOST_DEPENDENCIES";

echo "Preparing to install target dependencies";
for archie_dependency_package in $ARCHIE_TARGET_DEPENDENCIES; do
  if [ "$ARCHIE_STRATEGY" == "cross" ] ; then
    archie_dependency_package="$archie_dependency_package:$ARCHIE_ARCH";
  fi;
  target_packages_to_install="$target_packages_to_install $archie_dependency_package";
done;

echo "Host packages to install ------------------";
echo $host_packages_to_install;
echo "Target packages to install ----------------";
echo $target_packages_to_install;
echo "-------------------------------------------";
  
if [ "$ARCHIE_STRATEGY" == "cross" ] || [ "$ARCHIE_STRATEGY" == "virtualize" ] ; then
  echo "Installing host and target dependency packages";
  apt-get install -y $host_packages_to_install $target_packages_to_install;
elif [ "$ARCHIE_STRATEGY" == "hybrid" ] ; then
  echo "Installing host dependency packages for [hybrid]";
  apt-get install -y $host_packages_to_install;
  echo "Installing target dependency packages in jail for [hybrid]";
  $ARCHIE_HOME/kitchen/tools/archie_jail.sh apt-get install -y $target_packages_to_install;
elif [ "$ARCHIE_STRATEGY" == "emulate" ] ; then
  echo "Installing host and target dependency packages in jail for [$ARCHIE_ARCH]";
  $ARCHIE_HOME/kitchen/tools/archie_jail.sh apt-get install -y $host_packages_to_install $target_packages_to_install;
fi;

echo "[$HOME] is where the ♥ is";

echo "Dependencies installed";

. $ARCHIE_HOME/kitchen/env/linux/display.sh;
