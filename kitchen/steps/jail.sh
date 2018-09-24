#!/bin/bash
set -e;

#echo "Entering [$COBBLER_ARCH] cleanroom (proot) to execute command";
#proot -b /root/kitchen:/home/kitchen -R $COBBLER_CLEANROOM_DIRECTORY -q qemu-$COBBLER_QEMU_ARCH-static "$@";

echo "Entering [$COBBLER_ARCH] cleanroom ($COBBLER_CLEANROOM_DIRECTORY) via (fakeroot) to execute command";
fakechroot fakeroot chroot $COBBLER_CLEANROOM_DIRECTORY /usr/bin/qemu-$COBBLER_QEMU_ARCH-static /bin/bash -c "$@";
