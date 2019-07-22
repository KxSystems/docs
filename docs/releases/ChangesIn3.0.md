---
title: Changes in 3.0
description: Changes to V3.0 of kdb+ from the previous version
author: Charles Skelton
---
# Changes in 3.0



Below is a summary of changes from V2.8. Commercially licensed users may obtain the detailed change list / release notes from (http://downloads.kx.com)


## Production release date

2012.05.29

Vectors are no longer limited to 2 billion items as they now have a 64-bit length.

The default integer is no longer 32-bit, it is 64-bit. i.e. in k/q 0 is shorthand for `0j`. `0i` represents a 32-bit int.

You should almost never see type `i`, just like we never see type `h`.

The return type from `count`, `find`, `floor`, … are now 64-bit ints (q longs)

Schemas and q script files should be fine.

There will be some NUCs when performing operations like `0^int()`, as this now returns a vector of 64-bit ints. It may be simplest to scan your code for numeric literals, and where 32-bit ints are intended to be kept, specify them explicitly as such, e.g. `0i^…` This can be done prior to upgrade and such tokens are compatible with previous versions.

Kdb+ 3.0 can read 2.7/2.8 kdb+ file formats without conversion. Kdb+ files created by 3.0 cannot be read by previous versions.

IPC messaging is similar to previous versions, and no single message can exceed 2 billion bytes. In general, if you choose to upgrade, to ensure full IPC interop you should first upgrade your current kdb+ version to the latest release of that version (assuming versions 2.6 thru 2.8), then update client applications to use the latest drivers and then update the kdb+ version to V3.0. If you do not upgrade the drivers, you will not be able to send timestamp/timespan types to those applications, nor use IPC compression.

Shared libraries that are loaded into kdb+ must be recompiled using the new k header, and some function signatures have widened some of their types:  
<i class="far fa-github"></i> [KxSystems/kdb/c/c/k.h](https://github.com/KxSystems/kdb/blob/master/c/c/k.h)

When compiling for V3.0, define `KXVER=3`, e.g. `gcc -D KXVER=3 …`

At the moment there's no need to recompile standalone apps, i.e. that do not load as a shared lib into kdb+. If you choose to update to the latest `k.h` header file, and compile with `KXVER=3`, ensure that you link to the latest C library (`c.o`/`c.dll`). For legacy apps that are just being maintained, you can continue to use the new header file and compile with `KXVER` undefined or `=2`, and bind with older `c.o`/`c.obj` available from the [SVN repository revision 1442](http://code.kx.com/wsvn/code/kx/kdb%2B/l32/c.o?op=revision&rev=1442).

-   Kdb+V3.0 has support for WebSockets according to RFC 6455, and has been tested with Chrome and Firefox. It is expected that other browsers will catch up shortly.

-   A new type – Guid, type 2 – has been added. See [Datatypes](../basics/datatypes.md#guid)

-   `plist` has been removed.

-   date+time results in timestamp type; previously date+time resulted in datetime type, which has been deprecated since V2.6.

