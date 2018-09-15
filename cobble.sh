#!/bin/bash

echo "Setting arch to $1";
arch=$1;

echo "Entering the kitchen";
cd kitchen;

echo "Setting environment for $arch";
. ./env/linux/$arch.sh;

if [ "${arch}" != "amd64" ]
then
  cobbler_cross_architectures="$arch";
  if [ "${arch}" != "i386" ]
  then
    cobbler_foreign_architectures="$arch";
  fi
fi

if [ "${arch}" == "arm64" ]
then
  cobbler_qemu_architectures="aarch64";
else
  cobbler_qemu_architectures="$arch";
fi

case $arch in
"amd64")
  cobbler_foreign_triplets="x86-64-linux-gnu";
  qemu_package_architecture="x86";
  ;;
"i386")
  cobbler_foreign_triplets="i686-linux-gnu";
  qemu_package_architecture="x86";
  ;;
"armhf")
  cobbler_foreign_triplets="arm-linux-gnueabihf";
  qemu_package_architecture="arm";
  ;;
"arm64")
  cobbler_foreign_triplets="aarch64-linux-gnu";
  qemu_package_architecture="arm";
  ;;
"ppc64el")
  cobbler_foreign_triplets="powerpc64le-linux-gnu";
  qemu_package_architecture="ppc";
  ;;
"s390x")
  cobbler_foreign_triplets="s390x-linux-gnu";
  qemu_package_architecture="s390x";
  ;;
esac

echo "-------------------------------------------------------------"
echo "| Environment Summary"
echo "-------------------------------------------------------------"
echo "| Target architecture: $arch"; 
echo "| Non-native target architectures: $cobbler_foreign_architectures";
echo "| Cross-compile architectures: $cobbler_cross_architectures";
echo "| QEMU architectures: $cobbler_qemu_architectures";
echo "| QEMU system emulator set: qemu-system-$qemu_package_architecture";
echo "| C compilers (gcc-): $cobbler_foreign_triplets";
echo "| C++ compilers (gpp-): $cobbler_foreign_triplets";
echo "-------------------------------------------------------------"

cobbler_packages_to_install=""
for triplet in $cobbler_foreign_triplets; do cobbler_packages_to_install="$cobbler_packages_to_install \
gcc-$triplet \
g++-$triplet"; done

for arch in $cobbler_cross_architectures; do cobbler_packages_to_install="$cobbler_packages_to_install \
crossbuild-essential-$arch"; done

for arch in $cobbler_foreign_architectures; do cobbler_packages_to_install="$cobbler_packages_to_install libgtk2.0-0:$arch libxkbfile-dev:$arch \
libx11-dev:$arch libxdmcp-dev:$arch libdbus-1-3:$arch libpcre3:$arch libselinux1:$arch libp11-kit0:$arch libcomerr2:$arch libk5crypto3:$arch \
libkrb5-3:$arch libpango-1.0-0:$arch libpangocairo-1.0-0:$arch libpangoft2-1.0-0:$arch libxcursor1:$arch libxfixes3:$arch libfreetype6:$arch libavahi-client3:$arch \
libgssapi-krb5-2:$arch libtiff5:$arch fontconfig-config libgdk-pixbuf2.0-common libgdk-pixbuf2.0-0:$arch libfontconfig1:$arch libcups2:$arch \
libcairo2:$arch libc6-dev:$arch linux-libc-dev:$arch libatk1.0-0:$arch libx11-xcb-dev:$arch libxtst6:$arch libxss-dev:$arch libxss1:$arch libgconf-2-4:$arch \
libasound2:$arch libnss3:$arch zlib1g:$arch"; done

echo "Package install list: ${cobbler_packages_to_install}"

echo "Adding architectures supported by cobbler"
for arch in $cobbler_foreign_architectures; do dpkg --add-architecture $arch; done

#echo "Adding yarn signing key"
#curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -

#echo "Adding yarn repository"
#echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

#echo "Adding emdebian signing key"
#curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add -

echo "Resetting ubuntu package lists"
#echo "deb http://emdebian.org/tools/debian/ unstable main" | tee /etc/apt/sources.list.d/cobbler.list;
echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ cosmic main universe multiverse restricted" | tee /etc/apt/sources.list.d/cobbler.list;
echo "deb [arch=amd64,i386] http://security.ubuntu.com/ubuntu/ cosmic-security main universe multiverse restricted" | tee -a /etc/apt/sources.list.d/cobbler.list;
echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ cosmic-updates main universe multiverse restricted" | tee -a /etc/apt/sources.list.d/cobbler.list;
echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ cosmic-backports main universe multiverse restricted" | tee -a /etc/apt/sources.list.d/cobbler.list;

cobbler_architectures_ports_list="${cobbler_foreign_architectures// /,}"

echo "Checking for ports list [${cobbler_architectures_ports_list}]...";
if [ -n "${cobbler_architectures_ports_list}" ]; then
  echo "Adding ports list [${cobbler_architectures_ports_list}]...";
  echo "deb [arch=$cobbler_architectures_ports_list] http://ports.ubuntu.com/ubuntu-ports cosmic main universe multiverse restricted" | tee -a /etc/apt/sources.list.d/cobbler.list;
  echo "deb [arch=$cobbler_architectures_ports_list] http://ports.ubuntu.com/ubuntu-ports cosmic-security main universe multiverse restricted" | tee -a /etc/apt/sources.list.d/cobbler.list;
  echo "deb [arch=$cobbler_architectures_ports_list] http://ports.ubuntu.com/ubuntu-ports cosmic-updates main universe multiverse restricted" | tee -a /etc/apt/sources.list.d/cobbler.list;
  echo "deb [arch=$cobbler_architectures_ports_list] http://ports.ubuntu.com/ubuntu-ports cosmic-backports main universe multiverse restricted" | tee -a /etc/apt/sources.list.d/cobbler.list;
fi;

echo "cobbler.list now looks like this:"
cat /etc/apt/sources.list.d/cobbler.list;

echo "Deleting original packages sources"
rm /etc/apt/sources.list;

echo "Updating package sources"
apt-get update -yq;

#echo "Binding all unfiltered repositories to intel";
#sed -i 's/deb http/deb [arch=amd64,i386] http/g' /etc/apt/sources.list;
#find /etc/apt/sources.list.d/ -name '*.list' -print0 | xargs -0 -I {} -P 0 sed -i 's/deb http/deb [arch=amd64,i386] http/g' {}

#echo "Updating package sources"
# apt-get update -yq;

echo "Installing packages"
apt-get install -y curl gnupg git qemu-system-$qemu_package_architecture pkg-config libsecret-1-dev libglib2.0-dev software-properties-common xvfb wget python curl zip p7zip-full rpm graphicsmagick libwww-perl libxml-libxml-perl libxml-sax-expat-perl \
dpkg-dev perl libconfig-inifiles-perl libxml-simple-perl liblocale-gettext-perl libdpkg-perl libconfig-auto-perl libdebian-dpkgcross-perl ucf debconf dpkg-cross tree \
libx11-dev libxkbfile-dev zlib1g-dev libc6-dev ${cobbler_packages_to_install}

#echo "Creating ${ARCH} qemu debootstrap"
#qemu-debootstrap --arch=${arch} --variant=minbase cosmic rootfs

#echo "Mounting rootfs directories"
#mount --bind /dev/pts $(pwd)/rootfs/dev/pts
#mount --bind /proc $(pwd)/rootfs/proc

#echo "Updating rootfs apt"
#chroot rootfs apt-get update -yq;

#echo "Installing build packages into rootfs"
#chroot rootfs apt-get install -y libx11-dev libxkbfile-dev pkg-config libsecret-1-dev libglib2.0;

echo "Creating images directory [/kitchen/.images]"
mkdir .images;

echo "Downloading Ubuntu cloud images (used for testing later)";
for arch in $cobbler_qemu_architectures; do wget "https://cloud-images.ubuntu.com/cosmic/current/cosmic-server-cloudimg-$arch.img" -O ./.images/cosmic-server-cloudimg-$arch.img; done;

echo "Creating .cache folder if it does not exist";
if [[ ! -d ../.cache ]]; then mkdir ../.cache; fi

echo "cobble.sh is run at docker build time now, so skipping here"
# echo "Initializing cobbler for ${arch}";
# . ../../cobble.sh;

echo "Checking presence of NVM";
. ./env/setup_nvm.sh;

export ROOT_DIRECTORY=$(pwd);
export BUILDS_DIRECTORY=$ROOT_DIRECTORY/.builds/${arch};
export CODE_DIRECTORY=$BUILDS_DIRECTORY/.code;

echo "Creating .builds folders if they do not exist";
if [[ ! -d .builds ]]; then mkdir .builds; fi;
if [[ ! -d $BUILDS_DIRECTORY ]]; then mkdir $BUILDS_DIRECTORY; fi;
if [[ ! -d $CODE_DIRECTORY ]]; then mkdir $CODE_DIRECTORY; fi;

echo "Ready to cook";
