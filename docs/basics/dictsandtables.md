---
title: Dictionaries | Basics | kdb+ and q documentation
description: Operators and keywords for working with dictionaries 
author: Stephen Taylor
keywords: dictionary, group, kdb+, q, sort, table
---
# Dictionaries

<div markdown="1" class="typewriter">
[! Dict](../ref/dict.md)  make a dictionary         [key](../ref/key.md)      key list
[group](../ref/group.md)   group list by values      [value](../ref/value.md)    value list
</div>


## Lists and dictionaries

A list is a mapping from its indexes to its items: `v:1040 59 27` maps 

```txt
0 -> 1040
1 -> 59
2 -> 27
```

A dictionary is a mapping from a list of keys to a list of values.

```q
q)show d:`tom`dick`harry!1040 59 27
tom  | 1040
dick | 59
harry| 27
```

The indexes of `v` are `0 1 2`. The indexes of `d` are `` `tom`dick`harry``. 

The values of `v` and `d` are the same.

```q
q)value d
1040 59 27
q)value `v
1040 59 27
```


## Construction 

Use [Dict](../ref/dict.md) to make a dictionary from a list of keys and a list of values.

```q
q)show d:`a`b`c!1 2 3
a| 1
b| 2
c| 3
```

The lists must be the same length. The keys should be unique (no duplicates) but no error is signalled if duplicates are present.

??? danger "Avoid duplicating keys in a dictionary or (column names in a) table."

    Q does not reject duplicate keys, but operations on dictionaries and tables with duplicate keys are **undefined**.

??? tip "If you know the keys are unique you can set the `u` attribute on them."

    ``(`u#`a`b`c)!100 200 300``

    The dictionary will then function as a hash table – and indexing will be faster.

    :fontawesome-solid-book:
    [Set Attribute](../ref/set-attribute.md)

Items of the key and value lists can be of any datatype, including dictionaries or tables.


## Keys and values

```q
q)key d
`a`b`c
q)value d
1 2 3
```

Keywords [`key`](../ref/key.md) and [`value`](../ref/value.md) return the key and value lists respectively.


## Indexing 

A dictionary is a mapping from its key items to its value items.

A list is a mapping from its indexes to its items.
If the indexes of a list are its keys, it is unsurprising to find a dictionary is indexed by its keys.

```q
q)k:`a`b`c`d`e
q)v:10 20 30 40 50
q)show dic:k!v
a| 10
b| 20
c| 30
d| 40
e| 50

q)dic[`d`b]
40 20
q)v[3 1]
40 20
```

Nor that we can omit index brackets the same way.

```q
q)dic `d`b
40 20
q)v 3 1
40 20
```

Indexing out of the domain works as for lists, returning a null of the same type as the first value item.

```q
q)v 5
0N
q)dic `x
0N
```

But unlike a list, indexed assignment to a dictionary has upsert semantics.

```q
q)v[5 1]:42 100
'length
  [0]  v[5 1]:42 100
             ^
q)dic[`x`b]:42 100
q)dic
a| 10
b| 100
c| 30
d| 40
e| 50
x| 42
```


## `where` and Find

[Find](../ref/find.md) and [`where`](../ref/where.md) both return indexes from lists. Also from dictionaries.

```q
q)d:`a`b`c`d!10 20 30 10

q)where d=10
`a`d

q)d?30
`c
```

Reverse dictionary lookup: use Find for the key of the first matching value, or `where` for all of them.

```q
q)dns:`netbox`google`apple!`$("104.130.139.23";"216.58.212.206";"17.172.224.47")

q)dns `apple
`17.172.224.47

q)dns?`$"17.172.224.47"
`apple

q)where dns=`$"17.172.224.47"
,`apple
```


## Order

Dictionaries are ordered.

```q
q)first dic
10
q)last dic
42

q)k:`a`b`c
q)v:1 2 3
q)(k!v) ~ reverse[k]!reverse v
0b
```


## Taking and dropping from a dictionary

Dictionaries are ordered, so you can take and drop items from either end of them.

```q
q)d
a| 10
b| 20
c| 30
d| 10

q)-2#d
c| 30
d| 10

q)-1 _ d
a| 10
b| 20
c| 30
```

You can also take and drop selected items.

```q
q)`b`d#d
b| 20
d| 10

q)`b`x _ d
a| 10
c| 30
d| 10
```


## Joining dictionaries

Join on dictionaries has upsert semantics.

```q
q)(`a`b`c!10 20 30),`c`d!400 500
a| 10
b| 20
c| 400
d| 500
```


## Empty and singleton dictionaries

Just like a list, a dictionary may be empty or have a single item.
But its key and value must still be lists.

```q
q)()!()                     / general empty dictionary
q)(`symbol$())!`float$()    / typed empty dictionary

q)sd:(enlist `a)!enlist 1   / singleton dictionary
a| 1
q)key sd
,`a
q)value sd
,1
```


## Column dictionaries

When a dictionary’s value items are all same-length lists, it is a _column dictionary_.

```q
q)show bd:`name`dob`sex!(`jack`jill`john;1982.09.15 1984.07.05 1990.11.16;`m`f`m)
name| jack       jill       john
dob | 1982.09.15 1984.07.05 1990.11.16
sex | m          f          m
```

Flip it and we see a table.

```q
q)flip bd
name dob        sex
-------------------
jack 1982.09.15 m
jill 1984.07.05 f
john 1990.11.16 m
```


---
:fontawesome-solid-book:
[Step dictionaries](../ref/apply.md#step-dictionaries)
<br>
:fontawesome-solid-book-open:
[Tables](../kb/faq.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§5. Dictionaries](/q4m3/5_Dictionaries/),
