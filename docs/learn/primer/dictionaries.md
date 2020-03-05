---
title: Dictionaries | Kdb+ database and language primer | Documentation for kdb+ and q
author: Dennis Shasha (shasha@cs.nyu.edu)
description: Introduction to the kdb+ database and q language, used for Dennis Sasha’s college classes
hero: <i class="fas fa-graduation-cap"></i> Kdb+ database and language primer
---
# Dictionaries



A dictionary is [composed from two lists](../../ref/dict.md "Reference: Dict"): keys and values.

```q
q)salaries: 30 35 40
q)show sal:`Tom`Dick`Harry ! 30 35 40
Tom  | 30
Dick | 35
Harry| 40
q)salaries [2 0]  / select items by position
40 30
q)sal `Harry`Tom  / select items by key
40 30
```

Any list can be the key of a dictionary. 

```q
q)show stringfruit:("cherry"; "plum"; "tomato")!`brightred`violet`brightred
"cherry"| brightred
"plum"  | violet
"tomato"| brightred
q)stringfruit "tomato" 
`brightred
```

!!! warning "Duplicate keys"

    Ensure your dictionary keys are unique.
    Duplicate keys can have non-intuitive consequences; none useful.

    Q assumes dictionary keys are unique, but to protect performance does not ensure it.


## Order

Dictionaries are indexed by their keys, but they are still ordered.

```q
q)sal
Tom  | 30
Dick | 35
Harry| 40

q)value sal
30 35 40
q)first sal
30
q)last sal
40
q)sal 1 / 1 is not a key to sal!
'type
  [0]  sal 1
       ^
q)value[sal] 1
35
```


## Joining dictionaries

Joining lists is concatenation.

```q
q)`Tom`Dick`Harry,`Dick`Jane
`Tom`Dick`Harry`Dick`Jane
```

Dictionaries are joined using _upsert_ semantics.

```q
q)show fruitcolor:`cherry`plum`tomato!`brightred`violet`brightred 
cherry| brightred
plum  | violet
tomato| brightred

q)fruitcolor2:`grannysmith`plum`prune!`green`reddish`black

q)fruitcolor,fruitcolor2
cherry     | brightred
plum       | reddish
tomato     | brightred
grannysmith| green
prune      | black
```

An upsert will update values where keys match; otherwise an insert.
We notice `plum` has simply had its color updated, but the other entries from `fruitcolor2` are new.




---
<i class="far fa-hand-point-right"></i>
[Tables](tables.md)