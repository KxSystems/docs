# `sqrt`


Syntax: `sqrt[x]` (prefix, unary, atomic)

Returns the square root of numeric `x`. Where `x` is negative or null, the result is null.
```q
q)sqrt -1 0n 0 25 50
0n 0n 0 5 7.071068
```


## Domain and range
```
domain b g x h i j e f c s p m d z n u v t
range  f . f f f f f f f . f f f z f f f f
```
Range: `fz`

<i class="far fa-hand-point-right"></i> [Arithmetic](/basics/arithmetic), [`exp`](/ref/exp), [`log`](/ref/log), [`xexp`](/ref/xexp), [`xlog`](/ref/xlog)