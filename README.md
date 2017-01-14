# Haskell for Mac Package Builder

This repository contains package builder scripts to add extra packages to Haskell for Mac. This includes packages that wrap extra foreign language libraries.

* `script` — builder scripts
* `packages` — package specifications
* `sets` — package set specifications

Package sets are sets of packages needed to provide specific functionality — for example, the `llvm-general` set consists of all packages that are needed to use the `llvm-general` package, *including* the LLVM C++ framework. Package sets can be archived for binary distribution. Package sets can be dependent on other package sets — for example, the `accelerate` set depends on the `llvm-general` set.

Package builders are entirely self-contained and automatically download and build all required components. However, there is currently no dependency management; i.e., package builders explicitly need to be executed in package dependency order. Package sets ensure that all enclosed packages are built in the correct order.
