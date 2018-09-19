#!/bin/bash
set -e;

echo "Entering [$COBBLER_ARCH] cleanroom (proot) to execute command";
proot -r $COBBLER_CLEANROOM_DIRECTORY -q qemu-$COBBLER_QEMU_ARCH-static "$@";
