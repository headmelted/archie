#!/bin/bash
set -e;

echo "Staging for [$COBBLER_STRATEGY]";

  if [ "$COBBLER_STRATEGY" == "hybrid" ] || [ "$COBBLER_STRATEGY" == "emulate" ] ; then

    echo "Updating package sources"
    apt-get update -yq;

    echo "Installing apt-utils in isolation";
    apt-get install -y apt-utils;

    echo "Installing base Cobbler dependencies";
    apt-get install -y qemu qemu-user-static debootstrap fakechroot fakeroot;
    
    echo "Creating [$COBBLER_CLEANROOM_ROOT_DIRECTORY]";
    mkdir "$COBBLER_CLEANROOM_ROOT_DIRECTORY";

    echo "Creating [$COBBLER_CLEANROOM_RELEASE_DIRECTORY]";  
    mkdir "$COBBLER_CLEANROOM_RELEASE_DIRECTORY";

    echo "Creating [$COBBLER_CLEANROOM_DIRECTORY]";
    mkdir "$COBBLER_CLEANROOM_DIRECTORY";
    
    echo "Using debootstrap --foreign to create rootfs for [$COBBLER_ARCH] jail"
    fakeroot debootstrap --foreign --verbose --arch=$COBBLER_ARCH --variant=minbase $COBBLER_OS_RELEASE_NAME $COBBLER_CLEANROOM_DIRECTORY;

    echo "Copying static QEMU for [$COBBLER_QEMU_ARCH] into [$COBBLER_ARCH] jail";
    cp /usr/bin/qemu-$COBBLER_QEMU_ARCH-static $COBBLER_CLEANROOM_DIRECTORY/usr/bin/;
    
    echo "Attempting to setup binfmt support inside jail";
    fakechroot fakeroot chroot /tmp/sid apt-get install -q hello
    
    echo "Creating kitchen directory inside cleanroom user /home";
    mkdir $COBBLER_CLEANROOM_DIRECTORY/home/kitchen;
  
  fi;
  
if [ "$COBBLER_STRATEGY" == "emulate" ] ; then

    echo "Entering [$COBBLER_ARCH] jail to complete setup";
    . ~/kitchen/steps/jail.sh /home/kitchen/steps/prepare.sh;
    
else

  # For hybrid strategy, QEMU actually *will* be required, but not at this stage.
  # (Only package installation is performed inside QEMU, compilation happens outside of it).
  echo "QEMU not required, preparing environment";
  . ~/kitchen/steps/prepare.sh;

fi;
