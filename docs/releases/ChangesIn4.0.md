---
title: Changes in 4.0 | Releases | Documentation for kdb+ and the q programming language
description: Changes to V4.0 of kdb+ from the previous version
authors: [Charles Skelton, Stephen Taylor]
date: [March 2020, February 2023]
---
# Changes in 4.0


## Production release date

2020.03.17

## Updates

### 2023.01.20

Anymap write now detects consecutive deduplicated (address matching) top-level objects, skipping them to save space.

```q
q)a:("hi";"there";"world");
q)`:a0 set a;`:a1 set a@where 1000 2000 3000;
q)(hcount`$":a0#")=hcount`$":a1#"
```

Improved memory efficiency of writing nested data sourced from a type 77 file, commonly encountered during compression of files, e.g.

```q 
q)`:a set 500000 100#"abc"
q)system"ts `:b set get`:a" / was 76584400 bytes, now 8390208
```

### 2022.10.26

`l64arm` build available.

`m64` is now a universal binary, containing both Intel and ARM builds for macOS.
Use `lipo` to extract the individual architecture binaries. e.g.

```bash
lipo -thin x86_64 -output q/m64/q.x64 q/m64/q
lipo -thin arm64  -output q/m64/q.arm q/m64/q
```

Support for OpenSSL v3: 
on Linux, q will now try to load versioned shared libraries for OpenSSL if `libssl-dev[el]` is not installed.

the `-p` command-line option (or `\p` system command) can now listen on a port within a specified range e.g.

```q
q)\p 80/85
q)\p
81
```

The range of ports is inclusive and tried in a random order. 
A service name can be used instead of a port number. 
The existing option of using `0W` to choose a free ephemeral port can be more efficient (where suitable).

A range can be used in place of port number, when setting using existing rules e.g. for hostname

```q
q)\p myhost:2000/2010
```

or for multithreaded port

```q
q)\p -2000/2010
```

### 2021.07.12

Extended the range of `.z.ac` to `(4;"")` to indicate fallback to try authentication via [`.z.pw`](../ref/dotz.md#zpw-validate-user).

### 2021.03.25

On Windows builds, TCP send and receive buffers are no longer set to fixed sizes, allowing autotuning by the OS.

### 2021.01.20

The result of `dlerror` is appended to the error message if there is an error loading compression or encryption libraries e.g. (without Snappy installed)

```q
q).z.zd:17 3 6
q)`:a set til 1000000
'snappy libs required to compress a$. dlopen(libsnappy.dylib, 0x0002): tried: 'libsnappy.dylib' (no such file), '/System/Volumes/Preboot/Cryptexes/OSlibsnappy.dylib' (no such file), '/usr/lib/libsnappy.dylib' (no such file, not in dyld cache), 'libsnappy.d
  [0]  `:a set til 1000000
           ^
```

### 2020.11.02

Path-length limit is now 4095 bytes, instead of 255.

OS errors are now truncated (indicated by `..`) on the left to retain the more important tail, e.g.

```q
q)get`$":root/",(250#"path/"),"file"
'..path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/path/file. OS reports: No such file or directory
  [0]  get`$":root/",(250#"path/"),"file"
       ^
```


### 2020.08.10

Serialize and deserialize now use multithreaded memory, e.g.

```q
q)\t system"s 10";-9!-8!100#enlist a:1000000#0
```

Uncompressed file writes to shared memory/cache are now up to 2x faster, e.g.

```q
q)\t a:100 100000#"abc";do[100;`:/dev/shm/a set a]
```

### 2020.08.03

One-shot request now checks that it has received a response message, otherwise signals `expected response msg`, e.g.

```q
q)`::5001"neg[.z.w]`"
'expected response msg
```

### 2020.07.15

Errors raised by the underlying decompression routines are now reported as `decompression error at block <b> in <f>`.


### 2020.06.18

Allow more than one scalar to be extended in Group-by clause. e.g.

```q
q)select sum x by a:`,b:` from([]x:1 2 3)
a b| x
---| -
   | 6
```

### 2020.06.01
Added [`.z.H`](../ref/dotz.md#zh-active-sockets), a low-cost method to obtain the list of active sockets.

```q
.z.H~key .z.W
```

Added [`-38!x`](../basics/internal.md#-38x-socket-table): where `x` is a list of socket handles, returns a table of `([]p:protocol;f:socketFamily)` where 

-   `protocol` is `q` (IPC) or `w` (WebSocket)
-   `socketFamily` is `t` (TCP) or `u` (Unix domain socket)

```q
q){([]h)!-38!h:.z.H}[]
h| p f
-| ---
8| q u
9| q t
```


### 2020.05.20

Access-controlled file paths are now allowed to be canonical in addition to relative for remote handles under `reval` or `-u` in the command line. e.g.

```q
h(reval(value;)enlist@;(key;`$":/home/charlie/db"))
```

## :fontawesome-solid-bolt: Multithreaded primitives

kdb+ has been multithreaded for more than 15 years, and users could leverage this explicitly through [`peach`](../ref/each.md), or via the [multithreaded input mode](../basics/listening-port.md#multi-threaded-input-mode).

kdb+ 4.0 adds an additional level of multithreading via primitives.
It is fully transparent to the user, requiring no code change by the user to exploit it. The underlying framework currently uses the number of threads configured as secondary threads on the command line.
   
As most kdb+ primitives are memory-bound, within-primitive parallelism is intended to exploit all-core memory bandwidth available on modern server hardware with multi-channel memory. 

SSE-enabled primitives (mostly arithmetic) are not parallel when SSE is not available (Windows and NoSSE builds).
Within-primitive parallelism reverts to being single-threaded within `peach` or multi-threaded input mode.

Systems with low aggregate memory bandwidth are unlikely to see an improvement for in-memory data, but on-disk data should still benefit. 
Multi-threaded primitives are not NUMA-aware and should not be expected to scale beyond 1 socket.

:fontawesome-solid-graduation-cap:
[Multithreaded primitives](../kb/mt-primitives.md)


## :fontawesome-solid-lock: Data-At-Rest Encryption (DARE)

kdb+4.0 supports Data-At-Rest Encryption (DARE), using AES256CBC. As with the built-in file compression, encryption is transparent and requires no changes to a query to utilize it. Once a master key has been created via a third-party tool such as OpenSSL:

```bash
openssl rand 32 | openssl aes-256-cbc -salt -pbkdf2 -iter 50000 -out testkek.key
```

the key can then be [loaded into kdb+](../basics/internal.md#-36-load-master-key) using 

```q
-36!(`:testkek.key;"mypassword")
```

Files can then be compressed and/or encrypted using the same command as for file compression, with AES256CBC encryption as algo 16. e.g.

```q
(`:ztest;17;2+16;6) set asc 10000?`3 / compress and encrypt to an individual file
```

or use [`.z.zd`](../ref/dotz.md#zzd-compressionencryption-defaults) for process-wide default setting when writing files:

```q
.z.zd:(17;2+16;6) / zlib compression, with aes256cbc encryption
```

!!! info "kdb+ DARE requires OpenSSL 1.1.1"

:fontawesome-solid-graduation-cap:
[Data-At-Rest Encryption (DARE)](../kb/dare.md)


## :fontawesome-solid-bolt: Optane support

Memory can be backed by a filesystem, allowing use of DAX-enabled filesystems (e.g. AppDirect) as a non-persistent memory extension for kdb+.

Use command-line option [`-m path`](../basics/cmdline.md#-m-memory-domain) to use the filesystem path specified as a separate memory domain. This splits every thread’s heap into two:

domain | content
:-----:|:-------
0      | regular anonymous memory (active and used for all allocs by default)
1      | filesystem-backed memory

[Namespace `.m`](../ref/dotm.md) is reserved for objects in domain 1; however names from other namespaces can reference them too, e.g. `a:.m.a:1 2 3`.

`\d .m` changes the current domain to 1, causing it to be used by all further allocs. `\d .anyotherns` sets it back to 0.

`.m.x:x` ensures the entirety of `.m.x` is in the domain 1, performing a deep copy of `x` as needed. (Objects of types `100-103h`, `112h` are not copied and remain in domain 0.)

Lambdas defined in `.m` set current domain to 1 during execution. This will nest since other lambdas don’t change domains:

```q
q)\d .myns
q)g:{til x}
q)\d .m
q)w:{system"w"};f:{.myns.g x}
q)\d .
q)x:.m.f 1000000;.m.w` / x allocated in domain 1
```

[`-120!x`](../basics/internal.md#-120x-memory-domain) returns `x`’s domain (currently 0 or 1), e.g `0 1~-120!'(1 2 3;.m.x:1 2 3)`.

[`\w`](../basics/syscmds.md#w-workspace) returns memory info for the current domain only:

```q
q)value each ("\\d .m";"\\w";"\\d .";"\\w")
```

The [-w limit](../basics/cmdline.md#-w-workspace) (M1/m2) is no longer thread-local, but domain-local: command-line option `-w` and system command `\w` set the limit for domain 0.

`mapped` is a single global counter, the same in every thread’s `\w`.

:fontawesome-solid-graduation-cap:
[Optane Memory and kdb+](../kb/optane.md)


## :fontawesome-solid-code: Profiler

kdb+ 4.0 (for Linux only) includes an experimental built-in call-stack snapshot primitive that allows building a sampling [profiler](../kb/profiler.md).


## :fontawesome-solid-lock: Added support for OpenSSL 1.1.x

One-shot sync queries can now execute via

```q
`::[("host:port";timeout);query]
```

which allows a timeout to be specified.


## :fontawesome-solid-code: Debugger

There are various Debugger improvements:

The [`.Q.bt`](../ref/dotq.md#bt-backtrace) display highlights the current frame with `>>`.

```q
q)).Q.bt`
  [2]  {x+1}
         ^
>>[1]  {{x+1}x}
        ^
  [0]  {{x+1}x}`a
       ^
```

A new Debugger command `&` (where) prints current frame info.

```q
q))&
  [1]  {{x+1}x}
        ^
```

The Debugger restores original namespace and language (q or k) setting for every frame.

View calculations and `\` system commands, including `\l`, correspond to individual debug stack frames.

```q
 .d1 ).Q.bt`
>>[3]  t0.k:8: va::-a
                    ^
  [2]  t1.q:8: vb::va*3
                   ^
  [1]  t1.q:7: vc::vb+2
                   ^
  [0]  2+vc
         ^
```

Errors thrown by [`parse`](../ref/parse.md) show up in [`.Q.trp`](../ref/dotq.md#trp-extend-trap-at) with location information.

```q
q).Q.trp[parse;"2+2;+2";{1@.Q.sbt 2#y}];
  [3]  2+2;+2
           ^
  [2]  (.q.parse) 
```

The `name` (global used as local) bytecode compiler error has location info.

```q
q){a::1;a:1}
'a
  [0]  {a::1;a:1}
             ^
```


## Miscellaneous

-   The parser now interprets **Form Feed** (Ctl-L) as whitespace, allowing a script to be [divided into pages](https://en.wikipedia.org/wiki/Page_break "Wikipedia") at logical places. 

-   The macOS build no longer exits with `couldn’t report -- exiting` after waking from **system sleep** when running under an on-demand license. This alleviates the issue of Apple dropping support for 32-bit apps on macOS 10.15.

-   **Multicolumn table lookup** now scales smoothly, avoiding catastrophic slowdown for particular distributions of data at the expense of best-case performance.

-   **Stdout and stderr** may now be redirected to the same file, sharing the same file table entry underneath. This mimics the redirection of stdout and stderr at a Unix shell: `cmd > log.txt 2>&1`.

-   Both HTTP client and server now support **gzip compression** via `"Content-Encoding: gzip"` for responses to `form?...`-style requests. The response payload must be >2000 chars and the client must indicate support via `"Accept-Encoding: gzip"` HTTP header, as is automatically done in [`.Q.hg`](../ref/dotq.md#hg-http-get) and [`.Q.hp`](../ref/dotq.md#hp-http-post).

-   Externally compressed (e.g. using gzip) **log files** can now be played back via a fifo to ``-11!`:logfifo``, e.g.

    ```q
    q)system"mkfifo logfifo;gunzip log.gz > logfifo&";-11!`:logfifo
    ```

-   Further integrity checks have been added to **streaming execute** `-11!x` to avoid `wsfull` or `segfault` on corrupted/incomplete log files.

-   `-u/U passwordfile` now supports **SHA1 password** entries. Passwords must all be plain, MD5, or SHA1; they cannot be mixed. e.g.

    ```q
    q)raze string -33!"mypassword" / -33! calculates sha1
    ```


-   [`.Q.cn`](../ref/dotq.md#cn-count-partitioned-table) now uses [`peach`](../ref/each.md) to get the count of partitioned tables. This can improve the startup time for a partitioned database.


## :fontawesome-solid-triangle-exclamation: NUCs

We have sought to avoid introducing compatibility issues, and most of those that follow are a result of unifying behavior or tightening up loose cases.


### `select`

`select count,sum,avg,min,max,prd by` is now consistent for atoms.

```q
q)first max select count 1b by x1 from ([]1 2 3;3 3 3) / was 3
1
```

The length of the By clause needs to match table count.

`select` auto-aliased colliding duplicate column names for either `select a,a from t`, or `select a by c,c from t`, but not for `select a,a by a from t`.

Such a collision now signals a `dup names for cols/groups a` error during parse, indicating the first column name which collides. 

The easiest way to resolve this conflict is to explicitly rename columns. e.g.
```q
q)select a,b by c:a from t
```


### [`reval`](../ref/eval.md#reval)

Has been extended to behave as if command-line options `-u 1` and `-b` were active, and also block all system calls which change state.
I.e. all writes to file system are blocked; allows read access to files in working directory and below only; and prevents amendment of globals.


### [`lj`](../ref/lj.md)

Now checks that its right argument is a keyed table.

<!--
[`.Q.hmb`](../ref/dotq.md#FIXME) now returns a 2-item list - the HTTP header and contents. e.g.

```q
q)count .Q.hmb[`:http://www.google.com;`GET;()]
2
```
-->

### Command-line processing

Now checks for duplicate or mutually exclusive flags. e.g.

```bash
q -U 1 -u 1
```

throws `-u or -U`.


### License-related errors

Now reported with the prefix `licence error:`, e.g. `'licence error: upd`.



