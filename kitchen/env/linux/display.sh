#!/bin/bash
set -e;

echo " ██████╗ ██████╗ ██████╗ ██████╗ ██╗     ███████╗██████╗ "
echo "██╔════╝██╔═══██╗██╔══██╗██╔══██╗██║     ██╔════╝██╔══██╗"
echo "██║     ██║   ██║██████╔╝██████╔╝██║     █████╗  ██████╔╝"
echo "██║     ██║   ██║██╔══██╗██╔══██╗██║     ██╔══╝  ██╔══██╗"
echo "╚██████╗╚██████╔╝██████╔╝██████╔╝███████╗███████╗██║  ██║"
echo " ╚═════╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝"
echo "$COBBLER_OS_DISTRIBUTION_NAME:$COBBLER_OS_RELEASE_NAME                                     v0.0.1"
echo ""
echo "https://github.com/headmelted/cobbler"
echo "https://hub.docker.com/r/headmelted/cobbler"

echo "------------------ ENVIRONMENT DETAILS ------------------"
echo "Target architecture: $COBBLER_ARCH"
echo "Non-native target architectures: $cobbler_foreign_architectures"
echo "Cross-compile architectures: $cobbler_cross_architectures"
echo "QEMU architectures: $COBBLER_QEMU_ARCH"
echo "QEMU system emulator set: qemu-system-$COBBLER_QEMU_PACKAGE_ARCH"
echo "C compilers (gcc-): $COBBLER_GNU_TRIPLET"
echo "C++ compilers (gpp-): $COBBLER_GNU_TRIPLET"
echo "---------------------------------------------------------"
