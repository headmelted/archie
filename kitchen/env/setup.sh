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

echo "Setting up compilers";
. $ARCHIE_HOME/kitchen/tools/archie_initialize_compilers.sh;
