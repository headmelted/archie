#!/bin/bash

echo "Setting Cobbler environment for all architectures"
export COBBLER_OS_DISTRIBUTION_NAME=debian
export COBBLER_OS_RELEASE_NAME=stretch
export COBBLER_CLEANROOM_ROOT_DIRECTORY=/kitchen/cleanroom;
export COBBLER_CLEANROOM_RELEASE_DIRECTORY=$COBBLER_CLEANROOM_ROOT_DIRECTORY/$COBBLER_OS_RELEASE_NAME;
export COBBLER_CLEANROOM_DIRECTORY=$COBBLER_CLEANROOM_RELEASE_DIRECTORY/$COBBLER_ARCH;
export COBBLER_BUILDS_DIRECTORY=$COBBLER_CLEANROOM_DIRECTORY/builds;
export COBBLER_CODE_DIRECTORY=$COBBLER_BUILDS_DIRECTORY/code;
export COBBLER_QEMU_TEST_METHOD=user;
export HOSTCXX='x86_64-linux-gnu-g++';
export HOSTCC='x86_64-linux-gnu-gcc';
export RUNLEVEL=1; # Needed for binfmt-support

echo "Setting Cobbler environment for [$COBBLER_ARCH]"
. ./env/linux/$COBBLER_ARCH.sh
