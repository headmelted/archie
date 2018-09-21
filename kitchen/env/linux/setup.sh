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

export CC="$COBBLER_GNU_TRIPLET-gcc";
export CXX="$COBBLER_GNU_TRIPLET-g++";

if [ $COBBLER_STRATEGY == "cross" ]; then
  export CC="$CC -L /usr/lib/$COBBLER_GNU_TRIPLET/";
  export CXX="$CXX -L /usr/lib/$COBBLER_GNU_TRIPLET/";
else
  if [ "$COBBLER_STRATEGY" == "hybrid" ]; then
    export CC="$CC -L $COBBLER_CLEANROOM_DIRECTORY/usr/lib/$COBBLER_GNU_TRIPLET/";
    export CXX="$CXX --sysroot=$COBBLER_CLEANROOM_DIRECTORY -L $COBBLER_CLEANROOM_DIRECTORY/usr/lib/$COBBLER_GNU_TRIPLET/";
  fi;
fi;

echo "Setting TARGETCC and TARGETCXX to CC and CXX";
export TARGETCC=$CC;
export TARGETCXX=$CXX;
