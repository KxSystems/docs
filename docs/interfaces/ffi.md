---
title: FFI interface for kdb+ | Interfaces | kdb+ and q documentation
description: Foreign function interface for kdb+
keywords: ffi, dll, api, ipc
---

# FFI interface for kdb+

FFI (foreign function interface) is a mechanism by which a program written in one programming language can call routines or make use of services written in another.

The FFI interface is an extension to kdb+ for loading and calling dynamic libraries using pure q. 
The main purpose of the library is to build stable interfaces on top of external libraries, or to interact with the operating system from q. 

No compiler toolchain or writing C/C++ code is required to use this library.

The FFI interface is documented and available to download from [https://github.com/KxSystems/ffi/](https://github.com/KxSystems/ffi/)
