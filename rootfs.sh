
echo "Setting Cobbler home to build folder for building rootfs"
COBBLER_HOME=$(pwd)

echo "Setting Cobbler environment";
. ./kitchen/env/linux/setup.sh;

echo "Installing base Cobbler dependencies";
sudo apt-get install -y debootstrap fakechroot fakeroot proot qemu qemu-user-static;

echo "Creating rootfs";
mkdir rootfs;

echo "Using debootstrap --foreign to create rootfs for [$COBBLER_ARCH] jail"
fakeroot debootstrap --foreign --verbose --arch=$COBBLER_ARCH --variant=minbase stretch rootfs;

echo "Creating kitchen directory inside cleanroom user /home";
mkdir rootfs/home/kitchen;

echo "Injecting APT sources list";
mv sources.list rootfs/etc/apt/;

echo "Reading rootfs sources list";
cat rootfs/etc/apt/sources.list;

echo "Entering [$COBBLER_ARCH] cleanroom (proot) to execute second stage of debootstrap";
sudo proot -b /dev -b /proc -b /sys -b $COBBLER_HOME/kitchen:/home/kitchen -q qemu-$COBBLER_QEMU_ARCH-static rootfs uname -a && sudo dpkg --configure -a && sudo apt-get update -yq;
