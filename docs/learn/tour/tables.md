---
title: Tables in kdb+ | A whirlwind tour of kdb+ and q | Documentation for kdb+ and the q programming language
author: Stephen Taylor
date: February 2020
description: How to construct, manipulate and save tables in kdb+
---
# Tables



Tables are first-class objects in q. 


## Construct

Construct a small table using table notation.

```q
q)ec1:([]city:`Istanbul`Moscow`London`StPetersburg;country:`Turkey`Russia`UK`Russia;pop:15067724 12615279 9126366 5383890)
q)ec1
city         country pop
-----------------------------
Istanbul     Turkey  15067724
Moscow       Russia  12615279
London       UK      9126366
StPetersburg Russia  5383890
```

!!! tip "Equals means equals"

    In q names are assigned values with the colon.
    The equals sign `=` is the Equals operator. It returns a boolean.

    <pre><code class="language-q">q)a:5
    q)a+2   / a gets 5
    7
    q)a=2   / no, it is not
    0b
    </code></pre>

Unlike classical relational databases, q tables are ordered. You can index them.
A table is a list of dictionaries. Any single row is a dictionary.

```q
q)ec1 2
city   | `London
country| `UK
pop    | 9126366
```

:fontawesome-regular-hand-point-right:
[Dictionaries](dictionaries.md)

And a list of dictionaries with the same keys is – a table.

```q
q)ec1 2 0
city     country pop
-------------------------
London   UK      9126366
Istanbul Turkey  15067724
```

Flipping a table gets you its columns as a dictionary of vectors.

```q
q)flip ec1
city   | Istanbul Moscow   London  StPetersburg
country| Turkey   Russia   UK      Russia
pop    | 15067724 12615279 9126366 5383890
```

Flipping it again puts you back where you started. 

```q
q)flip flip ec1
city         country pop
-----------------------------
Istanbul     Turkey  15067724
Moscow       Russia  12615279
London       UK      9126366
StPetersburg Russia  5383890
```

So another way to construct a table:

```q
q)ec2:flip`city`country`pop!(`Berlin`Kyiv`Madrid;`Germany`Ukraine`Spain;3748148 3703100 3223334)
q)ec2
city   country pop
----------------------
Berlin Germany 3748148
Kyiv   Ukraine 3703100
Madrid Spain   3223334
```

CSVs are a common source of tables.

:fontawesome-regular-hand-point-right:
[CSVs](csvs.md)


## Work

There are two ways to work with tables and you can mix them to suit yourself. 

QSLQ queries are very like SQL. (Perhaps a little less verbose.)

```q
q)select city,pop from ec2 upsert ec1
city         pop
---------------------
Berlin       3748148
Kyiv         3703100
Madrid       3223334
Istanbul     15067724
Moscow       12615279
London       9126366
StPetersburg 5383890
```

:fontawesome-regular-hand-point-right:
[qSQL](queries.md)

Or you can think in terms of the underlying q objects. 

The [Join](../../ref/join.md) operator `,` catenates lists.

```q
q)1 2 3,10 20
1 2 3 10 20
q)"abc","def"
"abcdef"
```

Two tables are two lists of dictionaries. 

```q
q)ec2,ec1
city         country pop
-----------------------------
Berlin       Germany 3748148
Kyiv         Ukraine 3703100
Madrid       Spain   3223334
Istanbul     Turkey  15067724
Moscow       Russia  12615279
London       UK      9126366
StPetersburg Russia  5383890
```


## Persist

Any object can be persisted to a file.

```q
q)conts:`Africa`Asia`Australia`Europe`NorthAmerica`SouthAmerica
q)`:path/to/continents set conts
`:path/to/continents
q)get `:path/to/continents
`Africa`Asia`Australia`Europe`NorthAmerica`SouthAmerica

q)`:path/to/ec set ec
`:path/to/ec
q)select from `:path/to/ec where pop>5000000
city         country pop
-----------------------------
Istanbul     Turkey  15067724
Moscow       Russia  12615279
London       UK      9126366
StPetersburg Russia  5383890
```

Large tables can be splayed (one file for each column) across directories and/or partitioned by time periods. 

:fontawesome-regular-hand-point-right:
[Files](files.md)
<br>
:fontawesome-solid-book:
[`get`, `set`](../../ref/get.md),
[`save`](../../ref/save.md)
<br>
:fontawesome-solid-graduation-cap:
[Splayed tables](../../kb/splayed-tables.md),
[Partitioned tables](../../kb/partition.md)



