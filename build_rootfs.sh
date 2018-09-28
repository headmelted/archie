#!/bin/bash

echo "Setting Cobbler home to build folder for building rootfs";
COBBLER_HOME=$(pwd);

echo "Setting Cobbler environment";
. ./kitchen/env/linux/setup.sh;

echo "Installing cdebootstrap";
sudo apt-get install -y debootstrap fakechroot fakeroot proot;

echo "Using debootstrap --foreign to create rootfs for [$COBBLER_ARCH] jail"
fakechroot fakeroot debootstrap --foreign --verbose --arch=$COBBLER_ARCH --variant=minbase stretch rootfs;

echo "rootfs lib:";
ls rootfs/lib;

#echo "Injecting APT sources list";
#mv sources.list rootfs/etc/apt/;

#echo "Reading rootfs sources list";
#cat rootfs/etc/apt/sources.list;

echo "Override QEMU interception mode on build host to construct rootfs";
cobbler_qemu_interception_mode_original=$COBBLER_QEMU_INTERCEPTION_MODE;
COBBLER_QEMU_INTERCEPTION_MODE="binfmt_misc" # Azure supports binfmt_misc, so override here and then set back to whatever was specified.

echo "Installing QEMU dependencies";
sudo bash -c ". ./kitchen/steps/install_qemu_dependencies.sh";

echo "Restoring QEMU interception mode to [$cobbler_qemu_interception_mode_original]";
export COBBLER_QEMU_INTERCEPTION_MODE=$cobbler_qemu_interception_mode_original;

if [ ${COBBLER_QEMU_INTERCEPTION_MODE} == "binfmt_misc" ] ; then
  echo "Displaying binfmt bindings";
  update-binfmts --display;
fi;

#echo "Using cdebootstrap --arch to create rootfs for [$COBBLER_ARCH] jail in download only mode"
#cdebootstrap --download-only --debug --verbose --foreign --arch=$COBBLER_ARCH --flavour=minimal stretch rootfs http://ftp.us.debian.org/debian/;

echo "Copying static QEMU (using the Resin.IO patched version - ToDo: ADD REFERENCE IN README) for [$COBBLER_QEMU_ARCH] into [$COBBLER_ARCH] jail";
cp ./kitchen/qemu-$COBBLER_QEMU_ARCH-static rootfs/usr/bin/;
    
echo "Marking static [rootfs/usr/bin/qemu-$COBBLER_QEMU_ARCH-static] as executable";
chmod +x rootfs/usr/bin/qemu-$COBBLER_QEMU_ARCH-static;

#echo "Adding $COBBLER_ARCH to dpkg";
#sudo dpkg --add-architecture $COBBLER_ARCH;

#echo "Resetting ubuntu package lists"
#echo "deb http://emdebian.org/tools/debian/ unstable main" | tee /etc/apt/sources.list.d/cobbler.list;
#echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ xenial main universe multiverse restricted" | sudo tee /etc/apt/sources.list.d/cobbler.list;
#echo "deb [arch=amd64,i386] http://security.ubuntu.com/ubuntu/ xenial-security main universe multiverse restricted" | sudo tee -a /etc/apt/sources.list.d/cobbler.list;
#echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ xenial-updates main universe multiverse restricted" | sudo tee -a /etc/apt/sources.list.d/cobbler.list;
#echo "deb [arch=amd64,i386] http://archive.ubuntu.com/ubuntu/ xenial-backports main universe multiverse restricted" | sudo tee -a /etc/apt/sources.list.d/cobbler.list;#

#echo "Checking ports list [$COBBLER_ARCH]...";
#if [[ -n "${COBBLER_ARCH}" ]]; then
#  echo "Adding ports repositories...";
#  echo "deb [arch=$COBBLER_ARCH] http://ports.ubuntu.com/ubuntu-ports xenial main universe multiverse restricted" | sudo tee -a /etc/apt/sources.list.d/cobbler.list;
#  echo "deb [arch=$COBBLER_ARCH] http://ports.ubuntu.com/ubuntu-ports xenial-security main universe multiverse restricted" | sudo tee -a /etc/apt/sources.list.d/cobbler.list;
#  echo "deb [arch=$COBBLER_ARCH] http://ports.ubuntu.com/ubuntu-ports xenial-updates main universe multiverse restricted" | sudo tee -a /etc/apt/sources.list.d/cobbler.list;
#  echo "deb [arch=$COBBLER_ARCH] http://ports.ubuntu.com/ubuntu-ports xenial-backports main universe multiverse restricted" | sudo tee -a /etc/apt/sources.list.d/cobbler.list;
#fi;

#echo "cobbler.list be like:"
#cat /etc/apt/sources.list.d/cobbler.list;

#echo "Deleting original packages sources"
#sudo rm /etc/apt/sources.list;

#echo "Updating package sources"
#sudo apt-get update -yq;

#echo "Installing runtime dependencies for foreign fakechroot";
#sudo apt-get install -y fakeroot:$COBBLER_ARCH libc6:$COBBLER_ARCH;

# Following instructions at https://blog.mister-muffin.de/2011/04/02/foreign-debian-bootstrapping-without-root-priviliges-with-fakeroot%2C-fakechroot-and-qemu-user-emulation/
echo "Creating /etc/qemu-binfmt/$COBBLER_QEMU_ARCH/ if it doesn't exist...";
sudo mkdir -p /etc/qemu-binfmt/$COBBLER_QEMU_ARCH/;

echo "Creating /usr/lib/$COBBLER_GNU_TRIPLET/ if it doesn't exist...";
sudo mkdir -p /usr/lib/$COBBLER_GNU_TRIPLET/;

echo "Downloading libfakeroot_1.23-1_$COBBLER_ARCH.deb...";
wget http://ftp.debian.org/debian/pool/main/f/fakeroot/libfakeroot_1.23-1_$COBBLER_ARCH.deb;

echo "Extracting libfakeroot to /usr/lib/$COBBLER_GNU_TRIPLET/...";
dpkg-deb --fsys-tarfile libfakeroot_1.23-1_$COBBLER_ARCH.deb | sudo tar -xf - --strip-components=4 -C rootfs/lib/$COBBLER_GNU_TRIPLET/ ./usr/lib/$COBBLER_GNU_TRIPLET/libfakeroot/libfakeroot-sysv.so

echo "Downloading libfakechroot_2.19-3_$COBBLER_ARCH.deb...";
wget http://ftp.debian.org/debian/pool/main/f/fakechroot/libfakechroot_2.19-3_$COBBLER_ARCH.deb;

echo "Extracting libfakechroot to /usr/lib/$COBBLER_GNU_TRIPLET/...";
dpkg-deb --fsys-tarfile libfakechroot_2.19-3_$COBBLER_ARCH.deb | sudo tar -xf - --strip-components=4 -C rootfs/lib/$COBBLER_GNU_TRIPLET/ ./usr/lib/$COBBLER_GNU_TRIPLET/fakechroot/libfakechroot.so

echo "Downloading libc6_2.13-38+deb7u10_$COBBLER_ARCH.deb...";
wget http://ftp.debian.org/debian/pool/main/e/eglibc/libc6_2.13-38+deb7u10_$COBBLER_ARCH.deb;

echo "Creating qemu-binfmt directory in rootfs";
mkdir -p rootfs/etc/qemu-binfmt;

echo "Creating qemu-binfmt/$COBBLER_QEMU_ARCH directory in rootfs";
mkdir -p rootfs/etc/qemu-binfmt/$COBBLER_QEMU_ARCH;

echo "Extracting libc6 to /etc/qemu-binfmt/$COBBLER_QEMU_ARCH/...";
sudo dpkg -x libc6_2.13-38+deb7u10_$COBBLER_ARCH.deb rootfs/etc/qemu-binfmt/$COBBLER_QEMU_ARCH/;

echo "Removing downloaded packages";
rm libfakechroot_2.19-3_$COBBLER_ARCH.deb libfakeroot_1.23-1_$COBBLER_ARCH.deb libc6_2.13-38+deb7u10_$COBBLER_ARCH.deb;

#echo "Installing packages from debootstrap with QEMU"
#fakechroot -s fakeroot chroot rootfs dpkg --force-depends --install rootfs/var/cache/apt/archives/*.deb

echo "Manually setting up debootstrap";
#sudo fakechroot fakeroot chroot rootfs dpkg --add-architecture $COBBLER_ARCH;
#sudo fakechroot fakeroot chroot rootfs /debootstrap/debootstrap --second-stage;
fakechroot fakeroot chroot rootfs /debootstrap/debootstrap --second-stage --verbose;

#echo "Configuring dpkg"
#sudo fakechroot fakeroot chroot rootfs dpkg --configure -a;

#echo "Updating APT";
#sudo fakechroot fakeroot chroot rootfs apt-get update -yq;
