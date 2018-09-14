# Cobbler
## Easy multi-arch compilation and testing for busy developers

Cobbler is a series of pre-configured Ubuntu images that are collectively intended to make compiling and testing code for multiple architectures as simple as possible.

By using some sensible defaults, and several commonly used and well-supported tools, Cobbler's goal is to make supporting architectures such as ARM, PowerPC and SPARC, as simple as building for Intel.

Certain projects are a better fit than others to use Cobbler for performing and testing CI builds.  Specifically, any code that relies heavily on architecture-specific calls is not likely to benefit much (if it all) from using Cobbler.
