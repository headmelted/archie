#!/bin/bash
set -e;

cat <<EOF
------------------ ENVIRONMENT DETAILS ------------------
Target architecture: $COBBLER_ARCH
Non-native target architectures: $cobbler_foreign_architectures
echo "Cross-compile architectures: $cobbler_cross_architectures
echo "QEMU architectures: $COBBLER_QEMU_ARCH
echo "QEMU system emulator set: qemu-system-$COBBLER_QEMU_PACKAGE_ARCH
echo "C compilers (gcc-): $COBBLER_GNU_TRIPLET
echo "C++ compilers (gpp-): $COBBLER_GNU_TRIPLET
---------------------------------------------------------
EOF
