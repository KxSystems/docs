---
title: Interface examples | FFI | Interfaces | Documentation for kdb+ and q
description: Examples of using the FFI interface to call R and C code
author: Masato Shimizu
date: February 2021
---
# FFI interface examples




:fontawesome-brands-github:
[KxSystems/ffikdb](https://github.com/KxSystems/ffi)


## Rmath library

_Bindings to Rmath using FFI for kdb+_

[Rmath](https://cran.r-project.org/doc/manuals/r-release/R-admin.html#The-standalone-Rmath-library) provides the routines supporting the distribution and special (e.g. Bessel, beta and gamma functions) functions in R.

Prerequisites :

-   stand-alone Rmath library
-   FFI for kdb+

Install Rmath according to the platform you are using. For example;

=== "Ubuntu"

    ```bash
    sudo apt-get install r-mathlib
    ```

=== "CentOS/RedHat"
 
    ```bash
    sudo yum install libRmath
    ```

Generate 100K numbers from normal distribution:

```q
q)// Bind rnorm function
q).rm.rnorm:.ffi.bind[`libRmath.so`rnorm; "jff"; "f"]
q)// Bind set_seed function
q).rm.set_seed:.ffi.bind[`libRmath.so`set_seed; "ii"; " "]
q)// Set random seed
q).rm.set_seed (456i; 789i; ::)
q)norms:`float$()
q)do[100000; gen:.rm.rnorm (1; 0f; 1f; ::); if[-9h ~ type gen; norms,: gen]]
q)// verify that avg and dev are 0 and 1
q)(avg; dev) @\: norms
0.003488721 1.002219
```


## Standard C library

```q
q)// Buffer
q)buffer: 80#"\000"

q)// Write to buffer and return the number of bytes written
q)args:(buffer; "%s %.4f %hd\000"; "example\000"; 3.16f; 144000h; ::)
q)n:.ffi.callFunction[("i"; `sprintf)] args

q)// Show the written characters
q)buffer til n
"example 3.1600 32767"

q)// Bind qsort function
q).cstdlib.qsort:.ffi.bind[`qsort; "liik"; " "];

q)// Callback function
q)cmp:{0N!"compare: ",.Q.s x,y; (x>y)-x<y};
q)seq:3 1 2i

q).cstdlib.qsort (seq; `int$count seq; 4i; (cmp; "II"; "i"); ::)
"compare: 1 2i\n"
"compare: 3 1i\n"
"compare: 3 2i\n"

q)seq
1 2 3i
q)seq:101b

q).cstdlib.qsort (seq; `int$count seq; 1i; (cmp; "BB"; "i"); ::)
"compare: 01b\n"
"compare: 10b\n"
"compare: 11b\n"

q)seq
011b
q)seq:`c`a`b;

q)// symbols are pointers - size of pointer is .ffi.ptrsize[]
q).cstdlib.qsort (seq; `int$count seq; .ffi.ptrsize[]; (cmp; "SS"; "i"); ::)
"compare: `a`b\n"
"compare: `c`a\n"
"compare: `c`b\n"

q)seq
`a`b`c

```
