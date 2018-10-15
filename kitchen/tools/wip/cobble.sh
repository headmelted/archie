#!/bin/bash
set -e;

echo "Setting ARCHIE_HOME";
export ARCHIE_HOME=$HOME;

echo "ARCHIE_HOME is $ARCHIE_HOME";

echo "Entering kitchen to setup Archie";
cd ~/kitchen;

echo "Setting environment";
. ./env/linux/setup.sh;
. ./env/linux/display.sh;

#echo "Staging environment";
#. ./steps/stage.sh;

echo "Archie ready for [$ARCHIE_ARCH]";
