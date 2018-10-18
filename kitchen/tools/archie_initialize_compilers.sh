#!/bin/bash
set -e;

echo "Setting compiler configuration for [$ARCHIE_STRATEGY]";

ARCHIE_CROSS_LIB_PATH="/usr/lib/$ARCHIE_GNU_TRIPLET";

pkg_config_path=""
linkage_list=""

pkg_config_linkage_list="";
for archie_dependency_package in $ARCHIE_TARGET_DEPENDENCIES; do
  for pkg_config_file in $(dpkg-query -L libsecret-1-dev | grep .pc$); do
    pkg_config_id=$(basename $pkg_config_file .pc);
    pkg-config --libs --cflags $pkg_config_id
  done;
  pkg_config_linkage_list=$( pkg-config --libs --cflags );
  pkg_config_linkage_list="$pkg_config_linkage_list ";
done;
  
echo "PKG-CONFIG LINKAGE LIST (NOT CURRENTLY USED)--------------------------------------"
echo pkg_config_linkage_list
echo "----------------------------------------------------------------------------------"

if [ $ARCHIE_STRATEGY == "cross" ]; then
  linkage_list="-L$ARCHIE_CROSS_LIB_PATH -I/usr/include/$ARCHIE_GNU_TRIPLET";
  pkg_config_path="/usr/share/pkgconfig:$ARCHIE_CROSS_LIB_PATH/pkgconfig";
  for package in $ARCHIE_TARGET_DEPENDENCIES; do
    linkage_list="$linkage_list -I/usr/lib/$ARCHIE_GNU_TRIPLET/$package/include"
  done
else
  if [ "$ARCHIE_STRATEGY" == "hybrid" ]; then
    linkage_list="--sysroot=$ARCHIE_CLEANROOM_DIRECTORY -L$ARCHIE_CROSS_LIB_PATH -I/usr/include/$ARCHIE_GNU_TRIPLET"
    pkg_config_path="$ARCHIE_CLEANROOM_DIRECTORY/usr/share/pkgconfig:$ARCHIE_CLEANROOM_DIRECTORY$ARCHIE_CROSS_LIB_PATH/pkgconfig";
    for package in $ARCHIE_TARGET_DEPENDENCIES; do
      linkage_list="$linkage_list -I/usr/lib/$ARCHIE_GNU_TRIPLET/$package/include -I/usr/include/$package"
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