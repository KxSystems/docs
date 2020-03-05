---
title: Operations on dictionaries in q | Kdb+ database and language primer | Documentation for kdb+ and q
author: Dennis Shasha (shasha@cs.nyu.edu)
description: Operations on dictionaries in kdb+ and q
hero: <i class="fas fa-graduation-cap"></i> Kdb+ database and language primer
---
# Operations on dictionaries




When discussing the binary operations so far, we’ve concentrated on what could be done with atoms and lists. Now let’s see what can be done with dictionaries and tables. 

The basic idea is that for every key item the dictionaries have in common, atomic binary operators apply to the corresponding value items. 

!!! note "Atomic"

    An [atomic](../../basics/atomic.md) binary operator applies – _recursively_ – to two atoms, to an atom and a list, and element-by-element on two lists of equal length. 

    Arithmetic operations are atomic in q.

Other key elements are present in the result but are otherwise unchanged.

```q
schoolfriends: `bob`ted`carol`alice ! 23 28 30 24       
rockfriends: `sue`steve`alice`bob`allan ! 19 19 24 23 34
```

Multiplication applies to each item of the key.

```q
q)2*rockfriends
sue  | 38
steve| 38
alice| 48
bob  | 46
allan| 68
```

For each common item in the key, the value parts are added.

```q
q)schoolfriends+schoolfriends
bob  | 46
ted  | 56
carol| 60
alice| 48
```

Same as above and in addition there is a union of the keys. 
So `bob` and `alice` are doubled, but everyone else goes in as they were in the base dictionaries.

```q
q)schoolfriends = rockfriends
bob  | 1
ted  | 0
carol| 0
alice| 1
sue  | 0
steve| 0
allan| 0
```

In spite of the fact that `bob` and `alice` are in different positions in the two dictionaries, the fact that they have the same value is recognized.

---
<i class="far fa-hand-point-right"></i>
[Iterators](iterators.md)