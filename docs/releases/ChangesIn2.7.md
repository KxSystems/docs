---
title: Changes in 2.7
description: Changes to V2.7 of kdb+ from the previous version
author: Charles Skelton
---
# Changes in 2.7



Below is a summary of changes from V2.6. Commercially licensed users may obtain the detailed change list / release notes from (http://downloads.kx.com)


## Production release date

2010.08.05

## File compression

Previous versions of kdb+ were already able to exploit file systems such as ZFS and NTFS that feature compression. Kdb+ V2.7 extends this with built-in file compression with a choice of algorithms and compression levels using a common file format across all supported operating systems.

For further details, please see the [file compression FAQ](../kb/file-compression.md)

## Symbol Internalization – enhanced scalability

Strings stored as a symbol type have always been internalized in kdb+; this means the data of a string is stored once, and strings that have the same value refer to that single copy. The internalization algorithm has been improved to reduce latencies during addition of new strings (symbols). Note that this does not alter the schema choice recommendations that symbol type is suitable for repeating strings and that unique string data should be stored as char vectors.


## Memory allocator – garbage collection

Kdb+ V2.5 returned blocks of memory >32MB back to the operating system immediately when they were no longer referenced. This has now been extended to cache those blocks for reuse, allowing the user to explicitly request garbage collection via the command `.Q.gc[]`. This improves the performance of the allocator to levels seen prior to V2.5, and yet retains the convenience of returning unused memory to the operating system. Garbage collection will automatically be attempted if a memory request causes wsful or if the artificial memory limit (set via cmd line `-w` option) is hit.

<div id="IPCMessageValidator" style="display:none"></div>
## IPC Message Validator

Previous versions of kdb+ were sensitive to being fed malformed data structures, sometimes resulting in a crash. Kdb+ 2.7 validates incoming IPC messages to check that data structures are well formed, reporting `'badMsg` and disconnecting senders of malformed data structures. The raw message is captured for analysis via the callback `.z.bm`. The sequence upon receiving such a message is

1. calls `.z.bm` with a single arg, a list of `(handle;msgBytes)`
2. close the handle and call `.z.pc`
3. signals `'badmsg`

e.g. with the callback defined

```q
.z.bm:{`msg set (.z.p;x);}
```

then after a bad msg has been received, the global var `msg` will contain the timestamp, the handle and the full message. Note that this check validates only the data structures, it cannot validate the data itself.
