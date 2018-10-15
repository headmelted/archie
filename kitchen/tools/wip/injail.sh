#!/bin/bash

if [ ! -d ./.work/jails/$ARCHIE_LABEL/dev ]; then
  echo "Removing existing /dev links";
  rm -rf ./.work/jails/$ARCHIE_LABEL/dev;
  echo "Hard-linking /dev for jail $ARCHIE_LABEL";
  cp -alf /dev ./.work/jails/$ARCHIE_LABEL/dev;
fi;

if [ ! -d ./.work/jails/$ARCHIE_LABEL/proc ]; then
  echo "Removing existing /proc links";
  rm -rf ./.work/jails/$ARCHIE_LABEL/proc;
  echo "Hard-linking /proc for jail $ARCHIE_LABEL";
  cp -alf /proc ./.work/jails/$ARCHIE_LABEL/proc;
  read -p "Press enter to continue";
fi;

echo "Entering jail ./.work/jails/$ARCHIE_LABEL";
chroot ./.work/jails/$ARCHIE_LABEL /bin/bash -c "
  
  echo 'Switching into home directory';
  cd /home/root;
  
  echo 'Setting environment to $ARCHIE_LABEL';
  . ./tools/$ARCHIE_LABEL/env.sh;
  
  $1

";

if [ ! -d ./.work/jails/$ARCHIE_LABEL/dev ]; then
  echo "Removing /dev links";
  rm -rf ./.work/jails/$ARCHIE_LABEL/dev
fi;

if [ ! -d ./.work/jails/$ARCHIE_LABEL/proc ]; then
  echo "Removing /proc links";
  rm -rf ./.work/jails/$ARCHIE_LABEL/proc
fi;
