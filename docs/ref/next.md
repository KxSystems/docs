---
title: next, prev, xprev – immediate or near neighbours of the items of a list | Reference | kdb+ and q documentation
description: next, prev, and xprev are q keywords that return the immediate or near neighbours of the items of a list.
author: Stephen Taylor
---
# `next`, `prev`, `xprev`

_Immediate or near neighbours_




## `next`

_Next item/s in a list_

```txt
next x      next[x]
```

Where `x` is a list, for each item in `x`, returns the next item. 

For the last item, it returns a null if the list is a vector, otherwise an empty list `()`.

```q
q)next 2 3 5 7 11
3 5 7 11 0N
q)next (1 2;"abc";`ibm)
"abc"
`ibm
`int$()
```

Duration of a quote:

```q
q)update (next time)-time by sym from quote
```

`next` is a uniform function.



## `prev`

_Immediately preceding item/s in a list_

```txt
prev x     prev[x]
```

Where `x` is a list, for each item, returns the previous item. 

For the first item, it returns a null if the list is vector, otherwise an empty list `()`.

```q
q)prev 2 3 5 7 11
0N 2 3 5 7
q)prev (1 2;"abc";`ibm)
`int$()
1 2
"abc"
```

Shift the times in a table:

```q
q)update time:prev time by sym from t
```

`prev` is a uniform function.


## `xprev`

_Nearby items in a list_

```txt
x xprev y     xprev[x;y]
```

Where `x` is a long atom and `y` is a list, returns for each item of `y` the item `x` indices before it. 

The first `x` items of the result are null, empty or blank as appropriate.

!!! tip "There is no `xnext` function."

    Fortunately `xprev` with a negative number on the left can achieve this.

```q
q)2 xprev 2 7 5 3 11
0N 0N 2 7 5
q)-2 xprev 2 7 5 3 11
5 3 11 0N 0N
q)1 xprev "abcde"
" abcd"
```


`xprev` is a right-uniform function.

----

:fontawesome-solid-book:
[Each Prior](../ref/maps.md#each-prior)
<br>
:fontawesome-solid-book-open:
[Selection](../basics/by-topic.md#selection)

