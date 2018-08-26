# `log`


Syntax: `log x`, `log[x]` (atomic)

Returns the natural logarithm of `x`. 

Null is returned if `x` is negative, and negative infinity where `x` is 0.
```q
q)log 1
0f
q)log 0.5
-0.6931472
q)log exp 42
42f
q)log -2 0n 0 0.1 1 42
0n 0n -0w -2.302585 0 3.73767
```


## Domain and range
```
domain b g x h i j e f c s p m d z n u v t
range  f . f f f f f f f . f f f z f f f f
```
Range: `fz`

<i class="far fa-hand-point-right"></i> [Datatypes](/basics/datatypes), [`exp`](/ref/exp), [`xexp`](/ref/xexp), [`xlog`](/ref/xlog)