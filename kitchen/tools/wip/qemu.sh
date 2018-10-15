#!/bin/bash
set -e;

if [ ! -d "./.jail" ]; then

  echo "Installing QEMU and dependencies";
  apt-get install -y debootstrap qemu-user-static binfmt-support sbuild;

  echo "Reading proc";
  ls /proc/sys/fs/;

  echo "Creating $ARCHIE_ARCH jail";
  mkdir ./.jail;

  echo "Creating debootstrap";
  debootstrap --foreign --no-check-gpg --include=fakeroot,build-essential --arch=$ARCHIE_ARCH jessie ./.jail ${QEMU_ARCHIVE}

  echo "Copying static qemu into jail";
  cp /usr/bin/qemu-${QEMU_ARCH}-static ./.jail/usr/bin/

  echo "Switching into jail";
  chroot ./.jail ./debootstrap/debootstrap --second-stage;
  
  echo "Creating jailed workspace";
  mkdir ./.jail/workspace;

  echo "Mounting workspace into jail";
  mount --bind /workspace ./.jail/workspace;

  echo "Updating jail APT";  
  chroot ./.jail apt-get update;
  
else

  echo "Jail for ${QEMU_ARCH} has already been created.";
  
fi;

echo "Setting environment variables";
cp ./tools/environments/${LABEL}.sh ./.jail/workspace/.env.sh;
chmod a+x ./.jail/workspace/.env.sh;

echo "Executing script ($1) in jail";
chroot ./.jail bash -c "cd /workspace && ./.env.sh && echo 'Environment: \$(uname -a)' && echo 'Listing workspace in jail...' && ls /workspace && $1";

# echo "Mounting binfmt_misc";
# mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc;
  
# echo "Enabling binfmt_misc";
# echo 1 > /proc/sys/fs/binfmt_misc/status;

# echo "Enabling ${QEMU_ARCH} emulator";
# update-binfmts --enable qemu-${QEMU_ARCH};

