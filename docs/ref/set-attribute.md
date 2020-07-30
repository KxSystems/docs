---
title: Set Attribute | Reference | kdb+ and q documentation
description: Set Attribute is a q operator that assigns an attribute to a list, dictionary or table.
author: Stephen Taylor
keywords: attribute, grouped, kdb+, parted, q, sorted, unique,
---
# `#` Set Attribute




Syntax: `x#y`, `#[x;y]`

Where `y` is a list or dictionary and atom `x` is

-   an item from the list `` `s`u`p`g ``, returns `y` with the corresponding [attribute](../basics/syntax.md#attributes) set
-   the null symbol `` ` ``, returns `y` with all attributes removed

Attributes:
```txt
`s#2 2 3   sorted    items in ascending order  list, dict, table
`u#2 4 5   unique    each item unique          list
`p#2 2 1   parted    common values adjacent    simple list
`g#2 1 2   grouped   make a hash table         list
```

Setting or unsetting an attribute other than _sorted_ causes a copy of the object to be made.

`s`, `u` and `g` are preserved on append in memory, if possible.
Only `s` is preserved on append to disk.

```q
q)t:([1 2 4]y:7 8 9);`s#t;attr each (t;key t)
``s
```


## Sorted

The _sorted_ attribute can be set on a simple or mixed list, a dictionary, table, or keyed table.

```q
q)`s#1 2 3
`s#1 2 3
q)`#`s#1 2 3
1 2 3
```

Setting the _sorted_ attribute on an unsorted list signals an error.

```q
q)`s#3 2 1
's-fail
  [0]  `s#3 2 1
         ^
```

Setting/unsetting the _sorted_ attribute on a list which is already sorted will not cause a copy to be made, and hence will affect the original list in-place.

Setting the _sorted_ attribute on a table sets the parted attribute on the first column.

```q
q)meta `s#([] ti:00:00:00 00:00:01 00:00:03; v:98 98 100.)
c | t f a
--| -----
ti| v   p
v | f    
```

Setting the _sorted_ attribute on a dictionary or table, where the key is already in sorted order, in order to obtain a step-function, sets the _sorted_ attribute for the key but copies the outer object.


## Unique

The _unique_ attribute can be set on simple and mixed lists where all items are distinct.


## Grouped and parted

Attributes _parted_ and _grouped_ are useful for simple lists (where the datatype has an integral underlying value) in memory with a lot of repetition.

The _parted_ attribute asserts all common values in the list are adjacent.
The _grouped_ attribute causes kdb+ to create and maintain an index (hash table).

If the data can be sorted such that `p` can be set, it effects better speedups than grouped, both on disk and in memory.

The _grouped_ attribute implies an entry’s data may be dispersed – and possibly slow to retrieve from disk.

The _parted_ attribute is removed by any operation on the list.

```q
q)`p#2 2 2 1 1 4 4 4 4 3 3
`p#2 2 2 1 1 4 4 4 4 3 3
q)2,`p#2 2 2 1 1 4 4 4 4 3 3
2 2 2 2 1 1 4 4 4 4 3 3
```

??? warning "The _grouped_ attribute is presently unsuitable for cycling through a small window of a domain, due to the retention of keys backing the attribute."

    <pre><code class="language-q">
    q)v:\`g#1#0
    q)do[1000000;v[0]+:1];
    q)0N!.Q.w[]\`used; v:\`g#\`#v; .Q.w[]\`used
    74275344
    332368
    </code></pre>


## Errors

```txt
s-fail   not sorted ascending
type     tried to set u, p or g on wrong type
u-fail   not unique or not parted
```


## Performance

Some q functions use attributes to work faster:

-    Where-clauses in [`select` and `exec` templates](../basics/qsql.md) run faster with `where =`, `where in` and `where within`
-    Searching: [`bin`](bin.md), [`distinct`](distinct.md), [Find](find.md) and [`in`](in.md) (if the right argument has an attribute)
-    Sorting: [`iasc`](asc.md#iasc) and [`idesc`](asc.md##idesc)
-    Dictionaries: [`group`](group.md)

Setting attributes consumes resources and is likely to improve performance only on lists with more than a million items. Test!

!!! warning "Applying an attribute to compressed data on disk decompresses it."

----
:fontawesome-solid-book:
[`attr`](attr.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§8.8 Attributes](/q4m3/8_Tables/#88-attributes)

