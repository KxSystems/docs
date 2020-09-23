---
title: Fill operator, fills keyword – replace nulls in a vector | Reference | kdb+ and q documentation
description: Fill is a q operator that replaces nulls in a vector. fills is a q keyword that replaces nulls in a vector with preceding non-nulls.
author: Stephen Taylor
---
# `^` Fill, `fills`

_Replace nulls_



## `^` Fill

_Replace nulls_

```txtr
x^y    ^[x;y]
```

Where `x` and `y` are conforming lists or dictionaries
returns `y` with any nulls replaced by the corresponding item of `x`.

```q
q)0^1 2 3 0N
1 2 3 0
q)100^1 2 -5 0N 10 0N
1 2 -5 100 10 100
q)1.0^1.2 -4.5 0n 0n 15
1.2 -4.5 1 1 15
q)`nobody^`tom`dick``harry
`tom`dick`nobody`harry
q)1 2 3 4 5^6 0N 8 9 0N
6 2 8 9 5
```

Integer `x` items are promoted when `y` is float or real.

```q
q)a:11.0 2.1 3.1 0n 4.5 0n
q)type a
9h
q)10^a
11 2.1 3.1 10 4.5 10
q)type 10^a
9h
```

When `x` and `y` are dictionaries, both null and missing values in `y` are filled with those from `x`.

```q
q)(`a`b`c!1 2 3)^`b`c!0N 30
a| 1
b| 2
c| 30
```

Fill is an atomic function.

:fontawesome-solid-book: 
[`^` Coalesce](coalesce.md) where `x` and `y` are keyed tables 


## `fills`

_Replace nulls with preceding non-nulls_

```txt
fills x     fills[x]
```

Where `x` is a list, returns `x` with any null items replaced by their preceding non-null values, if any.

`fills` is a uniform function. 

```q
q)fills 0N 2 3 0N 0N 7 0N
0N 2 3 3 3 7 7
```

To back-fill, reverse the list and the result:

```q
q)reverse fills reverse 0N 2 3 0N 0N 7 0N
2 2 3 7 7 7 0N
```

For a similar function on infinities, first replace them with nulls:

```q
q)fills {(x where x=0W):0N;x} 0N 2 3 0W 0N 7 0W
0N 2 3 3 3 7 7
```

The keyword `fills` is defined as  `^\`, which fills forward, meaning that non-null items are filled over succeeding null items.

```q
q)fills 1 0N 3 0N 0N 5
1 1 3 3 3 5
q)fills `x``y```z
`x`x`y`y`y`z
q)update fills c2 from ([] `a`b`c`d`e`f; c2:1 0N 3 0N 0N 5)
x c2
----
a 1
b 1
c 3
d 3
e 3
f 5
```

To fill initial nulls apply the derived function as a binary.

```q
q)fills 0N 0N 3 0N 5
0N 0N 3 3 5
q)0 ^\ 0N 0N 3 0N 5
0 0 3 3 5
```

