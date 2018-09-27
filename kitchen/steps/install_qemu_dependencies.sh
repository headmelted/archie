#!/bin/bash
set -e;

if [ ${COBBLER_QEMU_INTERCEPTION_MODE} == "proot" ] ; then
  cobbler_qemu_dependencies="proot";
elif [ ${COBBLER_QEMU_INTERCEPTION_MODE} == "execve" ] ; then
  cobbler_qemu_dependencies="fakechroot fakeroot";
else
  cobbler_qemu_dependencies=""; # binfmt_misc and virtualize
fi;

echo "Installing base Cobbler dependencies";
apt-get install -y qemu-user-static ${cobbler_qemu_dependencies};
