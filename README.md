# Cobbler
## Easy cross-compilation and testing for busy developers

Cobbler is a series of pre-configured Ubuntu images that are collectively intended to make compiling and testing code for multiple architectures as simple as possible.

By using some sensible defaults, and several commonly used and well-supported tools, Cobbler's goal is to make supporting architectures such as ARM, PowerPC and SPARC, as simple as building for Intel.

Certain projects are a better fit than others to use Cobbler for performing and testing CI builds.  Specifically, any code that relies heavily on architecture-specific calls is not likely to benefit much (if it all) from using Cobbler.

### Supported architectures
As Cobbler is built on Ubuntu Cosmic, the architectures supported mirror those supported by the operating system.  Specifically, Cobbler provides docker containers for compiling from 64-bit Intel build servers to:

* i386 (32-bit Intel)
* amd64 (64-bit Intel)
* armhf (32-bit ARM)
* arm64 (64-bit ARM)
* ppc64el (64-bit IBM PowerPC, Little-endian)
* s390x (64-bit IBM Z/LinuxONE)
