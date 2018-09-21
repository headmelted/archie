#!/bin/bash

COBBLER_TAG_SETTINGS=(${COBBLER_DOCKER_TAG//-/ });

echo "Setting Cobbler environment for all architectures";
export COBBLER_STRATEGY=${COBBLER_TAG_SETTINGS[0]};
export COBBLER_ARCH=${COBBLER_TAG_SETTINGS[1]};
export COBBLER_OS_DISTRIBUTION_NAME=debian;
export COBBLER_OS_RELEASE_NAME=stretch;

echo "Setting cleanroom paths";
export COBBLER_CLEANROOM_ROOT_DIRECTORY=/root/kitchen/cleanroom;
export COBBLER_CLEANROOM_RELEASE_DIRECTORY=$COBBLER_CLEANROOM_ROOT_DIRECTORY/$COBBLER_OS_RELEASE_NAME;
export COBBLER_CLEANROOM_DIRECTORY=$COBBLER_CLEANROOM_RELEASE_DIRECTORY/$COBBLER_ARCH;

echo "Setting code and output paths";
export COBBLER_OUTPUT_DIRECTORY=~/output;
export COBBLER_CODE_DIRECTORY=~/code;

echo "Setting compile-time helpers";
export HOSTCXX='x86_64-linux-gnu-g++';
export HOSTCC='x86_64-linux-gnu-gcc';
export npm_config_arch=x64;

echo "Setting Cobbler environment for [$COBBLER_ARCH]"
. ~/kitchen/env/linux/$COBBLER_ARCH.sh;

echo "Setting compiler configuration for [$COBBLER_STRATEGY]";

COBBLER_CROSS_LIB_PATH="/usr/lib/$COBBLER_GNU_TRIPLET";

pkg_config_path=""
linkage_list=""

if [ $COBBLER_STRATEGY == "cross" ]; then
  linkage_list="-L $COBBLER_CROSS_LIB_PATH/";
  pkg_config_path="/usr/share/pkgconfig:$COBBLER_CROSS_LIB_PATH/pkgconfig";
  for package in $COBBLER_TARGET_DEPENDENCIES; do
    linkage_list="$linkage_list -I/usr/lib/$COBBLER_GNU_TRIPLET/$package/include -I/usr/include/$package -I/usr/include/$COBBLER_GNU_TRIPLET"
  done
else
  if [ "$COBBLER_STRATEGY" == "hybrid" ]; then
    linkage_list="--sysroot=$COBBLER_CLEANROOM_DIRECTORY -L $COBBLER_CLEANROOM_DIRECTORY$COBBLER_CROSS_LIB_PATH/"
    pkg_config_path="$COBBLER_CLEANROOM_DIRECTORY/usr/share/pkgconfig:$COBBLER_CLEANROOM_DIRECTORY$COBBLER_CROSS_LIB_PATH/pkgconfig";
    for package in $COBBLER_TARGET_DEPENDENCIES; do
      linkage_list=" -I$COBBLER_CLEANROOM_DIRECTORY/usr/include/$package -I$COBBLER_CLEANROOM_DIRECTORY/usr/lib/$COBBLER_GNU_TRIPLET/$package/include -I$COBBLER_CLEANROOM_DIRECTORY/usr/include/$COBBLER_GNU_TRIPLET"
    done
  else
    echo "TODO: OTHER STRATEGY LINKING";
  fi;
fi;

echo "Setting CC and CXX with linking for [$COBBLER_STRATEGY]";
export CC="$COBBLER_GNU_TRIPLET-gcc $linkage_list";
export CXX="$COBBLER_GNU_TRIPLET-g++ $linkage_list";

echo "Setting package config path";
export PKG_CONFIG_PATH=$pkg_config_path;

echo "Setting TARGETCC and TARGETCXX to CC and CXX";
export TARGETCC=$CC;
export TARGETCXX=$CXX;

echo "CC is [$COBBLER_GNU_TRIPLET-gcc]";
echo "CXX is [$COBBLER_GNU_TRIPLET-g++]";

echo "Linking Options ----------------------------------------------"
echo $linkage_list;
echo "--------------------------------------------------------------"
