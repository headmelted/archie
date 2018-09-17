#!/bin/bash
set -e;

echo "Setting environment";
. ~/kitchen/env/linux/setup.sh;

. ~/kitchen/steps/get.sh;
. ~/kitchen/steps/patch.sh;

. ~/kitchen/steps/prepare_build_jail.sh "$COBBLER_CLEANROOM_DIRECTORY";

echo "Entering cleanroom (chroot)";
chroot $COBBLER_CLEANROOM_DIRECTORY;

echo "Starting to cook";

echo "C compiler is ${CC}, C++ compiler is ${CXX}."

echo "Entering code directory [~/kitchen/build/output/code]";
cd ~/kitchen/build/output/code;

. ~/kitchen/cobbler/build.sh;

# echo "Preparing recipe";
# for i in "${@:1}"; do
#   echo "Entering code directory [~/kitchen/build/output/code]";
#   cd ~/kitchen/build/output/code;
#   echo "Executing step [$i]";
#   if [[ -f /cobbler/steps/$i.sh ]]; then
#     echo "Executing PROJECT step [$i]";
#     . /cobbler/steps/$i.sh;
#   else
#     echo "Executing KITCHEN step [$i]";
#     . /kitchen/steps/$i.sh;
#   fi;
#   echo "Returning to root directory [$COBBLER_CLEANROOM_ROOT_DIRECTORY]";
#   cd $COBBLER_CLEANROOM_ROOT_DIRECTORY;
# done

echo "All steps complete";