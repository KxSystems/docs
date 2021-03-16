---
title: Using foreign functions with kdb+ – Interfaces – kdb+ and q documentation
description: FFI for kdb+ is an extension to kdb+ for loading and calling dynamic libraries using pure q.
author: Masato Shimizu
date: February 2021
---

# :fontawesome-solid-map-signs: Ffikdb

:fontawesome-brands-github:
[KxSystems/ffikdb](https://github.com/kxsystems/ffi)

FFI (foreign function interface) is a mechanism by which a program written in one programming language can call routines or make use of services written in another. 

Some programs may not know at compilation what arguments are to be passed to a function. For instance, an interpreter may be told at runtime about the number and types of arguments used to call a given function. Libffi can be used in such programs to provide a bridge from the interpreter program to compiled code.

This interface uses [Libffi](https://sourceware.org/libffi/),  pre-installed in many OSs.  (Except for some Linux OS.) 

:fontawesome-brands-github: 
[KxSystems/ffikdb](https://github.com/KxSystems/ffi#requirements): pre-requisites
<br>
:fontawesome-brands-github: 
[libffi/libffi/doc](https://github.com/libffi/libffi/tree/master/doc): documentation


## FFI/kdb+ integration

Ffikdb is an extension to kdb+ for loading and calling dynamic libraries using pure q. The main purpose of the library is to build stable interfaces on top of external libraries, or to interact with the operating system from q. No compiler toolchain or writing C/C++ code is required to use this library.

!!! warning "Understand what you are doing"

    You do not need to write C code, but you do need to understand what you are doing. 
    You can easily crash the kdb+ process or corrupt data structures in memory with little information about what happened. 

    For example, when a q callback function passed to the foreign function fails, you might see an error message in the console but, as the foreign function cannot handle a q error, execution stops and crashes the entire application. 
    <!-- Or if you passed valid but wrong type characters to q callback, internal conversion failure of q cannot be handed and application crashes without any error message. -->

    No support is offered for crashes caused by use of this library.


### Acknowledgement

![Alexander Belopolsky](../../img/faces/alexanderbelopolsky.jpg)
{: .small-face}

We are grateful to [Alexander Belopolsky](https://www.linkedin.com/in/alexander-belopolsky-389bb944) for allowing us to adapt and expand on his original codebase. 