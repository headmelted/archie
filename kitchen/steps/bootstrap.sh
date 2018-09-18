#!/bin/bash
set -e;

~/kitchen/steps/prepare_build_jail.sh "$COBBLER_CLEANROOM_DIRECTORY";

echo "Starting compilation inside build jail";
chroot "$COBBLER_CLEANROOM_DIRECTORY" ~/kitchen/steps/cook.sh
