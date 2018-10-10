#!/bin/bash

if [ ! -d ./.work/jails/$COBBLER_LABEL/dev ]; then
  echo "Removing existing /dev links";
  rm -rf ./.work/jails/$COBBLER_LABEL/dev;
  echo "Hard-linking /dev for jail $COBBLER_LABEL";
  cp -alf /dev ./.work/jails/$COBBLER_LABEL/dev;
fi;

if [ ! -d ./.work/jails/$COBBLER_LABEL/proc ]; then
  echo "Removing existing /proc links";
  rm -rf ./.work/jails/$COBBLER_LABEL/proc;
  echo "Hard-linking /proc for jail $COBBLER_LABEL";
  cp -alf /proc ./.work/jails/$COBBLER_LABEL/proc;
  read -p "Press enter to continue";
fi;

echo "Entering jail ./.work/jails/$COBBLER_LABEL";
chroot ./.work/jails/$COBBLER_LABEL /bin/bash -c "
  
  echo 'Switching into home directory';
  cd /home/root;
  
  echo 'Setting environment to $COBBLER_LABEL';
  . ./tools/$COBBLER_LABEL/env.sh;
  
  $1

";

if [ ! -d ./.work/jails/$COBBLER_LABEL/dev ]; then
  echo "Removing /dev links";
  rm -rf ./.work/jails/$COBBLER_LABEL/dev
fi;

if [ ! -d ./.work/jails/$COBBLER_LABEL/proc ]; then
  echo "Removing /proc links";
  rm -rf ./.work/jails/$COBBLER_LABEL/proc
fi;
