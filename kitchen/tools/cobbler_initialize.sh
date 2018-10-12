#!/bin/bash

echo "Setting COBBLER_HOME";
export COBBLER_HOME=$HOME;

echo "Initializing environment for [${COBBLER_STRATEGY}/${COBBLER_ARCH}]";
. $COBBLER_HOME/kitchen/env/setup.sh;

if [ "${COBBLER_STRATEGY}" == "hybrid" ] || [ "${COBBLER_STRATEGY}" == "emulate" ]; then
  echo "Downloading rootfs from prebootstrap for [${COBBLER_STRATEGY}] image";
  wget -c "https://github.com/headmelted/prebootstrap/releases/download/Oct-18/prebootstrap_stretch_minbase_${COBBLER_ARCH}_rootfs.tar.gz" -O - | sudo tar -xz -C /root/jail/
fi
