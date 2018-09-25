#!/bin/bash
set -e;
  
echo "Setting COBBLER_HOME";
export $COBBLER_HOME=$(pwd);

if [ "$COBBLER_STRATEGY" == "emulate" ] ; then

    echo "Entering [$COBBLER_ARCH] jail to complete setup";
    . ~/kitchen/steps/jail.sh /home/kitchen/steps/prepare.sh;
    
else

  # For hybrid strategy, QEMU actually *will* be required, but not at this stage.
  # (Only package installation is performed inside QEMU, compilation happens outside of it).
  echo "QEMU not required, preparing environment";
  . ~/kitchen/steps/prepare.sh;

fi;
