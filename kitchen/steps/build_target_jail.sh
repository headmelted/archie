#!/bin/bash
set -e;

echo "Creating [$COBBLER_ARCH] jail at [$1]";
mkdir $1;

if [ $COBBLER_ARCH == "amd64" ]; then

  echo "QEMU not required, ignoring jail request";

else

  echo "Using QEMU debootstrap to create jail"
  qemu-debootstrap --arch=$COBBLER_ARCH --variant=minbase stretch "$1";

  echo "Copying QEMU userland emulator into jail";
  cp /usr/bin/qemu-$COBBLER_QEMU_ARCH-static "$1/usr/bin";

  echo "Mounting kitchen scripts inside [$COBBLER_ARCH] jail"
  mount --bind ~/kitchen $1/home/kitchen;

fi;