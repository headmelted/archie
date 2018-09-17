### WARNING: THIS PROJECT IS STILL VERY MUCH A WORK-IN-PROGRESS AND SHOULD NOT BE USED FOR YOUR OWN PROJECTS YET. THERE'S A LOT OF PARTS MOVING AROUND. YE'VE BEEN WARNED!!

# Cobbler
## Easy cross-compilation and testing for busy developers

[![GitHub Stars](https://img.shields.io/github/stars/headmelted/cobbler.svg)](https://github.com/headmelted/cobbler/stargazers)
[![GitHub Watchers](https://img.shields.io/github/watchers/headmelted/cobbler.svg)](https://github.com/headmelted/cobbler/watchers)
[![Docker Stars](https://img.shields.io/docker/stars/headmelted/cobbler.svg)](https://hub.docker.com/r/headmelted/cobbler/)
[![Docker Pulls](https://img.shields.io/docker/pulls/headmelted/cobbler.svg)](https://hub.docker.com/r/headmelted/cobbler/)
[![Docker Build](https://img.shields.io/docker/build/headmelted/cobbler.svg)](https://hub.docker.com/r/headmelted/cobbler/builds/)

Cobbler is a series of pre-configured Ubuntu images that are collectively intended to make compiling and testing code for multiple architectures as simple as possible.

By using some sensible defaults, and several commonly used and well-supported tools, Cobbler's goal is to make supporting architectures such as ARM, PowerPC and SPARC as simple as building for Intel.

Certain projects are a better fit than others to use Cobbler for performing and testing CI builds.  Specifically, any code that relies heavily on architecture-specific calls is not likely to benefit much (if it all) from using Cobbler.

### Supported architectures
There are effectively two lists of supported architectures for Cobbler. Compiling and testing of programs without dependendent packages (i.e. programs for which no dependencies need to be pulled from Ubuntu Cosmic repositories) is supported for the intersection of architectures of GCC and QEMU.

As Cobbler is built on Ubuntu Cosmic, the architectures supported for those programs which have dependencies on standard packages within the repository mirror those supported by the operating system.  To clarify, the table below shows the state of support for different architectures within Cobbler.

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

_Note that the amd64 target does not involve cross-compilation, and simply maps the $CC and $CXX variables to GCC 4.9.  The target is included so that the same pattern can be followed for all architectures within Cobbler itself.  It's expected therefore that most projects using Cobbler will treat their build process agnostically of the underlying processor architecture of their target._
