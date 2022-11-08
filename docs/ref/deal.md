---
title: Roll, Deal, Permute | Reference | kdb+ and q documentation
description: Roll, Deal, and Permute are q operators that return ran dom selections, with or without duplicates
author: Stephen Taylor
date: July 2019
keywords: deal, duplicate, generate, permute, rand, random, seed
---
# `?` Roll, Deal, Permute

_Random lists, with or without duplicates_






## Roll and Deal

_Select items randomly, generate random values_

```syntax
    x?y     ?[x;y]          / Roll
neg[x]?y    ?[neg[x];y]     / Deal
```


### Select

Where

-   `x` is an integer atom
-   `y` is a **list**

returns `abs[x]` randomly selected items of `y`.
Where `x` is

-   **positive** items are selected independently (Roll)
-   **negative** and `x>=neg count y`, items are selected from different indexes of `y` (Deal)

```q
q)5?`Arthur`Steve`Dennis
`Arthur`Arthur`Steve`Dennis`Arthur
q)2?("a";0101b;`abc;`the`quick;2012.06m)
`abc
2012.06m
q)-3?`the`quick`brown`fox
`brown`quick`fox
```

??? tip "Duplicate items in `y`"

    If `y` contains duplicate items, so may the result of Deal.

        q)-2?`bye`bye`blackbird
        `bye`bye


### Generate

Where

-   `x` is an int atom
-   `y` is an **atom** &gt; 0

returns a list of `abs[x]` items of the same type as `y`, generated as follows

```txt
right domain (y)     range                            operator
----------------------------------------------------------------
integer >0           til y                            Roll, Deal
0Ng                  GUIDs                            Roll, Deal
float, temporal ≥0   0 to y                           Roll
0i                   ints                             Roll
0                    longs                            Roll, Deal
0b                   01b                              Roll
" "                  .Q.a                             Roll
0x0                  bytes                            Roll
numeric symbol `n    symbols, each of n chars (n≤8)   Roll, Deal
                     from abcdefghijklmnop
```

!!! detail "Where `x` is negative (Deal), `y` must have integer or GUID type"

```q
q)10?5                                        / roll 10 (5-sided dice)
4 2 1 1 3 2 0 0 2 2
q)-5?20                                       / deal 5
13 11 8 12 19
q)-10?10                                      / first 10 ints in random order
9 3 5 7 2 0 6 1 4 8
q)(asc -10?10)~asc -10?10
1b

q)-1?0Ng                                      / deal 1 GUID
,fd2db048-decb-0008-0176-01714e5eeced
q)count distinct -1000?0Ng                    / deal 1000 GUIDs
1000

q)5?4.5                                       / roll floats
3.13239 1.699364 2.898484 1.334554 3.085937

q)4?2012.09m                                  / roll months
2006.02 2007.07 2007.07 2008.06m

q)30?" "
"tusrgoufcetphltnkegcflrunpornt"

q)16?0x0                                      / roll 16 bytes
0x8c6b8b64681560840a3e178401251b68

q)20?0b                                       / roll booleans
00000110010101000100b

q)10?`3                                       / roll short symbols
`bon`dec`nei`jem`pgm`kei`lpn`bjh`flj`npo
q)rand `6
`nemoad
```

!!! tip "Roll and Deal return list results"

    For an atom result, instead of `first 1?x`, use [`rand`](rand.md).


### Deal of GUID atom

Deal of GUID uses a mix of process ID, current time and IP address to generate the GUID, and successive calls may not allow enough time for the current time reading to change.

```q
q)count distinct {-1?0ng}each til 10  / Deal one GUID ten times
5
```

The range of GUIDs is large enough that Roll and Deal often return the same result.

```q
q)count distinct 1000000000?0Ng  / Roll a billion GUIDs
1000000000
```

!!! tip "For a set of distinct GUIDs, use Deal to generate them in one operation"


## Permute

```syntax
0N?x
```

Where `x` is

-   a **non-negative int atom**, returns the items of `til x` in random order
-   a **list**, returns the items of `x` in random order

(Since V3.3.)

```q
q)0N?10                         / permute til 10
8 2 4 1 6 0 5 3 7 9
q)0N?5 4 2                      / permute items
4 5 2
q)0N?"abc"                      / permute items
"bac"
q)0N?("the";1 2 4;`ibm`goog)    / permute items
`ibm`goog
1 2 4
"the"
```


## Seed

Deal, Roll, Permute and [`rand`](rand.md) use a constant seed on kdb+ startup: scripts using them can be repeated with the same results. You can see and set the value of the seed with system command [`\S`](../basics/syscmds.md#s-random-seed).)

!!! tip "To use GUIDs as identifiers, use Deal, not Roll"

```q
$ q
..
q)1?0Ng                                    / roll 1 GUID
,8c6b8b64-6815-6084-0a3e-178401251b68
q)\\
$ q
..
q)1?0Ng                                    / roll 1 GUID
,8c6b8b64-6815-6084-0a3e-178401251b68
q)\\
$ q
..
q)-1?0Ng                                   / deal 1 GUID
,2afe0040-2a1b-bfce-ef3e-7160260cf992
q)\\
$ q
..
q)-1?0Ng                                   / deal 1 GUID
,753a8739-aa6b-3cb4-2e31-0fcdf20fd2f0
```

Roll uses the current seed (`\S 0N`). Deal uses a seed based on process properties and the current time. This means `-10?0Ng` is different from `{first -1?0Ng}each til 10`.


## Errors

error  | cause
-------|-----------------------------
length | `neg x` exceeds `count y`
type   | `x` is negative (Roll only)

----

:fontawesome-solid-book:
[`rand`](rand.md)
<br>
:fontawesome-solid-book-open:
[system command `\S`](../basics/syscmds.md#s-random-seed)
<br>
:fontawesome-solid-book-open:
[command-line option `-S`](../basics/cmdline.md#-s-random-seed)
