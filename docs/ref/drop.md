---
title: Drop
description: Drop is a q operator that drops items from a list, entries from a dictionary or columns from a table.
author: Stephen Taylor
keywords: cut, drop, kdb+, list,q
---
# `_` Drop




_Drop items from a list, entries from a dictionary or columns from a table._

Syntax: `x _ y`, `_[x;y]`


## Drop leading or trailing items 

Where

-   `x` is an **int atom**
-   `y` a **list or dictionary**

returns `y` without the first or last `x` items.

```q
q)5_0 1 2 3 4 5 6 7 8      /drop the first 5 items
5 6 7 8
q)-5_0 1 2 3 4 5 6 7 8     /drop the last 5 items
0 1 2 3
q)1 _ `a`b`c!1 2 3
b| 2
c| 3
```


### Drop from a string

```q
q)b:"apple: banana: cherry"
q)(b?":") _ b / find the first ":" and remove the prior portion of the sentence
": banana: cherry"
```


## Drop selected items

Where

-   `x` is a **list or dictionary**
-   `y` is an **index or key** of `x`

returns `x` without the items or entries at `y`.

```q
q)0 1 2 3 4 5 6 7 8_5      /drop the 5th item
0 1 2 3 4 6 7 8
q)(`a`b`c!1 2 3)_`a        /drop the entry for `a
b| 2
c| 3
```


## Drop keys from a dictionary

Where

-   `x` is an **atom or vector of keys** to `y`
-   `y` is a **dictionary**

returns `y` without the entries for `x`. 

```q
q)`a _ `a`b`c!1 2 3
b| 2
c| 3
q)`a`b _ `a`b`c!1 2 3
c| 3
q)(`a`b`c!1 2 3) _ `a`b
'type
```

<i class="far fa-hand-point-right"></i> 
_Q for Mortals_: [§5. Dictionaries](/q4m3/5_Dictionaries/#522-extracting-a-sub-dictionary)

!!! warning "Dropping dictionary entries with integer arguments"

        With dictionaries, distinguish the roles of integer arguments to _drop_.

        <pre><code class="language-q">
        q)d:100 200!\`a\`b
        q)1 _ d            /drop the first entry
        200| b
        q)d _ 1            /drop where key=1
        100| a
        200| b
        q)d _ 100          /drop where key=100
        200| b
        q)enlist[1] _ d    /drop where key=1
        100| a
        200| b
        q)enlist[100] _ d  /drop where key=100
        200| b
        q)100 _ d          /drop first 100 entries
        </code></pre>


## Drop columns from a table

Where

-   `x` is a **symbol vector of column names** 
-   `y` is a **table**

returns `y` without columns `x`.

```q
q)t:([]a:1 2 3;b:4 5 6;c:`d`e`f)
q)`a`b _ t
c
-
d
e
f
q)t _ `a`b
'type
q)`a _ t
'type
q)t _ `a
'type
```

!!! tip "Drop in place"

    Assign through _drop_ to delete in place. 

    <pre><code class="language-q">
    q)show d:\`a\`b\`c\`x!(1;2 3;4;5)
    a| 1
    b| 2 3
    c| 4
    x| 5
    q)d _:\`x
    q)d
    a| 1
    b| 2 3
    c| 4
    </code></pre>


