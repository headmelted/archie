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

echo "Updating package sources"
apt-get update -yq;

echo "Installing additional Cobbler dependencies";
apt-get install -y qemu qemu-user-static binfmt-support debootstrap;

echo "Calling binfmts display";
update-binfmts --display;

cobbler_dependency_packages="libgtk2.0-0 libxkbfile-dev 
libx11-dev libxdmcp-dev libdbus-1-3 libpcre3 libselinux1 libp11-kit0 libcomerr2 libk5crypto3 
libkrb5-3 libpango-1.0-0 libpangocairo-1.0-0 libpangoft2-1.0-0 libxcursor1 libxfixes3 libfreetype6 libavahi-client3 
libgssapi-krb5-2 libtiff5 fontconfig-config libgdk-pixbuf2.0-common libgdk-pixbuf2.0-0 libfontconfig1 libcups2 
libcairo2 libc6-dev linux-libc-dev libatk1.0-0 libx11-xcb-dev libxtst6 libxss-dev libxss1 libgconf-2-4 
libasound2 libnss3 zlib1g";

echo "Dependency package install list: ${cobbler_dependency_packages}"

# echo "Adding architectures supported by cobbler"
# for arch in $cobbler_foreign_architectures; do dpkg --add-architecture $COBBLER_ARCH; done

# dpkg --add-architecture $COBBLER_ARCH;

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
#cat /etc/apt/sources.list;

# echo "Updating package sources"
# apt-get update -yq;

echo "Creating [$COBBLER_CLEANROOM_ROOT_DIRECTORY]";
mkdir "$COBBLER_CLEANROOM_ROOT_DIRECTORY";

echo "Creating [$COBBLER_CLEANROOM_RELEASE_DIRECTORY]";
mkdir "$COBBLER_CLEANROOM_RELEASE_DIRECTORY";

echo "Creating [$COBBLER_CLEANROOM_DIRECTORY]";
mkdir "$COBBLER_CLEANROOM_DIRECTORY";

echo "Creating [$COBBLER_CLEANROOM_BUILDS_DIRECTORY]";
mkdir "$COBBLER_CLEANROOM_BUILDS_DIRECTORY";

echo "Updating $CC AND $CXX to use [$COBBLER_ARCH] dependencies";
export CC="$CC -L $COBBLER_CLEANROOM_DIRECTORY/usr/lib/$COBBLER_GNU_TRIPLET/";
export CXX="$CXX -L $COBBLER_CLEANROOM_DIRECTORY/usr/lib/$COBBLER_GNU_TRIPLET/";

echo "Ready to cook";

