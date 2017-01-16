# Haskell for Mac Package Builder

This repository contains package builder scripts to add extra packages to Haskell for Mac. This includes packages that wrap extra foreign language libraries.

* `script` — builder scripts
* `packages` — package specifications
* `sets` — package set specifications

Package sets are sets of packages needed to provide specific functionality — for example, the `llvm-general` set consists of all packages that are needed to use the `llvm-general` package, *including* the LLVM C++ framework. Package sets can be archived for binary distribution. Package sets can be dependent on other package sets — for example, the `accelerate` set depends on the `llvm-general` set.

Package builders are entirely self-contained and automatically download and build all required components. However, there is currently no dependency management; i.e., package builders explicitly need to be executed in package dependency order. Package sets ensure that all enclosed packages are built in the correct order.

## Supported package sets

So far, we have support for three package sets (c.f., the `sets/` subdirectory of this repo):

* `llvm-general` — Haskell interface to the LLVM compiler toolkit: the main package is [llvm-general](https://hackage.haskell.org/package/llvm-general).
* `accelerate` — embedded array language for high-performance computations on multicore CPUs and GPUs: this package set contains the pre-release version of [Accelerate 1.0](https://github.com/AccelerateHS/accelerate/) including a parallelising and SIMD-vectorising CPU multicore backend. (No GPU backend support included, but programs developed with this package can also be run on GPUs.) This package set also includes all of `llvm-general`.
* `hmatrix` — Haskell interface to BLAS, LAPACK, and GSL.

To install a package set by compiling from source, 

1. clone this repo and
2. execute `build_set.sh install <package set>`.

For example, `build_set.sh install accelerate-1.0` will install the entire Accelerate package set.

The `build_set.sh` script also supports achiving a package set into a binary package set archive (tar ball), which in turn can be installed with `install_set.sh`. Binary package sets are relocatable and can be installed on other Macs with `install_set.sh`.

All this assumes that the Haskell for Mac command line tools are already installed.
