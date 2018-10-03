#!/bin/bash
	
export COBBLER_STRATEGY=$1;
export COBBLER_ARCH=$2;

echo "Initializing environment for ${COBBLER_STRATEGY}-${COBBLER_ARCH}";
. ./kitchen/env/linux/setup.sh;
