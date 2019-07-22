---
title: enlist
description: enlist is a q keyword that makes a 1-list from its arguments.
author: Stephen taylor
keywords: kdb+,list, q
---
# `enlist`

_Make a list._




Syntax: `enlist x`, `enlist[x]`

An atom is not a one-item list. `enlist` and `first` convert between the two.

```q
q)a:10
q)b:enlist a
q)c:enlist b
q)type each (a;b;c)
-7 7 0h
q)a~b
0b
q)a~first b
1b
q)b~c
0b
q)b~first c
1b
```

With multiple arguments returns a single list.

```q
q)show a:enlist[til 5;`ibm`goog;"hello"]
0 1 2 3 4
`ibm`goog
"hello"
q)count a
3
```

Where `x` is a dictionary, the result is the corresponding table.

```q
q)enlist `a`b`c!(1;2 3; 4)
a b   c
-------
1 2 3 4
```

!!! tip "Atoms to lists"
    If you need to ensure, say, all items in a list are themselves lists and not atoms, use `(),`, which leaves lists unchanged. 

    For example, `{(),x} each foo` converts any atoms in list `foo` into singleton lists.


