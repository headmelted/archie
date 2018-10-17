#!/bin/bash
set -e;

#echo "Kernel capabilities "
#echo "capsh --print | grep "Current:" | cut -d' ' -f3";

if [ "${ARCHIE_QEMU_INTERCEPTION_MODE}" == "binfmt_misc" ]; then
  echo "Executing command in [$ARCHIE_ARCH] cleanroom (with binfmt_misc/chroot method)";
  chroot $ARCHIE_CLEANROOM_DIRECTORY echo "chroot:[$(uname -a)]" && "$@" && echo "chroot:[$(uname -a)]";
elif [ "${ARCHIE_QEMU_INTERCEPTION_MODE}" == "ptrace" ]; then
  echo "Executing command in [$ARCHIE_ARCH] cleanroom (with proot method)";
  proot -b /root/kitchen:/home/kitchen -R $ARCHIE_CLEANROOM_DIRECTORY -q qemu-$ARCHIE_QEMU_ARCH-static "$@";
fi

#echo "Testing fakechroot at ($ARCHIE_CLEANROOM_DIRECTORY)";
#fakechroot fakeroot chroot $ARCHIE_CLEANROOM_DIRECTORY /usr/bin/qemu-$ARCHIE_QEMU_ARCH-static -L $ARCHIE_CLEANROOM_DIRECTORY pwd;

#echo "Entering [$ARCHIE_ARCH] cleanroom ($ARCHIE_CLEANROOM_DIRECTORY) to debug fakeroot";
#fakechroot fakeroot chroot $ARCHIE_CLEANROOM_DIRECTORY /usr/bin/qemu-$ARCHIE_QEMU_ARCH-static -L $ARCHIE_CLEANROOM_DIRECTORY -D ~/kitchen/qemu.log readelf -d /bin/bash

#echo "Entering [$ARCHIE_ARCH] cleanroom ($ARCHIE_CLEANROOM_DIRECTORY) via (fakeroot) to execute command";
#fakechroot fakeroot /usr/sbin/chroot $ARCHIE_CLEANROOM_DIRECTORY /usr/bin/qemu-$ARCHIE_QEMU_ARCH-static -L $ARCHIE_CLEANROOM_DIRECTORY -D ~/kitchen/qemu.log /bin/bash -c "$@";

#echo "QEMU log:"
#cat ~/kitchen/qemu.log
