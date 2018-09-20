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
Cobbler is a series of pre-configured Debian Stretch containers that are collectively intended to make porting, compiling and testing code for multiple architectures in a CI (Continuous Integration) setup as simple as possible.

By using some sensible defaults, and several commonly used and well-supported tools, Cobbler's goal is to make compiling platform-agnostic code to architectures such as ARM, PowerPC and SPARC as simple as building for Intel.

### Who should use Cobbler?
Certain projects are a better fit than others for the assumptions Cobbler makes.  Specifically, any code that relies heavily on architecture-specific calls is will see limited benefit from using Cobbler, whereas platform-agnostic C\C++ code (or code in higher-level languages with platform-agnostic C\C++ dependencies) is likely to have much better results.

It's expected that Cobbler should be able to compile fully platform-agnostic code to any target it supports verbatim, but any architecture-specific calls will need to be patched to support your target.  Cobbler can still help with migrating your project to support multiple architectures, but it won't be able to do this for you.

### How to get started
Typically, the easiest way to get started with Cobbler is to first try to migrate your existing build script to building inside Cobbler with the amd64 target (i.e. an amd64 to amd64 build).  Once your scripts are correctly configured for Cobbler, and your project is compiling for amd64, targeting other architectures should be as simple as adding a target architecture from the Supported Architectures table to your configuration.

### Strategies
Cobbler supports three different strategies for working with a target architecture within a session, as explained below.  Each of these strategies are agnostic of the structure of code, such that you should be able to change the setting as needed without making changes to your own code.

#### cross
The session is executed using amd64 GNU cross-compilers for the target architecture.  When using this strategy, the dependency packages for the target architecture are installed, and linked explicitly during compilation.

_This is the fastest strategy for compilation (broadly equivalent in performance to compiling directly to amd64 in the simplest cases), but may not play well with all dependencies of your project. During compilation, the $CC and $CXX variables commonly used to alias GCC are modified to explicitly include linking of the supporting dependencies for the target architecture.  While this is often all you'll need for cross-compilation, you may experience execution format errors that are likely a sign of native code (specific to the *target* architecture) trying to run during installation of a dependency. If this happens you'll need to choose another strategy._

#### hybrid
The session is executed similarly to the _cross_ strategy, but depedencies are installed within an emulated environment for the target architecture such that any native code called during installation of the dependencies will execute as expected. This is typically less performant than the *cross* method, but increases compatibility by emulating every call not made by the compiler.

_This is likely to be suitable for most cross-compilation scenarios, and would be the first thing to try if you encounter exec format errors with the *cross* strategy.  Compilation performance is mostly preserved as amd64-native compilers are still used, and emulation will only occur for dependency installation processes._

#### emulate
The session is executed inside an emulated environment for the target architecture. This is less performant than using the *hybrid* strategy, but increases compatibility further by transparently emulating every call.

_It may be necessary to switch from *hybrid* to *emulate* in certain cases where hard-coded logic inside your code or dependencies requires the target architecture specifically._

#### virtualize
The session is executed in a virtualized QEMU system that is running an image compiled explicitly for the target architecture.  This strategy has the highest compatibility, as all logic will be performed within the target architecture with effectively no trace of native host components - but at a significant performance cost due to the emulation overhead.

_This strategy is most useful in scenarios where you need to be able to confirm that your code can be compiled by downstream users with specific devices (e.g. specific niche processors, lower memory). An example of this is targeting the Raspberry Pi line of single-board computers, which can be completely virtualised within a session._

### Support matrix
#### Variables
Cobbler sets a series of global variables inside each session that can be used to help with your builds.  The table below explains these variables, and gives some context as to what each one means.  Note that Cobbler globals are always prefixed with *COBBLER_* so as to prevent conflicts with your own variables _except_ in limited instances where Cobbler intentionally overwrites global variables to make cross-compilation easier.

| Global                               | Description                                                               | cross | hybrid | emulate | virtualize | bindings
|--------------------------------------|---------------------------------------------------------------------------|-------|--------|---------|------------|-------
| $COBBLER_ARCH                        | The target architecture of the current session                            | yes   | yes    | yes     | yes        | yes
| $COBBLER_STRATEGY                    | The strategy of the current session                                       | yes   | yes    | yes     | yes        | yes
| $COBBLER_OS_DISTRIBUTION_NAME        | The Linux distribution Cobbler is running on (currently *debian*)         | yes   | yes    | yes     | yes        | yes
| $COBBLER_OS_RELEASE_NAME             | The Linux release Cobbler is running on (currently *stretch-slim*)        | yes   | yes    | yes     | yes        | yes
| $COBBLER_CLEANROOM_ROOT_DIRECTORY    | The directory in which the architecture-specific cleanrooms are placed    | no    | no     | yes     | no         | no
| $COBBLER_CLEANROOM_RELEASE_DIRECTORY | A sub-directory of the cleanroom corresponding to the OS release          | no    | no     | yes     | no         | no
| $COBBLER_CLEANROOM_DIRECTORY         | The directory of the cleanroom for the current session                    | no    | no     | yes     | no         | no
| $COBBLER_OUTPUT_DIRECTORY            | This is where build artifacts should should be placed during compilation. | yes   | yes    | yes     | yes        | yes
| $COBBLER_CODE_DIRECTORY              | This is where the source code for compilation is placed.                  | yes   | yes    | yes     | yes        | yes

#### Architecture
There are effectively two lists of supported architectures for Cobbler. Compiling and testing of programs without dependendent packages (i.e. programs for which no dependencies need to be pulled from Debian repositories) is supported for the intersection of architectures of GCC and QEMU.

As Cobbler is built on Debian Stretch, the architectures supported for those programs which have dependencies on standard packages within the repository mirror those supported by the operating system.  To clarify, the table below shows the state of support for different architectures within Cobbler.

| Architecture  | Family   | Bit width        | cross   | hybrid  | emulate | virtualize | packages |
|---------------|----------|------------------|---------|---------|---------|------------|----------|
| i386          | x86      | 32               | yes     | yes     | yes     | yes        | all      |
| amd64         | x86      | 64               | faked * | yes     | yes     | yes        | all      |
| armel         | ARM      | 32               | yes     | yes     | yes     | yes        | all      |
| armhf         | ARM      | 32 _(hard fp)_   | yes     | yes     | yes     | yes        | all      |
| arm64         | ARM      | 64               | yes     | yes     | yes     | yes        | all      |
| mips          | MIPS     | 32 _(be)_        | yes     | yes     | yes     | yes        | all      |
| mipsel        | MIPS     | 32 _(le)_        | yes     | yes     | yes     | yes        | all      |
| mips64        | MIPS     | 64               | yes     | yes     | yes     | yes        | all      |
| ppc64el       | POWER    | 64               | yes     | yes     | yes     | yes        | all      |
| s390x         | IBM Z    | 64               | yes     | yes     | yes     | yes        | all      |

*\* The amd64 target does not actually involve cross-compilation, and simply maps directly to the x86_64 GCC compilers.  The target is included so that the the developer's build process can treat amd64 as agnostically as other architectures in Cobbler.
