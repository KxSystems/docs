---
title: Roll, Deal, Permute
description: Roll, Deal, and Permute are q operators that return ran dom selections, with or without duplicates
author: Stephen Taylor
keywords: deal, duplicate, kdb+, permute, q, rand, random, seed
---
# `?` Roll, Deal, Permute

_Random selections, with or without duplicates_






## Roll

_A list of random selections._

Syntax: `x ? y`, `?[x;y]`

Where `x` is a **positive int atom** and `y` is a:


### Numeric atom
   
returns `x` values of the same type as `y` randomly chosen from the range 0 to `y`.

```q
q)20?5
4 3 3 4 1 2 2 0 1 3 1 4 0 2 2 1 4 4 2 4
q)5?4.5
3.13239 1.699364 2.898484 1.334554 3.085937 
q)4?2012.09m
2006.02 2007.07 2007.07 2008.06m
```


#### Short symbols

There is a shorthand special case for generating short symbols (length between 1 and 8) using the first 16 lower-case letters of the alphabet.

```q
q)10?`3
`bon`dec`nei`jem`pgm`kei`lpn`bjh`flj`npo
q)rand `6
`nemoad
```


### List

returns `x` items randomly chosen from `y`. 

```q
q)10?`Arthur`Steve`Dennis
`Arthur`Arthur`Steve`Dennis`Arthur`Arthur`Arthur`Dennis`Arthur`Dennis
q)2?("a";0101b;`abc;`the`quick;2012.06m)
`abc
2012.06m
```


## Deal

_Random selections without repetition_

Syntax: `x ? y`, `?[x;y]`

Where `x` is a **negative int atom**, and `y` is a:


### Integers

Where `y` is an **integer atom** such that `x<=y`, returns `x` integers chosen randomly and without repetition from the range `til y`.

```q
q)-20?100  /20 different integers from 0-99
2 40 66 52 86 45 94 84 38 26 33 23 78 49 51 59 44 37 48 53
q)-20?20   /first 20 integers in random order
10 19 2 6 17 16 14 8 3 12 13 1 5 11 4 9 18 15 0 7
q)(asc -20?20)~asc -20?20
1b
```


### GUIDs

Where `y` is the **null GUID**, returns a list of distinct GUIDs.

```q
q)-1?0Ng 
,fd2db048-decb-0008-0176-01714e5eeced
q)count distinct -1000?0Ng
1000
```

!!! warning 

    Deal of GUID uses a mix of process ID, current time and IP address to generate the GUID, and successive calls may not allow enough time for the current time reading to change. 

```q
q)count distinct {-1?0ng}each til 10
5
```


### Selection from a list

Where `y` is a **list of unique values** and `count[y]>=neg x`, returns `x` items randomly chosen without repetition from `y`.

```q
q)-3?`Arthur`Steve`Dennis
`Steve`Arthur`Dennis
q)-4?`Arthur`Steve`Dennis
'length
```


## Permute

Syntax: `0N?x`

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

!!! warning "To use GUIDs as identifiers, ensure `x` is negative." 

    Otherwise, you will get duplicates, given the same seed:

    <pre><code class="language-q">
    $ q
    q)1?0Ng
    ,8c6b8b64-6815-6084-0a3e-178401251b68
    q)\\
    $ q
    q)1?0Ng
    ,8c6b8b64-6815-6084-0a3e-178401251b68
    </code></pre>



## Errors

error  | cause
-------|-----------------------------
length | `neg x` exceeds `count y` 


<i class="far fa-hand-point-right"></i>
[`rand`](rand.md)