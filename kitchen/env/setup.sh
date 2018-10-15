#!/bin/bash
set -e;

if [ -n "${ARCHIE_DOCKER_TAG}" ] && [ "${ARCHIE_DOCKER_TAG}" != "base" ]; then

  echo "No target strategy specified, setting Archie strategy and arch from tag";
  ARCHIE_TAG_SETTINGS=(${ARCHIE_DOCKER_TAG//-/ });
  export ARCHIE_STRATEGY=${ARCHIE_TAG_SETTINGS[0]};
  export ARCHIE_ARCH=${ARCHIE_TAG_SETTINGS[1]};

fi

echo "Setting Archie environment for all architectures";
export ARCHIE_OS_DISTRIBUTION_NAME=debian;
export ARCHIE_OS_RELEASE_NAME=stretch;

echo "Setting Archie environment for [$ARCHIE_ARCH]"
. $ARCHIE_HOME/kitchen/env/linux/$ARCHIE_ARCH.sh;

#echo "Checking kernel for binfmt_misc support";
#config_binfmt_misc=$(zcat /proc/config.gz | grep -i binfmt_misc);
#if [ "$config_binfmt_misc" == "CONFIG_BINFMT_MISC=y" ] ; then
#  export ARCHIE_QEMU_INTERCEPTION_MODE="binfmt_misc";
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

export ARCHIE_QEMU_INTERCEPTION_MODE="binfmt_misc";

echo "Setting cleanroom paths";
export ARCHIE_CLEANROOM_DIRECTORY=/root/jail;

echo "Setting code and output paths";
export ARCHIE_OUTPUT_DIRECTORY=/root/output;
export ARCHIE_CODE_DIRECTORY=$(pwd);

echo "Matching npm_config_arch to npm_config_target_arch. THIS MAY BE WRONG - CONTACT ME IF THIS IS THE CASE."
export npm_config_arch=$npm_config_target_arch;

echo "Setting compiler configuration for [$ARCHIE_STRATEGY]";

ARCHIE_CROSS_LIB_PATH="/usr/lib/$ARCHIE_GNU_TRIPLET";

pkg_config_path=""
linkage_list=""

if [ $ARCHIE_STRATEGY == "cross" ]; then
 
  pkg_config_linkage_list="";
  for archie_dependency_package in $ARCHIE_TARGET_DEPENDENCIES; do
    pkg_config_linkage_list="$pkg_config_linkage_list $( pkg-config --libs --cflags $( basename $( dpkg-query -L libxkbfile-dev | grep .pc$ ) .pc ))";
  done;
  
  echo "PKG-CONFIG LINKAGE LIST (NOT CURRENTLY USED)--------------------------------------"
  echo pkg_config_linkage_list
  echo "----------------------------------------------------------------------------------"

  linkage_list="-L $ARCHIE_CROSS_LIB_PATH -I/usr/include/$ARCHIE_GNU_TRIPLET";
  pkg_config_path="/usr/share/pkgconfig:$ARCHIE_CROSS_LIB_PATH/pkgconfig";
  for package in $ARCHIE_TARGET_DEPENDENCIES; do
    linkage_list="$linkage_list -I/usr/lib/$ARCHIE_GNU_TRIPLET/$package/include"
  done
else
  if [ "$ARCHIE_STRATEGY" == "hybrid" ]; then
    linkage_list="--sysroot=$ARCHIE_CLEANROOM_DIRECTORY -L $ARCHIE_CLEANROOM_DIRECTORY$ARCHIE_CROSS_LIB_PATH -I$ARCHIE_CLEANROOM_DIRECTORY/usr/include/$ARCHIE_GNU_TRIPLET"
    pkg_config_path="$ARCHIE_CLEANROOM_DIRECTORY/usr/share/pkgconfig:$ARCHIE_CLEANROOM_DIRECTORY$ARCHIE_CROSS_LIB_PATH/pkgconfig";
    for package in $ARCHIE_TARGET_DEPENDENCIES; do
      linkage_list="$linkage_list -I$ARCHIE_CLEANROOM_DIRECTORY/usr/lib/$ARCHIE_GNU_TRIPLET/$package/include -I$ARCHIE_CLEANROOM_DIRECTORY/usr/include/$package"
    done
  else
    echo "TODO: OTHER STRATEGY LINKING";
  fi;
fi;

echo "Setting CC and CXX with linking for [$ARCHIE_STRATEGY]";
if [ "$ARCHIE_ARCH" == "i386" ]; then
  cc_compiler="x86_64-linux-gnu-gcc -m32";
  cxx_compiler="x86_64-linux-gnu-g++ -m32";
else
  cc_compiler="$ARCHIE_GNU_TRIPLET-gcc";
  cxx_compiler="$ARCHIE_GNU_TRIPLET-g++";
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
 
if [ $ARCHIE_STRATEGY == "cross" ]; then
  echo "Setting HOSTCC and HOSTCXX to x86_64 for cross";
  export HOSTCC='x86_64-linux-gnu-gcc';
  export HOSTCXX='x86_64-linux-gnu-g++';
else
  echo "Setting HOSTCC and HOSTCXX to CC and CXX";
  export HOSTCC=$CC;
  export HOSTCXX=$CXX;
fi;
