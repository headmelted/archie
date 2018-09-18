#!/bin/bash
set -e;

echo "Marking kitchen env scripts executable";
chmod +x ~/kitchen/env/linux/*.sh;

echo "Marking kitchen steps scripts executable";
chmod +x ~/kitchen/steps/*.sh;

. ~/kitchen/env/linux/setup.sh;

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

. ~/kitchen/env/linux/display.sh;

echo "------------ DEPENDENCY PACKAGE INSTALL LIST ------------"
echo "${COBBLER_DEPENDENCY_PACKAGES}"
echo "---------------------------------------------------------"

. ~/kitchen/steps/prepare_build_jail.sh "$COBBLER_CLEANROOM_DIRECTORY";

echo "Starting compilation inside build jail";
chroot "$COBBLER_CLEANROOM_DIRECTORY" ~/kitchen/steps/cook.sh;
