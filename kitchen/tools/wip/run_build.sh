#!/bin/bash
set -e;

echo "Starting to cook";

echo "C compiler is ${CC}, C++ compiler is ${CXX}.";

echo "Entering code directory [$ARCHIE_CODE_DIRECTORY]";
cd $ARCHIE_CODE_DIRECTORY;

. ~/kitchen/archie/build.sh;

echo "Build complete";

. ~/kitchen/archie/package.sh;

echo "Packaging complete";
