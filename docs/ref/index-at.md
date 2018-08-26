# `@` Index At



_Select items from a list._

Syntax: `L @ v`, `@[L;v]` 

Where

-   `L` is a list, dictionary, or table, or a [handle](handle) to one
-   `i` is a symbol or non-negative integer atom or list in the domain of `L`

`L @ i` returns `count(raze/)i` items from `L`. 

Index At is right-atomic. Every atom in `i` must be a valid index of `L`. 
If `L` is

-   a **dictionary**, a member of `key L`
-   a **table**, a member of `cols L` or `til count L`
-   a **list**, a member of `til count L`

The result is equivalent to replacing each atom of `i` with the item of `L` whose index or entry is that atom. 
```q
q)"abcdefg" @ 4
"e"
q)"abcdefg" @ 5 0 3 4 3
"faded"
q)"abcdefg" @ (5 0;(3;enlist 4 3))
f   a
"d" ,"ed"
q)(8 1 6; 3 5; 7 4 9 2) @ (2 1; 1 2 0)
(7 4 9 2;3 5)
(3 5;7 4 9 2;8 1 6)
```
If `L` is a dictionary then `i` is composed from its keys.
```q
q)d:`a`b!(2 3 4;"abcdefg")
q)d @ `a 
2 3 4
q)d@`b`a
"abcdefg"
2 3 4
```
If `L` is a table then `i` is composed from either its columns or its row indexes.
```q
sym  dat        qty
--------------------
msft 2018.03.15 1000
aapl 2018.02.21 1010
ibm  2018.06.04 1020
orcl 2017.12.25 1030
q)t @ 1 3
sym  dat        qty
--------------------
aapl 2018.02.21 1010
orcl 2017.12.25 1030
q)t@`qty`sym
1000 1010 1020 1030
msft aapl ibm  orcl
```
The general case of Index At can be defined recursively as follows, based on the definition for an atom right argument:
```q
IndexAt:{[d;i] $[0>type i; d @ i; d IndexAt/: i]}
```
That is, if `i` is not an atom then apply Index At to `d` and every item of `i`.

!!! tip "Index At and Index"
    `L @ i` is identical to `L . enlist i`.


## Ambivalence

Since `@` is a primitive function, where its rank cannot be determined from context, rank 2 is assumed. This assumption is not strict, however. 

For example, if `f:@` then `f` is binary, but it can also be given three or four arguments to evaluate Amend At. Ambivalence is allowed here because the functionality of Index At and Amend At is closely related.


## Errors

error  | cause
-------|-------------------------------------------------------------
domain | the symbol `L` is not a [handle](handle)
index  | an atom of `i` is not a valid index of `L`
type   | an atom of `i` is not an integer, symbol or nil

