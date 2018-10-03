#!/bin/bash
	
export COBBLER_STRATEGY=$1;
export COBBLER_ARCH=$2;
. ./kitchen/env/linux/setup.sh;
