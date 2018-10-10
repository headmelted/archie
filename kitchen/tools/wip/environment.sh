#!/bin/bash

architecture_packages="";
need_update="false";

if [[ $COBBLER_ARCH != "amd64" ]]; then

  echo "Checking installed foreign architectures";
  foreign_architecture_list=$(dpkg --print-foreign-architectures);
  
  echo "Foreign architectures installed:
$foreign_architecture_list
";

  if [[ $foreign_architecture_list != *"$COBBLER_ARCH"* ]]; then
  
    echo "Adding $COBBLER_ARCH architecture";
    dpkg --add-architecture $COBBLER_ARCH;
    
  fi;
  
  echo "Adding architecture packages to install list";
  architecture_packages="libc6-$COBBLER_ARCH-cross libstdc++6-$COBBLER_ARCH-cross gcc-${GNU_TRIPLET} g++-${GNU_TRIPLET} crossbuild-essential-$COBBLER_ARCH";
  echo "Adding: $COBBLER_ARCHitecture_packages";
  
  need_update="true";
  
else
  
  echo "Architecture is native, no need for foreign architecture installation";
  architecture_packages="gcc-4.9 g++-4.9";
  
fi;

# echo "Removing existing codebuilds package sources";
# rm -rf /etc/apt/sources.list.d/codebuilds_multiarch.list;
echo "Installing lsb-release";
apt-get install -y lsb-release;

if [[ ! -f /etc/apt/sources.list.d/codebuilds_multiarch.list ]]; then

  echo "Setting up APT";
  cp ./tools/codebuilds_multiarch.list /etc/apt/sources.list.d/codebuilds_multiarch.list;
  
  ubuntu_version=$(lsb_release -c | awk '{print $NF}');
  echo "Setting Ubuntu version to [$ubuntu_version] in source list";
  sed -i -e "s/UBUNTU_VERSION/$ubuntu_version/g" /etc/apt/sources.list.d/codebuilds_multiarch.list;
  
  need_update="true";
  
else

  echo "Codebuilds multiarch repositories added already";

fi;

# echo "Adding ubuntu test repository (remove if already present)";
# add-apt-repository -y --remove ppa:ubuntu-toolchain-r/test;
# add-apt-repository -y ppa:ubuntu-toolchain-r/test;

echo "Binding all unfiltered repositories to intel";
sed -i 's/deb http/deb [arch=amd64,i386] http/g' /etc/apt/sources.list;
sed -i 's/deb http/deb [arch=amd64,i386] http/g' /etc/apt/sources.list.d/*.list;

if [[ "$need_update" == "true" ]]; then

  echo "Updating package repositories";
  apt-get update -yq;
  
fi;
  
echo "Installing toolchain";
apt install -y ${architecture_packages} mlocate software-properties-common xvfb wget git python curl zip p7zip-full libgtk2.0-0:$COBBLER_ARCH libxkbfile-dev:$COBBLER_ARCH libx11-dev:$COBBLER_ARCH libxdmcp-dev:$COBBLER_ARCH rpm graphicsmagick libwww-perl libxml-libxml-perl libxml-sax-expat-perl dpkg-dev perl libconfig-inifiles-perl libxml-simple-perl liblocale-gettext-perl libdpkg-perl libconfig-auto-perl libdebian-dpkgcross-perl ucf debconf dpkg-cross libdbus-1-3:$COBBLER_ARCH libpcre3:$COBBLER_ARCH libselinux1:$COBBLER_ARCH libp11-kit0:$COBBLER_ARCH libcomerr2:$COBBLER_ARCH libk5crypto3:$COBBLER_ARCH libkrb5-3:$COBBLER_ARCH libpango-1.0-0:$COBBLER_ARCH libpangocairo-1.0-0:$COBBLER_ARCH libpangoft2-1.0-0:$COBBLER_ARCH libxcursor1:$COBBLER_ARCH libxfixes3:$COBBLER_ARCH libfreetype6:$COBBLER_ARCH libavahi-client3:$COBBLER_ARCH libgssapi-krb5-2:$COBBLER_ARCH libjpeg8:$COBBLER_ARCH  libtiff5:$COBBLER_ARCH fontconfig-config libgdk-pixbuf2.0-common libgdk-pixbuf2.0-0:$COBBLER_ARCH libfontconfig1:$COBBLER_ARCH libcups2:$COBBLER_ARCH libcairo2:$COBBLER_ARCH libc6-dev:$COBBLER_ARCH libatk1.0-0:$COBBLER_ARCH libx11-xcb-dev:$COBBLER_ARCH libxtst6:$COBBLER_ARCH libxss-dev:$COBBLER_ARCH libgconf-2-4:$COBBLER_ARCH libasound2:$COBBLER_ARCH libnss3:$COBBLER_ARCH zlib1g:$COBBLER_ARCH zlib1g-dev qemu binfmt-support qemu-user-static;
  
echo "Symlinking libxkbfile.so";
rm -rf /usr/lib/libxkbfile.so;
ln -s /usr/lib/${GNU_TRIPLET}/libxkbfile.so /usr/lib/libxkbfile.so;
  
echo "Symlinking libstdc++.so.6";
rm -rf /usr/lib/libstdc++.so.6;
if [ "$COBBLER_CROSS_TOOLCHAIN" == "true" ]; then
  ln -s /usr/lib/${GNU_TRIPLET}/libstdc++.so.6 /usr/lib/libstdc++.so.6;
else
  ln -s /usr/${GNU_TRIPLET}/lib/libstdc++.so.6 /usr/lib/libstdc++.so.6;
fi;

echo "Checking that LD_LIBRARY_PATH is looking in multi-arch directories, adding where necessary";
if [[ $LD_LIBRARY_PATH != *"/usr/${GNU_TRIPLET}/lib"* ]]; then LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/${GNU_TRIPLET}/lib; fi;
if [[ $LD_LIBRARY_PATH != *"/usr/lib/${GNU_TRIPLET}"* ]]; then LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/${GNU_TRIPLET}; fi;
if [[ $LD_LIBRARY_PATH != *"/lib/${GNU_TRIPLET}"* ]]; then LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lib/${GNU_TRIPLET}; fi;

echo "Checking if multilib emulation is required";
if [[ ${GNU_MULTILIB_TRIPLET} != "" ]]; then
  echo "Checking that LD_LIBRARY_PATH is looking in multilib multi-arch directories, adding where necessary";
  if [[ $LD_LIBRARY_PATH != *"/usr/${GNU_MULTILIB_TRIPLET}/lib"* ]]; then LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/${GNU_MULTILIB_TRIPLET}/lib; fi;
  if [[ $LD_LIBRARY_PATH != *"/usr/lib/${GNU_MULTILIB_TRIPLET}"* ]]; then LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/usr/lib/${GNU_MULTILIB_TRIPLET}; fi;
  if [[ $LD_LIBRARY_PATH != *"/lib/${GNU_MULTILIB_TRIPLET}"* ]]; then LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lib/${GNU_MULTILIB_TRIPLET}; fi;
else
  echo "Multilib multi-arch emulation not required";
fi;

# echo "Installing QEMU";
# . ./tools/get_qemu_resin.sh;
  
echo "Emulators available:";
update-binfmts --display;
  
echo "Reading proc";
ls /proc/sys/fs/;
  
# echo "Mounting binfmt_misc";
# mount binfmt_misc -t binfmt_misc /proc/sys/fs/binfmt_misc;

echo "Enabling binfmt_misc";
echo 1 > /proc/sys/fs/binfmt_misc/status;

if [[ $COBBLER_ARCH != "amd64" ]]; then
  echo "Enabling ${QEMU_ARCH} emulator";
  update-binfmts --enable qemu-${QEMU_ARCH};
fi;

echo "Emulators available:" && update-binfmts --display;
