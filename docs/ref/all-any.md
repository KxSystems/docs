---
title: all, any – Reference – kdb+ and q documentation
description: all and any are q keywords that invoke aggregator functions for vectors of flags
author: Stephen Taylor
---
# `all`, `any`




## `all`

_Everything is true_


```txt
all x    all[x]
```

Returns a boolean atom `0b`; or `1b` where `x` is

-   a list and all items are non-zero
-   a non-zero atom
-   an empty list

Applies to all datatypes except symbols and GUIDs.

Where `x` is a table, `all` iterates over its columns and returns a dictionary.

```q
q)all null ([] c1:`a`b`c; c2:0n 0n 0n; c3:10 0N 30)
c1| 0
c2| 1
c3| 0
```

Strings are [cast](cast.md) to boolean.

`all` is an aggregate function.

```q
q)all 1 2 3=1 2 4
0b
q)all 1 2 3=1 2 3
1b
q)all "YNYN" / string casts to 1111b
1b
q)all () /no zeros here
1b
q)all 2000.01.01
0b
q)all 2000.01.02 2010.01.02
1b

q)if[all x in y;....]   / use in control structure
```



## `any`

_Something is true_

```txt
any x    any[x]
```

Returns a boolean atom `0b`; or `1b` where `x` is

-   a list with at least one non-zero item
-   a non-zero atom

Applies to all datatypes except symbols and GUIDs.
Strings are [cast](cast.md) to boolean.

`any` is an aggregate function.

```q
q)any 1 2 3=10 20 4
0b
q)any 1 2 3=1 20 30
1b
q)any "YNYN" / string casts to 1111b
1b
q)any () / no non-zeros here
0b
q)any 2000.01.01
0b
q)any 2000.01.01 2000.01.02
1b

q)if[any x in y;....]   / use in control structure
```

----

:fontawesome-solid-book:
[Cast](cast.md),
[`&` `and`](lesser.md),
[`|` `or`](greater.md),
[`max`](max.md),
[`min`](min.md)
<br>
:fontawesome-solid-book-open:
[Logic](../basics/by-topic.md#logic)