---
title: Dict | Reference | kdb+ and q documentation
description: Dict is a q operator that returns a dictionary from vectors of keys and values. 
author: Stephen Taylor
keywords: bang, dict, dictionaries, dictionary, kdb+, q
---
# `!` Dict






_Make a dictionary or keyed table; remove a key from a table_

Syntax: `x!y`, `![x;y]` 

Where 

-   `x` and `y` are same-length lists, returns a dictionary in which `x` is the key and `y` is the value
-   `y` is a simple table and `x` is a member of `1_til count y`, returns a keyed table with the first `x` columns as its key
-   `y`  is a table and `x` is 0, returns a simple table; i.e. removes the key

Dictionary keys should be distinct (i.e. `{x~distinct x}key dict)` but no error is signalled if that is not so. 

Items of `x` and `y` can be of any datatype, including dictionaries and tables. 

```q
q)`a`b`c!1 2 3
a| 1
b| 2
c| 3

q)show kt:2!([]name:`Tom`Jo`Tom; city:`NYC`LA`Lagos; eye:`green`blue`brown; sex:`m`f`m)
name city | eye   sex
----------| ---------
Tom  NYC  | green m
Jo   LA   | blue  f
Tom  Lagos| brown m

q)show ku:([]name:`Tom`Jo`Tom; city:`NYC`LA`Lagos)!([]eye:`green`blue`brown; sex:`m`f`m)
name city | eye   sex
----------| ---------
Tom  NYC  | green m
Jo   LA   | blue  f
Tom  Lagos| brown m
q)kt~ku
1b

q)0!kt
name city  eye   sex
--------------------
Tom  NYC   green m
Jo   LA    blue  f
Tom  Lagos brown m
```

Dict is a uniform function on its right domain.

## Errors

error  | cause
-------|--------------------------------------
length | `x` and `y` are not same-length lists
length | `x` is not in `1_ til count y`
type   | `y` is not a simple table

:fontawesome-solid-book:
[`key`](key.md),
[`value`](value.md)
<br>
:fontawesome-solid-book-open:
[Dictionaries & tables](../basics/dictsandtables.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§5 Dictionaries](/q4m3/5_Dictionaries/)