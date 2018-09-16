#!/bin/bash

echo "Setting Cobbler environment for all architectures"
export COBBLER_OS_DISTRIBUTION_NAME=ubuntu
export COBBLER_OS_RELEASE_NAME=cosmic
export COBBLER_ROOT_DIRECTORY=/kitchen;
export COBBLER_BUILDS_DIRECTORY=$ROOT_DIRECTORY/.builds/${COBBLER_ARCH};
export COBBLER_CODE_DIRECTORY=$BUILDS_DIRECTORY/.code;
export COBBLER_QEMU_TEST_METHOD=rootfs;

echo "Setting Cobbler environment for [$COBBLER_ARCH]"
. ./env/linux/$COBBLER_ARCH.sh
