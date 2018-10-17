#!/bin/bash

echo "Setting ARCHIE_HOME";
export ARCHIE_HOME=$HOME;

echo "Initializing environment for [${ARCHIE_STRATEGY}/${ARCHIE_ARCH}]";
. $ARCHIE_HOME/kitchen/env/setup.sh;

if [ "${ARCHIE_STRATEGY}" == "hybrid" ] || [ "${ARCHIE_STRATEGY}" == "emulate" ]; then

  echo "Creating cleanroom [$ARCHIE_CLEANROOM_DIRECTORY]";
  mkdir "$ARCHIE_CLEANROOM_DIRECTORY";
  
  echo "Updating APT";
  apt-get update -yq;
  
  echo "Installing wget, qemu-user-static and binfmt-support for prebootstrap";
  apt-get install -y wget qemu-user-static binfmt-support;
  
  echo "Downloading rootfs from prebootstrap for [${ARCHIE_STRATEGY}] image";
  wget -c "https://github.com/headmelted/prebootstrap/releases/download/Oct-18/prebootstrap_stretch_minbase_${ARCHIE_ARCH}_rootfs.tar.gz" -O - | tar -xz -C "${ARCHIE_CLEANROOM_DIRECTORY}/";
  
  echo "Copying QEMU-${ARCHIE_QEMU_ARCH}-static into jail";
  cp "/usr/bin/qemu-${ARCHIE_QEMU_ARCH}-static" "${ARCHIE_CLEANROOM_DIRECTORY}/usr/bin";
  
fi
