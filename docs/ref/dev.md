---
title: dev, mdev, sdev – standard, moving, and sample standard deviations | Reference | KDB-X and q documentation
description: dev, mdev, and sdev are q keywords that return, respectively, the standard deviation, moving deviation, and sample standard deviation of their argument.
author: KX Systems, Inc., a subsidiary of KX Software Limited
---
# `dev`, `mdev`, `sdev`

_Deviations_

## `dev`

_Standard deviation_

```syntax
dev x     dev[x]
```

Where `x` is a numeric list, returns its [standard deviation](https://en.wikipedia.org/wiki/Standard_deviation "Wikipedia") (the square root of the variance).
Applies to all numeric data types.

```q
q)dev 10 343 232 55
134.3484
```

`dev` is an aggregate function, equivalent to `{sqrt var x}`.

```txt
domain: B G X H I J E F C S P M D Z N U V T
range:  f . f f f f f f f . f f f f f f f f
```

Since 4.1t 2022.04.15, it can also traverse columns of tables and general/anymap/nested lists.

```q
q)M:get`:m77 set m:(2 3;4 0N;1 7)
q)dev m
1.247219 2
q)dev M
1.247219 2
q)T:get`:tab/ set t:flip`a`b!flip m
q)dev t
a| 1.247219
b| 2
q)dev T
a| 1.247219
b| 2
```

`dev` is a [multithreaded primitive](mt-primitives.md).

## `mdev`

_Moving deviations_

```syntax
x mdev y     mdev[x;y]
```

Where

- `x` is a positive int atom
- `y` is a numeric list

returns the floating-point `x`-item moving deviations of `y`, with any nulls replaced by zero. The first `x` items of the result are the deviations of the terms so far, and thereafter the result is the moving deviation. If the first item of `y` is null, the first item of the result is also null.

```q
q)2 mdev 1 2 3 5 7 10
0 0.5 0.5 1 1 1.5
q)5 mdev 1 2 3 5 7 10
0 0.5 0.8164966 1.47902 2.154066 2.87054
q)5 mdev 0N 2 0N 5 7 0N      / the first item is null
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
Domain and range:

```txt
 | B G X H I J E F C S P M D Z N U V T
-| -----------------------------------
b| F . F F F F F F F . F F F F F F F F
g| . . . . . . . . . . . . . . . . . .
x| F . F F F F F F F . F F F F F F F F
h| F . F F F F F F F . F F F F F F F F
i| F . F F F F F F F . F F F F F F F F
j| F . F F F F F F F . F F F F F F F F
e| . . . . . . . . . . . . . . . . . .
f| . . . . . . . . . . . . . . . . . .
c| . . . . . . . . . . . . . . . . . .
s| . . . . . . . . . . . . . . . . . .
p| . . . . . . . . . . . . . . . . . .
m| . . . . . . . . . . . . . . . . . .
d| . . . . . . . . . . . . . . . . . .
z| . . . . . . . . . . . . . . . . . .
n| . . . . . . . . . . . . . . . . . .
u| . . . . . . . . . . . . . . . . . .
v| . . . . . . . . . . . . . . . . . .
t| . . . . . . . . . . . . . . . . . .
```

Range: `F`

### Implicit iteration

`mdev` applies to [dictionaries and tables](math.md#dictionaries-and-tables).

```q
q)kt:`k xkey update k:`abc`def`ghi from t:flip d:`a`b!(10 21 3;4 5 6)

q)2 mdev d
a| 0 0 0
b| 3 8 1.5

q)2 mdev t
a   b
-------
0   0
5.5 0.5
9   0.5

q)2 mdev kt
k  | a   b
---| -------
abc| 0   0
def| 5.5 0.5
ghi| 9   0.5
```

## `sdev`

_Sample standard deviation_

```syntax
sdev x     sdev[x]
```

Where `x` is a numeric list, returns its sample standard deviation, the square root of the [sample variance](var.md#svar).

$$\mathrm{sdev}(x)=\sqrt{\frac{n}{n-1}\mathrm{var}(x)}$$

```q
q)sdev 10 343 232 55
155.1322
```

`sdev` is an aggregate function, equivalent to `{sqrt var[x]*count[x]%-1+count x}`.

```txt
domain: B G X H I J E F C S P M D Z N U V T
range:  f . f f f f f f f . f f f f f f f f
```

Since 4.1t 2022.04.15, it can also traverse columns of tables and general/anymap/nested lists.

```q
q)M:get`:m77 set m:(2 3;4 0N;1 7)
q)sdev m
1.527525 2.828427
q)sdev M
1.527525 2.828427
q)T:get`:tab/ set t:flip`a`b!flip m
q)sdev t
a| 1.527525
b| 2.828427
q)sdev T
a| 1.527525
b| 2.828427
```

`sdev` is a [multithreaded primitive](mt-primitives.md).

----

[`var`, `svar`](var.md)
<br>

[Mathematics](math.md)
<br>

[Sliding windows](../examples/programming-idioms.md#how-do-i-apply-a-function-to-a-sequence-sliding-window)
<br>

[Standard deviation](https://en.wikipedia.org/wiki/Standard_deviation "Wikipedia"),
[Variance](https://en.wikipedia.org/wiki/Variance "Wikipedia")
