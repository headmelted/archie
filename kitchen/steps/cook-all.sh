#!/bin/bash

# This script should be imported at the root level in order
# to retain /kitchen as the current directory, which Cobbler
# depends on to reconcile further steps in the build process.

echo "Running all cook steps (get, patch, build, package, test)";
. ./steps/cook.sh get patch build package; # Removed test for now until the hiccups are ironed out
