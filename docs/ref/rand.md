---
title: rand | Reference | kdb+ and q documentation
description: rand is a q keyword that randomly picks a number, or an item from a list.
author: Stephen Taylor
keywords: deal, kdb+, q, rand, random, roll
---
# `rand` 

_Pick randomly_



```syntax
rand x   rand[x]
```


## Pick an item from a list

Where `x` is a **list** returns one item chosen randomly from `x`

```q
q)rand 1 30 45 32
32
q)rand("abc";"def";"ghi")  / list of lists
"ghi"
```


## Pick a value at random

Where `x` is an **atom** returns an atom of the same type.

```q
q)rand 100
10
q)rand each 20#6  /roll twenty 6-sided dice
2 5 4 5 1 0 5 2 4 5 1 2 0 1 1 2 1 0 0 5
q)rand 3.14159
1.277572
q)rand 2012.09.12
2008.02.04
q)rand `3
`afe
```

Right domain and range are as for [Roll and Deal](deal.md#generate).

!!! tip "Returns a single item"

    `rand` is exactly equivalent to `{first 1?x}`. 
    If you need a list result, use [Roll](deal.md). 
    The following expressions all roll a million six-sided dice.

        q)\ts rand each 1000000#6
        264 41166192
        q)\ts {first 1?x}each 1000000#6
        210 41166496
        q)\ts 1000000?6                     / Roll
        6 8388800


---
:fontawesome-solid-book:
[Random seed](deal.md#seed)