# `exp`


Syntax: `exp x`, `exp[x]` (atomic)

Returns _e_<sup>x</sup>, where _e_ is the base of natural logarithms.
```q
q)exp 1
2.718282
q)exp 0.5
1.648721
q)exp -4.2 0 0.1 0n 0w
0.01499558 1 1.105171 0n 0w
```


## Domain and range
```
domain b g x h i j e f c s p m d z n u v t
range  f . f f f f f f f . f f f z f f f f
```
Range: `fz`

<i class="far fa-hand-point-right"></i> [Arithmetic](/ref/arithmetic), [`log`](/ref/log), [`xexp`](/ref/xexp), [`xlog`](/ref/xlog) 