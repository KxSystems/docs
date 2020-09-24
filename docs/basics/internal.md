---
title: Internal functions – Basics – kdb+ and q documentation
description: The operator ! with a negative integer as left-argument calls an internal function.
keywords: bang, functions, internal, kdb+, q
---
# :fontawesome-solid-exclamation-triangle: Internal functions




The operator `!` with a negative integer as left argument calls an internal function.

<pre markdown="1" class="language-txt">
[0N!x](#0nx-show)        show                   Replaced:
[-4!x](#-4x-tokens)        tokens                   -1!   [hsym](../ref/hsym.md)
[-8!x](#-8x-to-bytes)        to bytes                 -2!   [attr](../ref/attr.md)
[-9!x](#-9x-from-bytes)        from bytes               -3!   [.Q.s1](../ref/dotq.md#qs1-string-representation)
[-10!x](#-10x-type-enum)       type enum                -5!   [parse](../ref/parse.md)
[-11!](#-11-streaming-execute)        streaming execute        -6!   [eval](../ref/eval.md)
[-14!x](#-14x-quote-escape)       quote escape             -7!   [hcount](../ref/hcount.md)
[-16!x](#-16x-ref-count)       ref count                -12!  [.Q.host](../ref/dotq.md#qhost-hostname)
[-18!x](#-18x-compress-byte)       compress byte            -13!  [.Q.addr](../ref/dotq.md#qaddr-ip-address)
[-19!](#-19-compress-file)        compress file            -15!  [md5](../ref/md5.md)
[-21!x](#-21x-compression-stats)       compression stats        -20!  [.Q.gc](../ref/dotq.md#qgc-garbage-collect)
[-22!x](#-22x-uncompressed-length)       uncompressed length      -24!  [reval](../ref/eval.md#reval)
[-23!x](#-23x-memory-map)       memory map               -29!  [.j.k](../ref/dotj.md#jk-deserialize)
[-25!x](#-25x-async-broadcast)       async broadcast          -31!  [.j.jd](../ref/dotj.md#jjd-serialize-infinity)
[-26!x](#-26x-ssl)       SSL                      -32!  [.Q.btoa](../ref/dotq.md#qbtoa-b64-encode)
[-27!(x;y)](#-27xy-format)   format                   -34!  [.Q.ts](../ref/dotq.md#qts-time-and-space)
[-30!x](#-30x-deferred-response)       deferred response        -35!  [.Q.gz](../ref/dotq.md#qgz-gzip)
[-33!x](#-33x-sha-1-hash)       SHA-1 hash               -37!  [.Q.prf0](../ref/dotq.md#qprf0-code-profiler)
[-36!(x;y)](#-36xy-load-master-key)   load master key
[-38!x](#-38x-socket-table)       socket table
[-120!x](#-120x-memory-domain)      memory domain
</pre>

!!! warning

    Internal functions are for use by language implementors.
    They are [exposed infrastructure](exposed-infrastructure.md)
    and may be redefined in subsequent releases.

    They also allow new language features to be tried on a provisional basis.

    Where they are replaced by keywords or utilities, **use the replacements**.

[![Neal Stephenson thinks it’s cute to name his labels 'dengo'](../img/goto.png "Neal Stephenson thinks it’s cute to name his labels 'dengo'")](https://xkcd.com/292/)
_xkcd.com_


## `0N!x` (show)

The identity function.
Returns `x` after writing it to the console.

An essential tool for debugging.


## `-4!x` (tokens)

Returns the list of q tokens found in string `x`. (Note the q parsing of names with embedded underscores.)

```q
q)-4!"select this from that"
"select"
," "
"this"
," "
"from"
," "
"that"

q)-5!"select this from that" / compare with −5!
?
`that
()
0b
(,`this)!,`this

q)-4!"a variable named aa_bb"
,"a"
," "
"variable"
," "
"named"
," "
"aa_bb"
q)
```


## `-8!x` (to bytes)

Returns the IPC byte representation of `x`.

```q
q)-8!1 2 3
0x010000001a000000060003000000010000000200000003000000
```


## `-9!x` (from bytes)

Creates data from IPC byte representation `x`.

```q
q)-9!-8!1 2 3
1 2 3
```

## `-10!x` (type enum)

Resolve a [type](datatypes.md) number to an [enum](enumerations.md) vector and check if it is available.

```q
q)-10!20h
1b
q)ee:`a`b`c
q)vv:`ee$`a`a`b
q)type vv
20h
q)-10!20h
0b
```


## `-11!` (streaming execute)

Syntax: `-11!x`<br>
Syntax: `-11!(-1;x)`<br>
Syntax: `-11!(-2;x)`<br>
Syntax: `-11!(n;x)`

Where `n` is a non-negative integer and `x` is a logfile handle

`-11!x` and `-11!(-1;x)`

: replay `x` and return the number of chunks executed; if end of file is corrupted, signal `badtail`.

`-11!(-2;x)`

: returns the number of consecutive valid chunks in `x` and the length of the valid part of the file

`-11!(n;x)`

: replays `n` chunks from top of logfile and returns the number of chunks executed

In replaying, if the logfile references an undefined function, the function name is signalled as an error.

:fontawesome-solid-graduation-cap:
[Replaying logfiles](../kb/replay-log.md)


## `-14!x` (quote escape)

Handles `"` escaping in strings: used to prepare data for CSV export.


## `-16!x` (ref count)

Returns the reference count for a variable.

```q
q)-16!a
1
q)a:b:c:d:e:1 2 3
q)-16!a
5
```


## `-18!x` (compress byte)

Returns compressed IPC byte representation of `x`, see notes about network compression in [Changes in V2.6](../releases/ChangesIn2.6.md)


## `-19!` (compress file)

Syntax: `-19!(src;tgt;lbs;alg;lvl)`

Where

-   `src` is a handle to a source file
-   `tgt` is a handle to the target file
-   `lbs` is logical block size: a power of 2 between 12 and 20 (pageSize or allocation granularity to 1MB – pageSize for AMD64 is 4kB, SPARC is 8kB. Windows seems to have a default allocation granularity of 64kB). When choosing the logical block size, consider the minimum of all the platforms that will access the files directly – otherwise you may encounter `"disk compression - bad logicalBlockSize"`. Note that this argument affects both compression speed and compression ratio: larger blocks can be slower and better compressed.
-   `alg` is compression algorithm
-   `lvl` is compression level

returns the target file as a file symbol.

Compression algorithms and levels:

alg | algorithm | level
:--:|-----------|:-------:
0   | none      | 0
1   | q IPC     | 0
2   | gzip      | 0-9
3   | [snappy](http://google.github.io/snappy/) (since V3.4) | 0
4   | `lz4hc` (since V3.6) | 1-12

```q
q)`:test set asc 10000000?100; / create a test data file
q) / compress input file test, to output file ztest
q) / using a block size of 128kB (2 xexp 17), gzip level 6
q)-19!(`:test;`:ztest;17;2;6)
99.87667
q) / check the compressed data is the same as the uncompressed data
q)get[`:test]~get`:ztest
1b
```

!!! warning "`lz4` compression"

    Certain [releases](https://github.com/lz4/lz4/releases) of `lz4` do not function correctly within kdb+.

    Notably, `lz4-1.7.5` does not compress, and `lz4-1.8.0` appears to hang the process.

    Kdb+ requires at least `lz4-r129`.
    `lz4-1.8.3` works.
    We recommend using the latest `lz4` release available.

:fontawesome-solid-graduation-cap:
[File compression](../kb/file-compression.md)


## `-21!x` (compression stats)

Syntax: `-21! x`

Where `x` is a file symbol, returns a dictionary of compression statistics for it.

```q
q)-21!`:ztest
compressedLength  | 137349
uncompressedLength| 80000016
algorithm         | 2i
logicalBlockSize  | 17i
zipLevel          | 6i
```

:fontawesome-solid-graduation-cap:
[File compression](../kb/file-compression.md)


## `-22!x` (uncompressed length)

An optimized shortcut to obtain the length of uncompressed serialized `x`, i.e. `count -8!x`

```q
q)v:til 100000
q)\t do[5000;-22!v]
1
q)\t do[5000;count -8!v]
226
q)(-22!v)=count -8!v
1b
```


## `-23!x` (memory map)

Since V3.1t 2013.03.04

Attempts to force the object `x` to be resident in memory by hinting to the OS and/or faulting the underlying memory pages.
Useful for triggering sequential access to the storage backing `x`.


## `-25!x` (async broadcast)

Since V3.4

Broadcast data as an async msg to specified handles. The advantage of using `-25!(handles;msg)` over `neg[handles]@\:msg` is that `-25!msg` will serialize `msg` just once – thereby reducing CPU and memory load.

Use as

```q
q)-25!(handles; msg)
```

Handles should be a vector of positive int or longs.

`msg` will be serialized just once, to the lowest capability of the list of handles. I.e. if handles are connected to a mix of versions of kdb+, it will serialize limited to the types supported by the lowest version. If there is an error, no messages will have been sent, and it will return the handle whose cap caused the error.

Just as with `neg[handles]@\:msg`, `-25!x` queues the msg as async on those handles – they don't get sent until the next spin of the main loop, or are flushed with `neg[handles]@\:(::)`.

!!! tip "`-25!(handles; ::)` can also flush the handles"

Possible error scenarios:

-   from trying to serialize data for a handle whose remote end does not support a type, or size of the data.

    <pre><code class="language-q">
    / connect to 2.8 and 3.4
    q)h:hopen each 5000 5001
    q)h
    5 6i 
    q)(-5) 0Ng / 2.8 does not support guid
    'type
    q)(-6) 0Ng / 3.4 does support guid 
    q)-25!(h;0Ng)
    'type error serializing for handle 5
    </code></pre>

-   an int is passed which is not a handle

    <pre><code class="language-q">
    q)-25!(7 8;0Ng)
    '7 is not an ipc handle
    </code></pre>



## `-26!x` (SSL)

View TLS settings on a handle or current process `-26!handle` or `-26!()`.
Since V3.4 2016.05.12.

:fontawesome-solid-graduation-cap:
[SSL](../kb/ssl.md)


## `-27!(x;y)` (format)

Where

-   `x` is an int atom
-   `y` is numeric

returns `y` as a string or strings formatted as a float to `x` decimal places.
(Since V3.6 2018.09.26.)
It is atomic and doesn’t take `\P` into account. e.g.

```q
q)-27!(3i;0 1+123456789.4567)
"123456789.457"
"123456790.457"
```

This is a more precise, built-in version of [`.Q.f`](../ref/dotq.md#qf-format) but uses IEEE754 rounding:

```q
q).045
0.044999999999999998
q)-27!(2i;.045)
"0.04"
q).Q.f[2;.045]
"0.05"
```

You might want to apply a rounding before applying `-27!`.


## `-30!x` (deferred response)

Syntax: `-30!(::)`<br>
Syntax: `-30!(handle;isError;msg)`

Where `handle` is an int, `isError` is a boolean, and `msg` is a string

- `-30!(::)` allows the currently-executing callback to complete without responding
- `-30!(handle;isError;msg)` responds to the deferred sync call

Since V3.6 2018.05.18.

:fontawesome-solid-graduation-cap:
[Deferred response](../kb/deferred-response.md)


## `-33!x` (SHA-1 hash)

Syntax: `-33!x`

where `x` is a string, returns its SHA-1 hash as a list of strings of hex codes.

```q
q)raze string -33!"mypassword"
"91dfd9ddb4198affc5c194cd8ce6d338fde470e2"
```

:fontawesome-solid-book-open:
Command-line options [`-u`](cmdline.md#-u-usr-pwd-local) and [`-U`](cmdline.md#-u-usr-pwd)


## `-36!(x;y)` Load master key

Syntax: `-36!(x;y)`

Where

-   `x` is a master-key file as a [file symbol](glossary.md#file-symbol)
-   `y` is a password as a string

loads and validates the master key into memory as the key to use when decrypting or encrypting data on disk.

:fontawesome-solid-graduation-cap:
[Create master key](../kb/dare.md#configuration)

Expect this call to take about 500 milliseconds to execute.
It can be executed from handle 0 only.

Signals errors:
```txt
Encryption lib unavailable      failed to load OpenSSL libs
Invalid password
Main thread only                can be executed from the main thread only
PKCS5_PBKDF2_HMAC               library invocation failed
Restricted                      must be executed under handle 0
Unrecognized key format         master key file format unrecognized
```


## `-38!x` (socket table)

Syntax: `-38!x`

where `x` is a list of socket handles, returns a table with columns

-   `p` (protocol): `q` (IPC) or `w` (WebSocket)
-   `f` (family): `t` (TCP) or `u` (Unix domain socket)

Since v4.0 2020.06.01.

```q
q){([]h)!-38!h:.z.H}[]
h| p f
-| ---
8| q u
9| q t
```

:fontawesome-solid-book:
[`.z.H`](../ref/dotz.md#zh-active-sockets)
## `-120!x` (memory domain)

Syntax `-120!x`

returns `x`’s memory domain (currently 0 or 1), e.g.

```q
q)-120!'(1 2 3;.m.x:1 2 3)
0 1
```

:fontawesome-solid-book:
[`.m` namespace](../ref/dotm.md)
