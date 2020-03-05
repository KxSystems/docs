---
title: Temporal primitives in kdb+ | Kdb+ database and language primer | Documentation for kdb+ and q
author: Dennis Shasha (shasha@cs.nyu.edu)
description: Temporal primitives in q and kdb+
hero: <i class="fas fa-graduation-cap"></i> Kdb+ database and language primer
---
# Temporal primitives






Q has very rich temporal primitives and keeps track of all those pesky leap years and the base-60 operations on seconds and minutes that we have inherited from the Babylonians.

```q
q)show x: .z.z / Greenwich Mean Time
2020.03.04T10:10:24.019

q)x.month
2020.03m
q)x.year
2020i
q)x.minute
10:10
q)x.second
10:10:24
q)x.time
10:10:24.019
q)x.date
2020.03.04
q)x.second
10:10:24
```

<i class="fas fa-book"></i>
[Cast](../../ref/cast.md),
[`.z` namespace](../../ref/dotz.md)
<br>
<i class="fas fa-book-open"></i>
[Casting](../../basics/casting.md),
[Datatypes](../../basics/datatypes.md)


---
<i class="far fa-hand-point-right"></i>
[Appendix 2: Execution control](control.md)