---
title: where | Reference | kdb+ and q documentation
description: where is a q keyword that returns copies of indexes of a list or keys of a dictionary.
author: Stephen Taylor
keywords: kdb+, q, selection, where
---
# `where`





_Copies of indexes of a list or keys of a dictionary_

Syntax: `where x`, `where[x]`

Where `x` is a:


## Vector of non-negative integers

returns a vector containing, for each item of `x`, that number of copies of its index. 

```q
q)where 2 3 0 1
0 0 1 1 1 3
q)raze x #' til count x:2 3 0 1
0 0 1 1 1 3
```

Where `x` is boolean, the result is the indices of the 1s. Thus `where` is often used after a logical test:

```q
q)where 0 1 1 0 1
1 2 4
q)x:1 5 6 8 11 17 20 21
q)where 0 = x mod 2        / indices of even numbers
2 3 6
q)x where 0 = x mod 2      / select even numbers from list
6 8 20
```


## Dictionary whose values are non-negative integers

returns a list of keys repeated as many times as the corresponding value. (If a list is viewed as a mapping from indices to entries, than the definition for the integer list above is a special case.)

```q
q)d:`amr`ibm`msft!2 3 1
q)where d
`amr`amr`ibm`ibm`ibm`msft
q)where 2 3 0 1               / usual operation on integer list
0 0 1 1 1 3
q)where 0 1 2 3 ! 2 3 0 1     / same on dictionary with indices as keys
0 0 1 1 1 3
```



:fontawesome-solid-book-open:
[`where` in q-SQL](../basics/qsql.md), 
[Selection](../basics/selection.md)


