#!/bin/bash
set -e;

if [ $# -eq 0 ]
then

  echo "No target strategy specified, setting Cobbler strategy and arch from tag";
  COBBLER_TAG_SETTINGS=(${COBBLER_DOCKER_TAG//-/ });
  export COBBLER_STRATEGY=${COBBLER_TAG_SETTINGS[0]};
  export COBBLER_ARCH=${COBBLER_TAG_SETTINGS[1]};

else

  echo "Setting Cobbler strategy and arch from parameters"
  export COBBLER_STRATEGY=$1;
  export COBBLER_ARCH=$2;

fi

echo "Setting Cobbler environment for all architectures";
export COBBLER_OS_DISTRIBUTION_NAME=debian;
export COBBLER_OS_RELEASE_NAME=stretch;

echo "Setting Cobbler environment for [$COBBLER_ARCH]"
. $COBBLER_HOME/kitchen/env/linux/$COBBLER_ARCH.sh;

#echo "Checking kernel for binfmt_misc support";
#config_binfmt_misc=$(zcat /proc/config.gz | grep -i binfmt_misc);
#if [ "$config_binfmt_misc" == "CONFIG_BINFMT_MISC=y" ] ; then
#  export COBBLER_QEMU_INTERCEPTION_MODE="binfmt_misc";
#else
#  echo "ToDo add support for CAP_SYS_PTRACE and proot as a fallback, and then potentially QEMU EXECVE() interception as a last resort."
#  exit;
#  
#  echo "Disabling SECCOMP for proot";
#  export PROOT_NO_SECCOMP=1;
#  
#  echo "Setting QEMU_EXECVE flag to allow QEMU to intercept execve() calls without binfmt_misc";
#  export QEMU_EXECVE=1;
#fi;

export COBBLER_QEMU_INTERCEPTION_MODE="binfmt_misc";

echo "Setting cleanroom paths";
export COBBLER_CLEANROOM_DIRECTORY=/root/jail;

echo "Setting code and output paths";
export COBBLER_OUTPUT_DIRECTORY=~/output;
export COBBLER_CODE_DIRECTORY=~/code;

echo "Matching npm_config_arch to npm_config_target_arch. THIS MAY BE WRONG - CONTACT ME IF THIS IS THE CASE."
export npm_config_arch=$npm_config_target_arch;

echo "Setting compiler configuration for [$COBBLER_STRATEGY]";

COBBLER_CROSS_LIB_PATH="/usr/lib/$COBBLER_GNU_TRIPLET";

pkg_config_path=""
linkage_list=""

if [ $COBBLER_STRATEGY == "cross" ]; then
  linkage_list="-L $COBBLER_CROSS_LIB_PATH -I/usr/include/$COBBLER_GNU_TRIPLET";
  pkg_config_path="/usr/share/pkgconfig:$COBBLER_CROSS_LIB_PATH/pkgconfig";
  for package in $COBBLER_TARGET_DEPENDENCIES; do
    linkage_list="$linkage_list -I/usr/lib/$COBBLER_GNU_TRIPLET/$package/include"
  done
else
  if [ "$COBBLER_STRATEGY" == "hybrid" ]; then
    linkage_list="--sysroot=$COBBLER_CLEANROOM_DIRECTORY -L $COBBLER_CLEANROOM_DIRECTORY$COBBLER_CROSS_LIB_PATH -I$COBBLER_CLEANROOM_DIRECTORY/usr/include/$COBBLER_GNU_TRIPLET"
    pkg_config_path="$COBBLER_CLEANROOM_DIRECTORY/usr/share/pkgconfig:$COBBLER_CLEANROOM_DIRECTORY$COBBLER_CROSS_LIB_PATH/pkgconfig";
    for package in $COBBLER_TARGET_DEPENDENCIES; do
      linkage_list="$linkage_list -I$COBBLER_CLEANROOM_DIRECTORY/usr/lib/$COBBLER_GNU_TRIPLET/$package/include -I$COBBLER_CLEANROOM_DIRECTORY/usr/include/$package"
    done
  else
    echo "TODO: OTHER STRATEGY LINKING";
  fi;
fi;

echo "Setting CC and CXX with linking for [$COBBLER_STRATEGY]";
if [ "$COBBLER_ARCH" == "i386" ]; then
  cc_compiler="x86_64-linux-gnu-gcc -m32";
  cxx_compiler="x86_64-linux-gnu-g++ -m32";
else
  cc_compiler="$COBBLER_GNU_TRIPLET-gcc";
  cxx_compiler="$COBBLER_GNU_TRIPLET-g++";
fi;

echo "CC is [$cc_compiler]";
echo "CXX is [$cxx_compiler]";

export CC="$cc_compiler $linkage_list";
export CXX="$cxx_compiler $linkage_list";

echo "Setting package config path";
export PKG_CONFIG_PATH=$pkg_config_path;

echo "Setting TARGETCC and TARGETCXX to CC and CXX";
export TARGETCC=$CC;
export TARGETCXX=$CXX;
 
if [ $COBBLER_STRATEGY == "cross" ]; then
  echo "Setting HOSTCC and HOSTCXX to x86_64 for cross";
  export HOSTCC='x86_64-linux-gnu-gcc';
  export HOSTCXX='x86_64-linux-gnu-g++';
else
  echo "Setting HOSTCC and HOSTCXX to CC and CXX";
  export HOSTCC=$CC;
  export HOSTCXX=$CXX;
fi;

echo "Linking Options ----------------------------------------------"
echo $linkage_list;
echo "--------------------------------------------------------------"
