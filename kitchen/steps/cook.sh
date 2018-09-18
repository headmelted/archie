#!/bin/bash
set -e;

echo "Setting environment";
. ~/kitchen/env/linux/setup.sh;

echo "Checking for $COBBLER_GIT_ENDPOINT";
if [ "$COBBLER_GIT_ENDPOINT" != "" ]; then
  echo "Cobbler is pointed at a git endpoint";
  . ~/kitchen/steps/get.sh;
  . ~/kitchen/steps/patch.sh;
else
  echo "Cobbler is not pointed at a git endpoint, assuming the current project is the one to build";
fi;

echo "Starting to cook";
echo "C compiler is ${CC}, C++ compiler is ${CXX}.";

echo "Entering code directory [$COBBLER_CODE_DIRECTORY]";
cd "$COBBLER_CODE_DIRECTORY";

. ~/kitchen/cobbler/build.sh;

echo "All steps complete";
