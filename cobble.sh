#!/bin/bash
set -e;

echo "Setting COBBLER_HOME";
export COBBLER_HOME=$(pwd);

echo "COBBLER_HOME is $COBBLER_HOME";

echo "Entering kitchen to setup Cobbler";
cd ~/kitchen;

echo "Setting environment";
. ./env/linux/setup.sh;
. ./env/linux/display.sh;

echo "Staging environment";
. ./steps/stage.sh;

echo "Cobbler ready for [$COBBLER_ARCH]";
