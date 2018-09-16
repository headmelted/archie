#!/bin/bash

echo "Passed label [$1]";
if [ "$1" == "" ]; then LABEL="amd64_linux"; else LABEL=$1; fi;

echo "Setting environment";
. ./env/linux/setup.sh;

export CXX="${GPP_COMPILER} --sysroot=$(pwd)/rootfs -L$(pwd)/rootfs/usr/lib/${GNU_TRIPLET} -I$(pwd)/rootfs/usr/include/libsecret-1 -I$(pwd)/rootfs/usr/include/glib-2.0 -I$(pwd)/rootfs/usr/lib/${GNU_TRIPLET}/glib-2.0/include" CC="${GCC_COMPILER}" DEBIAN_FRONTEND="noninteractive";
echo "C compiler is ${CC}, C++ compiler is ${CXX}."
    
export PKG_CONFIG_PATH="$(pwd)/rootfs/usr/share/pkgconfig:$(pwd)/rootfs/usr/lib/arm-linux-gnueabihf/pkgconfig"
export npm_config_target="$(grep target vscode/.yarnrc | sed 's/[^0-9.]*//g')"
    
echo "Installing dependencies";
. ./tools/environment.sh;

if [ "${LABEL}" == "" ]; then
  echo "Failed to load environment: '$1'.  Check it exists.";
  return -1;
else
  echo "Environment [$1] loaded succesfully.";
fi;

echo "Installing nvm for user";
. ./tools/setup_nvm.sh;
