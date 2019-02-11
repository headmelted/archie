#!/bin/bash
set -e;

#echo "Installing dependencies";
#. /root/kitchen/tools/archie_install_dependencies.sh;

echo "Setting up environment";
. /root/kitchen/env/setup.sh;

echo "Entering build directory";
cd /root/build;

echo "Marking build script as executable";
chmod +x $ARCHIE_HOME/build/build.sh;

echo "Running build script";
. build.sh;
