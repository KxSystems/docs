---
title: dev, mdev, sdev – standard, moving, and sample standard deviations | Reference | kdb+ and q documentation
description: dev, mdev, and sdev are q keywords that return, respectively, the standard deviation, moving deviation, and sample standard deviation of their argument.
author: Stephen Taylor
---
# `dev`, `mdev`, `sdev`

_Deviations_




## `dev`

_Standard deviation_

```txt
dev x    dev[x]
```

Where `x` is a numeric list, returns its [standard deviation](https://en.wikipedia.org/wiki/Standard_deviation "Wikipedia") (as the square root of the variance).
Applies to all numeric data types and signals an error with temporal types, char and sym.

```q
q)dev 10 343 232 55
134.3484
q)select dev price by sym from trade
```

`dev` is an aggregate function.

The function `dev` is equivalent to `{sqrt var x}`.


## `mdev`

_Moving deviations_

```txt
x mdev y    mdev[x;y]
```

Where

-   `x` is a positive int atom
-   `y` is a numeric list

returns the floating-point `x`-item moving deviations of `y`, with any nulls after the first item replaced by zero. The first `x` items of the result are the deviations of the terms so far, and thereafter the result is the moving deviation.

```q
q)2 mdev 1 2 3 5 7 10
0 0.5 0.5 1 1 1.5
q)5 mdev 1 2 3 5 7 10
0 0.5 0.8164966 1.47902 2.154066 2.87054
q)5 mdev 0N 2 0N 5 7 0N    / nulls after the first are replaced by 0
0n 0 0 1.5 2.054805 2.054805
```

`mdev` is a uniform function.


## `sdev`

_Sample standard deviation_

```txt
sdev x    sdev[x]
```

Where `x` is a numeric list, returns its sample standard deviation as the square root of the [sample variance](var.md#svar).

$$sdev(x)=\sqrt{\frac{n}{n-1}var(x)}$$

Applies to all numeric data types and signals an error with temporal types, char and sym.

```q
q)sdev 10 343 232 55
155.1322
q)select sdev price by sym from trade
```

`sdev` is an aggregate function.


----

:fontawesome-solid-book:
[`var`, `svar`](var.md)
<br>
:fontawesome-solid-graduation-cap:
[Mathematics](../basics/math.md),
[Sliding windows](../kb/programming-idioms.md#how-do-i-apply-a-function-to-a-sequence-sliding-window)
<br>
:fontawesome-brands-wikipedia-w:
[Standard deviation](https://en.wikipedia.org/wiki/Standard_deviation "Wikipedia"),
[Variance](https://en.wikipedia.org/wiki/Variance "Wikipedia")
<br>
:fontawesome-solid-globe:
[Standard deviation](http://financereference.com/learn/standard-deviation "financereference.com")
