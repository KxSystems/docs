---
title: Linking columns | Database | kdb+ and q documentation
description: A link column is similar to a foreign-key column – it provides linkage between the values of a column in a table to the values in a column in a second table
---
# Linking columns




A link column is similar to a [foreign key](../wp/foreign-keys.md) – it links the values of a column in a table to the values in a column in a second table.

They differ: 

-   a foreign-key column is an enumeration over the key column of a keyed table
-   a link column consists of indexes into an arbitrary column of an arbitrary table

A link column is useful where a key column is not available. For example:

-   a table can contain a link to itself to represent a parent-child relationship
-   links can represent ‘foreign-key’ relationships between splayed tables, which cannot be keyed


## Tables in memory 

In our first example, a link column from a table to itself represents a parent-child relationship.

```q
q)t:([] id:101 102 103 104; v:1.1 2.2 3.3 4.4)
```

To create the column `parent`, we look up the values in the key column using [`?`](../ref/find.md "Find") and then declare the link using `!` – instead of [`$`](../ref/enumerate.md "Enumerate") as we would for a [foreign key enumeration](/q4m3/8_Tables/#852-example-of-simple-foreign-key).

```q
q)update parent:`t!id?101 101 102 102 from `t
`t
q)t
id  v   parent
--------------
101 1.1 0
102 2.2 0
103 3.3 1
104 4.4 1
```

Observe that [`meta`](../ref/meta.md) displays the target table of the link in the `f` column, just as it does for a foreign key.

```q
q)meta t
c     | t f a
------| -----
id    | i
v     | f
parent| i t
```

And, just as with a foreign key, we can use dot notation on the link column to follow the link and access any column in the linked table.

```q
q)select id, parentid:parent.id from t
id  parentid
------------
101 101
102 101
103 102
104 102
```

Next, we create a link between two columns of enumerated symbols, since this occurs frequently in practice. The table `t1` has a column `c1` enumerated over `sym`.

```q
q)sym:()
q)show t1:([] c1:`sym?`c`b`a; c2: 10 20 30)
c1 c2
-----
c  10
b  20
a  30
```

The table `t2` has a column `c3` also enumerated over `sym`, and whose values are drawn from those of column `c1` in `t1`.

```q
q)show t2:([] c3:`sym?`a`b`a`c; c4: 1 2 3 4.)
c3 c4
-----
a  1
b  2
a  3
c  4
```

As before, we use `?` to create a vector of indices and we use `!` in place of `$` to create the link.

```q
q)update t1link:`t1!t1.c1?c3 from `t2
```

Again the `f` column of `meta` indicates the table over which the link is created.

```q
q)meta t2
c     | t f  a
------| ------
c3    | s
c4    | f
t1link| i t1
```

Now we can issue queries that traverse the link using dot notation.

```q
q)select c3, t1link.c2 from t2
c3 c2
-----
a  30
b  20
a  30
c  10
```


## Splayed tables

Suppose table `t1` has already been splayed on disk and mapped into the q session. 
Note that dot notation does not work for splayed tables when creating the link.

```q
q)`:data/db/t1/ set .Q.en[`:data/db/; ([] c1:`c`b`a; c2: 10 20 30)]
`:data/db/t1/

q)\l data/db
q)meta t1
c | t f a
--| -----
c1| s
c2| i
```

Create a link column in table `t2` as it is splayed. 
(Do this on each append if you are creating `t2` incrementally on disk.)

```q
q)temp:.Q.en[`:data/db/; ([] c3:`a`b`a`c; c4: 1. 2. 3. 4.)]
q)`:data/db/t2/ set update t1link:`t1!t1[`c1]?c3 from temp
`:data/db/t2/
```

Remap and check `meta`.

```q
q)\l data/db
q)meta t2
c     | t f  a
------| ------
c3    | s
c4    | f
t1link| i t1
```

Now execute a query across the link:

```q
q)select t1link.c2, c3 from t2
c2 c3
-----
30 a
20 b
30 a
10 c
```

Next suppose `t1` and `t2` have both been splayed.

```q
q)`:data/db/t1/ set .Q.en[`:data/db/; ([] c1:`c`b`a; c2: 10 20 30)]
`:data/db/t1/

q)`:data/db/t2/ set .Q.en[`:data/db/; ([] c3:`a`b`a`c; c4: 1. 2. 3. 4.)]
`:data/db/t2/
```

First create the link when both tables have been mapped into memory.

```q
q)\l data/db
```

Create the link column as before, but update the splayed files of `t2` manually.

```q
q)`:data/db/t2/t1link set `t1!t1[`c1]?t2`c3
`:data/db/t2/t1link

q)`:data/db/t2/.d set (cols t2),`t1link
`:data/db/t2/.d
```

Remap and execute the query as before.

```q
q)\l data/db
q)meta t2
c     | t f  a
------| ------
c3    | s
c4    | f
t1link| i t1

q)select t1link.c2, c3 from t2
c2 c3
-----
30 a
20 b
30 a
10 c
```

Finally, consider two splayed tables that have not been mapped.

```q
q)`:data/db/t1/ set .Q.en[`:data/db/; ([] c1:`c`b`a; c2: 10 20 30)]
`:data/db/t1/

q)`:data/db/t2/ set .Q.en[`:data/db/; ([] c3:`a`b`a`c; c4: 1. 2. 3. 4.)]
`:data/db/t2/
```

Retrieve the column lists manually and proceed as before.

```q
q)`:data/db/t2/t1link set `t1!(get `:data/db/t1/c1)?get `:data/db/t2/c3
`:data/db/t2/t1link

q)colst2:get `:data/db/t2/.d

q)`:data/db/t2/.d set colst2,`t1link
`:data/db/t2/.d
```


## Partitioned tables

Partitioned tables can have link columns provided the links do not span partitions. 
In particular, you cannot link across days for a table partitioned by date.

Creating a link column in a partitioned table is best done as each partition is written.
The process then reduces to that for splayed tables.

Create a link between non-symbol columns in the simple partitioned tables `t1` and `t2`.

First, create the first day’s tables with the link and save them to a partition.

```q
q)t1:([] id:101 102 103; v:1.1 2.2 3.3)

q)t2:([] t1link:`t1!t1[`id]?103 101 101 102; n:10 20 30 40)

q)`:temp/db/2019.01.01/t1/ set t1
`:temp/db/2019.01.01/t1/

q)`:temp/db/2019.01.01/t2/ set t2
`:temp/db/2019.01.01/t2/
```

Do the same for the second day.

```q
q)t1:([] id:104 105; v:4.4 5.5)
q)t2:([] t1link:`t1!t1[`id]?105 104 104; n:50 60 70)

q)`:temp/db/2019.01.02/t1/ set t1
`:temp/db/2019.01.02/t1/
q)`:temp/db/2019.01.02/t2/ set t2
`:temp/db/2019.01.02/t2/
```

Finally, restart kdb+, map the tables and execute a query across the link.

```bash
$ q
KDB+ 4.0 2020.10.02 Copyright (C) 1993-2020 Kx Systems
```
```q
q)\l temp/db

q)select date,n,t1link.v from t2 where date within 2019.01.01 2019.01.02
date       n  v
-----------------
2019.01.01 10 3.3
2019.01.01 20 1.1
2019.01.01 30 1.1
2019.01.01 40 2.2
2019.01.02 50 5.5
2019.01.02 60 4.4
2019.01.02 70 4.4
```

The final example is similar except that it creates a link over enumerated symbol columns.

```q
q)/ day 1
q)t1:([] c1:`c`b`a; c2: 10 20 30)
q)`:temp/db/2019.01.01/t1/ set .Q.en[`:temp/db/; t1]
`:temp/db/2019.01.01/t1/

q)t2:([] c3:`a`b`a`c; c4: 1. 2. 3. 4.)
q)`:temp/db/2019.01.01/t2/ set .Q.en[`:temp/db/; update t1link:`t1!t1[`c1]?c2 from t2]
`:temp/db/2019.01.01/t2/

q)/ day 2
q)t1:([] c1:`d`a; c2: 40 50)
q)`:temp/db/2019.01.02/t1/ set .Q.en[`:temp/db/; t1]
`:temp/db/2019.01.02/t1/

q)t2:([] c3:`d`a`d; c4:5. 6. 7.)
q)`:temp/db/2019.01.02/t2/ set .Q.en[`:temp/db/; update t1link:`t1!t1[`c1]?c2 from t2]
`:temp/db/2019.01.02/t2/

q)/ remap
q)\l temp/db

q)select c3,t1link.c2,c4 from t2 where date within 2019.01.01 2019.01.02
c3 c2 c4
--------
a  30 1
b  20 2
a  30 3
c  10 4
d  40 5
a  50 6
d  40 7
```


---
:fontawesome-regular-map:
[The application of foreign keys and linked columns in kdb+](../wp/foreign-keys.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§8.5 Foreign Keys and Virtual Columns](/q4m3/8_Tables/#85-foreign-keys-and-virtual-columns)