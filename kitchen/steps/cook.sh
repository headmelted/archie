#!/bin/bash
set -e;

echo "Creating .cache folder if it does not exist";
if [[ ! -d ../.cache ]]; then mkdir ../.cache; fi

echo "Setting environment for $1";
. ./env/linux/$1.sh;

echo "cobble.sh is run at docker build time now, so skipping here"
# echo "Initializing cobbler for ${ARCH}";
# . ../../cobble.sh;

echo "Checking presence of NVM";
. ./env/setup_nvm.sh;

export ROOT_DIRECTORY=$(pwd);
export BUILDS_DIRECTORY=$ROOT_DIRECTORY/.builds/$1;
export CODE_DIRECTORY=$BUILDS_DIRECTORY/.code;

echo "Creating .builds folders if they do not exist";
if [[ ! -d .builds ]]; then mkdir .builds; fi;
if [[ ! -d $BUILDS_DIRECTORY ]]; then mkdir $BUILDS_DIRECTORY; fi;
if [[ ! -d $CODE_DIRECTORY ]]; then mkdir $CODE_DIRECTORY; fi;

echo "Preparing recipe";
for i in "${@:2}"; do
  echo "Entering code directory [$CODE_DIRECTORY]";
  cd $CODE_DIRECTORY;
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
