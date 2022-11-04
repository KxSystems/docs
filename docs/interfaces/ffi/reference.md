---
title: Function reference | FFI | Interfaces | Documentation for kdb+ and q
keywords: ffi, api, fusion, interface, q
author: Masato Shimizu
date: February 2021
---
# Ffikdb function reference


<div markdown="1" class="typewriter">
.ffi **FFI interface**

Call function
    [bind](#ffibind)            bind function to be called
    [callFunction](#fficallfunction)    one-off function call

Utility
    [cvar](#fficvar)            read global variable from the library
    [extension](#ffiextension)       file extension of a shared object
    [os](#ffios)              operating system
    [ptrsize](#ptrsize)         size of void*
    [setErrno](#ffiseterrno)        get or set error number
</div>

:fontawesome-brands-github:
[KxSystems/ffi](https://github.com/KxSystems/ffi)


## Argument and result types

Throughout the library, characters are used to encode the types of data provided and expected as a result. These are based on the `c` column of [primitive data types](../../basics/datatypes.md#primitive-datargument_types) for atoms, with upper case for vectors. The `sz` column is useful to work out what type can hold enough data passing to and from C.

The argument types are derived from data passed to the function (in case of `callFunction`) or explicitly specified (in case of `bind`). The number of character types provided must match the number of arguments expected by the C function.

The return type is specified as a single character and can be `" "` (space), which means to discard the result (i.e. `void`). If not provided, defaults to `int`.

char             | C type                                         | FFI type
-----------------| -----------------------------------------------|------------------------------------
b, c, x          | unsigned int8                                  | ffi_type_uint8
h                | signed int16                                   | ffi_type_sint16
i, m, d, u, v, t | signed int32                                   | ffi_type_sint32
j, p, n          | signed int64                                   | ffi_type_sint64
e                | float                                          | ffi_type_float
f, z             | double                                         | ffi_type_double
g, s             | uint8*                                         | ffi_type_pointer
`" "` (space)    | void (only as return type)                     | ffi_type_void
r                | raw pointer                                    | ffi_type_pointer
l                | size of pointer (size_t)                       | ffi_type_sint32 or ffi_type_sint64
k                | callback function/closure (only argument type) | ffi_type_pointer
uppercase letter | pointer to the same type                       | ffi_type_pointer

To pass a q function to C code as a callback (see `qsort` example below) make the argument type `"k"` and represent the function as a mixed list:

    (func;argument_types;return_type)

where 

-   `func` is a q function (type `100h`)
-   `argument_types` is the types of the arguments the function expects (string)
-   `return_type` is the return type of the function (char atom)

!!! note "As callbacks can have unbounded life in C code, they are not deleted after the function completes"

---


## `.ffi.bind`

_Create a projection with the function resolved to call with arguments_

```syntax
bind[fname;argument_types;return_type]
bind[lfname;argument_types;return_type]
```

Where

-   `fname` is name of function to look for (symbol atom)
-   `lfname` is shared object library and function name (2-item symbol vector)
-   `argument_types` is types of arguments (string)
-   `return_type` is type of returned value (char atom)

returns a q function, bound to the specifed C function for future calls. 

Useful for multiple calls to the C library.


## `.ffi.callFunction`

_A simple function call, intended for one-off calls._

```syntax
callFunction[fname;args]
callFunction[(return_type;fname);args]
callFunction[(return_type;lfname);args]
```

Where

-   `fname` is name of function to look for (symbol atom)
-   `lfname` is shared object library and function name (2-item symbol vector)
-   `argument_types` is types of arguments (string)
-   `return_type` is type of returned value (char atom)
-   `args`: mixed list of arguments to pass to the foreign function; the last item must be the generic null `(::)`

calls the identified function with the arguments and returns the result.

`callFunction` performs function lookup on each call and has significant overhead. 

!!! tip "For hot-path functions use `.ffi.bind`"



## `.ffi.cvar`

_Read global variable from the library._

```syntax
.ffi.cvar vname
.ffi.cvar (return_type;lfname)
```

Where

-   `vname` is a variable name (symbol atom)
-   `return_type` is type of returned value (char atom)
-   `lfname` is shared object library and function name (2-item symbol vector)

In the second example it is assumed that `libsampleparser.so` is exposing a global variable `CHUNK_SIZE_THRESHOLD`, i.e. the result of `nm` is as below:

```bash
$ nm -D l64/libsampleparser.so | grep CHUNK
0000000000054a10 D CHUNK_SIZE_THRESHOLD
```

Examples:

```q
q).ffi.cvar`timezone
-32400i
q).ffi.cvar ("j"; `libsampleparser.so`CHUNK_SIZE_THRESHOLD)
25000
```


## `.ffi.extension`

_File extension of a shared object for a platform_

```syntax
.ffi.extension[]
```

Returns symbol atom identifying the file extension for a shared object on the current platform. 

```q
q).ffi.extension[]
`so
q)` sv `libRmath, .ffi.extension[]
`libRmath.so
```


## `.ffi.os`

_Identify operating system_

```syntax
.ffi.os[]
```

Returns char atom identifying the operating system. 

```q
q).ffi.os[]
"l"
```


## `.ffi.ptrsize`

_Size of `void*`_

```syntax
.ffi.ptrsize[]
```

Returns the size of `void*` as an int.

```q
q).ffi.ptrsize[]
8i
```


## `.ffi.setErrno`

_Get or set error number_

```syntax
.ffi.setErrno n
.ffi.setErrno[]
```

Returns the current value of `errno`; if an argument `n` is passed it is set as the new value.

```q
q)// No such file or directory
q).ffi.setErrno[]
2i

q)// No such process
q).ffi.setErrno[3i]
2i
q).ffi.setErrno[]
3i
```


