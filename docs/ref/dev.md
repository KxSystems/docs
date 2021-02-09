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
dev x     dev[x]
```

Where `x` is a numeric list, returns its [standard deviation](https://en.wikipedia.org/wiki/Standard_deviation "Wikipedia") (as the square root of the variance).
Applies to all numeric data types and signals an error with temporal types, char and sym.

```q
q)dev 10 343 232 55
134.3484
```

`dev` is an aggregate function, equivalent to `{sqrt var x}`.


## `mdev`

_Moving deviations_

```txt
x mdev y     mdev[x;y]
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

q)t
b c
----
1 45
2 46
3 47
q)2 mdev t
b   c
-------
0   0
0.5 0.5
0.5 0.5
```

`mdev` is a uniform function.


### :fontawesome-solid-sitemap: Implicit iteration

`mdev` applies to [dictionaries and tables](../basics/math.md#dictionaries-and-tables).

```q
q)k:`k xkey update k:`abc`def`ghi from t:flip d:`a`b!(10 21 3;4 5 6)

q)2 mdev d
a| 0 0 0
b| 3 8 1.5

q)2 mdev t
a   b
-------
0   0
5.5 0.5
9   0.5

q)2 mdev k
k  | a   b
---| -------
abc| 0   0
def| 5.5 0.5
ghi| 9   0.5
```


## `sdev`

_Sample standard deviation_

```txt
sdev x     sdev[x]
```

Where `x` is a numeric list, returns its sample standard deviation as the square root of the [sample variance](var.md#svar).

$$sdev(x)=\sqrt{\frac{n}{n-1}var(x)}$$

```q
q)sdev 10 343 232 55
155.1322
```

`sdev` is an aggregate function, equivalent to `{sqrt var[x]*count[x]%-1+count x}`.


----
:fontawesome-solid-book:
[`var`, `svar`](var.md)
<br>
:fontawesome-solid-book-open:
[Mathematics](../basics/math.md)
<br>
:fontawesome-solid-graduation-cap:
[Sliding windows](../kb/programming-idioms.md#how-do-i-apply-a-function-to-a-sequence-sliding-window)
<br>
:fontawesome-brands-wikipedia-w:
[Standard deviation](https://en.wikipedia.org/wiki/Standard_deviation "Wikipedia"),
[Variance](https://en.wikipedia.org/wiki/Variance "Wikipedia")
<br>
:fontawesome-solid-globe:
[Standard deviation](http://financereference.com/learn/standard-deviation "financereference.com")
