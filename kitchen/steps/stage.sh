#!/bin/bash
set -e;

echo "Staging for [$COBBLER_STRATEGY]";

  if [ "$COBBLER_STRATEGY" == "hybrid" ] || [ "$COBBLER_STRATEGY" == "emulate" ] ; then

    echo "Updating package sources"
    apt-get update -yq;

    echo "Installing apt-utils in isolation";
    apt-get install -y apt-utils;

    echo "Installing base Cobbler dependencies";
    apt-get install -y debootstrap fakechroot fakeroot proot qemu qemu-$COBBLER_QEMU_PACKAGE_ARCH-static;
    
    echo "Creating [$COBBLER_CLEANROOM_ROOT_DIRECTORY]";
    mkdir "$COBBLER_CLEANROOM_ROOT_DIRECTORY";

    echo "Creating [$COBBLER_CLEANROOM_RELEASE_DIRECTORY]";  
    mkdir "$COBBLER_CLEANROOM_RELEASE_DIRECTORY";

    echo "Creating [$COBBLER_CLEANROOM_DIRECTORY]";
    mkdir "$COBBLER_CLEANROOM_DIRECTORY";
    
    echo "Using debootstrap --foreign to create rootfs for [$COBBLER_ARCH] jail"
    fakeroot debootstrap --foreign --verbose --arch=$COBBLER_ARCH --variant=minbase $COBBLER_OS_RELEASE_NAME $COBBLER_CLEANROOM_DIRECTORY;

    #echo "Copying static QEMU (using the Resin.IO patched version - ToDo: ADD REFERENCE IN README) for [$COBBLER_QEMU_ARCH] into [$COBBLER_ARCH] jail";
    #cp ~/kitchen/qemu-$COBBLER_QEMU_ARCH-static $COBBLER_CLEANROOM_DIRECTORY/usr/bin/;
   
    echo "Copying static QEMU for [$COBBLER_QEMU_ARCH] into [$COBBLER_ARCH] jail";
    cp /usr/bin/qemu-$COBBLER_QEMU_ARCH-static $COBBLER_CLEANROOM_DIRECTORY/usr/bin/;
    
    echo "Marking static [$COBBLER_CLEANROOM_DIRECTORY/usr/bin/qemu-$COBBLER_QEMU_ARCH-static] as executable";
    chmod +x $COBBLER_CLEANROOM_DIRECTORY/usr/bin/qemu-$COBBLER_QEMU_ARCH-static;
    
    #echo "Displaying binfmts";
    #update-binfmts --display;
    
    #echo "Enabling binfmts";
    #update-binfmts --enable qemu-$COBBLER_QEMU_ARCH-static;
    
    #echo "Manually installing qemu-$COBBLER_QEMU_ARCH binfmt";
    #mv ~/kitchen/qemu-binfmts/$COBBLER_QEMU_ARCH /usr/share/binfmts/qemu-$COBBLER_QEMU_ARCH;
    
    #echo "Installing binfmt-support";
    #update-binfmts --import;

    echo "Creating kitchen directory inside cleanroom user /home";
    mkdir $COBBLER_CLEANROOM_DIRECTORY/home/kitchen;
  
  fi;
  
  echo "Making sure bootstrap_prepare.sh is executable for next stage";
  chmod +x /root/kitchen/steps/bootstrap_prepare.sh;
