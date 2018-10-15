#!/bin/bash
set -e;

echo "Staging for [$ARCHIE_STRATEGY]";

 # if [ "$ARCHIE_STRATEGY" == "hybrid" ] || [ "$ARCHIE_STRATEGY" == "emulate" ] ; then

    #echo "Updating package sources"
    #apt-get update -yq;

    #echo "Installing apt-utils in isolation";
    #apt-get install -y apt-utils;

    #echo "Installing base Archie dependencies";
    #apt-get install -y debootstrap fakechroot fakeroot proot qemu qemu-user-static;
    
    #echo "Creating [$ARCHIE_CLEANROOM_ROOT_DIRECTORY]";
    #mkdir "$ARCHIE_CLEANROOM_ROOT_DIRECTORY";

    #echo "Creating [$ARCHIE_CLEANROOM_RELEASE_DIRECTORY]";  
    #mkdir "$ARCHIE_CLEANROOM_RELEASE_DIRECTORY";

    #echo "Creating [$ARCHIE_CLEANROOM_DIRECTORY]";
    #mkdir "$ARCHIE_CLEANROOM_DIRECTORY";
    
    #echo "Using debootstrap --foreign to create rootfs for [$ARCHIE_ARCH] jail"
    #fakeroot debootstrap --foreign --verbose --arch=$ARCHIE_ARCH --variant=minbase $ARCHIE_OS_RELEASE_NAME $ARCHIE_CLEANROOM_DIRECTORY;

    #echo "Copying static QEMU (using the Resin.IO patched version - ToDo: ADD REFERENCE IN README) for [$ARCHIE_QEMU_ARCH] into [$ARCHIE_ARCH] jail";
    #cp ~/kitchen/qemu-$ARCHIE_QEMU_ARCH-static $ARCHIE_CLEANROOM_DIRECTORY/usr/bin/;
   
    #echo "Copying static QEMU for [$ARCHIE_QEMU_ARCH] into [$ARCHIE_ARCH] jail";
    #cp /usr/bin/qemu-$ARCHIE_QEMU_ARCH-static $ARCHIE_CLEANROOM_DIRECTORY/usr/bin/;
    
    #echo "Marking static [$ARCHIE_CLEANROOM_DIRECTORY/usr/bin/qemu-$ARCHIE_QEMU_ARCH-static] as executable";
    #chmod +x $ARCHIE_CLEANROOM_DIRECTORY/usr/bin/qemu-$ARCHIE_QEMU_ARCH-static;
    
    #echo "Displaying binfmts";
    #update-binfmts --display;
    
    #echo "Enabling binfmts";
    #update-binfmts --enable qemu-$ARCHIE_QEMU_ARCH-static;
    
    #echo "Manually installing qemu-$ARCHIE_QEMU_ARCH binfmt";
    #mv ~/kitchen/qemu-binfmts/$ARCHIE_QEMU_ARCH /usr/share/binfmts/qemu-$ARCHIE_QEMU_ARCH;
    
    #echo "Installing binfmt-support";
    #update-binfmts --import;

    #echo "Creating kitchen directory inside cleanroom user /home";
    #mkdir $ARCHIE_CLEANROOM_DIRECTORY/home/kitchen;
  
  #fi;
  
  echo "Making sure bootstrap_prepare.sh is executable for next stage";
  chmod +x /root/kitchen/steps/bootstrap_prepare.sh;
