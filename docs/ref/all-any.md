---
title: all, any – Reference – KDB-X and q documentation
description: all and any are q keywords that invoke aggregator functions for vectors of flags
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `all`, `any`

## `all`

_Is every item true?_

```syntax
all x    all[x]
```

Returns a boolean atom `1b` if `x` is

- a list and all items are nonzero (this includes the empty list)
- a nonzero atom;

returns `0b` otherwise.

Applies to all datatypes except symbols and GUIDs.

Strings are [cast](cast.md) to boolean; the only character that casts to zero is the [null character](https://en.wikipedia.org/wiki/Null_character "Wikipedia"), represented in q by the escape sequence `"\000"`. Note that this is _not_ the same as the character atom considered null by q, which is `" "`.

Where `x` is a table, `all` iterates over its columns and returns a dictionary.

```q
q)all 1 2 3 = 1 2 4
0b
q)all 1 2 3 = 1 2 3
1b
q)all "YNYN" / string casts to 1111b
1b
q)all () /no zeros here
1b
q)all 2000.01.01
0b
q)all 2000.01.02 2010.01.02
1b
q)all " \000"
0b
q)all null " \000"
0b
q)all ([] c1:1 2 3; c2:0n 0w -0w; c3:0 1 2f)
c1| 1
c2| 1
c3| 0
```

`all` is an aggregate function.

```txt
domain: B G X H I J E F C S P M D Z N U V T
range:  b . b b b b b b b . b b b b b b b b
```

`all` is a [multithreaded primitive](mt-primitives.md).

## `any`

_Is there a true item?_

```syntax
any x    any[x]
```

Returns a boolean atom `1b` if `x` is

- a list with at least one nonzero item,
- a nonzero atom;

returns `0b` otherwise.

All other notes are the same as for `all` above.

```q
q)any 1 2 3 = 10 20 4
0b
q)any 1 2 3 = 1 20 30
1b
q)any "YNYN" / string casts to 1111b
1b
q)any () / no nonzeros here
0b
q)any " \000"
1b
q)any null " \000"
1b
q)any 2000.01.01
0b
q)any 2000.01.01 2000.01.02
1b
q)any ([] c1:1 2 3; c2:0n 0w -0w; c3:000b)
c1| 1
c2| 1
c3| 0
```

`any` is an aggregate function.

```txt
domain: B G X H I J E F C S P M D Z N U V T
range:  b . b b b b b b b . b b b b b b b b
```

`any` is a [multithreaded primitive](mt-primitives.md).

----

[Cast](cast.md),
[`&` `and`](lesser.md),
[`|` `or`](greater.md),
[`max`](max.md),
[`min`](min.md)
<br>

[Logic](by-topic.md#logic)
