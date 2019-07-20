---
title: Internal functions
description: The operator ! with a negative integer as left-argument calls an internal function.
keywords: bang, functions, internal, kdb+, q
---
# Internal functions




The operator `!` with a negative integer as left-argument calls an internal function.

<i class="far fa-hand-point-right"></i> [Exposed infrastructure](exposed-infrastructure.md)



!!! warning 

    `-n!` bindings are subject to change. If a cover function is provided in the `.q` or `.Q` namespaces – use that instead!

[![Neal Stephenson thinks it’s cute to name his labels 'dengo'](../img/goto.png "Neal Stephenson thinks it’s cute to name his labels 'dengo'")](https://xkcd.com/292/)  
_xkcd.com_


## `-1!x` (`hsym`)

<i class="far fa-hand-point-right"></i> 
[hsym](../ref/handles.md#hsym)


## `-2!x` (`attr`)

<i class="far fa-hand-point-right"></i> 
[attr](../basics/metadata.md#attr)


## `-3!x` string

Returns the string representation of `x`. 
Covered by `.Q.s1`. 
Use `show`.

<i class="far fa-hand-point-right"></i> 
[`show`](../ref/show.md),
[.Q.s](../ref/dotq.md#qs-plain-text)



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


## `-5!x` (`parse`)

<i class="far fa-hand-point-right"></i> 
[`parse`](../ref/parse.md)


## `-6!x` (`eval`)

<i class="far fa-hand-point-right"></i> 
[`eval`](../ref/eval.md)


## `-7!x` (`hcount`)

<i class="far fa-hand-point-right"></i> 
[`hcount`](../ref/handles.md#hcount)


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

Resolves a [type](datatypes.md) number to an [enum](enumerations.md) vector and check if it is available.

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


## `-11!x` (streaming execute)

Streaming-execute over file `x`, used for example in kdb+tick to replay logfiles in a memory-efficient manner.

A logfile is just a list of lists, and each list is read in turn and evaluated, either by [`value`](metadata.md#value) or by [`.z.ps`](../ref/dotz.md#zps-set) if it is defined.

Here, for demonstration purposes, we manually create a logfile, and play it back through `-11!`. This is functionally equivalent to doing ``value each get `:logfile`` but uses far less memory.

```q
q)`:logfile.2013.12.03 set () / create a new,empty log file
`:logfile.2013.12.03
q)h:hopen `:logfile.2013.12.03 / open it
q)h enlist(`f;`a;10) / append a record
3i
q)h enlist(`f;`b;20) / append a record
3i
q)hclose h / close the file
q)f:{0N!(x;y)} / define the function that is referenced in those records
q)-11!`:logfile.2013.12.03 / playback the logfile
(`a;10)
(`b;20)
2
q)/ DO NOT DO THIS ON LARGE LOGFILES!!!! This is the whole purpose of -11!x.
q)value each get `:logfile.2013.12.03
(`a;10)
(`b;20)
`a 10
`b 20
```

If successful, the number of chunks executed is returned. If the end of the file is corrupt a `'badtail` error is signalled. In the event that the log file references an undefined function, the function name is signalled as an error. This can be confusing if the missing function name is `upd`, as it does not reflect the same situation as the license expiry 'upd error. e.g.

```q
/ Continuing the above example
q)delete f from `.
`.
q)-11!`:logfile.2013.12.03 / function f no longer defined, so it signals an error
'f
```

<i class="fab fa-github"></i> [github.com/simongarland/tickrecover/rescuelog.q](https://github.com/simongarland/tickrecover/blob/master/rescuelog.q) for examples of usage


## `−11!(-1;x)` (streaming execute)

Same as `−11!x`.


## `−11!(n;x)` (streaming execute)

Streaming-execute the first `n` chunks of logfile `x`, return the number of chunks if successful.

It is possible to use the above to playback `n` records from record `M` onwards. 

Firstly create a sample log file, which contains 1000 records as 
`((`f;0);(`f;1);(`f;2);..;(`f;999))`.

```q
q)`:log set();h:hopen`:log;i:0;do[1000;h enlist(`f;i);i+:1];hclose h;
```

Then define function `f` to just print its arg, skip the first `M` records. If [`.z.ps`](../ref/dotz.md#zps-set) is defined, `-11!` calls it for each record.

```q
q)m:0;M:750;f:0N!;.z.ps:{m+:1;if[m>M;value x;];};-11!(M+5-1;`:log)
750
751
752
753
754
```


## `-11!(-2;x)` (logfile chunks)

Given a valid logfile, returns the number of chunks.

Given an invalid logfile, returns the number of valid chunks and length of the valid part.

```q
q)logfile:`:good.log / a non-corrupted logfile
q)-11!(-2;logfile)
26
q)logfile:`:broken.log / a manually corrupted logfile
q)upd:{[x;y]} / define a dummy upd file as components are of the form (`upd;data)
q)-11!logfile
'badtail
q)-11!(-1;logfile)
'badtail
q)hcount logfile
39623j
q)-11!(-2;logfile)
26
35634j
q)/ 26 valid chunks until position 35634 (out of 39623)
q)-11!(26;logfile)
26
```


## `-12!x` (`.Q.host`)

<i class="far fa-hand-point-right"></i> 
[.Q.host](../ref/dotq.md#qhost-hostname)


## `-13!x` (`.Q.addr`)

<i class="far fa-hand-point-right"></i> 
[.Q.addr](../ref/dotq.md#qaddr-ip-address)


## `-14!x` (quote escape)

Handles `"` escaping in strings: used to prepare data for CSV export.


## `-15!x` (`md5`)

<i class="far fa-hand-point-right"></i> 
[md5](../ref/md5.md)


## `-16!x` (ref count)

Returns the reference count for a variable.

```q
q)-16!a
1
q)a:b:c:d:e:1 2 3
q)-16!a
5
```


## `-17!x` (flip endian-ess)

Returns flip endian-ness of kdb+ datafile `x`, see notes in [Changes in kdb+ V2.6](../releases/ChangesIn2.6.md)



## `-18!x` (compress byte)

Returns compressed IPC byte representation of `x`, see notes about network compression in [Changes in V2.6](../releases/ChangesIn2.6.md)



## `-19!x` (compress file)

Syntax: `-19! x`

Where `x` is a list of 5 items: 

-   _source file_: file symbol
-   _target file_: file symbol
-   _logical block size_: a power of 2 between 12 and 20 (pageSize or allocation granularity to 1MB – pageSize for AMD64 is 4kB, SPARC is 8kB. Windows seems to have a default allocation granularity of 64kB). When choosing the logical block size, consider the minimum of all the platforms that will access the files directly – otherwise you may encounter `"disk compression - bad logicalBlockSize"`. Note that this argument affects both compression speed and compression ratio: larger blocks can be slower and better compressed.
-   _compression algorithm_: one of:
    + 0: none
    + 1: q IPC
    + 2: `gzip`
    + 3: [snappy](http://google.github.io/snappy) (since V3.4)
    + 4: `lz4hc` (since V3.6)
-   _compression level_: an integer 
    +   for `gzip`: between 0 and 9 
    +   for `lz4hc`: between 1 and 12 (int `x` taken as `12&x`) 
    +   otherwise: 0

returns the target file as a file symbol. 

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

<i class="far fa-hand-point-right"></i> 
Knowledge Base: [File compression](../kb/file-compression.md)


## `-20!0` (`.Q.gc`)

<i class="far fa-hand-point-right"></i> 
[`.Q.gc`](../ref/dotq.md#qgc-garbage-collect)


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

<i class="far fa-hand-point-right"></i> 
Knowledge Base: [File compression](../kb/file-compression.md)


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


## `-24!x` (read-only eval)

Since V3.3t 2014.10.07.

Read-only evaluation, underpinning the keyword "reval", similar to eval (-6!), which behaves as if the command-line option `-b` were active for the duration of the `-24!` call.

An example usage is inside the message handler `.z.pg`, useful for access control, here blocking sync messages from updating

```q
q).z.pg:{reval(value;enlist x)} / define on local process listening on port 500
q)h:hopen 5000 / from another process on localhost
q)h"a:4"
'noupdate: `. `a
```


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
<i class="far fa-hand-point-right"></i> 
Knowledge Base: [SSL](../kb/ssl.md)


## `-29!x` (parse JSON)

Underpins the JSON parser, [`.j.k`](../ref/dotj.md).
Since V3.3t 2015.02.17.


## `-30!x` (deferred response)

Syntax: `-30!(::)`
Syntax: `-30!(handle;isError;msg)`

Where `handle` is an int, `isError` is a boolean, and `msg` is a string

- `-30!(::)` allows the currently-executing callback to complete without responding
- `-30!(handle;isError;msg)` responds to the deferred sync call

Since V3.6 2018.05.18. 

<i class="far fa-hand-point-right"></i> Knowledge Base: [Deferred response](../kb/deferred-response.md)