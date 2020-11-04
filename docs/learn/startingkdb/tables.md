---
title: Tables – Starting kdb+ – Learn – kdb+ and q documentation
description: How to work with tables in q
keywords: kdb+, q, start, table, tutorial
---
# Tables



A basic understanding of the internal structure of tables is needed to work with q. The structure is actually quite simple, but very different from conventional databases.

This section gives a quick overview, followed by an explanation of the sp.q script, and then a typical table for stock data. After completing this, you should read [_Q for Mortals_ 14. Introduction to Kdb+](/q4m3/14_Introduction_to_Kdb+/), which has a detailed comparison of q and conventional RDBMS.

Tables are created out of lists. A table with no key columns is essentially a list of column names associated with a list of corresponding column values, each of which is a list. A table with key columns is built internally from a pair of tables – the key columns associated with the non-key columns.

Tables are created in memory, and then written to disk if required. When written to disk, smaller tables can be stored in a single file, while larger tables are usually partitioned in some way. The partitioning can be seen when viewing the file directories, but the table is treated as a single object within a kdb+ process.


## Creating tables

There are two ways of creating a table. One way explicitly associates lists of column names and data; the other uses a q expression that specifies the column names and initial values. The second method also permits each column’s datatype to be given, and so is particularly useful when a table is created with no data.

-   create table by association:
    <pre><code class="language-q">
    q)tab:flip \`items\`sales\`prices!(\`nut\`bolt\`cam\`cog;6 8 0 3;10 20 15 20)
    q)tab
    items sales prices
    ------------------
    nut   6     10
    bolt  8     20
    cam   0     15
    cog   3     20
    </code></pre>

-   create table by specifying column names and initial values:
    <pre><code class="language-q">
    q)tab2:([]items:\`nut\`bolt\`cam\`cog;sales:6 8 0 3;prices:10 20 15 20)
    q)tab~tab2              / tab and tab2 are identical
    1b
    </code></pre>

The form for the second method, for a table with `j` primary keys and `n` columns in total, is:

`t:([c`<sub>`1`</sub>`:v`<sub>`1`</sub>`;...;c`<sub>`j`</sub>`:v`<sub>`j`</sub>`]c`<sub>`j+1`</sub>`:v`<sub>`j+1`</sub>`;...;c`<sub>`n`</sub>`:v`<sub>`n`</sub>`)`

Here table `t` is defined with column names c<sub>i</sub>, and corresponding values v<sub>i</sub>. The square brackets are for primary keys, and are required even if there are no primary keys.


## 4.3 Suppliers and parts

The script `sp.q` defines [C.J. Date’s Suppliers and Parts database](https://en.wikipedia.org/wiki/Suppliers_and_Parts_database). You can view this script in an editor to see the definitions. Load the script.

```q
q)\l sp.q
```


### Table `s`

Table `s` has a primary key column, also called `s`, given as a list of symbols which should be unique. In this example, the name `s` is used both for the table and the primary key column, but this is not required.

The remaining columns are of type symbol, integer, symbol.

```q
s:([s:`s1`s2`s3`s4`s5]
 name:`smith`jones`blake`clark`adams;
 status:20 10 30 20 30;
 city:`london`paris`paris`london`athens)
```

Display in q.

```q
q)s
s | name  status city
--| -------------------
s1| smith 20     london
s2| jones 10     paris
s3| blake 30     paris
s4| clark 20     london
s5| adams 30     athens
```

Note that the column types are set from the data given. If this were first created as an empty table, say table `t`, then the column types could be defined explicitly as follows:

```q
q)t:([s:`$()]name:`$();status:"i"$();city:`$())
```

Insert a row.

```q
q)`t insert (`s1;`smith;20;`london)
,0
q)t
s | name status city
--| -------------------
s1| smith 20 london
```


### Table `p`

Table `p` is created much like table `s`. As before, the table name and primary key name are both the same:

```q
p:([p:`p1`p2`p3`p4`p5`p6]
 name:`nut`bolt`screw`screw`cam`cog;
 color:`red`green`blue`red`blue`red;
 weight:12 17 17 14 12 19;
 city:`london`paris`rome`london`paris`london)
```

Display in q:

```q
q)p
p | name  color weight city
--| -------------------------
p1| nut   red   12     london
p2| bolt  green 17     paris
p3| screw blue  17     rome
p4| screw red   14     london
p5| cam   blue  12     paris
p6| cog   red   19     london
```


### Table `sp`

Table `sp` is defined with no primary key. Columns `s` and `p` refer to tables `s` and `p` respectively as foreign keys. The syntax for specifying another table’s primary key as a foreign key is:

```q
`tablename$data
```

The definition of `sp` is:

```q
sp:([]
 s:`s$`s1`s1`s1`s1`s4`s1`s2`s2`s3`s4`s4`s1;
 p:`p$`p1`p2`p3`p4`p5`p6`p1`p2`p2`p2`p4`p5;
 qty:300 200 400 200 100 100 300 400 200 200 300 400)
```

Display in q.

```q
q)sp
s  p  qty
---------
s1 p1 300
s1 p2 200
s1 p3 400
s1 p4 200
s4 p5 100
...
```


## Stock data

The following is a typical layout populated with random data. Load the `trades.q` script.

```q
q)\l start/trades.q
```

:fontawesome-brands-github: 
[KxSystems/cookbook/start/trades.q](https://github.com/KxSystems/cookbook/blob/master/start/trades.q) 

A trade table might include: date, time, symbol, price, size, condition code.

```q
q)trades:([]date:`date$();time:`time$();sym:`symbol$();
    price:`real$();size:`int$(); cond:`char$())

q)`trades insert (2013.07.01;10:03:54.347;`IBM;20.83e;40000;"N")
q)`trades insert (2013.07.01;10:04:05.827;`MSFT;88.75e;2000;"B")
q)trades
date       time         sym  price size  cond
---------------------------------------------
2013.07.01 10:03:54.347 IBM  20.83 40000 N
2013.07.01 10:04:05.827 MSFT 88.75 2000  B
```

The `?` operator will generate random data. 

```q
q)syms:`IBM`MSFT`UPS`BAC`AAPL
q)tpd:100              / trades per day
q)day:5                / number of days
q)cnt:count syms       / number of syms
q)len:tpd*cnt*day      / total number of trades
q)date:2013.07.01+len?day
q)time:"t"$raze (cnt*day)#enlist 09:30:00+15*til tpd
q)time+:len?1000
q)sym:len?syms
q)price:len?100e
q)size:100*len?1000
q)cond:len?" ABCDENZ"

q)`trades:0#trades      / empty trades table
q)`trades insert (date;time;sym;price;size;cond)
0 1 2 3 4 5 6 7 8 9 10 11 12 13 14 15 16 17 18 19 20 21 22 23 24
..
q)trades:`date`time xasc trades  / sort on time within date
q)5#trades             / actual values are random
date       time         sym  price    size  cond
------------------------------------------------
2013.07.01 09:30:00.037 AAPL 14.68571 18800 Z
2013.07.01 09:30:00.431 AAPL 88.91143 87600 B
2013.07.01 09:30:00.631 IBM  46.61601 35200 N
2013.07.01 09:30:15.087 UPS  42.53144 36500 A
2013.07.01 09:30:15.142 AAPL 78.99029 42300 B
```

