#!/bin/bash

echo "Setting Cobbler environment for all architectures";
export COBBLER_QEMU_TEST_METHOD=user;
export COBBLER_OS_DISTRIBUTION_NAME=debian;
export COBBLER_OS_RELEASE_NAME=stretch;

echo "Setting cleanroom paths";
export COBBLER_CLEANROOM_ROOT_DIRECTORY=/root/kitchen/cleanroom;
export COBBLER_CLEANROOM_RELEASE_DIRECTORY=$COBBLER_CLEANROOM_ROOT_DIRECTORY/$COBBLER_OS_RELEASE_NAME;
export COBBLER_CLEANROOM_DIRECTORY=$COBBLER_CLEANROOM_RELEASE_DIRECTORY/$COBBLER_ARCH;

echo "Setting kitchen paths";
export COBBLER_KITCHEN_DIRECTORY=~/kitchen;
export COBBLER_BUILD_DIRECTORY=$COBBLER_KITCHEN_DIRECTORY/build;
export COBBLER_OUTPUT_DIRECTORY=$COBBLER_BUILD_DIRECTORY/output;
export COBBLER_CODE_DIRECTORY=$COBBLER_BUILD_DIRECTORY/code;

echo "Setting compile-time helpers";
export HOSTCXX='x86_64-linux-gnu-g++';
export HOSTCC='x86_64-linux-gnu-gcc';
export npm_config_arch=x64;

echo "Setting Cobbler environment for [$COBBLER_ARCH]"
. ./env/linux/$COBBLER_ARCH.sh;

echo "Setting TARGETCC and TARGETCXX to CC and CXX";
export TARGETCC=$CC;
export TARGETCXX=$CXX;
