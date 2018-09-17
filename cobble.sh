#!/bin/bash

echo "Entering the kitchen";
cd /kitchen;

echo "Setting environment";
. ./env/linux/setup.sh;

if [ "$COBBLER_ARCH" != "amd64" ]
then
  cobbler_cross_architectures="$COBBLER_ARCH";
  if [ "$COBBLER_ARCH" != "i386" ]
  then
    cobbler_foreign_architectures="$COBBLER_ARCH";
  fi
fi

# if [ "$COBBLER_ARCH" == "arm64" ]
# then
#   cobbler_qemu_architectures="aarch64";
# else
#   cobbler_qemu_architectures="$COBBLER_ARCH";
# fi

# case $COBBLER_ARCH in
# "amd64")
#   cobbler_foreign_triplets="x86-64-linux-gnu";
#   qemu_package_architecture="x86";
#   ;;
# "i386")
#   cobbler_foreign_triplets="i686-linux-gnu";
#   qemu_package_architecture="x86";
#   ;;
# "armhf")
#   cobbler_foreign_triplets="arm-linux-gnueabihf";
#   qemu_package_architecture="arm";
#   ;;
# "arm64")
#   cobbler_foreign_triplets="aarch64-linux-gnu";
#   qemu_package_architecture="arm";
#   ;;
# "ppc64el")
#   cobbler_foreign_triplets="powerpc64le-linux-gnu";
#   qemu_package_architecture="ppc";
#   ;;
# "s390x")
#   cobbler_foreign_triplets="s390x-linux-gnu";
#   qemu_package_architecture="s390x";
#   ;;
# esac

echo "-------------------------------------------------------------"
echo "| Environment Summary"
echo "-------------------------------------------------------------"
echo "| Target architecture: $COBBLER_ARCH"; 
echo "| Non-native target architectures: $cobbler_foreign_architectures";
echo "| Cross-compile architectures: $cobbler_cross_architectures";
echo "| QEMU architectures: $COBBLER_QEMU_ARCH";
echo "| QEMU system emulator set: qemu-system-$COBBLER_QEMU_PACKAGE_ARCH";
echo "| C compilers (gcc-): $COBBLER_GNU_TRIPLET";
echo "| C++ compilers (gpp-): $COBBLER_GNU_TRIPLET";
echo "-------------------------------------------------------------"

cobbler_packages_to_install="gcc-$COBBLER_GNU_TRIPLET g++-$COBBLER_GNU_TRIPLET"

for cobbler_cross_architecture in $cobbler_cross_architectures; do cobbler_packages_to_install="$cobbler_packages_to_install \
crossbuild-essential-$cobbler_cross_architecture"; done

for arch in $cobbler_foreign_architectures; do cobbler_packages_to_install="$cobbler_packages_to_install libgtk2.0-0:$COBBLER_ARCH libxkbfile-dev:$COBBLER_ARCH \
libx11-dev:$COBBLER_ARCH libxdmcp-dev:$COBBLER_ARCH libdbus-1-3:$COBBLER_ARCH libpcre3:$COBBLER_ARCH libselinux1:$COBBLER_ARCH libp11-kit0:$COBBLER_ARCH libcomerr2:$COBBLER_ARCH libk5crypto3:$COBBLER_ARCH \
libkrb5-3:$COBBLER_ARCH libpango-1.0-0:$COBBLER_ARCH libpangocairo-1.0-0:$COBBLER_ARCH libpangoft2-1.0-0:$COBBLER_ARCH libxcursor1:$COBBLER_ARCH libxfixes3:$COBBLER_ARCH libfreetype6:$COBBLER_ARCH libavahi-client3:$COBBLER_ARCH \
libgssapi-krb5-2:$COBBLER_ARCH libtiff5:$COBBLER_ARCH fontconfig-config libgdk-pixbuf2.0-common libgdk-pixbuf2.0-0:$COBBLER_ARCH libfontconfig1:$COBBLER_ARCH libcups2:$COBBLER_ARCH \
libcairo2:$COBBLER_ARCH libc6-dev:$COBBLER_ARCH linux-libc-dev:$COBBLER_ARCH libatk1.0-0:$COBBLER_ARCH libx11-xcb-dev:$COBBLER_ARCH libxtst6:$COBBLER_ARCH libxss-dev:$COBBLER_ARCH libxss1:$COBBLER_ARCH libgconf-2-4:$COBBLER_ARCH \
libasound2:$COBBLER_ARCH libnss3:$COBBLER_ARCH zlib1g:$COBBLER_ARCH"; done

echo "Package install list: ${cobbler_packages_to_install}"

echo "Adding architectures supported by cobbler"
for arch in $cobbler_foreign_architectures; do dpkg --add-architecture $COBBLER_ARCH; done

#dpkg --add-architecture $COBBLER_ARCH;

#echo "Adding yarn signing key"
#curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -

#echo "Adding yarn repository"
#echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

#echo "Adding emdebian signing key"
#curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add -

#echo "Resetting ubuntu package lists"
#echo "deb http://emdebian.org/tools/debian/ unstable main" | tee /etc/apt/sources.list.d/cobbler.list;
#echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ cosmic main universe multiverse restricted" | tee /etc/apt/sources.list.d/cobbler.list;
#echo "deb [arch=amd64,i386] http://security.ubuntu.com/ubuntu/ cosmic-security main universe multiverse restricted" | tee -a /etc/apt/sources.list.d/cobbler.list;
#echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ cosmic-updates main universe multiverse restricted" | tee -a /etc/apt/sources.list.d/cobbler.list;
#echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ cosmic-backports main universe multiverse restricted" | tee -a /etc/apt/sources.list.d/cobbler.list;

#cobbler_architectures_ports_list="${cobbler_foreign_architectures// /,}"

cobbler_architectures_ports_list=$cobbler_foreign_architectures;

#echo "Checking for ports list [${cobbler_architectures_ports_list}]...";
#if [ -n "${cobbler_architectures_ports_list}" ]; then
#  echo "Adding ports list [${cobbler_architectures_ports_list}]...";
#  echo "deb [arch=$cobbler_architectures_ports_list] http://ports.ubuntu.com/ubuntu-ports cosmic main universe multiverse restricted" | tee -a /etc/apt/sources.list.d/cobbler.list;
#  echo "deb [arch=$cobbler_architectures_ports_list] http://ports.ubuntu.com/ubuntu-ports cosmic-security main universe multiverse restricted" | tee -a /etc/apt/sources.list.d/cobbler.list;
#  echo "deb [arch=$cobbler_architectures_ports_list] http://ports.ubuntu.com/ubuntu-ports cosmic-updates main universe multiverse restricted" | tee -a /etc/apt/sources.list.d/cobbler.list;
#  echo "deb [arch=$cobbler_architectures_ports_list] http://ports.ubuntu.com/ubuntu-ports cosmic-backports main universe multiverse restricted" | tee -a /etc/apt/sources.list.d/cobbler.list;
#fi;

#echo "cobbler.list now looks like this:"
cat /etc/apt/sources.list.d/cobbler.list;

#echo "Deleting original packages sources"
#rm /etc/apt/sources.list;
cat /etc/apt/sources.list;

echo "Updating package sources"
apt-get update -yq;

#echo "Binding all unfiltered repositories to intel";
#sed -i 's/deb http/deb [arch=amd64,i386] http/g' /etc/apt/sources.list;
#find /etc/apt/sources.list.d/ -name '*.list' -print0 | xargs -0 -I {} -P 0 sed -i 's/deb http/deb [arch=amd64,i386] http/g' {}

#echo "Updating package sources"
# apt-get update -yq;

echo "Installing packages"
apt-get install -y curl gnupg git qemu qemu-user-static binfmt-support debootstrap fakeroot module-init-tools qemu-system-$qemu_package_architecture pkg-config libsecret-1-dev libglib2.0-dev software-properties-common xvfb wget python curl zip p7zip-full rpm graphicsmagick libwww-perl libxml-libxml-perl libxml-sax-expat-perl \
dpkg-dev perl libconfig-inifiles-perl libxml-simple-perl liblocale-gettext-perl libdpkg-perl libconfig-auto-perl libdebian-dpkgcross-perl ucf debconf dpkg-cross tree \
libx11-dev libxkbfile-dev zlib1g-dev libc6-dev ${cobbler_packages_to_install}

echo "Creating [/kitchen/testing]";
mkdir /kitchen/testing;

if [ "$COBBLER_QEMU_TEST_METHOD" == "rootfs" ]; then

  echo "Creating [/kitchen/testing/.rootfs]";
  mkdir /kitchen/testing/.rootfs;

  echo "Creating [/kitchen/testing/.rootfs/cosmic]";
  mkdir /kitchen/testing/.rootfs/cosmic;

  echo "Creating [/kitchen/testing/.rootfs/cosmic/$COBBLER_ARCH]";
  mkdir /kitchen/testing/.rootfs/cosmic/$COBBLER_ARCH;
  
  echo "Preparing binfmt-misc";
  modprobe binfmt_misc;

  echo "Creating emulated [$COBBLER_ARCH] debootstrap for testing at [/kitchen/testing/.rootfs/cosmic/$COBBLER_ARCH]";
  qemu-debootstrap --arch=$COBBLER_ARCH --variant=minbase cosmic /kitchen/testing/.rootfs/cosmic/$COBBLER_ARCH;

fi;

#echo "Creating $COBBLER_ARCH qemu debootstrap"
#qemu-debootstrap --arch=$COBBLER_ARCH --variant=minbase cosmic rootfs

#echo "Mounting rootfs directories"
#mount --bind /dev/pts $(pwd)/rootfs/dev/pts
#mount --bind /proc $(pwd)/rootfs/proc

#echo "Updating rootfs apt"
#chroot rootfs apt-get update -yq;

#echo "Installing build packages into rootfs"
#chroot rootfs apt-get install -y libx11-dev libxkbfile-dev pkg-config libsecret-1-dev libglib2.0;

# echo "Creating .cache folder if it does not exist";
# if [[ ! -d ../.cache ]]; then mkdir ../.cache; fi

# echo "cobble.sh is run at docker build time now, so skipping here"
# echo "Initializing cobbler for $COBBLER_ARCH";
# . ../../cobble.sh;

echo "Checking presence of NVM";
. ./env/setup_nvm.sh;

echo "Creating [/kitchen/.builds] folders if it does not exist";
if [[ ! -d /kitchen/.builds ]]; then mkdir /kitchen/.builds; fi;

echo "Creating [$COBBLER_BUILDS_DIRECTORY] folder if it does not exist";
if [[ ! -d $COBBLER_BUILDS_DIRECTORY ]]; then mkdir $COBBLER_BUILDS_DIRECTORY; fi;

echo "Creating [$COBBLER_CODE_DIRECTORY] folder if it does not exist";
if [[ ! -d $COBBLER_CODE_DIRECTORY ]]; then mkdir $COBBLER_CODE_DIRECTORY; fi;

echo "Ready to cook";
cd /kitchen;
