#!/bin/bash
set -e;

echo "Entering cleanroom (chroot) to execute [$1]";
chroot "$COBBLER_CLEANROOM_DIRECTORY" "$1";
