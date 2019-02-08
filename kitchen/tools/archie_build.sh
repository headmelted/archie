#!/bin/bash
set -e;

echo "Installing dependencies";
. /root/kitchen/tools/archie_install_dependencies.sh;

echo "Setting up environment";
. /root/kitchen/env/setup.sh;

echo "Running build script";
. /root/build/build.sh;
