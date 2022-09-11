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
-   `i` is a value that indexes `x`
-   `y` is a scalar, or a list of the same length as `i`

the value of `y` is assigned to `x` at indexes `i`. 

!!! warning "Indexed assignment cannot change the type of `x`."

    If `x` is a vector (has negative type) then `(=). abs type each(x;y)` must be true. 

Where `x` is a dictionary, assignment has upsert semantics.

```q
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
x[i]op:y   op:[x i;y]
```

Where 

-   `op` is a binary operator with infix syntax
-   `x` is an applicable value (i.e. not an atom) in the left domain of `op`
-   `i` is a value that indexes `x`
-   `y` is a value in the right domain of `op` that conforms to either `i` or `x`
-   `x op y` (or `x[i]op y`) has the same type as `x`

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

----
:fontawesome-solid-book:
[Amend, Amend At](../ref/amend.md)
<br>
:fontawesome-solid-street-view:
_Q for Mortals_
[§4.6.2 Simple q Amend](/q4m3/4_Operators/#462-simple-q-amend)

