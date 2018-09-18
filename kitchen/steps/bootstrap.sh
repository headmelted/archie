#!/bin/bash
set -e;
~/kitchen/env/linux/setup.sh;

cat <<EOF

 ██████╗ ██████╗ ██████╗ ██████╗ ██╗     ███████╗██████╗ 
██╔════╝██╔═══██╗██╔══██╗██╔══██╗██║     ██╔════╝██╔══██╗
██║     ██║   ██║██████╔╝██████╔╝██║     █████╗  ██████╔╝
██║     ██║   ██║██╔══██╗██╔══██╗██║     ██╔══╝  ██╔══██╗
╚██████╗╚██████╔╝██████╔╝██████╔╝███████╗███████╗██║  ██║
 ╚═════╝ ╚═════╝ ╚═════╝ ╚═════╝ ╚══════╝╚══════╝╚═╝  ╚═╝
$COBBLER_OS_DISTRIBUTION_NAME:$COBBLER_OS_RELEASE_NAME                                     v0.0.1

https://github.com/headmelted/cobbler
https://hub.docker.com/r/headmelted/cobbler

EOF

~/kitchen/env/linux/display.sh;

cat <<EOF
------------ DEPENDENCY PACKAGE INSTALL LIST ------------
${COBBLER_DEPENDENCY_PACKAGES}
---------------------------------------------------------
EOF

~/kitchen/steps/prepare_build_jail.sh "$COBBLER_CLEANROOM_DIRECTORY";

echo "Starting compilation inside build jail";
chroot "$COBBLER_CLEANROOM_DIRECTORY" ~/kitchen/steps/cook.sh
