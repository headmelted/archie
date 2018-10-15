#!/bin/bash
set -e;

if [ "${ARCHIE_QEMU_INTERCEPTION_MODE}" == "proot" ] ; then
  archie_qemu_dependencies="proot";
elif [ "${ARCHIE_QEMU_INTERCEPTION_MODE}" == "execve" ] ; then
  archie_qemu_dependencies="fakechroot fakeroot";
else
  archie_qemu_dependencies=""; # binfmt_misc and virtualize
fi;

echo "Installing base Archie dependencies";
apt-get install -y qemu-user-static ${archie_qemu_dependencies};
