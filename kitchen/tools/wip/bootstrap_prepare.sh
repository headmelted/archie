#!/bin/bash
set -e;

if [ "$ARCHIE_STRATEGY" == "emulate" ] ; then

    echo "Entering [$ARCHIE_ARCH] jail to complete setup";
    . ~/kitchen/steps/jail.sh /home/kitchen/steps/install_dependencies.sh;
    
else

  # For hybrid strategy, QEMU actually *will* be required, but not at this stage.
  # (Only package installation is performed inside QEMU, compilation happens outside of it).
  echo "QEMU not required, preparing environment";
  . ~/kitchen/steps/install_dependencies.sh;

fi;
