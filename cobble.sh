#!/bin/bash
set -e;

echo "Entering kitchen to setup Cobbler";
cd ~/kitchen;

echo "Marking all files in kitchen executable (this directory should contain scripts and executables only!)";
chmod +x ~/kitchen/**/*;

echo "Setting environment";
. ./env/linux/setup.sh;
. ./env/linux/display.sh;

echo "Staging environment";
. ./steps/stage.sh;

echo "Cobbler ready for [$COBBLER_ARCH]";
