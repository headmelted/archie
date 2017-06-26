echo "Setting environment for armhf";
LABEL="armhf_linux";
CROSS_TOOLCHAIN="true";
ARCH="armhf";
RPM_ARCH="armhf";
NPM_ARCH="arm";
GNU_TRIPLET="arm-linux-gnueabihf";
GNU_MULTILIB_TRIPLET="";
CXX="arm-linux-gnueabihf-g++";
CC="arm-linux-gnueabihf-gcc";
PACKAGE_ARCH="arm";
QEMU_ARCH="arm";
ELECTRON_ARCH="arm";
VSCODE_ELECTRON_PLATFORM="arm";

        # # "JAIL_ROOTFS=""http:#cdimage.ubuntu.com/ubuntu-base/releases/16.04.2/release/ubuntu-base-16.04.2-base-${ARCH}.tar.gz"";
        # "QEMU_ARCHIVE=""http:#archive.raspbian.org/raspbian"";
        # "QEMU_IMAGE=""https:#downloads.raspberrypi.org/raspbian/images/raspbian-2016-11-29/2016-11-25-raspbian-jessie.zip"";

    # # # Raspberry Pi B
    # # "QEMU_KERNEL=""kernel.img"";
    # # "QEMU_DTB=""bcm2708-rpi-b.dtb"";
    # # "QEMU_OPTS=""-cpu arm1176 -m 256 -machine versatilepb"";

    # #Raspberry Pi 2B
    # "QEMU_KERNEL=""kernel7.img"";
    # "QEMU_DTB=""bcm2709-rpi-2-b.dtb"";
    # "QEMU_OPTS=""-machine versatilepb"";

