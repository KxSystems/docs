---
title: Enum Extend | Reference | kdb+ and q documentation
description: Enum Extend is a q operator that extends an enumeration.
author: Stephen Taylor
---
# `?` Enum Extend




_Extend an enumeration_


```txt
x?y    ?[x;y]
```

Where 

-   `y` is a list
-   `x` is a handle to a:


## Variable

fills in any missing items in `x`, then returns `y` as an enumeration of it. (Unlike [Enumerate](enumerate.md).)

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

In detail: 

```q
`:enumname ?`a`b`c
```

executes the following steps:

1.  opens the file `enumname` and locks it (see note)
1.  reads contents of the file `enumname`, interning each symbol, and binds the resulting symbol vector to `enumname`
1.  enumerates according to `` `enumname ?`a`b`c``
1.  appends any new symbols to the file `` `:enumname``
1.  closes file `enumname`, which automatically unlocks it

!!! note "Locking the file"

    The file is locked at a **process** level for **writing** during `.Q.en` only. 
    Avoid reading from any file which may be being written to. 

    The system call used is <https://linux.die.net/man/3/lockf>.

One can verify that the file system supports the write lock by stracing the following q script `locktest.q` on the filesystem which you are sharing between those machines:

```q
`:dummysym?`a`b
\\
```

```bash
$ strace q locktest.q 2>&1 | grep F_SETLKW
fcntl(1024, F_SETLKW, {type=F_WRLCK, whence=SEEK_CUR, start=0, len=0}) = 0
```

If that return value is not 0, then the lock failed and may not be supported by the chosen filesystem.
Kdb+ does not report an error if that lock call fails.

Enum Extend is a uniform function. 

----
:fontawesome-solid-book: 
[Enumerate](enumerate.md),
[Enumeration](enumeration.md),
[`.Q.en` (enumerate varchar cols)](dotq.md#qen-enumerate-varchar-cols),
[`?` query overloads](overloads.md#query)
<br>
:fontawesome-solid-book-open:
[Enumerations](../basics/enumerations.md),
[File system](../basics/files.md)
<br>
:fontawesome-solid-graduation-cap:
[Enumerating varchar columns in a table](../kb/splayed-tables.md#enumerating-varchar-columns-in-a-table)
<br>
:fontawesome-solid-street-view: 
_Q for Mortals_
[§7.5 Enumerations](/q4m3/7_Transforming_Data/#75-enumerations)  

