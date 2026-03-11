---
title: cross product | Reference | kdb+ and q documentation
description: cross is a q keyword that returns the cross-product (all possible combinations) of the items of its arguments.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `cross`

_Cross product_

```syntax
x cross y    cross[x;y]
```

Returns the [cross (or Cartesian) product](https://en.wikipedia.org/wiki/Cartesian_product "Wikipedia") (that is, all possible pairings) of lists `x` and `y`.

```q
q)1 2 3 cross 10 20
1 10
1 20
2 10
2 20
3 10
3 20
```

Use `(cross/)` to create the cross product of 3 or more lists.

```q
q)(cross/)(2 3;10;"abc")
2 10 "a"
2 10 "b"
2 10 "c"
3 10 "a"
3 10 "b"
3 10 "c"
```

`cross` can work on tables and dictionaries.

```q
q)s:`IBM`MSFT`AAPL
q)v:1 2
q)([]s:s)cross([]v:v)
s    v
------
IBM  1
IBM  2
MSFT 1
MSFT 2
AAPL 1
AAPL 2
```

The function `cross` is equivalent to `{raze x,/:\:y}`.

!!! note

    As a result of this equivalence and the way the [Join operator (`,`)](join.md) works, if the items of `x` and `y` are lists themselves, they are joined together with no regards to the extra level of nesting.

    ```q
    q)a:(1 2;3 4) cross (5 6;7 8)
    1 2 5 6
    1 2 7 8
    3 4 5 6
    3 4 7 8
    ```

    To keep the nesting, `enlist` the sublists.

    ```q
    q)b:(enlist each (1 2;3 4)) cross enlist each (5 6;7 8)
    1 2 5 6
    1 2 7 8
    3 4 5 6
    3 4 7 8
    ```

    Although they are displayed identically, the two results are not the same!

    ```q
    q)-1 .Q.s1 (1 2;3 4) cross (5 6;7 8);
    (1 2 5 6;1 2 7 8;3 4 5 6;3 4 7 8)
    q)-1 .Q.s1 (enlist each (1 2;3 4)) cross enlist each (5 6;7 8);
    ((1 2;5 6);(1 2;7 8);(3 4;5 6);(3 4;7 8))
    ```

---
