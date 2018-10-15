#!/bin/bash
set -e;

echo " ██████╗ ██████╗ ██████╗ ██████╗ ██╗     ███████╗██████╗ "
echo "██╔════╝██╔═══██╗██╔══██╗██╔══██╗██║     ██╔════╝██╔══██╗"
echo "██║     ██║   ██║██████╔╝██████╔╝██║     █████╗  ██████╔╝"
echo "██║     ██║   ██║██╔══██╗██╔══██╗██║     ██╔══╝  ██╔══██╗"
echo "╚██████╗╚██████╔╝██████╔╝██████╔╝███████╗███████╗██║  ██║"
echo " ╚═════╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝"
echo "$ARCHIE_OS_DISTRIBUTION_NAME:$ARCHIE_OS_RELEASE_NAME                                     v0.0.1"
echo ""
echo "https://github.com/headmelted/archie"
echo "https://hub.docker.com/r/headmelted/archie"

echo "------------------ ENVIRONMENT DETAILS ------------------"
echo "Target architecture: $ARCHIE_ARCH"
echo "QEMU architectures: $ARCHIE_QEMU_ARCH"
echo "QEMU system emulator set: qemu-system-$ARCHIE_QEMU_PACKAGE_ARCH"
echo "CC (version) ---------------------------------------------------"
eval "$CC -v";
echo "CC (configuration) ---------------------------------------------"
echo $CC
echo "CXX (version) --------------------------------------------------"
eval "$CXX -v";
echo "CXX (configuration) --------------------------------------------"
echo $CXX
echo "----------------------------------------------------------------"
