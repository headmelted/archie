#!/bin/bash
set -e;

#echo "Setting environment";
#. ~/kitchen/env/linux/setup.sh;

echo "Checking for $COBBLER_GIT_ENDPOINT";
if [ "$COBBLER_GIT_ENDPOINT" != "" ]; then
  echo "Cobbler is pointed at a git endpoint";
  cobbler_get_sources;
else
  echo "Cobbler is not pointed at a git endpoint, assuming the current project is the one to build";
fi;

build_command="cd $COBBLER_CODE_DIRECTORY && cobbler_install_dependencies && . /build.sh"

if [ "$COBBLER_STRATEGY" == "emulate" ]; then
  echo "Entering jail to start build in new bash shell";
  cobbler_jail /bin/bash -c "$build_command";
else
  echo "Starting build in new bash shell";
  /bin/bash -c "$build_command";
fi;
