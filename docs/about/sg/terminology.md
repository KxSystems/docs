# Terminology


!!! info "Terminology review 2017"
    In 2017 the terminology used to describe Kx technology was reviewed and revised to 

    -   use common terms for common concepts
    -   distinguish adverbs more clearly

The following terms are no longer used to describe q:

-   monad, monadic
-   dyad, dyadic
-   nilad, niladic
-   verb
-   element of a list

Q defines twelve adverbs, denoted by six characters and character pairs. 


## Q and kdb+

-   _kdb+_ denotes the database and the process that manages it;
-   _q_ denotes the programming language, a domain-specific language for time series embedded in 
-   the _k_ language;


## Lists

> A list is an ordered collection of zero or more _items_. 

Any q element (atom, list, function, adverb) may be an item of a list. 

Where all its items are of the same type, a list is a _vector_ of that type. 

_Mixed list_, _general list_ or _simple list_ may be used for emphasis, but _list_ and _vector_ usually suffice. 

A matrix is a list of its rows.

A dictionary is not a list, but a table is a list of dictionaries.


## Map

_Map_ is a general term. It encompasses 

-   functions (operators, keywords, lambdas and derived functions) 
-   lists
-   dictionaries

These are all maps because they map one or more arguments to the map’s range. 


## Function rank

> A function’s _rank_ is the number of arguments it takes. 

rank | adjective
:---:|----------
0    | nullary
1    | unary
2    | binary
3    | ternary
4    | quaternary

The terms _nilad_, _monad_, _dyad_, _niladic_,  _monadic_, and _dyadic_ are no longer used.


## Operators 

All functions can be applied with bracket notation, e.g. `f[x;y;z]` and `+[2;3]`.

> An _operator_ is a primitive binary function that can also be applied with infix notation.
```q
q)2+3
5
```

## Keywords

The term _verb_ is no longer used. 


## Extenders

> An _extender_ is a primitive higher-order function that is applied (usually postfix) to a single argument map and returns a derived function,  known as an _extension_.
```
q)total:+/
q)total[1 2 3]
6
```
Extenders are distinguished from the overloaded characters and character pairs that denote them. For example, the character `'` is overloaded with the extenders Case, Compose, and Each. 

!!! note "Refer to an extender by its name"

    Refer to an extender by its name, not the (overloaded) character that denotes it. 

    For example, in `2 +//5 5#til 25` the extender denoted by `/` is Over.

**Watch out:** `each`, `peach`, `prior`, `over`, and `scan` are keywords that apply their function arguments. They are not extenders, and do not return extensions. Where an extender applied postfix returns a derivative, a keyword applied infix, but without a right argument, returns a projection. 

```q
q)(+/)1 2 3
6
q)(+)over 1 2 3
6
q)tot1:+/                / derived function
q)tot1[1 2 3]
6
q)tot2:(+)over           / projection
q)tot2 1 2 3
6
q)type each (tot1;tot2)  / derivative; projection
107 104h
```

