---
title: Dictionaries & tables | Basics | kdb+ and q documentation
description: Operators and keywords for working with dictionaries and tables
author: Stephen Taylor
keywords: dictionary, group, kdb+, q, sort, table
---
# Dictionaries and tables

<pre markdown="1" class="language-txt">
dictionaries:
 [! Dict](../ref/dict.md)  make a dictionary         [key](../ref/key.md)      key list
 [group](../ref/group.md)   group list by values      [value](../ref/value.md)    value list

tables:
 [cols](../ref/cols.md)    column names              [xasc](../ref/asc.md#xasc)     sort ascending 
 [meta](../ref/meta.md)    metadata                  [xdesc](../ref/desc.md#xdesc)    sort descending 
 [xcol](../ref/cols.md#xcol)    rename cols               [xgroup](../ref/xgroup.md)   group by values in selected cols
 [xcols](../ref/cols.md#xcols)   re-order cols             [xdesc](../ref/desc.md#xdesc)    sort descending
 [xkey](../ref/keys.md#xkey)    set cols as primary keys  [ungroup](../ref/ungroup.md)  normalize
 [! Enkey, Unkey](../ref/enkey.md)  add/remove keys
</pre>

Operators and keywords for working with dictionaries and tables.


## Dictionaries

### Keys and values

Use [Dict](../ref/dict.md) to make a dictionary from a list of keys and a list of values.

```q
q)show d:`a`b`c!1 2 3
a| 1
b| 2
c| 3

q)key d
`a`b`c
q)value d
1 2 3
```

Keywords [`key`](../ref/key.md) and [`value`](../ref/value.md) return the key and value lists respectively.

The lists must be the same length. The keys should be unique (no duplicates) but no error is signalled if duplicates are present.

??? warning "Avoid duplicating keys in a dictionary or (column names in a) table."

    Q does not reject duplicate keys, but operations on dictionaries and tables with duplicate keys are **undefined**.

??? tip "If you know the keys are unique you can set the `u` attribute on them."

    ``(`u#`a`b`c)!100 200 300``

    The dictionary will then function as a hash table – and indexing will be faster.

    :fontawesome-solid-book:
    [Set Attribute](../ref/set-attribute.md)

Items of the key and value lists can be of any datatype, including dictionaries or tables.


### Indexing a dictionary

A dictionary is a mapping from its key items to its value items.

A list is a mapping from its indexes to its items.
If the indexes of a list are its keys, it is unsurprising to find a dictionary is indexed the same way,

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


### `where` and Find

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


### Order

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


### Taking and dropping from a dictionary

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


### Joining dictionaries

Join on dictionaries has upsert semantics.

```q
q)(`a`b`c!10 20 30),`c`d!400 500
a| 10
b| 20
c| 400
d| 500
```


### Empty and singleton dictionaries

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


### Column dictionaries

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


## Simple tables

Flipping a column dictionary produces a table.
Think of a table as a list of named same-length lists.
The lists can be of any type; they are usually simple lists, i.e. vectors.


### Notation for a simple table

Table notation allows direct definition of a table as a list of named columns.

```q
q)show t:([] name:`dick`jane; dob:1980.05.24 1990.09.03; sex:`m`f)
name dob        sex
-------------------
dick 1980.05.24 m
jane 1990.09.03 f
```


### Indexing a simple table

If a table is a flipped dictionary, it is unsurprising that we can index the table by column names

```q
q)t `sex`dob
m          f
1980.05.24 1990.09.03
```

much as we index the column dictionary above.

```q
q)bd `sex`dob
m          f          m
1982.09.15 1984.07.05 1990.11.16
```

But a table is also ordered.

```q
q)reverse t
name dob        sex
-------------------
jane 1990.09.03 f
dick 1980.05.24 m

q)count t
2
```

So an item is not a column, but – a row?

```q
q)first t
name| `dick
dob | 1980.05.24
sex | `m
```

Oh, a dictionary.

We see at last the dual nature of a table.
It is _both_

-   a list of named same-length columns
-   a list of like (same-key) dictionaries

And we can index it either way or both.

```q
q)t 1
name| `jane
dob | 1990.09.03
sex | `f

q)t `dob
1980.05.24 1990.09.03

q)t[1 0;`dob`sex]
1990.09.03 `f
1980.05.24 `m
```

Its items are dictionaries and, as a table is a list of like dictionaries, any sublist of the table is – also a table.

```q
q)t 1 0
name dob        sex
-------------------
jane 1990.09.03 f
dick 1980.05.24 m
```


### Taking and dropping from a simple table

A table is ordered, so you can take and drop from either end of it.

```q
q)caps:([]country:`France`Nigeria`UK`USA;
        city:`Paris`Lagos`London`Washington;
        continent:`Europe`Africa`Europe`NorthAmerica)

q)-2#caps
country city       continent
-------------------------------
UK      London     Europe
USA     Washington NorthAmerica

q)-2 _ caps
country city  continent
-----------------------
France  Paris Europe
Nigeria Lagos Africa
```

You can also take selected columns.

```q
q)`city`country#caps
city       country
------------------
Paris      France
Lagos      Nigeria
London     UK
Washington USA
```


### Joining simple tables

With tables, Join appends the second to the first.

```q
q)t,flip bd
name dob        sex
-------------------
dick 1980.05.24 m
jane 1990.09.03 f
jack 1982.09.15 m
jill 1984.07.05 f
john 1990.11.16 m
```

Join Each has upsert semantics.

```q
q)t,'([] eye:`blue`green; city:`Tokyo`London; sex:`m`m)
name dob        sex eye   city
--------------------------------
dick 1980.05.24 m   blue  Tokyo
jane 1990.09.03 m   green London
```

There are many other [join keywords](joins.md).


### Dict Each

Because tables are collections of like dictionaries, `x!` applied to each member of a list returns a table of that list. For example:

```q
q)`a`b`c!/:(0 0 0;1 2 3;2 4 6)
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


## Keyed tables

A table is a list of rows, each one a dictionary.

A keyed table uses one or more of the columns as a key.
It is a dictionary. Its key is the key columns; its value, the other columns.

Here we use [Dict](../ref/dict.md) to make a key from the first column of a simple table.

```q
q)show kt:1!t,flip bd
name| dob        sex
----| --------------
dick| 1980.05.24 m
jane| 1990.09.03 f
jack| 1982.09.15 m
jill| 1984.07.05 f
john| 1990.11.16 m

q)key kt
name
----
dick
jane
jack
jill
john

q)value kt
dob        sex
--------------
1980.05.24 m
1990.09.03 f
1982.09.15 m
1984.07.05 f
1990.11.16 m
```



### Notation for a keyed table

Table notation allows direct definition of a keyed table.

```q
q)show ku:([name:`Tom`Jo`Tom; city:`NYC`LA`Lagos] eye:`green`blue`brown; sex:`m`f`m)
name city | eye   sex
----------| ---------
Tom  NYC  | green m
Jo   LA   | blue  f
Tom  Lagos| brown m

q)key ku
name city
----------
Tom  NYC
Jo   LA
Tom  Lagos

q)value ku
eye   sex
---------
green m
blue  f
brown m
```


### Indexing a keyed table

There are two ways to index a keyed table.

First, with a single row from its key, returning a dictionary.

```q
q)flip{x cols x}key kt
dick
jane
jack
jill
john
q)kt `john
dob| 1990.11.16
sex| `m

q)flip{x cols x}key ku
Tom NYC
Jo  LA
Tom Lagos
q)ku `Tom`Lagos
eye| brown
sex| m
```

Second, with a sublist from its key, returning a list of dictionaries, which is a table.

```q
q)ku ([]city:`LA`Lagos; name:`Jo`Tom)
eye   sex
---------
blue  f
brown m
```


!!! tip "qSQL and Functional SQL"

    The foregoing describes dictionaries and tables in terms of lists and indexes.
    [Functional SQL](funsql.md) extends the concepts through the query operators `?` and `!`.

    If you are familiar with SQL, you will find [qSQL queries](qsql.md) more readable.

----

:fontawesome-solid-book-open:
[Functional SQL](funsql.md),
[qSQL](qsql.md)
<br>
:fontawesome-solid-book:
[Step dictionaries](../ref/apply.md#step-dictionaries)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§5. Dictionaries](/q4m3/5_Dictionaries/),
[§8. Tables](/q4m3/8_Tables/)
