#!/bin/bash

echo "Setting Cobbler home to build folder for building rootfs";
COBBLER_HOME=$(pwd);

echo "Setting Cobbler environment";
. ./kitchen/env/linux/setup.sh;

echo "Installing cdebootstrap";
sudo apt-get install -y debootstrap fakechroot fakeroot proot;

echo "Using debootstrap --foreign to create rootfs for [$COBBLER_ARCH] jail"
fakechroot fakeroot debootstrap --foreign --verbose --arch=$COBBLER_ARCH --variant=fakechroot stretch rootfs;

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

echo "Installing packages from debootstrap with QEMU"
fakechroot -s fakeroot chroot rootfs dpkg --force-depends --install rootfs/var/cache/apt/archives/*.deb

#echo "Manually setting up debootstrap";
#sudo fakechroot fakeroot chroot rootfs dpkg --add-architecture $COBBLER_ARCH;
#sudo fakechroot fakeroot chroot rootfs /debootstrap/debootstrap --second-stage;
#DEBOOTSTRAP_DIR=rootfs/debootstrap fakechroot fakeroot debootstrap --second-stage --second-stage-target=rootfs --verbose || echo "Debootstrap log:"; || cat rootfs/debootstrap/debootstrap.log;

#echo "Configuring dpkg"
#sudo fakechroot fakeroot chroot rootfs dpkg --configure -a;

#echo "Updating APT";
#sudo fakechroot fakeroot chroot rootfs apt-get update -yq;
