---
title: Count the items of a list or dictionary | Reference | kdb+ and q documentation
description: count and mcount are q keywords count returns the number of items in a list. mcount returns a moving count of the non-null items of a list. 
author: Stephen Taylor
---
# `count`, `mcount`


_Count the items of a list or dictionary_




## `count`

_Number of items_

```txt
count x     count[x]
```

Where `x` is

-   a list, returns the number of its items
-   a dictionary, the number of items in its value
-   anything else, 1

```q
q)count 0                            / atom
1
q)count "zero"                       / vector
4
q)count (2;3 5;"eight")              / mixed list
3
q)count each (2;3 5;"eight")
1 2 5
q)count `a`b`c!2 3 5                 / dictionary
3
q)/ the items of a table are its rows
q)count ([]city:`London`Paris`Berlin; country:`England`France`Germany)
3
q)count each ([]city:`London`Paris`Berlin; country:`England`France`Germany)
2 2 2

q)count ({x+y})
1
q)count (+/)
1
```

Use with [`each`](maps.md#each) to count the number of items at each level of a list or dictionary.

```q
q)RaggedArray:(1 2 3;4 5;6 7 8 9;0)
q)count RaggedArray
4
q)count each RaggedArray
3 2 4 1
q)RaggedDict:`a`b`c!(1 2;3 4 5;"hello")
q)count RaggedDict
3
q)count each RaggedDict
a| 2
b| 3
c| 5
q)\l sp.q
q)count sp
12
```

:fontawesome-solid-graduation-cap:
[Table counts in a partitioned database](../kb/partition.md#table-counts)


## `mcount`

_Moving counts_

```txt
x mcount y     mcount[x;y]
```

Where

-   `x` is a positive int atom
-   `y` is a numeric list

returns the `x`-item moving counts of the non-null items of `y`. The first `x` items of the result are the counts so far, and thereafter the result is the moving count.

```q
q)3 mcount 0 1 2 3 4 5
1 2 3 3 3 3
q)3 mcount 0N 1 2 3 0N 5
0 1 2 3 2 2
```

`mcount` is a uniform function. 


### :fontawesome-solid-sitemap: Implicit iteration

`mcount` applies to [dictionaries and tables](../basics/math.md#dictionaries-and-tables).

```q
q)k:`k xkey update k:`abc`def`ghi from t:flip d:`a`b!(10 21 3;4 5 6)

q)2 mcount d
a| 1 1 1
b| 2 2 2

q)2 mcount t
a b
---
1 1
2 2
2 2

q)2 mcount k
k  | a b
---| ---
abc| 1 1
def| 2 2
ghi| 2 2
```


:fontawesome-solid-graduation-cap:
[Sliding windows](../kb/programming-idioms.md#how-do-i-apply-a-function-to-a-sequence-sliding-window)





----

:fontawesome-solid-book-open:
[Mathematics](../basics/math.md)


