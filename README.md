![Cobbler logo](https://github.com/headmelted/cobbler/raw/master/logo_128.png)

# Cobbler
## Simple cross-compilation for busy projects

_WARNING: THIS PROJECT IS STILL VERY MUCH A WORK-IN-PROGRESS AND SHOULD NOT BE USED FOR YOUR OWN PROJECTS YET. THERE'S A LOT OF PARTS MOVING AROUND. YE'VE BEEN WARNED!!_

[![GitHub Stars](https://img.shields.io/github/stars/headmelted/cobbler.svg)](https://github.com/headmelted/cobbler/stargazers)
[![GitHub Watchers](https://img.shields.io/github/watchers/headmelted/cobbler.svg)](https://github.com/headmelted/cobbler/watchers)
[![Docker Stars](https://img.shields.io/docker/stars/headmelted/cobbler.svg)](https://hub.docker.com/r/headmelted/cobbler/)
[![Docker Pulls](https://img.shields.io/docker/pulls/headmelted/cobbler.svg)](https://hub.docker.com/r/headmelted/cobbler/)
[![Docker Build](https://img.shields.io/docker/build/headmelted/cobbler.svg)](https://hub.docker.com/r/headmelted/cobbler/builds/)

### What is Cobbler?
Cobbler is a series of pre-configured Debian images that are collectively intended to make compiling and testing code for multiple architectures in a CI (Continuous Integration) setup as simple as possible.

By using some sensible defaults, and several commonly used and well-supported tools, Cobbler's goal is to make compiling platform-agnostic code to architectures such as ARM, PowerPC and SPARC as simple as building for Intel.

### Who should use Cobbler?
Certain projects are a better fit than others for the assumptions Cobbler makes.  Specifically, any code that relies heavily on architecture-specific calls is will see limited benefit from using Cobbler, whereas platform-agnostic C\C++ code (or code in higher-level languages with platform-agnostic C\C++ dependencies) is likely to have much better results.

It's expected that Cobbler should be able to compile fully platform-agnostic code to any target it supports verbatim, but any architecture-specific calls will need to be patched to support your target.  Cobbler can still help with migrating your project to support multiple architectures, but it won't be able to do this for you.

### How to get started
Typically, the easiest way to get started with Cobbler is to first try to migrate your existing build script to building inside Cobbler with the amd64 target (i.e. an amd64 to amd64 build).  Once your scripts are correctly configured for Cobbler, and your project is compiling for amd64, targeting other architectures should be as simple as adding a target architecture from the Supported Architectures table to your configuration.

## Compilation
### Supported strategies
Cobbler supports three different compilation strategies for a target architecture within a session, as explained below.  Each of these strategies are agnostic of the structure of code, such that you should be able to change the setting as needed without making changes to your own code.

#### cross
The compilation is performed using amd64 GNU cross-compilers for the target architecture.  When using this strategy, the dependency packages for the target architecture are installed, and linked explicitly during compilation.

_This is the fastest compilation strategy (broadly similar to compiling directly to amd64 in the simplest cases), but may not play well with all dependencies of your project. During compilation, the $CC and $CXX variables commonly used to alias GCC are modified to explicitly include linking of the supporting depdencies for the target architecture.  While this is often all you'll need for cross-compilation, you may experience execution format errors that are likely a sign of native code running inside a dependency. This likely means you'll need to choose another strategy._

#### emulate
The compilation is performed in a QEMU debootstrap of the target architecture. This is slower than using the cross method, but increases compatibility by transparently emulating every call not made by the compiler.

_This strategy may be necessary in scenarios where compilation steps (or calls made by dependencies of the project during the build) are compiled for the target architecture.  In these scenarios, using the *cross* strategy would fail if (for example) a dependency package needed to execute architecture-specific code during it's installation as part of a pre- or post- install script. When using the *emulate* strategy, the execution of this code would be handled by QEMU transparently, but would likely be slower than direct *cross* compilation._

#### virtualize
The compilation is performed in a virtualized QEMU system that is running the target architecture top-to-bottom.  This strategy has the highest compatibility, as all build steps will be performed under the target architecture with it's native build of GCC, but at a significant performance cost due to the emulation overhead.

This strategy is also useful in scenarios where you need to be able to confirm that your code can be compiled by downstream users with specific devices (e.g. specific niche processors, lower memory).

_An example of this is targeting (for example) the Raspberry Pi line of single-board computers.  It's possible (thanks to QEMU's excellent support for systme virtualization) to perform the compilation on a virtual version of a specific model of the Raspberry Pi (that matches the physical hardware as closely as possible) to confirm that your software can be compiled directly on the device, rather than just executed on it._

### Convenience variables
Cobbler sets a series of global variables inside each session that can be used to help with your builds.  The table below explains these variables, and gives some context as to expected use cases.  Note that most Cobbler globals are prefixed with *COBBLER_* so as to prevent conflicts with your own variables.  *The exception to this rule is where Cobbler intentionally overwrites global variables to make cross-compilation easier.  These variables, and the changes made, are shown below*.

| Global                               | Description                                                                 |
|--------------------------------------|-----------------------------------------------------------------------------|
| $COBBLER_STRATEGY                    | The strategy of the current session (*cross*, *emulate* or *virtualize*)    |
| $COBBLER_OS_DISTRIBUTION_NAME        | The Linux distribution Cobbler is running on (currently *debian*)           |
| $COBBLER_OS_RELEASE_NAME             | The Linux release Cobbler is running on (currently *stretch-slim*)          |
| $COBBLER_CLEANROOM_ROOT_DIRECTORY    | The directory in which the architecture-specific cleanrooms are placed      |
| $COBBLER_CLEANROOM_RELEASE_DIRECTORY | A sub-directory of the cleanroom corresponding to the OS release            |
| $COBBLER_CLEANROOM_DIRECTORY         | The directory of the cleanroom for the current session (if using *cross* or *emulate* strategies)    |
| $COBBLER_KITCHEN_DIRECTORY | to follow |
| $COBBLER_BUILD_DIRECTORY | to follow |
| $COBBLER_OUTPUT_DIRECTORY | to follow |
| $COBBLER_CODE_DIRECTORY | to follow |

## Architecture Matrix
There are effectively two lists of supported architectures for Cobbler. Compiling and testing of programs without dependendent packages (i.e. programs for which no dependencies need to be pulled from Debian repositories) is supported for the intersection of architectures of GCC and QEMU.

As Cobbler is built on Debian Stretch, the architectures supported for those programs which have dependencies on standard packages within the repository mirror those supported by the operating system.  To clarify, the table below shows the state of support for different architectures within Cobbler.

| Architecture  | Family   | Bit width        | Compilation   | Dependencies  | FSE           | rootfs
|---------------|----------|------------------|---------------|---------------|---------------|-----------:
| i386          | x86      | 32               | Cross         | Yes           | Yes           | Yes
| amd64         | x86      | 64               | Native        | Yes           | Yes           | Yes
| armel         | ARM      | 32               | Cross         | Yes           | Yes           | Yes
| armhf         | ARM      | 32 _(hard fp)_   | Cross         | Yes           | Yes           | Yes
| arm64         | ARM      | 64               | Cross         | Yes           | Yes           | Yes
| mips          | MIPS     | 32 _(be)_        | Cross         | Yes           | Yes           | Yes
| mipsel        | MIPS     | 32 _(le)_        | Cross         | Yes           | Yes           | Yes
| mips64        | MIPS     | 64               | Cross         | Yes           | Yes           | Yes
| ppc64el       | POWER    | 64               | Cross         | Yes           | Yes           | Yes
| s390x         | IBM Z    | 64               | Cross         | Yes           | Yes           | Yes

_Note that the amd64 target does not involve cross-compilation, and simply maps the $CC and $CXX variables to directly to the x86_64 GCC compilers.  The target is included so that the same pattern can be followed for all architectures within Cobbler itself.  It's expected therefore that most projects using Cobbler will treat their build process agnostically of the underlying architecture of their target._


