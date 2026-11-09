---
title: where | Reference | kdb+ and q documentation
description: where is a q keyword that returns copies of indexes of a list or keys of a dictionary.
author: KX Systems, Inc., a subsidiary of KX Software Limited
keywords: kdb+, q, selection, where
---
# `where`

_Copies of indexes of a list or keys of a dictionary_

```syntax
where x    where[x]
```

## Vector of non-negative integers

Where `x` is a vector of non-negative integers, returns a vector containing, for each item of `x`, that number of copies of its index.
`x` can be a boolean, int, or long vector.

```q
q)where 2 3 0 1
0 0 1 1 1 3
q)raze x #' til count x:2 3 0 1
0 0 1 1 1 3
```

Where `x` is boolean, the result is the indexes of the 1s. Thus `where` is often used after a logical test:

```q
q)where 0 1 1 0 1
1 2 4
q)x:1 5 6 8 11 17 20 21
q)where 0 = x mod 2        / indexes of even numbers
2 3 6
q)x where 0 = x mod 2      / select even numbers from list
6 8 20
```

## Dictionary whose values are non-negative integers

Where `x` is a dictionary whose values are non-negative integers, returns a list of keys repeated as many times as the corresponding value.

```q
q)d:`amr`ibm`msft!2 3 1
q)where d
`amr`amr`ibm`ibm`ibm`msft
q)where `a`b`c!101b            / boolean values
`a`c
q)where 2 3 0 1               / usual operation on integer list
0 0 1 1 1 3
q)where 0 1 2 3 ! 2 3 0 1     / same on dictionary with indexes as keys
0 0 1 1 1 3
```

!!! tip "Insight"

    If you view a list as a mapping from indexes to entries, the definition for a [vector of non-negative integers](#vector-of-non-negative-integers) is a special case.

----

[`where` in qSQL](../basics/qsql.md),
[Selection](../basics/by-topic.md#selection)
