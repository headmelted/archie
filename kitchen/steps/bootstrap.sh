#!/bin/bash
set -e;

echo "Setting COBBLER_HOME";
export COBBLER_HOME=$HOME;

echo "Marking kitchen env scripts executable";
chmod +x ~/kitchen/env/linux/*.sh;

echo "Marking kitchen steps scripts executable";
chmod +x ~/kitchen/steps/*.sh;

. ~/kitchen/env/linux/setup.sh;
. ~/kitchen/env/linux/display.sh;

echo "Starting compilation inside build jail";
. ~/kitchen/steps/cook.sh;
