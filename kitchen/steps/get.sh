#!/bin/bash
set -e;

# get.sh
#
# Clone $COBBLER_GIT_ENDPOINT into the code folder, and make the executing
# user the owner of the folder.

echo "Retrieving code from git endpoint [$COBBLER_GIT_ENDPOINT] into [$COBBLER_CODE_DIRECTORY]";
git clone $COBBLER_GIT_ENDPOINT $COBBLER_CODE_DIRECTORY;
  
echo "Setting current owner as owner of code folder";
chown ${USER:=$(/usr/bin/id -run)}:$USER -R $COBBLER_CODE_DIRECTORY;
