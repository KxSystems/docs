---
title: Functions withdrawn from q
description: The functions listed here have been withdrawn from q, and are listed here solely for the interpretation of old scripts. 
author: Stephen Taylor
keywords: kdb+, q, withdrawn
---
# Functions withdrawn from q




The functions listed here have been withdrawn from q, and are listed here solely for the interpretation of old scripts. 


## `list`

The `list` function created a list from its arguments. Use [`enlist`](../ref/enlist.md) instead.
```q
q)list[1;`a`b;"abcd"]
(1;`a`b;"abcd")
```



## `plist`

The `plist` function was a form of [enlist](../ref/enlist.md) (which creates a list from its arguments). It was removed completely in V3.0.
```q
q)plist[1;`a`b;"abcd"]
(1;`a`b;"abcd")
```


## `txf`

Syntax: `txf[table;indices;columns]`

The `txf` function did indexed lookup on a keyed table. The function was deprecated since V2.4, and removed completely in V3.0, in favor of straightforward indexing as shown below.

Here, `table` is a keyed table. The `indices` are the key values to lookup. The `columns` are those to be read.
```q
q)s:`a`s`d`f
q)c:2 3 5 7
q)p:1 2 3 4
q)r:10 20 30 40
q)t:([s;c];p;r)
q)txf[t;(s;c);`p`r]
1 10
2 20
3 30
4 40
q)t[([]s;c);`p`r]             / equivalent without txf
1 10
2 20
3 30
4 40
q)
q)txf[t;(`d`a;5 2);`p`r]
3 30
1 10
q)t[([]s:`d`a;c:5 2);`p`r]    / equivalent without txf
3 30
1 10
```
`txf` was used in select-expressions to join tables with no foreign key relationship.
```q
q)q:([]s:`d`f`s;c:5 7 3;k:"DFS")
q)select s,k,txf[t;(s;c);`p] from q
s k x
-----
d D 3
f F 4
s S 2
q)select s,k,t[([]s;c);`p] from q    / equivalent without txf
s k x
-----
d D 3
f F 4
s S 2
```


