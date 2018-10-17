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
  
  echo "Installing wget and qemu-user-static for prebootstrap";
  apt-get install -y wget qemu-user-static;
  
  echo "Downloading rootfs from prebootstrap for [${ARCHIE_STRATEGY}] image";
  wget -c "https://github.com/headmelted/prebootstrap/releases/download/Oct-18/prebootstrap_stretch_minbase_${ARCHIE_ARCH}_rootfs.tar.gz" -O - | tar -xz -C "${ARCHIE_CLEANROOM_DIRECTORY}/";
  
  echo "Copying QEMU-${ARCHIE_QEMU_ARCH}-static into jail";
  cp "/usr/bin/qemu-${ARCHIE_QEMU_ARCH}-static" "${ARCHIE_CLEANROOM_DIRECTORY}/usr/bin";
  
  if [ "${ARCHIE_QEMU_INTERCEPTION_MODE}" == "binfmt_misc" ]; then
  
    echo "Binding mounts for [${ARCHIE_ARCH}] cleanroom (for binfmt_misc/chroot method)";
  
    echo "Mounting /dev into cleanroom [$ARCHIE_CLEANROOM_DIRECTORY]";
    mount --bind /dev "$ARCHIE_CLEANROOM_DIRECTORY/dev/";
  
    echo "Mounting /sys into cleanroom [$ARCHIE_CLEANROOM_DIRECTORY]";
    mount --bind /sys "$ARCHIE_CLEANROOM_DIRECTORY/sys/";
  
    echo "Mounting /proc into cleanroom [$ARCHIE_CLEANROOM_DIRECTORY]";
    mount --bind /proc "$ARCHIE_CLEANROOM_DIRECTORY/proc/";
  
    echo "Mounting /dev/pts into cleanroom [$ARCHIE_CLEANROOM_DIRECTORY]";
    mount --bind /dev/pts "$ARCHIE_CLEANROOM_DIRECTORY/dev/pts/";
  
    echo "Mounting /root/kitchen into cleanroom [$ARCHIE_CLEANROOM_DIRECTORY]";
    mount --bind /root/kitchen "$ARCHIE_CLEANROOM_DIRECTORY/home/kitchen/";
    
  fi;
  
fi
