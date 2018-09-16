#!/bin/bash
set -e;

echo "Setting environment to [$COBBLER_ARCH] again, as we should now be inside the CI session."
. ./env/linux/$COBBLER_ARCH.sh;

echo "Starting to cook";

echo "C compiler is ${CC}, C++ compiler is ${CXX}.";

echo "Preparing recipe";
for i in "${@:1}"; do
  echo "Entering code directory [$COBBLER_CODE_DIRECTORY]";
  cd $COBBLER_CODE_DIRECTORY;
  echo "Executing step [$i]";
  if [[ -f /cobbler/steps/$i.sh ]]; then
    echo "Executing PROJECT step [$i]";
    . /cobbler/steps/$i.sh;
  else
    echo "Executing KITCHEN step [$i]";
    . /kitchen/steps/$i.sh;
  fi;
  echo "Returning to root directory [$ROOT_DIRECTORY]";
  cd $ROOT_DIRECTORY;
done

echo "All steps complete";
