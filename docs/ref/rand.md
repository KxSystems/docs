---
title: rand
description: rand is a q keyword that randomly picks a number, or an item from a list.
author: Stephen Taylor
keywords: deal, kdb+, q, rand, random, roll
---
# `rand` 

_Pick randomly_



Syntax: `rand x`, `rand[x]`



## Pick a number at random

Where `x` is a **positive numeric atom** returns a numeric atom in the range [0,x).

```q
q)rand 100
10
q)rand each 20#6  /roll twenty 6-sided dice
2 5 4 5 1 0 5 2 4 5 1 2 0 1 1 2 1 0 0 5
q)rand 3.14159
1.277572
q)rand 2012.09.12
2008.02.04
```


## Pick from a list

Where `x` is a **list** returns an item chosen randomly from `x`

```q
q)rand 1 30 45 32
32
```

`rand` is exactly equivalent to `{first 1?x}`. If you need a vector result, consider using Roll instead of `rand`. The following expressions all roll 100 six-sided dice.

```q
rand each 100#6
{first 1?x} each 100#6
100?6
```


<i class="far fa-hand-point-right"></i>
[Roll and Deal](deal.md) for random seed