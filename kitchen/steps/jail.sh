#!/bin/bash

#echo "Entering [$COBBLER_ARCH] cleanroom (proot) to execute command";
#proot -b /root/kitchen:/home/kitchen -R $COBBLER_CLEANROOM_DIRECTORY -q qemu-$COBBLER_QEMU_ARCH-static "$@";

echo "Chroot is at: $(which chroot) lets see";

echo "Testing fakechroot at ($COBBLER_CLEANROOM_DIRECTORY)";
fakechroot fakeroot chroot $COBBLER_CLEANROOM_DIRECTORY pwd;

echo "Entering [$COBBLER_ARCH] cleanroom ($COBBLER_CLEANROOM_DIRECTORY) to debug fakeroot";
fakechroot fakeroot chroot $COBBLER_CLEANROOM_DIRECTORY /usr/bin/qemu-$COBBLER_QEMU_ARCH-static -D ~/kitchen/qemu.log readelf -d /bin/bash

echo "QEMU log:"
cat ~/kitchen/qemu.log

echo "Entering [$COBBLER_ARCH] cleanroom ($COBBLER_CLEANROOM_DIRECTORY) via (fakeroot) to execute command";
fakechroot fakeroot /usr/sbin/chroot $COBBLER_CLEANROOM_DIRECTORY /usr/bin/qemu-$COBBLER_QEMU_ARCH-static /bin/bash -c "$@";
