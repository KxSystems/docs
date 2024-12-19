---
title: Take selects leading or trailing items | Reference | kdb+ and q documentation
description: Take is a q operator that selects leading or trailing items from a list or dictionary, named entries from a dictionary, or named columns from a table.
author: Stephen Taylor
---
# `#` Take

_Select leading or trailing items from a list or dictionary, named entries from a dictionary, or named columns from a table_


```syntax
x#y     #[x;y]
```

Where 

-   `x` is an int atom or vector, or a table
-   `y` is an atom, list, dictionary, table, or keyed table

returns `y` as a list, dictionary or table described or selected by `x`. 

`#` is a [multithreaded primitive](../kb/mt-primitives.md).


## Atom or list

Where `x` is an **int atom**, and `y` is an **atom or list**, returns a list of length `x` filled from `y`, starting at the front if `x` is positive and the end if negative.

```q 
q)5#0 1 2 3 4 5 6 7 8      /take the first 5 items
0 1 2 3 4
q)-5#0 1 2 3 4 5 6 7 8     /take the last 5 items
4 5 6 7 8
```

If `x>count y`, `y` is treated as circular.

```q 
q)5#`Arthur`Steve`Dennis
`Arthur`Steve`Dennis`Arthur`Steve
q)-5#`Arthur`Steve`Dennis
`Steve`Dennis`Arthur`Steve`Dennis
q)3#9
9 9 9
q)2#`a
`a`a
```

If `x` is 0, an empty list is returned.

```q 
q)trade:([]time:();sym:();price:();size:())  /columns can hold anything
q)trade
+`time`sym`price`size!(();();();())
q)/idiomatic way to initialize columns to appropriate types
q)trade:([]time:0#0Nt;sym:0#`;price:0#0n;size:0#0N)
q)trade
+`time`sym`price`size!(`time$();`symbol$();`float$();`int$())
```

Where `x` is a vector, returns a matrix or higher-dimensional array; `count x` gives the number of dimensions.

```q 
q)2 5#"!"
"!!!!!"
"!!!!!"
q)2 3#til 6
(0 1 2;3 4 5)
```

A 2×4 matrix taken from the list `` `Arthur`Steve`Dennis``

```q 
q)2 4#`Arthur`Steve`Dennis
Arthur Steve  Dennis Arthur
Steve  Dennis Arthur Steve
```

Higher dimensions are not always easy to see.

```q 
q)2 3 4#"a"
"aaaa" "aaaa" "aaaa"
"aaaa" "aaaa" "aaaa"
q)show five3d:2 3 4#til 5
0 1 2 3 4 0 1 2 3 4 0 1
2 3 4 0 1 2 3 4 0 1 2 3
q)count each five3d
3 3
q)first five3d
0 1 2 3
4 0 1 2
3 4 0 1
```

A null in `x` will cause that dimension to be maximal.

```q 
q)0N 3#til 10
0 1 2
3 4 5
6 7 8
,9
```


### Changes since V3.3

From V3.4, if `x` is a list of length 1, the result has a single dimension. 

```q
q)enlist[2]#til 10
0 1
```

From V3.4, `x` can have length greater than 2 – but may not contain nulls.

```q
q)(2 2 3#til 5)~((0 1 2;3 4 0);(1 2 3;4 0 1))
1b
q)(enlist("";""))~1 2 0#"a"
1b
q)all`domain=@[;1 2;{`$x}]each(#)@'(1 0 2;2 3 0N;0N 2 1;-1 2 3)
1b
```

The effect of nulls in `x` changed in V3.3.
    
Prior to V3.3:

```q
q)3 0N # til 10
(0 1 2 3;4 5 6 7;8 9)
q)(10 0N)#(),10
10
q)4 0N#til 9
0 1 2
3 4 5
6 7 8
```

From V3.3:

```q
q)3 0N#til 10
0 1 2
3 4 5
6 7 8 9
q)2 0N#0#0



q)(10 0N)#(),10
`long$()
`long$()
`long$()
`long$()
`long$()
`long$()
`long$()
`long$()
`long$()
,10
q)4 0N#til 9
0 1
2 3
4 5
6 7 8
```


## Dictionary

### Leading/Trailing

Where

-   `x` is an **int atom**
-   `y` is a **dictionary**

returns `x` entries from `y`.

```q 
q)d:`a`b`c!1 2 3
q)2#d
a| 1
b| 2
q)-2#d
b| 2
c| 3
```

### Keys

Where

-   `x` is a **symbol vector**
-   `y` is a **dictionary**

returns from `y` entries for `x`.

```q 
q)d:`a`b`c!1 2 3
q)`a`b#d
a| 1
b| 2
q)enlist[`a]#d
a| 1
```


## Table

### Rows

Where

-   `x` is an **int atom** 
-   `y` is a **table**

returns `x` rows from `y`.

```q 
q)t:([] name:`Dent`Beeblebrox`Prefect; iq:98 42 126; age:20 22 25)
q)2#t
name       iq age
-----------------
Dent       98 20
Beeblebrox 42 22
q)-2#t
name       iq  age
------------------
Beeblebrox 42  22
Prefect    126 25
```

!!! note "Not currently supported for partitioned tables. [`.Q.ind`](dotq.md#ind-partitioned-index) can be used as an alternative to access indices."

### Columns

Where

-   `x` is a **symbol vector**
-   `y` is a **table**

returns column/s `x` from `y`.

```q 
t:([] name:`Dent`Beeblebrox`Prefect; iq:98 42 126; age:20 22 25)
q)`name`age#t
name       age
--------------
Dent       20
Beeblebrox 22
Prefect    25
```

!!! note "Not currently supported for partitioned tables."


## Keyed table

Where 

-   `x` is a **table**
-   `y` is a **keyed table**
-   columns of `x` are keys of `y`

returns matching rows, together with the respective keys. This is similar to retrieving multiple records through the square brackets syntax, except Take also returns the keys. 

```q 
q)([]s:`s1`s2)#s
s | name  status city  
--| -------------------
s1| smith 20     london
s2| jones 10     paris 
```


----
:fontawesome-solid-street-view:
_Q for Mortals_
[§8.4.5 Retrieving Multiple Records](/q4m3/8_Tables/#845-retrieving-multiple-records)



