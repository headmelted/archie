#!/bin/bash

# get.sh
#
# Clone the given git endpoint into the .code folder, and make the executing
# user the owner of the folder.
#
# usage: get.sh <git_endpoint_url>

echo "Temporarily exiting code directory to replace it";
cd ..;

echo "Remove .code folder if it exists"
rm -rf $CODE_DIRECTORY;

echo "Creating .code folder";
mkdir $CODE_DIRECTORY;

echo "Retrieving code from git endpoint [$COBBLER_GIT_ENDPOINT] into [$CODE_DIRECTORY]";
git clone $COBBLER_GIT_ENDPOINT $CODE_DIRECTORY;
  
echo "Setting current owner as owner of code folder";
chown ${USER:=$(/usr/bin/id -run)}:$USER -R $CODE_DIRECTORY;

echo "Entering code directory";
cd $CODE_DIRECTORY;