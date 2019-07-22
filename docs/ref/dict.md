---
title: Dict
description: Dict is a q operator that returns a dictionary from vectors of keys and values. 
author: Stephen Taylor
keywords: bang, dict, dictionaries, dictionary, kdb+, q
---
# `!` Dict






_Make a dictionary from two lists_

Syntax: `x!y`, `![x;y]` 

Where `x` and `y` are same-length lists, returns a dictionary in which `x` are the keys and `y` are the values. 

Dictionary keys should be distinct (i.e. `{x~distinct x}key dict)` but no error is signalled if that is not so. 

Items of `x` and `y` can be of any datatype, or dictionaries, or tables. 

```q
q)`a`b`c!1 2 3
a| 1
b| 2
c| 3
```

Because tables are collections of like dictionaries, `x!` applied to each member of a list returns a table of that list. For example:

```q
q)(`a`b`c!)each(0 0 0;1 2 3;2 4 6)
a b c
-----
0 0 0
1 2 3
2 4 6
```

The same result may be achieved with a pair of flips:

```q
q)flip`a`b`c!flip(0 0 0;1 2 3;2 4 6)
a b c
-----
0 0 0
1 2 3
2 4 6
```

Dict is a uniform function.

## Errors

error  | cause
-------|--------------------------------------
length | `x` and `y` are not same-length lists

<i class="far fa-hand-point-right"></i>
Basics: [Dictionaries & tables](../basics/dictsandtables.md)