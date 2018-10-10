#!/bin/bash
set -e;

echo "Starting to cook";

echo "C compiler is ${CC}, C++ compiler is ${CXX}.";

echo "Entering code directory [$COBBLER_CODE_DIRECTORY]";
cd $COBBLER_CODE_DIRECTORY;

. ~/kitchen/cobbler/build.sh;

echo "Build complete";

. ~/kitchen/cobbler/package.sh;

echo "Packaging complete";
