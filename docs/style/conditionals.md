---
title: The right conditional | Remarks on Style | q and kdb+ documentation
description: Consistent use of if and the conditional will make your code more readable. Indexing and dictionaries are often faster and more expressive forms. 
author: Stevan Apter and Stephen Taylor
keywords: conditional, default, dictionary, else, if, indexing, result, switch
---
# The right conditional



Q has two forms of conditional evaluation: Cond (`$`) and `if`. The following rules help you write code where useful information is conveyed by your choice of conditional.

:fontawesome-regular-hand-point-right:
Reference: [Cond](../ref/cond.md),
[`if`](../ref/if.md)

`if` has the syntax:

```q
if[cond;
  true1;
  …
  trueN]
```

`$[]` has the syntax:

```q
r:$[cond1; true1;
  …
  condN; trueN;
  false]
```

Cond returns a result; `if` does not. (Strictly: it returns a null.) Use `if` only when you do not want to capture a result. Another way to say this is:

!!! tip "Use `if` to govern a side effect." 

```q
foo:{
  if[x<0;log.msg"Negative value: ",string x];
  …
}
```

Assigning a default value to a function argument can be thought of as a side effect.

```q
foo:{
  if[x~::;x:101];
  …
  }
```

This distinction is not always clear. The example above could have been written:

```q
x:$[x~::;101;x];
```

Here, the thought is: there _will_ be a value for `x`, whether supplied or not. The same can be expressed by indexing. 

```q
x:(x;101)x~::;
```

!!! tip "If in doubt, avoid `if`."


## Validation

It is common for a function to validate its arguments before doing its work. 
This can be written as a multiply-nested Cond. 

```q
foo:{
  $[x<0;[log.error"Negative value: ",string x;0];
    y>100*x;[log.error"Excess y: ",string y;0];
    …
    ]
  }
```

If there is work to do between the tests, `if` may be more legible. 

```q
foo:{
  if[x<0;log.error"Negative value: ",string x;:0];
  s:bar x;
  if[y>100*s;log.error"Excess y: ",string y;:0];
  …
  }
```

Signalling an error is a side effect. Use `if`.

```q
foo:{
  if[x=0;'"Cannot be zero"];
  …
  }
```


## If-then-else

Although `if` does not support if-then-else logic, it should be used even when that logic is required but where side effects are intended. 

```q
if[b:x>5;foo::x];
if[not b;goo::y];
```


## Indexing

If/else and case constructions can often be represented as indexes.
Indexing has great power of expression. 

Consider the example above, setting either `foo` or `goo`.
It could also be written as

```q
(`goo`foo x>5)set x
```

Suppose instead that `foo` and `goo` are lamdbdas that produce quite different side effects. We would use `if` to make it clear no result is being captured.

```q
if[b:x>5;foo x];
if[not b;goo x];
```

But if `foo` and `goo` returned results we could write

```q
r:$[x>5;foo x;goo x]
```

or even 

```q
r:(goo;foo)[x>5] x
```


## Switch statement

A [switch statement](https://en.wikipedia.org/wiki/Switch_statement "Wikipedia") produces different outcomes according to the value of a variable. It is easy to represent with Cond.

```q
foo:{[age]
  "You are ",$[x=1;"one";
               x=2;"two";
               x=3;"three";
               x=4;"four";
               "not one, two, three, or four"] }
```

Repeated tests of the same value suggests an alternative. 
We can use [Find](../ref/find.md) and two lists. 

```q
foo:{"You are ",("one";"two";"three";"four";"not one, two, three, or four")1 2 3 4?x}
```

The example above could be described as an “n+1 dictionary”: it specifies a default result for when `x` is not a key. 

If the range of `x` is known, a dictionary can be used. 
Suppose `foo`, `goo`, `hoo`, and `joo` are functions to be executed on `y` according to the word in `x`, and `x` will be one of `"append"`, `"insert"`, `"replace"`, or `"execute"`.

```q
d:`append`insert`replace`execute!(foo;goo;hoo;joo)
d[`$x]@y
```


Consistent use of `if` and the conditional will make your code more readable: 

-   seeing `if` you know that a side effect is sought and a result is not; 
-   seeing `$[]`, you know that a result is intended unconditionally.


:fontawesome-regular-hand-point-right:
Reference: [`do`](../ref/do.md), 
[`while`](../ref/while.md), 
[Do](../ref/accumulators.md#do),
[While](../ref/accumulators.md#while),
[Vector Conditional](../ref/vector-conditional.md)<br>
Basics: [Controlling evaluation](../basics/control.md)



