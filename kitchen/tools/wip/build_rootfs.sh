#!/bin/bash

echo "Setting Archie home to build folder for building rootfs";
ARCHIE_HOME=$(pwd);

echo "Setting Archie environment";
. ./kitchen/env/linux/setup.sh;

echo "Installing debootstrap";
sudo apt-get install -y debootstrap;

echo "Using debootstrap --foreign to create rootfs for [$ARCHIE_ARCH] jail"
sudo debootstrap --foreign --verbose --arch=$ARCHIE_ARCH --variant=minbase stretch rootfs;

echo "Manually mounting proc, sys and dev into rootfs";
cd rootfs;
sudo mount --bind /dev dev/
sudo mount --bind /sys sys/
sudo mount --bind /proc proc/
sudo mount --bind /dev/pts dev/pts
cd ..;

echo "Override QEMU interception mode on build host to construct rootfs";
archie_qemu_interception_mode_original=$ARCHIE_QEMU_INTERCEPTION_MODE;
ARCHIE_QEMU_INTERCEPTION_MODE="binfmt_misc" # Azure supports binfmt_misc, so override here and then set back to whatever was specified.

echo "Installing QEMU dependencies";
sudo bash -c ". ./kitchen/steps/install_qemu_dependencies.sh";

echo "Restoring QEMU interception mode to [$archie_qemu_interception_mode_original]";
export ARCHIE_QEMU_INTERCEPTION_MODE=$archie_qemu_interception_mode_original;

#echo "Copying static QEMU (using the Resin.IO patched version - ToDo: ADD REFERENCE IN README) for [$ARCHIE_QEMU_ARCH] into [$ARCHIE_ARCH] jail";
#sudo cp ./kitchen/qemu-$ARCHIE_QEMU_ARCH-static rootfs/usr/bin/;

echo "Copying QEMU for [$ARCHIE_QEMU_ARCH] into [$ARCHIE_ARCH] jail";
sudo cp /usr/bin/qemu-$ARCHIE_QEMU_ARCH-static rootfs/usr/bin/;
    
echo "Marking static [rootfs/usr/bin/qemu-$ARCHIE_QEMU_ARCH-static] as executable";
sudo chmod +x rootfs/usr/bin/qemu-$ARCHIE_QEMU_ARCH-static;

echo "Manually setting up debootstrap";
sudo chroot rootfs /debootstrap/debootstrap --second-stage --verbose;
