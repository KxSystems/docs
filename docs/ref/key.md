---
title: key keyword | Reference | kdb+ and q documentation
description: Keys of a dictionary; key columns of a keyed table; files in a folder; whether a file or name exists; target of a foreign key, type of a vector; or the enumerator of a list.
author: Stephen Taylor
keywords: dictionary, directory, enumeration, file, foreign key, handle, kdb+, keyed table, q, symbol, til, vector
---

<div markdown="1" style="float: right; max-width: 300px">
[![Swiss army knife](../img/swiss-army-knife.jpg)](https://www.victorinox.com/ "victorinox.com")
</div>

# `key`




```txt
key x     key[x]
```



## Key of a dictionary

Where `x` is a dictionary (or the name of one), returns its key.

```q
q)D:`q`w`e!(1 2;3 4;5 6)
q)key D
`q`w`e
q)key `D
`q`w`e
```

A namespace is a dictionary.

```q
q)key `.
`D`daily`depth`mas`sym`date`nbbo...
q)key `.q
``neg`not`null`string`reciprocal`floor`ceiling`signum`mod`xbar`xlog`and`or`ea..
```

So is the default namespace.

```q
q)key `           /list namespaces in the root
`q`Q`h`o`util`rx
```


## Keys of a keyed table

Where `x` is a keyed table (or the name of one), returns its key column/s.

```q
q)K:([s:`q`w`e]g:1 2 3;h:4 5 6)
q)key K
s
-
q
w
e
```


## Files in a folder

Where `x` is a directory handle returns a list of objects in the directory, sorted ascending.

```q
q)key`:c:/q
`c`profile.q`sp.q`trade.q`w32
```

To select particular files, use [`like`](like.md)

```q
q)f:key`:c:/q
q)f where f like "*.q"
`profile.q`sp.q`trade.q
```


## Whether a file exists

Where `x` is a file handle, returns the descriptor if the file exists, otherwise an empty list.

```q
q)key`:c:/q/sp.q
`:c:/q/sp.q
q)key`:c:/q/notfound.q
()
```

Note that 

-   an empty directory returns an empty symbol vector
-   a non-existent directory returns an empty general list

```q
q)\ls foo
ls: cannot access foo: No such file or directory
'os
q)()~key`:foo
1b
q)\mkdir foo
q)key`:foo
`symbol$()
```


## Whether a name is defined

Where `x` is a symbol atom that is not a file or directory descriptor, nor the name of a dictionary or table, returns the original symbol if a variable of that name exists, otherwise an empty list. The name is interpreted relative to the current context if not fully qualified.

```q
q)()~key`a        /now you don't see it
1b
q)a:1
q)key`a           /now you see it
`a
q)\d .foo
q.foo)key`a       /now you don't
q.foo)a:1 2!3 4
q.foo)key`a       /this one has keys
1 2
q.foo)key`.foo.a  /fully qualified name
1 2
q.foo)key`..a     /fully qualified name
`..a
q.foo)\d .
q)key`a
`a
q)key`.foo.a
1 2
q)key`..a
`..a
```


## Target of a foreign key

Where `x` is a foreign-key column returns the name of the foreign-key table.

```q
q)f:([f:1 2 3]v:`a`b`c)
q)x:`f$3 2
q)key x
`f
```


## Type of a vector

Where `x` is a vector returns the name of its [type](../basics/datatypes.md) as a symbol.

```q
q)key each ("abc";101b;1 2 3h;1 2 3;1 2 3;1 2 3f)
`char`boolean`short`int`long`float
q)key 0#5
`long
```


## Enumerator of a list

Where `x` is an enumerated list returns the name of the enumerating list.

```q
q)ids:`a`b`c
q)x:`ids$`a`c
q)key x
`ids
```


## `til`

Where `x` is a non-negative integer returns the same result as [`til`](til.md).

```q
q)key 10
0 1 2 3 4 5 6 7 8 9
```

----
:fontawesome-solid-book-open:
[Metadata](../basics/metadata.md)