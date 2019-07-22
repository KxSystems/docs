---
title: Changes in 3.1
description: Changes to V3.1 of kdb+ from the previous version
author: Charles Skelton
---
# Changes in 3.1



Below is a summary of changes from V3.0. Commercially licensed users may obtain the detailed change list / release notes from (http://downloads.kx.com)

- improved performance of `select` with intervals.
- improved performance through using more chip-specific instructions (SSE).
- parallel processing through multiprocess `peach`.
- and numerous other minor fixes and improvements.


## Production release date

2013.06.09


## Not upwardly compatible

- distributed `each` (i.e. `q -s -N`) no longer opens connections to slave processes automatically on ports `20000+til N`.
- result type of E arithmetic for `+-*` changes from F to E. (`avg` and `wavg` still always go to F. `mdev` promotes to F.)

