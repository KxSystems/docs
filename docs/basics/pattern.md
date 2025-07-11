---
title: Pattern matching | Basics | kdb+ and q documentation
description: Pattern matching in assignments and function parameters
author: Péter Györök
---
# Pattern Matching

Pattern matching allows an object such as a list or dictionary to be matched to a pattern, assigning variables to its parts, checking types, and/or modifying values via a filter function. It can simplify unpacking multiple objects passed to and returned from functions, and reduce the overhead of type checking.

## Assignment

The left side of the [assignment](../ref/assign.md) operator may be a pattern. Various kinds of patterns have different effects. When used in an assignment, the pattern must have parentheses around it. A failed match results in no variables being changed.

```q
q)(b;c):2 3
q)b
2
q)c
3
```

The return value of the match is the entire assigned object, including any modifications from filter functions.

```q
q)a:(b;:1+):1 2
q)a
1 3
q)b
1
```

## Function parameters

Pattern matching can also be used in the parameter list of a [function](function-notation.md), in which case the parentheses are not necessary unless the pattern requires them (such as a list pattern).

```q
q)f:{[(a;b);c]a+b+c}
q)f[1 2;3]
6
```

## Pattern conditional

The pattern conditional takes the form `:[v;p1;r1;p2;r2;...;rd]` where `v` is a value to be matched, `p1`, `p2`, ... are patterns and `r1`, `r2`, ... `rd` are the corresponding return values. The value is matched to the patterns in turn, and the value of the expression is the return value corresponding to the first successful match, or `rd` if no patterns match. Similarly to the regular [conditional](../ref/cond.md), the result expressions corresponding to failed matches, as well as any match after the first successful match, are not evaluated.

```q
q)a: :[1f;r:`f;"float";r:`i;"int";"other"]
q)a
"float"
q)r
1f
q)a: :[1i;r:`f;"float";r:`i;"int";"other"]
q)r
1i
q)a
"int"
q)a: :[1;r:`f;"float";r:`i;"int";"other"]
q)a
"other"
```

## Types of patterns

### Null

The null pattern matches anything. It cannot be used as the main pattern in an assignment, but it can appear as a component of more complex patterns by elision.

### Constant value

The simplest pattern is a constant (atom or list). If the assigned value exactly matches (see [~](../ref/match.md)), the assignment does nothing. If the values don't match, a `'match` error is thrown.

```q
q)(1):1
q)(`a):`a
q)(1):2
'match
  [0]  (1):2
          ^
q)(1 2):1 2
q)(1 2):1 3
'match
  [0]  (1 2):1 3
            ^
```

### Name

A name is an identifier used as a pattern. The variable with the name is set to the matched value. On its own, this is equivalent to a simple assignment, but a name pattern can be used as a component of more complex patterns.

```q
q)(a):1 3
q)a
1 3
```

### Name with index

A name can be augmented with an index, similar to [indexed assignment](../ref/assign.md#indexed-assign). The index is not a pattern but a value.

```q
q)a:1 2 3
q)(a[1]):4
q)a
1 4 3
```

### List

A list pattern looks like a [general list](syntax.md#list-notation). Each element of the list is a pattern itself. Combined with name patterns, this can be used to assign multiple variables in a single assignment.

```q
q)(b;c):2 3
q)b
2
q)c
3
```

The length of the pattern must match the length of the assigned value, and each element is matched in turn.

```q
q)(b;c):2 3 4
'length
q)(b;c;3):2 3 4
'match
  [0]  (b;c;3):2 3 4
            ^
```

Since a table can be used as a list, it can match a list pattern:

```q
q)(a;b):([]colA:1 2;colB:3 4)
q)a
colA| 1
colB| 3
q)b
colA| 2
colB| 4
```

Null patterns can be used by eliding items from the list pattern. In this case, the element is checked for existence but its value is not matched.

```q
q)(a;b;):1 2
'length
  [0]  (a;b;):1 2
       ^
q)(a;b;):1 2 3
```

### Dictionary

A dictionary pattern can be made using the [!](../ref/dict.md) operator or using the bracketed dictionary syntax. Each _value_ in the dictionary is a pattern. The values are matched with those with the same key in the assigned value. The assigned value may have additional keys that are ignored.

```q
q)(1 2!(one;two)):1 2!"ab"
q)one
"a"
q)two
"b"
q)(1 2!(one;two)):1 2 3!"abc"
q)(1 2!(one;two)):1 3!"ac"
'match
  [0]  (1 2!(one;two)):1 3!"ac"
                 ^
q)([four:d]):`one`two`three`four`five!1 2 3 4 5
q)d
4
```

As with lists, null patterns can be used. For the bracketed syntax, this means not putting a value after the colon for a key.

```q
q)([one:;four:d]):`one`two`three`four`five!1 2 3 4 5
q)([six:;four:d]):`one`two`three`four`five!1 2 3 4 5
'match
  [0]  ([six:;four:d]):`one`two`three`four`five!1 2 3 4 5
            ^
```

### Table

Tables can also be used as patterns similarly to dictionaries.

```q
q)([]cc:e):([]aa:1 2;bb:3 4;cc:5 6)
q)e
5 6
q)([k1:f]cc:e):([k1:7 8]aa:1 2;bb:3 4;cc:5 6)
q)f
7 8
```

### Operator

Certain operators can be used as patterns. Currently only [!](../ref/dict.md) and [`flip`](../ref/flip.md) (for dict-to-table conversion) can be used in this way.

```q
q)(flip([a;b])):([]a:1 2;b:3 4)
q)a
1 2
q)b
3 4
q)(a!b):1 2!"ab"
q)a
1 2
q)b
"ab"
q)(a!):1 2!3 4
q)a
1 2
```

### Type check

The type check pattern takes the form ```p:`x```, where `p` is a pattern (including the null pattern) and `x` is the [type character](datatypes.md) for the type being checked. A lowercase letter matches an atom and an uppercase letter matches a list. If the type is correct, the pattern match proceeds to `p`, otherwise a `'type` error is thrown.

```q
q)(:`f):3f
q)(:`f):3e
'type
  [0]  (:`f):3e
        ^
q)((a;b):`F):3 4f
q)a
3f
q)b
4f
q)((a;b):`F):3 4e
'type
  [0]  ((a;b):`F):3 4e
             ^
```

### Filter function

The filter function pattern takes the form ```p:expr``` where `expr` is an expression that returns a callable (such as a lambda, projection or operator). The result of `expr` is called on the value from the assigned value, and the result is matched to `p`.

```q
q)(a:3+):4
q)a
7
q)tempCheck:{$[x<0;'"too cold";x>40;'"too hot";x]}
q)c2f:{[x:tempCheck]32+1.8*x}
q)c2f -4.5
'too cold
q)c2f 42.8
'too hot
q)c2f 20
68f
```
