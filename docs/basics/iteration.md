# Iteration


The primary means of iteration in q are 

-   atomic functions
-   the **distributive operators**: Each and its variants
-   the **progressive operators** Scan and Over


## Atomic functions

[Atomic functions](FIXME) apply to atoms in their arguments, and preserve structure to arbitrary depth.

Many of the q operators that take numerical arguments are atomic. 

The arguments of an atomic function must _conform_: 
they must be lists with the same count, or atoms.

When an atom argument is applied to a list, it is applied to every item.

```q
q)2 3 4 + 5 6 7          / same-count lists
7 9 11
q)2 + 3 4 5              / atom and list
5 6 7
```

This is called _scalar extension_. It applies at every level of nesting.

```q
q)2+(3 4;`a`b`c!5 6 7;(8 9;10;11 12 13);14)
5 6
`a`b`c!7 8 9
(10 11;12;13 14 15)
16
```


## Unary operators

The distributive and progressive operators are unary. 
They take maps as arguments and derive functions (_extensions_) that apply the maps repeatedly.

Unary operators can be applied postfix, and almost always are. 
For example, the Over operator `/` takes the Add operator `+` to derive the extension `+/`, which reduces a list by summing it.

```q
q)(+/)2 3 4 5
14
```


### Distributive operators

The [distributive operators](/ref/distributive-operators) – Each, Each Left, Each Right, Each Prior, and Each Parallel – apply a map to each item of a list or dictionary.

```q
q)count "zero"                             / count the chars (items) in a string
4
q)(count')("The";"quick";"brown";"fox")    / count each string
3 5 5 3
```


### Progressive operators

The [progressive operators](/ref/progressive-operators) – Scan and Over – apply a map successively, first to the argument, then to the results of successive applications. 


## Control words

The control words [`if`](FIXME), [`do`](FIXME), and [`while`](FIXME) also enable iteration, but are rarely required. 



