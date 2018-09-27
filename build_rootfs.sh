
echo "Setting Cobbler home to build folder for building rootfs"
COBBLER_HOME=$(pwd)

echo "Setting Cobbler environment";
. ./kitchen/env/linux/setup.sh;

echo "Installing base Cobbler dependencies";
sudo apt-get install -y debootstrap fakechroot fakeroot proot qemu qemu-user-static;

echo "Using debootstrap --foreign to create rootfs for [$COBBLER_ARCH] jail"
fakeroot debootstrap --foreign --verbose --arch=$COBBLER_ARCH --variant=minbase stretch rootfs;

echo "Checking binfmts";
update-binfmts --display;

echo "Injecting APT sources list";
mv sources.list rootfs/etc/apt/;

echo "Reading rootfs sources list";
cat rootfs/etc/apt/sources.list;

echo "Copying static QEMU (using the Resin.IO patched version - ToDo: ADD REFERENCE IN README) for [$COBBLER_QEMU_ARCH] into [$COBBLER_ARCH] jail";
cp ./kitchen/qemu-$COBBLER_QEMU_ARCH-static rootfs/usr/bin/;
    
echo "Marking static [rootfs/usr/bin/qemu-$COBBLER_QEMU_ARCH-static] as executable";
chmod +x rootfs/usr/bin/qemu-$COBBLER_QEMU_ARCH-static;

qwrap_path=rootfs/usr/bin/qwrap_${COBBLER_QEMU_ARCH}.sh

echo "Writing QEMU bash wrapper to ${qwrap_path}";
cat > ${qwrap_path} << 'endmsg'
#!/bin/bash
echo "Executing command using QEMU shell";
"$@"
endmsg

echo "Marking ${qwrap_path} as executable";
chmod +x ${qwrap_path};

echo "Contents of ${qwrap_path}";
cat ${qwrap_path};

#echo "Entering [$COBBLER_ARCH] cleanroom (proot) to execute second stage of debootstrap";
#sudo proot -b $COBBLER_HOME/kitchen:/kitchen -q qemu-$COBBLER_QEMU_ARCH-static -R rootfs uname -a && sudo dpkg --configure -a && sudo apt-get update -yq;

#sudo ./rootfs/usr/bin/qemu-arm-static -L rootfs uname -a
fakechroot fakeroot chroot rootfs /usr/bin/qwrap_${COBBLER_QEMU_ARCH}.sh uname -a
