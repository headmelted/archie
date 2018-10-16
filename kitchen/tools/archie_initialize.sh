#!/bin/bash

echo "Setting ARCHIE_HOME";
export ARCHIE_HOME=$HOME;

echo "Initializing environment for [${ARCHIE_STRATEGY}/${ARCHIE_ARCH}]";
. $ARCHIE_HOME/kitchen/env/setup.sh;

if [ "${ARCHIE_STRATEGY}" == "hybrid" ] || [ "${ARCHIE_STRATEGY}" == "emulate" ]; then
  echo "Updating APT";
  apt-get update -yq;
  echo "Installing wget for prebootstrap";
  apt-get install -y wget;
  echo "Creating /root/jail directory";
  mkdir /root/jail;
  echo "Downloading rootfs from prebootstrap for [${ARCHIE_STRATEGY}] image";
  wget -c "https://github.com/headmelted/prebootstrap/releases/download/Oct-18/prebootstrap_stretch_minbase_${ARCHIE_ARCH}_rootfs.tar.gz" -O - | tar -xz -C /root/jail/
fi
