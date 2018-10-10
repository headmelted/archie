#!/bin/bash

echo "Setting Cobbler home to build folder for building rootfs";
COBBLER_HOME=$(pwd);

echo "Setting Cobbler environment";
. ./kitchen/env/linux/setup.sh;

echo "Installing debootstrap";
sudo apt-get install -y debootstrap;

echo "Using debootstrap --foreign to create rootfs for [$COBBLER_ARCH] jail"
sudo debootstrap --foreign --verbose --arch=$COBBLER_ARCH --variant=minbase stretch rootfs;

echo "Manually mounting proc, sys and dev into rootfs";
cd rootfs;
sudo mount --bind /dev dev/
sudo mount --bind /sys sys/
sudo mount --bind /proc proc/
sudo mount --bind /dev/pts dev/pts
cd ..;

echo "Override QEMU interception mode on build host to construct rootfs";
cobbler_qemu_interception_mode_original=$COBBLER_QEMU_INTERCEPTION_MODE;
COBBLER_QEMU_INTERCEPTION_MODE="binfmt_misc" # Azure supports binfmt_misc, so override here and then set back to whatever was specified.

echo "Installing QEMU dependencies";
sudo bash -c ". ./kitchen/steps/install_qemu_dependencies.sh";

echo "Restoring QEMU interception mode to [$cobbler_qemu_interception_mode_original]";
export COBBLER_QEMU_INTERCEPTION_MODE=$cobbler_qemu_interception_mode_original;

#echo "Copying static QEMU (using the Resin.IO patched version - ToDo: ADD REFERENCE IN README) for [$COBBLER_QEMU_ARCH] into [$COBBLER_ARCH] jail";
#sudo cp ./kitchen/qemu-$COBBLER_QEMU_ARCH-static rootfs/usr/bin/;

echo "Copying QEMU for [$COBBLER_QEMU_ARCH] into [$COBBLER_ARCH] jail";
sudo cp /usr/bin/qemu-$COBBLER_QEMU_ARCH-static rootfs/usr/bin/;
    
echo "Marking static [rootfs/usr/bin/qemu-$COBBLER_QEMU_ARCH-static] as executable";
sudo chmod +x rootfs/usr/bin/qemu-$COBBLER_QEMU_ARCH-static;

echo "Manually setting up debootstrap";
sudo chroot rootfs /debootstrap/debootstrap --second-stage --verbose;
