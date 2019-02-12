#!/bin/bash
set -e;

echo "Setting ARCHIE_HOME";
export ARCHIE_HOME=$HOME;

echo "ARCHIE_HOME is $ARCHIE_HOME";

echo "Initializing environment for [${ARCHIE_STRATEGY}/${ARCHIE_ARCH}]";
. $ARCHIE_HOME/kitchen/env/setup.sh;

if [ "$ARCHIE_ARCH" == "amd64" ] || [ "$ARCHIE_ARCH" == "i386" ] || [ "$ARCHIE_STRATEGY" == "emulate" ]; then
  echo "Installing base gcc and g++ for [$ARHCHIE_ARCH] with [$ARCHIE_STRATEGY] strategy";
  packages_to_install="gcc g++ build-essential";
  if [ "$ARCHIE_ARCH" == "i386" ] ; then packages_to_install="$packages_to_install g++-multilib"; fi;
else
  echo "Installing [$ARCHIE_GNU_TRIPLET] gcc and g++";
  packages_to_install="gcc-$ARCHIE_GNU_TRIPLET g++-$ARCHIE_GNU_TRIPLET dpkg-cross";
fi;

if [ "$ARCHIE_ARCH" != "amd64" ] && ( [ "$ARCHIE_STRATEGY" == "cross" ] || [ "$ARCHIE_STRATEGY" == "hybrid" ] ) ; then
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
  
if [ "$ARCHIE_STRATEGY" == "cross" ] || [ "$ARCHIE_STRATEGY" == "emulate" ] ; then
  echo "Installing host and target dependency packages";
  apt-get install -y ${host_packages_to_install//[$'\t\r\n']} ${target_packages_to_install//[$'\t\r\n']};
  if [ -f /root/build/archie_custom_host_dependencies.sh ]; then
    echo 'Installing custom host dependencies';
    . /root/build/archie_custom_host_dependencies.sh;
  fi;
  if [ -f /root/build/archie_custom_target_dependencies.sh ]; then
    echo 'Installing custom target dependencies';
    . /root/build/archie_custom_target_dependencies.sh;
  fi;
elif [ "$ARCHIE_STRATEGY" == "hybrid" ] ; then
  echo "Installing host dependency packages for [hybrid]";
  apt-get install -y $host_packages_to_install;
  if [ -f /root/build/archie_custom_host_dependencies.sh ]; then
    echo 'Installing custom host dependencies';
    . /root/build/archie_custom_host_dependencies.sh;
  fi;
  echo "Installing target dependency packages in jail for [hybrid]";
  . /root/kitchen/tools/archie_jail.sh "apt-get install -y ${ARCHIE_HOST_DEPENDENCIES//[$'\t\r\n']} ${target_packages_to_install//[$'\t\r\n']} && if [ -f /root/build/archie_custom_target_dependencies.sh ]; then echo 'Installing custom target dependencies in jail'; . /root/build/archie_custom_target_dependencies.sh; fi;";
fi;

echo "[$HOME] is where the ♥ is";

echo "Dependencies installed";

. /root/kitchen/env/linux/display.sh;
