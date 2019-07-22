---
title: Changes in 3.3
description: Changes to V3.3 of kdb+ from the previous version
author: Charles Skelton
---
# Changes in 3.3



Below is a summary of changes from V3.2. Commercially-licensed users may obtain the detailed change list / release notes from [downloads.kx.com](http://downloads.kx.com)


## Production release date

2015.06.01


## New

-   Many operations are now 10 times faster – performance of `avg … by`, avg for types G H, sum G, grouping by G H. Also `distinct`/`find` for G H.
-   `+/` `&/` `|/` `=` `<` are 10-20x faster for GH, `avg` is a lot faster for GHIJ.
-   `+/I` will give `0Ni` on overflow.
-   Faster and stricter JSON parser. It is approx 50-100x faster and can process Unicode.
-   `` `g`` attr can (again) be created in threads other than main thread. In V3.2, we removed the limit on number of concurrent vectors which can have `` `g`` attr, and a side-effect was that `` `g`` attr could be created on the main thread only. That restriction has now been removed.
-   Read-only eval of parse tree. The new keyword `reval`, backed by `-24!`, behaves similarly to `eval` (`-6!`), but evaluates the parse tree in read-only mode, as if the cmd line option `-b` were active for the duration of the reval call. This should prove useful for access control.
-   Improve performance of on-disk sort for un-cached splayed tables.
-   Allow processing of `http://host:port/.json?query` requests.
-   Columns of nested enumerated syms with key `` `sym`` now report as `S` in meta.
-   Splayed table count is now taken from first column in table. (Previously it was taken from the last column).
-   Distributed `each` will revert to local `each` if `.z.pd` is not defined.
-   Added `.z.X`, which provides the raw, unfiltered cmd line.
-   Added `.Q.Xf` to write empty nested files.
-   `.Q.id` now handles columns that start with a numeric character.


## Not upwardly compatible

-   `reval` is now a reserved word.
-   SSE-enabled builds (v64,l64,m64) now require SSE4.2
-   WebSocket open/close callbacks are now via `.z.wo`/`.z.wc` instead of `.z.po`/`.z.pc`.

