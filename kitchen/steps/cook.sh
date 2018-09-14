#!/bin/bash
set -e;

echo "Starting to cook";

echo "C compiler is ${CC}, C++ compiler is ${CXX}.";

echo "Preparing recipe";
for i in "${@:1}"; do
  echo "Entering code directory [$CODE_DIRECTORY]";
  cd $CODE_DIRECTORY;
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
