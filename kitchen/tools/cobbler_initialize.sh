#!/bin/bash

echo "Setting COBBLER_HOME";
export COBBLER_HOME=$HOME;

echo "Initializing environment for [${COBBLER_DOCKER_TAG}]";
. $COBBLER_HOME/kitchen/env/setup.sh;

if [ "${COBBLER_STRATEGY}" == "hybrid" ] || [ "${COBBLER_STRATEGY}" == "emulate" ]; then
  echo "Downloading rootfs from prebootstrap for [${COBBLER_STRATEGY}] image";
  wget -c "https://github.com/headmelted/prebootstrap/releases/download/Oct-18/prebootstrap_stretch_minbase_${COBBLER_ARCH}_rootfs.tar.gz" -O - | sudo tar -xz -C /root/jail/
fi

echo "Updating APT caches"
apt-get update -yq;

echo "Ensuring git is installed";
apt-get install -y git;

. $COBBLER_HOME/kitchen/env/linux/display.sh;
