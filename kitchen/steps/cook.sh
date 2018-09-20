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

if [ "$COBBLER_STRATEGY" == "emulate" ]; then
  echo "Entering jail to start build";
  . ~/kitchen/steps/jail.sh /home/kitchen/cobbler/build.sh;
else
  echo "Starting build";
  . /home/kitchen/cobbler/build.sh;
fi;

echo "All steps complete";
