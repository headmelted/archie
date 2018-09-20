#!/bin/bash
set -e;

if [ $COBBLER_ARCH == "amd64" ] || [ $COBBLER_STRATEGY == "cross" ]; then

  echo "QEMU not required, preparing environment";
  . ~/kitchen/steps/prepare.sh;

else

  if [ $COBBLER_STRATEGY == "emulate" ]; then
  
    echo "Creating [$COBBLER_CLEANROOM_ROOT_DIRECTORY]";
    mkdir "$COBBLER_CLEANROOM_ROOT_DIRECTORY";

    echo "Creating [$COBBLER_CLEANROOM_RELEASE_DIRECTORY]";  
    mkdir "$COBBLER_CLEANROOM_RELEASE_DIRECTORY";

    echo "Creating [$COBBLER_CLEANROOM_DIRECTORY]";
    mkdir "$COBBLER_CLEANROOM_DIRECTORY";

    echo "Updating package sources"
    apt-get update -yq;

    echo "Installing apt-utils in isolation";
    apt-get install -y apt-utils;

    echo "Installing base Cobbler dependencies";
    apt-get install -y qemu qemu-user-static debootstrap proot;
 
    echo "Using debootstrap --foreign to create rootfs for [$COBBLER_ARCH] jail"
    debootstrap --foreign --verbose --arch=$COBBLER_ARCH --variant=minbase $COBBLER_OS_RELEASE_NAME $COBBLER_CLEANROOM_DIRECTORY;

    echo "Creating kitchen directory inside cleanroom user /home";
    mkdir $COBBLER_CLEANROOM_DIRECTORY/home/kitchen;

    echo "Copying static QEMU for [$COBBLER_QEMU_ARCH] into [$COBBLER_ARCH] jail";
    cp /usr/bin/qemu-$COBBLER_QEMU_ARCH-static $COBBLER_CLEANROOM_DIRECTORY/usr/bin/;

    echo "Entering [$COBBLER_ARCH] jail to complete setup";
    . ~/kitchen/steps/jail.sh /home/kitchen/steps/prepare.sh;
  
  else
  
    echo "ONLY cross AND emulate STRATEGIES ARE CURRENTLY SUPPORTED.";
    exit;
  
  fi;
  
fi;
