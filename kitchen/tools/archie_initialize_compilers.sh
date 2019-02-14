#!/bin/bash
set -e;

echo "Setting compiler configuration for [$ARCHIE_STRATEGY]";

ARCHIE_CROSS_LIB_PATH="/usr/lib/$ARCHIE_GNU_TRIPLET";

#pkg_config_linkage_list="";
#for archie_dependency_package in $ARCHIE_TARGET_DEPENDENCIES; do
#  for pkg_config_file in $(dpkg-query -L $archie_dependency_package | grep .pc$); do
#    pkg_config_id=$(basename $pkg_config_file .pc);
#    pkg-config --libs --cflags $pkg_config_id
#  done;
#  pkg_config_linkage_list=$( pkg-config --libs --cflags );
#  pkg_config_linkage_list="$pkg_config_linkage_list ";
#done;
#  
#echo "PKG-CONFIG LINKAGE LIST (NOT CURRENTLY USED)--------------------------------------"
#echo pkg_config_linkage_list
#echo "----------------------------------------------------------------------------------"

linkage_list="-L$ARCHIE_CROSS_LIB_PATH -I/usr/include/$ARCHIE_GNU_TRIPLET";

if [ "$ARCHIE_STRATEGY" == "hybrid" ]; then
  compiler_root_directory=$ARCHIE_CLEANROOM_DIRECTORY;
  linkage_list="--sysroot=$ARCHIE_CLEANROOM_DIRECTORY -ldl $linkage_list"
else
  compiler_root_directory="";
fi

#export PKG_CONFIG_PATH="$compiler_root_directory/usr/share/pkgconfig:$compiler_root_directory$ARCHIE_CROSS_LIB_PATH/pkgconfig";

for package in $ARCHIE_TARGET_DEPENDENCIES; do
  linkage_list="$linkage_list -I$compiler_root_directory/usr/lib/$ARCHIE_GNU_TRIPLET/$package/include -I$compiler_root_directory/usr/include/$package";
done

echo "Setting CC and CXX with linking for [$ARCHIE_STRATEGY]";
if [ "$ARCHIE_ARCH" == "i386" ]; then
  cc_compiler="gcc -m32";
  cxx_compiler="g++ -m32";
else
  cc_compiler="$ARCHIE_GNU_TRIPLET-gcc";
  cxx_compiler="$ARCHIE_GNU_TRIPLET-g++";
fi;

echo "CC is [$cc_compiler]";
echo "CXX is [$cxx_compiler]";

export CC="$cc_compiler $linkage_list";
export CXX="$cxx_compiler $linkage_list";

echo "CC (with linking) is:";
echo "---------------------";
echo "$CC";
echo "---------------------";
echo "CXX (with linking) is:";
echo "---------------------";
echo "$CXX";
echo "---------------------";

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
