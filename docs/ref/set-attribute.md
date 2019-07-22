---
title: Set Attribute
description: Set Attribute is a q operator that assigns an attribute to a list.
author: Stephen Taylor
keywords: attribute, grouped, kdb+, parted, q, sorted, unique, 
---
# `#` Set Attribute





Syntax: `x#y`, `#[x;y]`

Where `y` is a list and atom `x` is 

-   an item from the list `` `s`u`p`g ``, returns `y` with the corresponding [attribute](../basics/syntax.md#attributes) set
-   the null symbol `` ` ``, returns `y` with all attributes removed

```q
q)`s#1 2 3
`s#1 2 3
q)`#`s#1 2 3
1 2 3
```

Setting or unsetting an attribute other than `s` (i.e. `upg`) causes a copy of the object to be made. 

Setting/unsetting the `s` attribute on a list which is already sorted will not cause a copy to be made, and hence will affect the original list in-place. 

Setting the `s` attribute on a dictionary or table, where the key is already in sorted order, in order to obtain a step-function, causes the `s` attribute to be set in place for the key but copies the outer object. 

`s`, `u` and `g` are preserved on append in memory, if possible.
Only `s` is preserved on append to disk.

```q
q)t:([1 2 4]y:7 8 9);`s#t;attr each (t;key t)
``s
```

example       | attribute
--------------|---------
`` `s#2 2 3`` | sorted  
`` `u#2 4 5`` | unique  
`` `p#2 2 1`` | parted  
`` `g#2 1 2`` | grouped 


Attribute `u` is for unique lists – where all items are distinct.

!!! tip "Grouped and parted"

    Attributes `p` and `g` are useful for lists in memory with a lot of repetition.

    If the data can be sorted such that `p` can be applied, the `p` attribute effects better speedups than `g`, both on disk and in memory.

    The `g` attribute implies an entry’s data may be dispersed – and possibly slow to retrieve from disk.

Some q functions use attributes to work faster:

-    Where-clauses in [`select` and `exec` templates](../basics/qsql.md) run faster with `where =`, `where in` and `where within`
-    Searching: [`bin`](bin.md), [`distinct`](distinct.md), [Find](find.md) and [`in`](in.md) (if the right argument has an attribute)
-    Sorting: [`iasc`](asc.md#iasc) and [`idesc`](asc.md##idesc)
-    Dictionaries: [`group`](group.md)


!!! warning "Grouped attribute"

    The `g` attribute is presently unsuitable for cycling through a small window of a domain, due to the retention of keys backing the attribute.

    <pre><code class="language-q">
    q)v:\`g#1#0
    q)do[1000000;v[0]+:1];
    q)0N!.Q.w[]\`used; v:\`g#\`#v; .Q.w[]\`used
    74275344
    332368
    </code></pre>


!!! warning "Compressed data"

    Applying an attribute to compressed data on disk decompresses it. 