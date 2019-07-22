---
title: Enum Extend 
description: Enum Extend is a q operator that extends an enumeration.
author: Stephen Taylor
keywords: enumeration, enum extend, extend, kdb+, list, q, query
---
# `?` Enum Extend




_Extend an enumeration_

Syntax: `x?y`, `?[x;y]` 

Where 

-   `y` is a list
-   `x` is a handle to a:


## Variable

fills in any missing items in `x`, returns `y` as an enumeration of the variable named in `x` with filling in missing items in it. (Unlike [Enumerate](enumerate.md).)

```q
q)foo:`a`b
q)`foo?`a`b`c`b`a`b`c`c`c`c`c`c`c
`foo$`a`b`c`b`a`b`c`c`c`c`c`c`c
q)foo
`a`b`c
```

Note that `?` preserves the attribute/s of the right-argument but `$` does not.

```q
q)`foo?`g#y
`g#`foo$`g#`a`b`c`b`a`b`c`c`c`c`c`c`c
q)`foo$`g#y
`foo$`a`b`c`b`a`b`c`c`c`c`c`c`c
```


## Filepath

fills in any missing items in file `x`, loads it into the session as a variable of the same name, and returns `y` as an enumeration of it.

```q
q)bar:`c`d  /about to be overwritten
q)`:bar?`a`b`c`b`a`b`c`c`c`c`c`c`c
`bar$`a`b`c`b`a`b`c`c`c`c`c`c`c
q)\ls -l bar
"-rw-r--r--  1 sjt  staff  16  3 Mar 12:53 bar"
q)bar
`a`b`c
```


Enum Extend is a uniform function. 

<i class="far fa-hand-point-right"></i> 
[Enumerate](enumerate.md),
[Enumeration](enumeration.md)  
Basics: [Enumerations](../basics/enumerations.md),
[File system](../basics/files.md)  
_Q for Mortals:_ [§7.5 Enumerations](/q4m3/7_Transforming_Data/#75-enumerations)  
[`?` query](overloads.md#query) 


