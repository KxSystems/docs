---
title: key
keywords: dictionary, directory, enumeration, file, foreign key, handle, kdb+, keyed table, q, symbol, til, vector
---

# `key`



Syntax `key x`, `key[x]`

Where `x` is a

## Dictionary

(or a handle to one), returns its entries as a symbol vector.

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


## Keyed table

(or a handle to one), returns its key column/s.

```q
q)K:([s:`q`w`e]g:1 2 3;h:4 5 6)
q)key K
s
-
q
w
e
```


## Directory handle

returns a list of objects in the directory. 

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


## File handle

returns the descriptor if the file exists, otherwise an empty list.

```q
q)key`:c:/q/sp.q
`:c:/q/sp.q
q)key`:c:/q/notfound.q
()
```

Note that an empty directory returns an empty symbol vector, while a non-existent directory returns an empty general list.

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


## Symbol atom

that is not a file or directory descriptor, nor the name of a dictionary or table, returns the original symbol if a variable of that name exists, otherwise an empty list. The name is interpreted relative to the current context if not fully qualified.

```q
q)()~key`a.       /now you don't see it
1b
q)a:1
q)key`a.          /now you see it
`a
q)\d .foo
q.foo)key`a.      /now you don't
q.foo)a:1 2!3 4
q.foo)key`a       /this one has keys
1 2
q.foo)key`.foo.a. /fully qualified name
1 2
q.foo)key`..a.    /fully qualified name
`..a
q.foo)\d .
q)key`a
`a
q)key`.foo.a
1 2
q)key`..a
`..a
```


## Foreign-key column

returns the name of the foreign-key table.

```q
q)f:([f:1 2 3]v:`a`b`c)
q)x:`f$3 2
q)key x
`f
```


## Vector

returns the name of its [type](../basics/datatype.md) as a symbol.

```q
q)key each ("abc";101b;1 2 3h;1 2 3;1 2 3j;1 2 3f)
`char`boolean`short`int`long`float
q)key 0#5
`long
```


## Enumerated list

returns the name of the enumerating list.

```q
q)ids:`a`b`c
q)x:`ids$`a`c
q)key x
`ids
```


## Positive integer

returns the same result as [til](arith-integer/#til).

```q
q)key 10
0 1 2 3 4 5 6 7 8 9
```


<i class="far fa-hand-point-right"></i>
Basics: [Metadata](../basics/metadata.md)