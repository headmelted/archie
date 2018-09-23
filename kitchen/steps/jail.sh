#!/bin/bash
set -e;

#echo "Entering [$COBBLER_ARCH] cleanroom (proot) to execute command";
#proot -b /root/kitchen:/home/kitchen -R $COBBLER_CLEANROOM_DIRECTORY -q qemu-$COBBLER_QEMU_ARCH-static "$@";

fakeroot fakechroot chroot $COBBLER_CLEANROOM_DIRECTORY "$@"
