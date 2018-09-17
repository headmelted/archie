#!/bin/bash

echo "Setting Cobbler environment for all architectures"
export COBBLER_OS_DISTRIBUTION_NAME=debian
export COBBLER_OS_RELEASE_NAME=stretch
export COBBLER_CLEANROOM_DIRECTORY=/kitchen/cleanroom;
export COBBLER_BUILDS_DIRECTORY=$COBBLER_CLEANROOM_DIRECTORY/rootfs/$COBBLER_OS_RELEASE_NAME/$COBBLER_ARCH/builds;
export COBBLER_CODE_DIRECTORY=$COBBLER_BUILDS_DIRECTORY/code;
export COBBLER_QEMU_TEST_METHOD=user;
export HOSTCXX='x86_64-linux-gnu-g++';
export HOSTCC='x86_64-linux-gnu-gcc';

echo "Setting Cobbler environment for [$COBBLER_ARCH]"
. ./env/linux/$COBBLER_ARCH.sh
