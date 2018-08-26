# `abs`


Syntax: `abs[x]`, `abs x` (unary, atomic)

Returns the absolute value of boolean or numeric `x`. Null is returned if `x` is null.
```q
q)abs -1.0
1f
q)abs 10 -43 0N
10 43 0N
```


## Domain and range
```
domain b g x h i j e f c s p m d z n u v t
range  i . i h i j e f i . p m d z n u v t
```
Range: `ihjefpmdznuvt`

<i class="far fa-hand-point-right"></i> [Arithmetic](/basics/arithmetic), [`signum`](/ref/signum)