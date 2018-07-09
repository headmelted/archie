#!/bin/bash

cobbler_cross_architectures="armhf arm64"
cobbler_foreign_architectures="i386 ${cobbler_cross_architectures}"
cobbler_foreign_triplets="arm-linux-gnueabihf aarch64-linux-gnu"
cobbler_architectures_ports_list="armhf,arm64"

cobbler_packages_to_install=""
for triplet in $cobbler_foreign_triplets; do cobbler_packages_to_install="$cobbler_packages_to_install \
gcc-$triplet \
g++-$triplet"; done

# libc6-$arch-cross \
# libstdc++6-$arch-cross \

for arch in $cobbler_cross_architectures; do cobbler_packages_to_install="$cobbler_packages_to_install \
crossbuild-essential-$arch"; done
#  libjpeg-turbo:$arch \
for arch in $cobbler_foreign_architectures; do cobbler_packages_to_install="$cobbler_packages_to_install \
libgtk2.0-0:$arch \
libxkbfile-dev:$arch \
libx11-dev:$arch \
libxdmcp-dev:$arch \
libdbus-1-3:$arch \
libpcre3:$arch \
libselinux1:$arch \
libp11-kit0:$arch \
libcomerr2:$arch \
libk5crypto3:$arch \
libkrb5-3:$arch \
libpango-1.0-0:$arch \
libpangocairo-1.0-0:$arch \
libpangoft2-1.0-0:$arch \
libxcursor1:$arch \
libxfixes3:$arch \
libfreetype6:$arch \
libavahi-client3:$arch \
libgssapi-krb5-2:$arch \
libtiff5:$arch \ 
fontconfig-config \
libgdk-pixbuf2.0-common \
libgdk-pixbuf2.0-0:$arch \
libfontconfig1:$arch \
libcups2:$arch \
libcairo2:$arch \
libc6-dev:$arch \
libatk1.0-0:$arch \
libx11-xcb-dev:$arch \
libxtst6:$arch \
libxss-dev:$arch \
libxss1:$arch \
libgconf-2-4:$arch \
libasound2:$arch \
libnss3:$arch \
zlib1g:$arch"; done

echo "Package install list: ${cobbler_packages_to_install}"

echo "Building cobbler image for ${cobbler_ports_architectures_list}"

echo "Adding architectures supported by cobbler"
dpkg --add-architecture i386
for arch in $cobbler_foreign_architectures; do dpkg --add-architecture $arch; done

echo "Updating package sources"
apt-get update -yq;

echo "Installing curl, gnupg and git"
apt-get install -y curl gnupg git;

echo "Adding yarn signing key"
curl -sS https://dl.yarnpkg.com/debian/pubkey.gpg | apt-key add -

echo "Adding yarn repository"
echo "deb https://dl.yarnpkg.com/debian/ stable main" | tee /etc/apt/sources.list.d/yarn.list

echo "Adding emdebian signing key"
curl http://emdebian.org/tools/debian/emdebian-toolchain-archive.key | apt-key add -

echo "Adding emdebian for multiarch packages"
echo "deb http://emdebian.org/tools/debian/ unstable main" | tee /etc/apt/sources.list.d/cobbler.list;
#echo "deb [arch=$cobbler_architectures_ports_list] http://ports.ubuntu.com/ubuntu-ports xenial main universe multiverse restricted" | tee /etc/apt/sources.list.d/cobbler.list;
#echo "deb [arch=$cobbler_architectures_ports_list] http://ports.ubuntu.com/ubuntu-ports xenial-security main universe multiverse restricted" | tee -a /etc/apt/sources.list.d/cobbler.list;
#echo "deb [arch=$cobbler_architectures_ports_list] http://ports.ubuntu.com/ubuntu-ports xenial-updates main universe multiverse restricted" | tee -a /etc/apt/sources.list.d/cobbler.list;
#echo "deb [arch=$cobbler_architectures_ports_list] http://ports.ubuntu.com/ubuntu-ports xenial-backports main universe multiverse restricted" | tee -a /etc/apt/sources.list.d/cobbler.list;

echo "cobbler.list be like:"
cat /etc/apt/sources.list.d/cobbler.list;

#echo "Binding all unfiltered repositories to intel";
#sed -i 's/deb http/deb [arch=amd64,i386] http/g' /etc/apt/sources.list;
#find /etc/apt/sources.list.d/ -name '*.list' -print0 | xargs -0 -I {} -P 0 sed -i 's/deb http/deb [arch=amd64,i386] http/g' {}

echo "Updating package sources"
apt-get update -yq;

echo "Installing packages"
apt-get install -y pkg-config libsecret-1-dev software-properties-common xvfb wget python curl zip p7zip-full rpm graphicsmagick libwww-perl libxml-libxml-perl libxml-sax-expat-perl \
dpkg-dev perl libconfig-inifiles-perl libxml-simple-perl liblocale-gettext-perl libdpkg-perl libconfig-auto-perl libdebian-dpkgcross-perl ucf debconf dpkg-cross tree \
libx11-dev libxkbfile-dev zlib1g-dev qemu binfmt-support qemu-user-static ${cobbler_packages_to_install} debootstrap fakeroot;

echo "Installing gulp and yarn"
apt-get install -y -g gulp yarn

echo "Checking for debootstrap"
if [[ ! -d "rootfs" ]]; then
  echo "Creating ${ARCH} qemu debootstrap"
  qemu-debootstrap --arch=${ARCH} --variant=minbase xenial rootfs
fi

echo "Mounting rootfs directories"
mount --bind /dev/pts $(pwd)/rootfs/dev/pts
mount --bind /proc $(pwd)/rootfs/proc

echo "Updating rootfs apt"
sudo chroot rootfs apt-get update -yq;

echo "Installing build packages into rootfs"
chroot rootfs apt-get install -y libx11-dev libxkbfile-dev pkg-config libsecret-1-dev libglib2.0;
