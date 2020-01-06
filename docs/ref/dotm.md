---
title: Memory backed by filesystem | Basics | q and kdb+ documentation
description: Memory can be backed by a filesystem, allowing use of DAX-enabled filesystems (e.g. AppDirect) as a non-persistent memory extension for kdb+
author: Charlie Skelton
date: November 2019
keywords: appdirect, dax, memory, thread
---
# The `.m` namespace


Since V3.7t 2019.10.22

Memory can be backed by a filesystem, allowing use of DAX-enabled filesystems (e.g. AppDirect) as a non-persistent memory extension for kdb+.

[Command-line option `-m path`](../basics/cmdline.md#-m-memory-domain) directs kdb+ to use the filesystem path specified as a separate memory domain. This splits every thread’s heap into two:

domain | description
-------|------------
0      | regular anonymous memory, active and used for all allocs by default
1      | filesystem-backed memory

The `.m` namespace is reserved for objects in memory domain 1, however names from other namespaces can reference them too, e.g. `a:.m.a:1 2 3`

`\d .m` changes current memory domain to 1, causing it to be used by all further allocs. `\d .anyotherns` sets it back to 0.

`.m.x:x` ensures the entirety of `.m.x` is in memory domain 1, performing a deep copy of `x` as needed. (Objects of types `100h`-`103h`, `112h` are not copied and remain in memory domain 0.)

Lambdas defined in `.m` set current memory domain to 1 during execution. This will nest, since other lambdas don’t change memory domains:

```q
q)\d .myns
q)g:{til x}
q)\d .m
q)w:{system"w"};f:{.myns.g x}
q)\d .
q)x:.m.f 1000000;.m.w` / x allocated in domain 1
```

[Internal function `-120!x`](../basics/internal.md#-120x-memory-domain) returns `x`’s memory domain, currently 0 or 1.

```q
q)-120!'(1 2 3;.m.x:1 2 3)
0 1
```

[System command `\w`](../basics/syscmds.md#w-workspace) returns memory info for the current memory domain only.

```q
q)value each ("\\d .m";"\\w";"\\d .";"\\w")
::
353968 67108864 67108864 0 0 8589934592
::
354032 67108864 67108864 0 0 8589934592
```

[Command-line option `-w limit`](../basics/cmdline.md#-w-workspace) (M1/m2) is no longer thread-local, but memory domain-local. Command-line option `-w`, and [system command `\w`](../basics/syscmds.md#w-workspace) set limit for memory domain 0.

Mapped is a single global counter, the same in every thread’s `\w`.

