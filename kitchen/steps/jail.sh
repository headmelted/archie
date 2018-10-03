#!/bin/bash
set -e;

echo "Listing capabilities:"
echo "capsh --print | grep "Current:" | cut -d' ' -f3";

if [ "${COBBLER_QEMU_INTERCEPTION_MODE}" == "binfmt_misc" ]; then
  echo "Mounting [${COBBLER_ARCH}] cleanroom (for binfmt_misc/chroot method)";
  current_directory=$(pwd);
  cd "$COBBLER_CLEANROOM_DIRECTORY";
  sudo mount --bind /dev dev/
  sudo mount --bind /sys sys/
  sudo mount --bind /proc proc/
  sudo mount --bind /dev/pts dev/pts/
  sudo mount --bind /root/kitchen home/kitchen
  cd "$current_directory";
  echo "Executing command in [$COBBLER_ARCH] cleanroom (with binfmt_misc/chroot method)";
  sudo chroot $COBBLER_CLEANROOM_DIRECTORY "$@";
elif [ "${COBBLER_QEMU_INTERCEPTION_MODE}" == "ptrace" ]; then
  echo "Executing command in [$COBBLER_ARCH] cleanroom (with proot method)";
  proot -b /root/kitchen:/home/kitchen -R $COBBLER_CLEANROOM_DIRECTORY -q qemu-$COBBLER_QEMU_ARCH-static "$@";
fi

#echo "Testing fakechroot at ($COBBLER_CLEANROOM_DIRECTORY)";
#fakechroot fakeroot chroot $COBBLER_CLEANROOM_DIRECTORY /usr/bin/qemu-$COBBLER_QEMU_ARCH-static -L $COBBLER_CLEANROOM_DIRECTORY pwd;

#echo "Entering [$COBBLER_ARCH] cleanroom ($COBBLER_CLEANROOM_DIRECTORY) to debug fakeroot";
#fakechroot fakeroot chroot $COBBLER_CLEANROOM_DIRECTORY /usr/bin/qemu-$COBBLER_QEMU_ARCH-static -L $COBBLER_CLEANROOM_DIRECTORY -D ~/kitchen/qemu.log readelf -d /bin/bash

#echo "Entering [$COBBLER_ARCH] cleanroom ($COBBLER_CLEANROOM_DIRECTORY) via (fakeroot) to execute command";
#fakechroot fakeroot /usr/sbin/chroot $COBBLER_CLEANROOM_DIRECTORY /usr/bin/qemu-$COBBLER_QEMU_ARCH-static -L $COBBLER_CLEANROOM_DIRECTORY -D ~/kitchen/qemu.log /bin/bash -c "$@";

#echo "QEMU log:"
#cat ~/kitchen/qemu.log
