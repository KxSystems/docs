---
title: Changes in 3.2
description: Changes to V3.2 of kdb+ from the previous version
author: Charles Skelton
---
# Changes in 3.2



Below is a summary of changes from V3.1. Commercially-licensed users may obtain the detailed change list / release notes from [downloads.kx.com](http://downloads.kx.com)


## Production release date

2014.08.22


## New

-   allow views to use their previous value as part of their recalc.
-   views, in addition to vars, are now also returned by default HTTP handler.
-   removed limit on number of concurrent vectors which can have `` `g`` attr.
-   `\c` – Console width, height now defaults to 100 1000, previously was 25 80; `LINES`, `COLUMNS` environment vars override it.
-   allow some messaging threads other than main.
-   retain `` `p`` attr if both args to _catenate_ have `` `p`` attr, and parted info conforms
-   map single splayed files.
-   appending a sorted vector to a sorted vector on disk now just appends to the file if the sort can be retained.
-   `exec by a,b`  or `select by a,b` now sets sort/part attr for those cols. Enhancement to that released on 2014.02.07, now multiple cols
-   Support automatic WebSockets compression according to (http://tools.ietf.org/html/draft-ietf-hybi-permessage-compression-17)
-   added `dsave` to make it easy to ``.Q.en`p#sym`` and save; expects `sym` as first col.
-   `rload` changed to map all singleton splayed tables; eliminates all the open, map, unmap, close overhead.
-   expanded **mlim** (number of mapped nested files) from 251 to 32767.
-   Added WebSocket client functionality. `.z.ws` must be defined before opening a WebSocket
-   allow single escape `\` for `\/` in char vector (to support JSON)
-   JSON \[de\]serialization is now part of `q.k`
-   uses two file descriptors per compressed file. This is a result of the change in design to accommodate decompressing a file from multiple threads

## Not upwardly compatible

-   views cannot be triggered for recalc from socket threads – signals `'threadview`.
-   view loop detection is no longer performed during view creation; now is during the view recalc.
-   `var`, `dev`, `cov`, `cor` and `enlist` are now reserved words.
-   `` `g`` attr can be set on a vector in main thread only.

