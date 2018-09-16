#!/bin/bash
set -e;

# get.sh
#
# Clone the given git endpoint into the .code folder, and make the executing
# user the owner of the folder.
#
# usage: get.sh <git_endpoint_url>

echo "Temporarily exiting code directory to replace it";
cd ..;

echo "Remove .code folder if it exists"
rm -rf $COBBLER_CODE_DIRECTORY;

echo "Creating .code folder";
mkdir $COBBLER_CODE_DIRECTORY;

echo "Retrieving code from git endpoint [$COBBLER_GIT_ENDPOINT] into [$COBBLER_CODE_DIRECTORY]";
git clone $COBBLER_GIT_ENDPOINT $COBBLER_CODE_DIRECTORY;
  
echo "Setting current owner as owner of code folder";
chown ${USER:=$(/usr/bin/id -run)}:$USER -R $COBBLER_CODE_DIRECTORY;

echo "Entering code directory";
cd $COBBLER_CODE_DIRECTORY;