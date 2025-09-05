---
title: Assign operator | Reference | kdb+ and q documentation
description: Name a value in q
author: Stephen Taylor
---
# Assign

_Name a value; amend a named value_


## Simple assign

```syntax
x:y
```

Where `x` is a name and `y` is a value, the value of `y` is associated with the name `x`.

```q
q)a:42        / assign
q)a
42
q)a:3.14159   / amend
```

!!! warning "The Equal operator `=` tests equality. It has nothing to do with naming or amending values."

!!! detail "There is no need to declare the type of a variable."

    A variable acquires the type of the value assigned to it.
    (Known as *dynamic typing*.)

    ```q
    q)type a:til 5    / integer vector
    7h
    q)type a:3.14159  / float atom
    -9h
    ```


## Indexed assign

```syntax
x[i]:y
```

Where 

-   `x` is the name of a list, dictionary or table
-   `i` is a value that indexes `x` (including a `;`-separated multi-level index)
-   `y` is a scalar, or a list of the same shape as `i`

the value of `y` is assigned to `x` at indexes `i`. 

!!! warning "Indexed assignment to a simple list cannot change the type of `x`."

    If `x` is a simple list (has type between 1 and 20) then `(=). abs type each(x;y)` must be true. However, a general list that ends up having all items of the same atomic type after assignment _will_ collapse into a simple list.

Where `x` is a dictionary, assignment has upsert semantics.

```q
q)s:1 2 3
q)s[1]:4
q)s
1 4 3
q)s[2]:5f
'type
  [0]  s[2]:5f
           ^

q)s:(1;2f;3)
q)s
1
2f
3
q)s[1]:4
q)s
1 4 3
q)s[1]:5f
'type
  [0]  s[1]:5f
           ^

q)m:(1 2;3 4)
q)m[1;1]:5
q)m
1 2
3 5

q)d:`tom`dick`harry!1 2 3
q)d[`dick`jane]:100 200
q)d
tom  | 1
dick | 100
harry| 3
jane | 200
```


## Assign through operator

```syntax
x op:y     op:[x;y]
x[i]op:y
```

Where 

-   `op` is a binary operator with infix syntax
-   `x` or `x[i]` is an assignable in the left domain of `op` (the rules of [indexed assign](#indexed-assign) apply for `x[i]`)
-   `y` is a value in the right domain of `op` that conforms to `x` (or `i`)

the value of `x` (or `x[i]`) becomes `x op y` (or `x[i]op y`). 

```q
q)s:("the";"quick";"brown";"fox")
q)s[1 2],:("er";"ish")
q)s
"the"
"quicker"
"brownish"
"fox"
```

!!! tip "Extend Assign-through-operator to derived functions, keywords and lambdas."

    ```q
    q)s:("the";"quick";"brown";"fox")
    q)@[s;1 2;,;("er";"ish")]
    "the"
    "quicker"
    "brownish"
    "fox"
    ```

    [Amend At](amend.md) is more general, and extends assignment-through-operator to derived functions, keywords and lambdas.

If `x` is undefined, the [identity element](../basics/glossary.md#identity-element) for `op` is used as a default.

```q
q)bar
'bar
  [0]  bar
       ^
q)bar+:1
q)bar
1
```

Some operators have significant differences between their base and assignment form, for example [`,`](join.md).

## Pattern match

See [Pattern matching](../basics/pattern.md#assignment)

## Syntax

An expression with an assignment on the left returns no value to the console. 
```q
q)a:til 5
q)
```
The value of an assignment is the value assigned.
```q
q)3+a:til 5
3 4 5 6 7
q)1+a[2]+:5
8
q)a
0 1 7 3 4
```

## Pick second argument

If `:` is used as a value (e.g. assigned to a variable, passed as a function parameter, or modified by an iterator), invoking it causes it to discard its first argument and return its second argument, without performing an assignment.

```q
q)a:3
q)f:(:)
q)f[a;4]
4
q)a
3
```

A common use of this is with [functional amend](amend.md), where it indicates replacing the element at the specified index with a new value, as opposed to performing an operation between the existing and new values:

```q
q)@[1 2 3 4 5; 2; :; 6]
1 2 6 4 5
```

Combining it with [`over`](accumulators.md) has an effect equivalent to [`last`](first.md#last):

```q
q):/[1 2 3 4 5]
5
```

----
:fontawesome-solid-book:
[Amend, Amend At](../ref/amend.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§4.6.2 Simple q Amend](/q4m3/4_Operators/#462-simple-q-amend)

